Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9C4F2F9CD2
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 11:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389223AbhARK0k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 05:26:40 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:53071 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388301AbhARJss (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jan 2021 04:48:48 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 2560C167D;
        Mon, 18 Jan 2021 04:47:55 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 18 Jan 2021 04:47:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=oCp9uD
        VlLslyFksAeGfKd1bytJnkVkQGUEmHFM1llDQ=; b=TJ+wooUQinGgAUpbdJhbx9
        3XVMbqi60HL1T59RfX8tzVG0nr1R/iEJxn6E3yfsHkgkUF+yronEPHqUCnHk8iSi
        uV0oHHmuntLKY9w1XVLPv4ftC0a+UzCLVTxAzzI/qEBwFKZhXihdpjmzsRxXJ7wA
        naXHdSf2RjTmZNl3ooE5NI32JsLu/aUPWTRTA4YE3bSJ0yCL95i7xVDGlhfuMkdQ
        yqagWjRM+AHcG2C/TD2oe/t3KqXjgqkwlsXjydLOHoKYdpvKJnTDYe0v50ynyKCs
        tuaEiC0+v8YNyzta/RrjglSuWPKJH2ACcUC9WCXSW6rUQBThJdH2AsksaWx4S1vQ
        ==
X-ME-Sender: <xms:SlkFYJfy_XhlJBKUNHLZT0CP83LGnfk6eDIjQ_zb_FTlVhhRQNCRpA>
    <xme:SlkFYHMQPomikMZVrf34fwSgtHzcIJr2F4UmptIeB3x7bhwhiqotvODKXgiAfpTbs
    xyuzi0kZeqN_g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtdekgddtkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:SlkFYCirmA1NqKQU6pyfmoCUcKj_l0yyifiXps8715ea3FM5VU7Z-Q>
    <xmx:SlkFYC88irF_EbqROKuR4glmNZ_0vLIls5RYKDksQhfwjVk-RkavhA>
    <xmx:SlkFYFuehUOazpDsE7yxJxSlfkKKuAo5f0fRn0CnUTf1nBPb19Y98g>
    <xmx:SlkFYK6-mnqPqezNd5TYFvzs6_OkbDiwkrzY2Z_rZgQxA54NCQpGbTeI-XY>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6E058240057;
        Mon, 18 Jan 2021 04:47:54 -0500 (EST)
Subject: FAILED: patch "[PATCH] pNFS: We want return-on-close to complete when evicting the" failed to apply to 4.14-stable tree
To:     trond.myklebust@hammerspace.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 Jan 2021 10:47:45 +0100
Message-ID: <1610963265149147@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 078000d02d57f02dde61de4901f289672e98c8bc Mon Sep 17 00:00:00 2001
From: Trond Myklebust <trond.myklebust@hammerspace.com>
Date: Mon, 4 Jan 2021 13:18:03 -0500
Subject: [PATCH] pNFS: We want return-on-close to complete when evicting the
 inode

If the inode is being evicted, it should be safe to run return-on-close,
so we should do it to ensure we don't inadvertently leak layout segments.

Fixes: 1c5bd76d17cc ("pNFS: Enable layoutreturn operation for return-on-close")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 14acd2f79107..2f4679a62712 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3536,10 +3536,8 @@ static void nfs4_close_done(struct rpc_task *task, void *data)
 	trace_nfs4_close(state, &calldata->arg, &calldata->res, task->tk_status);
 
 	/* Handle Layoutreturn errors */
-	if (pnfs_roc_done(task, calldata->inode,
-				&calldata->arg.lr_args,
-				&calldata->res.lr_res,
-				&calldata->res.lr_ret) == -EAGAIN)
+	if (pnfs_roc_done(task, &calldata->arg.lr_args, &calldata->res.lr_res,
+			  &calldata->res.lr_ret) == -EAGAIN)
 		goto out_restart;
 
 	/* hmm. we are done with the inode, and in the process of freeing
@@ -6384,10 +6382,8 @@ static void nfs4_delegreturn_done(struct rpc_task *task, void *calldata)
 	trace_nfs4_delegreturn_exit(&data->args, &data->res, task->tk_status);
 
 	/* Handle Layoutreturn errors */
-	if (pnfs_roc_done(task, data->inode,
-				&data->args.lr_args,
-				&data->res.lr_res,
-				&data->res.lr_ret) == -EAGAIN)
+	if (pnfs_roc_done(task, &data->args.lr_args, &data->res.lr_res,
+			  &data->res.lr_ret) == -EAGAIN)
 		goto out_restart;
 
 	switch (task->tk_status) {
@@ -6441,10 +6437,10 @@ static void nfs4_delegreturn_release(void *calldata)
 	struct nfs4_delegreturndata *data = calldata;
 	struct inode *inode = data->inode;
 
+	if (data->lr.roc)
+		pnfs_roc_release(&data->lr.arg, &data->lr.res,
+				 data->res.lr_ret);
 	if (inode) {
-		if (data->lr.roc)
-			pnfs_roc_release(&data->lr.arg, &data->lr.res,
-					data->res.lr_ret);
 		nfs_post_op_update_inode_force_wcc(inode, &data->fattr);
 		nfs_iput_and_deactive(inode);
 	}
@@ -6520,16 +6516,14 @@ static int _nfs4_proc_delegreturn(struct inode *inode, const struct cred *cred,
 	nfs_fattr_init(data->res.fattr);
 	data->timestamp = jiffies;
 	data->rpc_status = 0;
-	data->lr.roc = pnfs_roc(inode, &data->lr.arg, &data->lr.res, cred);
 	data->inode = nfs_igrab_and_active(inode);
-	if (data->inode) {
+	if (data->inode || issync) {
+		data->lr.roc = pnfs_roc(inode, &data->lr.arg, &data->lr.res,
+					cred);
 		if (data->lr.roc) {
 			data->args.lr_args = &data->lr.arg;
 			data->res.lr_res = &data->lr.res;
 		}
-	} else if (data->lr.roc) {
-		pnfs_roc_release(&data->lr.arg, &data->lr.res, 0);
-		data->lr.roc = false;
 	}
 
 	task_setup_data.callback_data = data;
diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index ccc89fab1802..a18b1992b2fb 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -1509,10 +1509,8 @@ bool pnfs_roc(struct inode *ino,
 	return false;
 }
 
-int pnfs_roc_done(struct rpc_task *task, struct inode *inode,
-		struct nfs4_layoutreturn_args **argpp,
-		struct nfs4_layoutreturn_res **respp,
-		int *ret)
+int pnfs_roc_done(struct rpc_task *task, struct nfs4_layoutreturn_args **argpp,
+		  struct nfs4_layoutreturn_res **respp, int *ret)
 {
 	struct nfs4_layoutreturn_args *arg = *argpp;
 	int retval = -EAGAIN;
@@ -1545,7 +1543,7 @@ int pnfs_roc_done(struct rpc_task *task, struct inode *inode,
 		return 0;
 	case -NFS4ERR_OLD_STATEID:
 		if (!nfs4_layout_refresh_old_stateid(&arg->stateid,
-					&arg->range, inode))
+						     &arg->range, arg->inode))
 			break;
 		*ret = -NFS4ERR_NOMATCHING_LAYOUT;
 		return -EAGAIN;
diff --git a/fs/nfs/pnfs.h b/fs/nfs/pnfs.h
index bbd3de1025f2..d810ae674f4e 100644
--- a/fs/nfs/pnfs.h
+++ b/fs/nfs/pnfs.h
@@ -297,10 +297,8 @@ bool pnfs_roc(struct inode *ino,
 		struct nfs4_layoutreturn_args *args,
 		struct nfs4_layoutreturn_res *res,
 		const struct cred *cred);
-int pnfs_roc_done(struct rpc_task *task, struct inode *inode,
-		struct nfs4_layoutreturn_args **argpp,
-		struct nfs4_layoutreturn_res **respp,
-		int *ret);
+int pnfs_roc_done(struct rpc_task *task, struct nfs4_layoutreturn_args **argpp,
+		  struct nfs4_layoutreturn_res **respp, int *ret);
 void pnfs_roc_release(struct nfs4_layoutreturn_args *args,
 		struct nfs4_layoutreturn_res *res,
 		int ret);
@@ -772,7 +770,7 @@ pnfs_roc(struct inode *ino,
 }
 
 static inline int
-pnfs_roc_done(struct rpc_task *task, struct inode *inode,
+pnfs_roc_done(struct rpc_task *task,
 		struct nfs4_layoutreturn_args **argpp,
 		struct nfs4_layoutreturn_res **respp,
 		int *ret)

