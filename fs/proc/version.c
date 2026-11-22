#include <linux/fs.h>
#include <linux/init.h>
#include <linux/kernel.h>
#include <linux/proc_fs.h>
#include <linux/seq_file.h>
#include <linux/utsname.h>
#ifdef CONFIG_KSU_SUSFS_SPOOF_UNAME
#include <linux/jump_label.h>
extern struct static_key_false susfs_is_uname_spoof_buffer_set;
extern void susfs_spoof_uname(struct new_utsname *tmp);
#endif // #ifdef CONFIG_KSU_SUSFS_SPOOF_UNAME

static int version_proc_show(struct seq_file *m, void *v)
{
#ifdef CONFIG_KSU_SUSFS_SPOOF_UNAME
	struct new_utsname tmp;

	if (static_branch_likely(&susfs_is_uname_spoof_buffer_set)) {
		down_read(&uts_sem);
		memcpy(&tmp, utsname(), sizeof(tmp));
		up_read(&uts_sem);
		susfs_spoof_uname(&tmp);
		seq_printf(m, linux_proc_banner,
			tmp.sysname,
			tmp.release,
			tmp.version);
		return 0;
	}
#endif // #ifdef CONFIG_KSU_SUSFS_SPOOF_UNAME
	seq_printf(m, linux_proc_banner,
		utsname()->sysname,
		utsname()->release,
		utsname()->version);
	return 0;
}

static int version_proc_open(struct inode *inode, struct file *file)
{
	return single_open(file, version_proc_show, NULL);
}

static const struct file_operations version_proc_fops = {
	.open		= version_proc_open,
	.read		= seq_read,
	.llseek		= seq_lseek,
	.release	= single_release,
};

static int __init proc_version_init(void)
{
	proc_create("version", 0, NULL, &version_proc_fops);
	return 0;
}
fs_initcall(proc_version_init);
