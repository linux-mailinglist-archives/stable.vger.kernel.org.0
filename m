Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB0CE7169C
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 12:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387447AbfGWKz3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 06:55:29 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:50471 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731642AbfGWKz3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 06:55:29 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 3E2425AE;
        Tue, 23 Jul 2019 06:55:28 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 23 Jul 2019 06:55:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=KXcgOF
        mxSmbZTZVpLjH9GsA8+F5VHt4M/5p+vuXeVbk=; b=tBDzrGg6D80zvFZkCfWKul
        Ry7V0gl3XACLSM7bTAI065xaVkXYikm+Wi1fa0/lh3aj0DwpRx9RYoSDtFeciZKy
        DEkaEuPTS1M04k1Rr6i55gIyl1DIkQa9Ie2+3n1w27I4cPNCutNzN7ix/Rdkk0mZ
        gtqN9GfyWcpfGQoXI3jhnj5z/VKB8utGX4BUOSjuSOaZ6Iwr6M02YnXovrZHPtC2
        O9/sjZ4Oj946/MMB9WWotZI5VBpqiTFs0dUSoRds0d1sd6yg1+sDJc9Vrn2G/kp1
        BRhjHdUn4aH/UZ4pfzPySck4MLWQcfOX5LfocoH+iniwojBcLJOphHMALSFxMp5Q
        ==
X-ME-Sender: <xms:n-c2XRUBYTWiF3KC4FR6xN4X4NHVJeQ2OLA1mgw0GG-7aTDYB82SgQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeekgdefgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:n-c2XWgJLyS1UFhk02gXPlqH0_yHjc9x6jkYKIs-JmvEPDy4DToFCw>
    <xmx:n-c2XRqh2geUXz7LTfnJUoP75IdFeKlQqJ0RKVcPz6VUdOv-3_oIiA>
    <xmx:n-c2XUGqbebHE5F8p6sADgXF1P3Tq-GaB1AmcDBfjUWod_FlklWPiw>
    <xmx:n-c2XT57IcBh1JkRblJ5hJtsqeaUAwC61nwprFHVs2P9vYZ_uWwpGA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3B57B8005C;
        Tue, 23 Jul 2019 06:55:27 -0400 (EDT)
Subject: FAILED: patch "[PATCH] signal/usb: Replace kill_pid_info_as_cred with" failed to apply to 4.14-stable tree
To:     ebiederm@xmission.com, gregkh@linuxfoundation.org,
        oneukum@suse.com, stern@rowland.harvard.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jul 2019 12:53:16 +0200
Message-ID: <156387919633132@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 70f1b0d34bdf03065fe869e93cc17cad1ea20c4a Mon Sep 17 00:00:00 2001
From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Thu, 7 Feb 2019 19:44:12 -0600
Subject: [PATCH] signal/usb: Replace kill_pid_info_as_cred with
 kill_pid_usb_asyncio

The usb support for asyncio encoded one of it's values in the wrong
field.  It should have used si_value but instead used si_addr which is
not present in the _rt union member of struct siginfo.

The practical result of this is that on a 64bit big endian kernel
when delivering a signal to a 32bit process the si_addr field
is set to NULL, instead of the expected pointer value.

This issue can not be fixed in copy_siginfo_to_user32 as the usb
usage of the the _sigfault (aka si_addr) member of the siginfo
union when SI_ASYNCIO is set is incompatible with the POSIX and
glibc usage of the _rt member of the siginfo union.

Therefore replace kill_pid_info_as_cred with kill_pid_usb_asyncio a
dedicated function for this one specific case.  There are no other
users of kill_pid_info_as_cred so this specialization should have no
impact on the amount of code in the kernel.  Have kill_pid_usb_asyncio
take instead of a siginfo_t which is difficult and error prone, 3
arguments, a signal number, an errno value, and an address enconded as
a sigval_t.  The encoding of the address as a sigval_t allows the
code that reads the userspace request for a signal to handle this
compat issue along with all of the other compat issues.

Add BUILD_BUG_ONs in kernel/signal.c to ensure that we can now place
the pointer value at the in si_pid (instead of si_addr).  That is the
code now verifies that si_pid and si_addr always occur at the same
location.  Further the code veries that for native structures a value
placed in si_pid and spilling into si_uid will appear in userspace in
si_addr (on a byte by byte copy of siginfo or a field by field copy of
siginfo).  The code also verifies that for a 64bit kernel and a 32bit
userspace the 32bit pointer will fit in si_pid.

I have used the usbsig.c program below written by Alan Stern and
slightly tweaked by me to run on a big endian machine to verify the
issue exists (on sparc64) and to confirm the patch below fixes the issue.

 /* usbsig.c -- test USB async signal delivery */

 #define _GNU_SOURCE
 #include <stdio.h>
 #include <fcntl.h>
 #include <signal.h>
 #include <string.h>
 #include <sys/ioctl.h>
 #include <unistd.h>
 #include <endian.h>
 #include <linux/usb/ch9.h>
 #include <linux/usbdevice_fs.h>

 static struct usbdevfs_urb urb;
 static struct usbdevfs_disconnectsignal ds;
 static volatile sig_atomic_t done = 0;

 void urb_handler(int sig, siginfo_t *info , void *ucontext)
 {
 	printf("Got signal %d, signo %d errno %d code %d addr: %p urb: %p\n",
 	       sig, info->si_signo, info->si_errno, info->si_code,
 	       info->si_addr, &urb);

 	printf("%s\n", (info->si_addr == &urb) ? "Good" : "Bad");
 }

 void ds_handler(int sig, siginfo_t *info , void *ucontext)
 {
 	printf("Got signal %d, signo %d errno %d code %d addr: %p ds: %p\n",
 	       sig, info->si_signo, info->si_errno, info->si_code,
 	       info->si_addr, &ds);

 	printf("%s\n", (info->si_addr == &ds) ? "Good" : "Bad");
 	done = 1;
 }

 int main(int argc, char **argv)
 {
 	char *devfilename;
 	int fd;
 	int rc;
 	struct sigaction act;
 	struct usb_ctrlrequest *req;
 	void *ptr;
 	char buf[80];

 	if (argc != 2) {
 		fprintf(stderr, "Usage: usbsig device-file-name\n");
 		return 1;
 	}

 	devfilename = argv[1];
 	fd = open(devfilename, O_RDWR);
 	if (fd == -1) {
 		perror("Error opening device file");
 		return 1;
 	}

 	act.sa_sigaction = urb_handler;
 	sigemptyset(&act.sa_mask);
 	act.sa_flags = SA_SIGINFO;

 	rc = sigaction(SIGUSR1, &act, NULL);
 	if (rc == -1) {
 		perror("Error in sigaction");
 		return 1;
 	}

 	act.sa_sigaction = ds_handler;
 	sigemptyset(&act.sa_mask);
 	act.sa_flags = SA_SIGINFO;

 	rc = sigaction(SIGUSR2, &act, NULL);
 	if (rc == -1) {
 		perror("Error in sigaction");
 		return 1;
 	}

 	memset(&urb, 0, sizeof(urb));
 	urb.type = USBDEVFS_URB_TYPE_CONTROL;
 	urb.endpoint = USB_DIR_IN | 0;
 	urb.buffer = buf;
 	urb.buffer_length = sizeof(buf);
 	urb.signr = SIGUSR1;

 	req = (struct usb_ctrlrequest *) buf;
 	req->bRequestType = USB_DIR_IN | USB_TYPE_STANDARD | USB_RECIP_DEVICE;
 	req->bRequest = USB_REQ_GET_DESCRIPTOR;
 	req->wValue = htole16(USB_DT_DEVICE << 8);
 	req->wIndex = htole16(0);
 	req->wLength = htole16(sizeof(buf) - sizeof(*req));

 	rc = ioctl(fd, USBDEVFS_SUBMITURB, &urb);
 	if (rc == -1) {
 		perror("Error in SUBMITURB ioctl");
 		return 1;
 	}

 	rc = ioctl(fd, USBDEVFS_REAPURB, &ptr);
 	if (rc == -1) {
 		perror("Error in REAPURB ioctl");
 		return 1;
 	}

 	memset(&ds, 0, sizeof(ds));
 	ds.signr = SIGUSR2;
 	ds.context = &ds;
 	rc = ioctl(fd, USBDEVFS_DISCSIGNAL, &ds);
 	if (rc == -1) {
 		perror("Error in DISCSIGNAL ioctl");
 		return 1;
 	}

 	printf("Waiting for usb disconnect\n");
 	while (!done) {
 		sleep(1);
 	}

 	close(fd);
 	return 0;
 }

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oneukum@suse.com>
Fixes: v2.3.39
Cc: stable@vger.kernel.org
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index fa783531ee88..a02448105527 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -63,7 +63,7 @@ struct usb_dev_state {
 	unsigned int discsignr;
 	struct pid *disc_pid;
 	const struct cred *cred;
-	void __user *disccontext;
+	sigval_t disccontext;
 	unsigned long ifclaimed;
 	u32 disabled_bulk_eps;
 	bool privileges_dropped;
@@ -90,6 +90,7 @@ struct async {
 	unsigned int ifnum;
 	void __user *userbuffer;
 	void __user *userurb;
+	sigval_t userurb_sigval;
 	struct urb *urb;
 	struct usb_memory *usbm;
 	unsigned int mem_usage;
@@ -582,22 +583,19 @@ static void async_completed(struct urb *urb)
 {
 	struct async *as = urb->context;
 	struct usb_dev_state *ps = as->ps;
-	struct kernel_siginfo sinfo;
 	struct pid *pid = NULL;
 	const struct cred *cred = NULL;
 	unsigned long flags;
-	int signr;
+	sigval_t addr;
+	int signr, errno;
 
 	spin_lock_irqsave(&ps->lock, flags);
 	list_move_tail(&as->asynclist, &ps->async_completed);
 	as->status = urb->status;
 	signr = as->signr;
 	if (signr) {
-		clear_siginfo(&sinfo);
-		sinfo.si_signo = as->signr;
-		sinfo.si_errno = as->status;
-		sinfo.si_code = SI_ASYNCIO;
-		sinfo.si_addr = as->userurb;
+		errno = as->status;
+		addr = as->userurb_sigval;
 		pid = get_pid(as->pid);
 		cred = get_cred(as->cred);
 	}
@@ -615,7 +613,7 @@ static void async_completed(struct urb *urb)
 	spin_unlock_irqrestore(&ps->lock, flags);
 
 	if (signr) {
-		kill_pid_info_as_cred(sinfo.si_signo, &sinfo, pid, cred);
+		kill_pid_usb_asyncio(signr, errno, addr, pid, cred);
 		put_pid(pid);
 		put_cred(cred);
 	}
@@ -1427,7 +1425,7 @@ find_memory_area(struct usb_dev_state *ps, const struct usbdevfs_urb *uurb)
 
 static int proc_do_submiturb(struct usb_dev_state *ps, struct usbdevfs_urb *uurb,
 			struct usbdevfs_iso_packet_desc __user *iso_frame_desc,
-			void __user *arg)
+			void __user *arg, sigval_t userurb_sigval)
 {
 	struct usbdevfs_iso_packet_desc *isopkt = NULL;
 	struct usb_host_endpoint *ep;
@@ -1727,6 +1725,7 @@ static int proc_do_submiturb(struct usb_dev_state *ps, struct usbdevfs_urb *uurb
 	isopkt = NULL;
 	as->ps = ps;
 	as->userurb = arg;
+	as->userurb_sigval = userurb_sigval;
 	if (as->usbm) {
 		unsigned long uurb_start = (unsigned long)uurb->buffer;
 
@@ -1801,13 +1800,17 @@ static int proc_do_submiturb(struct usb_dev_state *ps, struct usbdevfs_urb *uurb
 static int proc_submiturb(struct usb_dev_state *ps, void __user *arg)
 {
 	struct usbdevfs_urb uurb;
+	sigval_t userurb_sigval;
 
 	if (copy_from_user(&uurb, arg, sizeof(uurb)))
 		return -EFAULT;
 
+	memset(&userurb_sigval, 0, sizeof(userurb_sigval));
+	userurb_sigval.sival_ptr = arg;
+
 	return proc_do_submiturb(ps, &uurb,
 			(((struct usbdevfs_urb __user *)arg)->iso_frame_desc),
-			arg);
+			arg, userurb_sigval);
 }
 
 static int proc_unlinkurb(struct usb_dev_state *ps, void __user *arg)
@@ -1977,7 +1980,7 @@ static int proc_disconnectsignal_compat(struct usb_dev_state *ps, void __user *a
 	if (copy_from_user(&ds, arg, sizeof(ds)))
 		return -EFAULT;
 	ps->discsignr = ds.signr;
-	ps->disccontext = compat_ptr(ds.context);
+	ps->disccontext.sival_int = ds.context;
 	return 0;
 }
 
@@ -2005,13 +2008,17 @@ static int get_urb32(struct usbdevfs_urb *kurb,
 static int proc_submiturb_compat(struct usb_dev_state *ps, void __user *arg)
 {
 	struct usbdevfs_urb uurb;
+	sigval_t userurb_sigval;
 
 	if (get_urb32(&uurb, (struct usbdevfs_urb32 __user *)arg))
 		return -EFAULT;
 
+	memset(&userurb_sigval, 0, sizeof(userurb_sigval));
+	userurb_sigval.sival_int = ptr_to_compat(arg);
+
 	return proc_do_submiturb(ps, &uurb,
 			((struct usbdevfs_urb32 __user *)arg)->iso_frame_desc,
-			arg);
+			arg, userurb_sigval);
 }
 
 static int processcompl_compat(struct async *as, void __user * __user *arg)
@@ -2092,7 +2099,7 @@ static int proc_disconnectsignal(struct usb_dev_state *ps, void __user *arg)
 	if (copy_from_user(&ds, arg, sizeof(ds)))
 		return -EFAULT;
 	ps->discsignr = ds.signr;
-	ps->disccontext = ds.context;
+	ps->disccontext.sival_ptr = ds.context;
 	return 0;
 }
 
@@ -2614,22 +2621,15 @@ const struct file_operations usbdev_file_operations = {
 static void usbdev_remove(struct usb_device *udev)
 {
 	struct usb_dev_state *ps;
-	struct kernel_siginfo sinfo;
 
 	while (!list_empty(&udev->filelist)) {
 		ps = list_entry(udev->filelist.next, struct usb_dev_state, list);
 		destroy_all_async(ps);
 		wake_up_all(&ps->wait);
 		list_del_init(&ps->list);
-		if (ps->discsignr) {
-			clear_siginfo(&sinfo);
-			sinfo.si_signo = ps->discsignr;
-			sinfo.si_errno = EPIPE;
-			sinfo.si_code = SI_ASYNCIO;
-			sinfo.si_addr = ps->disccontext;
-			kill_pid_info_as_cred(ps->discsignr, &sinfo,
-					ps->disc_pid, ps->cred);
-		}
+		if (ps->discsignr)
+			kill_pid_usb_asyncio(ps->discsignr, EPIPE, ps->disccontext,
+					     ps->disc_pid, ps->cred);
 	}
 }
 
diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
index 38a0f0785323..c68ca81db0a1 100644
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -329,7 +329,7 @@ extern void force_sigsegv(int sig, struct task_struct *p);
 extern int force_sig_info(int, struct kernel_siginfo *, struct task_struct *);
 extern int __kill_pgrp_info(int sig, struct kernel_siginfo *info, struct pid *pgrp);
 extern int kill_pid_info(int sig, struct kernel_siginfo *info, struct pid *pid);
-extern int kill_pid_info_as_cred(int, struct kernel_siginfo *, struct pid *,
+extern int kill_pid_usb_asyncio(int sig, int errno, sigval_t addr, struct pid *,
 				const struct cred *);
 extern int kill_pgrp(struct pid *pid, int sig, int priv);
 extern int kill_pid(struct pid *pid, int sig, int priv);
diff --git a/kernel/signal.c b/kernel/signal.c
index a1eb44dc9ff5..18040d6bd63a 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1439,13 +1439,44 @@ static inline bool kill_as_cred_perm(const struct cred *cred,
 	       uid_eq(cred->uid, pcred->uid);
 }
 
-/* like kill_pid_info(), but doesn't use uid/euid of "current" */
-int kill_pid_info_as_cred(int sig, struct kernel_siginfo *info, struct pid *pid,
-			 const struct cred *cred)
+/*
+ * The usb asyncio usage of siginfo is wrong.  The glibc support
+ * for asyncio which uses SI_ASYNCIO assumes the layout is SIL_RT.
+ * AKA after the generic fields:
+ *	kernel_pid_t	si_pid;
+ *	kernel_uid32_t	si_uid;
+ *	sigval_t	si_value;
+ *
+ * Unfortunately when usb generates SI_ASYNCIO it assumes the layout
+ * after the generic fields is:
+ *	void __user 	*si_addr;
+ *
+ * This is a practical problem when there is a 64bit big endian kernel
+ * and a 32bit userspace.  As the 32bit address will encoded in the low
+ * 32bits of the pointer.  Those low 32bits will be stored at higher
+ * address than appear in a 32 bit pointer.  So userspace will not
+ * see the address it was expecting for it's completions.
+ *
+ * There is nothing in the encoding that can allow
+ * copy_siginfo_to_user32 to detect this confusion of formats, so
+ * handle this by requiring the caller of kill_pid_usb_asyncio to
+ * notice when this situration takes place and to store the 32bit
+ * pointer in sival_int, instead of sival_addr of the sigval_t addr
+ * parameter.
+ */
+int kill_pid_usb_asyncio(int sig, int errno, sigval_t addr,
+			 struct pid *pid, const struct cred *cred)
 {
-	int ret = -EINVAL;
+	struct kernel_siginfo info;
 	struct task_struct *p;
 	unsigned long flags;
+	int ret = -EINVAL;
+
+	clear_siginfo(&info);
+	info.si_signo = sig;
+	info.si_errno = errno;
+	info.si_code = SI_ASYNCIO;
+	*((sigval_t *)&info.si_pid) = addr;
 
 	if (!valid_signal(sig))
 		return ret;
@@ -1456,17 +1487,17 @@ int kill_pid_info_as_cred(int sig, struct kernel_siginfo *info, struct pid *pid,
 		ret = -ESRCH;
 		goto out_unlock;
 	}
-	if (si_fromuser(info) && !kill_as_cred_perm(cred, p)) {
+	if (!kill_as_cred_perm(cred, p)) {
 		ret = -EPERM;
 		goto out_unlock;
 	}
-	ret = security_task_kill(p, info, sig, cred);
+	ret = security_task_kill(p, &info, sig, cred);
 	if (ret)
 		goto out_unlock;
 
 	if (sig) {
 		if (lock_task_sighand(p, &flags)) {
-			ret = __send_signal(sig, info, p, PIDTYPE_TGID, 0);
+			ret = __send_signal(sig, &info, p, PIDTYPE_TGID, 0);
 			unlock_task_sighand(p, &flags);
 		} else
 			ret = -ESRCH;
@@ -1475,7 +1506,7 @@ int kill_pid_info_as_cred(int sig, struct kernel_siginfo *info, struct pid *pid,
 	rcu_read_unlock();
 	return ret;
 }
-EXPORT_SYMBOL_GPL(kill_pid_info_as_cred);
+EXPORT_SYMBOL_GPL(kill_pid_usb_asyncio);
 
 /*
  * kill_something_info() interprets pid in interesting ways just like kill(2).
@@ -4474,6 +4505,28 @@ static inline void siginfo_buildtime_checks(void)
 	CHECK_OFFSET(si_syscall);
 	CHECK_OFFSET(si_arch);
 #undef CHECK_OFFSET
+
+	/* usb asyncio */
+	BUILD_BUG_ON(offsetof(struct siginfo, si_pid) !=
+		     offsetof(struct siginfo, si_addr));
+	if (sizeof(int) == sizeof(void __user *)) {
+		BUILD_BUG_ON(sizeof_field(struct siginfo, si_pid) !=
+			     sizeof(void __user *));
+	} else {
+		BUILD_BUG_ON((sizeof_field(struct siginfo, si_pid) +
+			      sizeof_field(struct siginfo, si_uid)) !=
+			     sizeof(void __user *));
+		BUILD_BUG_ON(offsetofend(struct siginfo, si_pid) !=
+			     offsetof(struct siginfo, si_uid));
+	}
+#ifdef CONFIG_COMPAT
+	BUILD_BUG_ON(offsetof(struct compat_siginfo, si_pid) !=
+		     offsetof(struct compat_siginfo, si_addr));
+	BUILD_BUG_ON(sizeof_field(struct compat_siginfo, si_pid) !=
+		     sizeof(compat_uptr_t));
+	BUILD_BUG_ON(sizeof_field(struct compat_siginfo, si_pid) !=
+		     sizeof_field(struct siginfo, si_pid));
+#endif
 }
 
 void __init signals_init(void)

