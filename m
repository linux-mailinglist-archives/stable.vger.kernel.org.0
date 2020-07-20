Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 288A1225E42
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 14:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728601AbgGTMRU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 08:17:20 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:56543 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728564AbgGTMRT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jul 2020 08:17:19 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 7D93D1941116;
        Mon, 20 Jul 2020 08:17:18 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 20 Jul 2020 08:17:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=nKZb7N
        bdXCfw7b7KfFhj8C+v2mczaXWCvfrynKQDQZY=; b=S2XzFE/fFnt8OxjUpuM7xK
        0ZQLWO1HIRcY1pmMUNTFVkg2KvfBF+3YBSwejE8FmRyLZQlveCHog9jzhaAGWuq+
        DGysqD1F4qSVerXNZX9M7D8ZEv+F0NPoPfhWQNS8lP5YNb0cbk4tPtPwFOrMDrCh
        0eDYbjKNPZeD25EzciqOkecx9smasftoKswK41GZ/sEYcT5+Z/nqwmbk4qP4nBE8
        6S9I5vtSSRXDHwp8av1bGrf+rj2vS+Nx196Yj5CNw4xVUhpWW0F3cwHrA6X7LibW
        ennMaxfPVWsAKSoV+uY2EOWfFZULChdmW6/rbjr97zA1KjBsZyRA8Gxj8TsHsaiQ
        ==
X-ME-Sender: <xms:TYsVXwKuIaB0w27b6ABkeHJOQzVjqad1qNGX632E5tu4BaKwBkk28g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrgeeggddvhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    ejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpedvffegjeejiedtieffjeeijeffgfehvdeiudejheefge
    evhffhvedvfeeuheekleenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhrghen
    ucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:TYsVXwL_et7SU51b4FFfls8CAtrcfWiBIJdKhKfdC91KEN-iA96hWw>
    <xmx:TYsVXwu4sgTbd8EinlUwp8YN2Np126-kuczdVaIMRkxUGTzihEdLJA>
    <xmx:TYsVX9aqeQrBS1NNlL6wLqpr3ein774iBZsx63O9KBh6jkqIEWmwgQ>
    <xmx:TosVX-z6DqFzZaTe1ed4hXBHcbTZ33YBdR22gVFzI3VcEM4kFHn4Ag>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3D3B43060067;
        Mon, 20 Jul 2020 08:17:17 -0400 (EDT)
Subject: FAILED: patch "[PATCH] dmabuf: use spinlock to access dmabuf->name" failed to apply to 5.4-stable tree
To:     charante@codeaurora.org, christian.koenig@amd.com,
        michael.j.ruhl@intel.com, stable@vger.kernel.org,
        sumit.semwal@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Jul 2020 14:17:26 +0200
Message-ID: <15952474469367@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6348dd291e3653534a9e28e6917569bc9967b35b Mon Sep 17 00:00:00 2001
From: Charan Teja Kalla <charante@codeaurora.org>
Date: Fri, 19 Jun 2020 17:27:19 +0530
Subject: [PATCH] dmabuf: use spinlock to access dmabuf->name
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

There exists a sleep-while-atomic bug while accessing the dmabuf->name
under mutex in the dmabuffs_dname(). This is caused from the SELinux
permissions checks on a process where it tries to validate the inherited
files from fork() by traversing them through iterate_fd() (which
traverse files under spin_lock) and call
match_file(security/selinux/hooks.c) where the permission checks happen.
This audit information is logged using dump_common_audit_data() where it
calls d_path() to get the file path name. If the file check happen on
the dmabuf's fd, then it ends up in ->dmabuffs_dname() and use mutex to
access dmabuf->name. The flow will be like below:
flush_unauthorized_files()
  iterate_fd()
    spin_lock() --> Start of the atomic section.
      match_file()
        file_has_perm()
          avc_has_perm()
            avc_audit()
              slow_avc_audit()
	        common_lsm_audit()
		  dump_common_audit_data()
		    audit_log_d_path()
		      d_path()
                        dmabuffs_dname()
                          mutex_lock()--> Sleep while atomic.

Call trace captured (on 4.19 kernels) is below:
___might_sleep+0x204/0x208
__might_sleep+0x50/0x88
__mutex_lock_common+0x5c/0x1068
__mutex_lock_common+0x5c/0x1068
mutex_lock_nested+0x40/0x50
dmabuffs_dname+0xa0/0x170
d_path+0x84/0x290
audit_log_d_path+0x74/0x130
common_lsm_audit+0x334/0x6e8
slow_avc_audit+0xb8/0xf8
avc_has_perm+0x154/0x218
file_has_perm+0x70/0x180
match_file+0x60/0x78
iterate_fd+0x128/0x168
selinux_bprm_committing_creds+0x178/0x248
security_bprm_committing_creds+0x30/0x48
install_exec_creds+0x1c/0x68
load_elf_binary+0x3a4/0x14e0
search_binary_handler+0xb0/0x1e0

So, use spinlock to access dmabuf->name to avoid sleep-while-atomic.

Cc: <stable@vger.kernel.org> [5.3+]
Signed-off-by: Charan Teja Kalla <charante@codeaurora.org>
Reviewed-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Acked-by: Christian König <christian.koenig@amd.com>
 [sumits: added comment to spinlock_t definition to avoid warning]
Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/a83e7f0d-4e54-9848-4b58-e1acdbe06735@codeaurora.org

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 412629601ad3..1ca609f66fdf 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -45,10 +45,10 @@ static char *dmabuffs_dname(struct dentry *dentry, char *buffer, int buflen)
 	size_t ret = 0;
 
 	dmabuf = dentry->d_fsdata;
-	dma_resv_lock(dmabuf->resv, NULL);
+	spin_lock(&dmabuf->name_lock);
 	if (dmabuf->name)
 		ret = strlcpy(name, dmabuf->name, DMA_BUF_NAME_LEN);
-	dma_resv_unlock(dmabuf->resv);
+	spin_unlock(&dmabuf->name_lock);
 
 	return dynamic_dname(dentry, buffer, buflen, "/%s:%s",
 			     dentry->d_name.name, ret > 0 ? name : "");
@@ -338,8 +338,10 @@ static long dma_buf_set_name(struct dma_buf *dmabuf, const char __user *buf)
 		kfree(name);
 		goto out_unlock;
 	}
+	spin_lock(&dmabuf->name_lock);
 	kfree(dmabuf->name);
 	dmabuf->name = name;
+	spin_unlock(&dmabuf->name_lock);
 
 out_unlock:
 	dma_resv_unlock(dmabuf->resv);
@@ -402,10 +404,10 @@ static void dma_buf_show_fdinfo(struct seq_file *m, struct file *file)
 	/* Don't count the temporary reference taken inside procfs seq_show */
 	seq_printf(m, "count:\t%ld\n", file_count(dmabuf->file) - 1);
 	seq_printf(m, "exp_name:\t%s\n", dmabuf->exp_name);
-	dma_resv_lock(dmabuf->resv, NULL);
+	spin_lock(&dmabuf->name_lock);
 	if (dmabuf->name)
 		seq_printf(m, "name:\t%s\n", dmabuf->name);
-	dma_resv_unlock(dmabuf->resv);
+	spin_unlock(&dmabuf->name_lock);
 }
 
 static const struct file_operations dma_buf_fops = {
@@ -542,6 +544,7 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
 	dmabuf->size = exp_info->size;
 	dmabuf->exp_name = exp_info->exp_name;
 	dmabuf->owner = exp_info->owner;
+	spin_lock_init(&dmabuf->name_lock);
 	init_waitqueue_head(&dmabuf->poll);
 	dmabuf->cb_excl.poll = dmabuf->cb_shared.poll = &dmabuf->poll;
 	dmabuf->cb_excl.active = dmabuf->cb_shared.active = 0;
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index ab0c156abee6..a2ca294eaebe 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -311,6 +311,7 @@ struct dma_buf {
 	void *vmap_ptr;
 	const char *exp_name;
 	const char *name;
+	spinlock_t name_lock; /* spinlock to protect name access */
 	struct module *owner;
 	struct list_head list_node;
 	void *priv;

