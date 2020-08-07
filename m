Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9330423EE2F
	for <lists+stable@lfdr.de>; Fri,  7 Aug 2020 15:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726159AbgHGN2j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Aug 2020 09:28:39 -0400
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:36633 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725970AbgHGN2i (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Aug 2020 09:28:38 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id E1EDAAB0;
        Fri,  7 Aug 2020 09:28:36 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 07 Aug 2020 09:28:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=YjH9+2
        Zcn3XK7ZvTh4uH4BUpv2cJ0Mq62B9BxC1Udp0=; b=RCz3EtwIuLQ/eblA488oLC
        zAd/U7ojv3asYVnAU8iK+cl2D+NljutjIkO+KAwYrHaVctw1VFJJOH9q/NrLhmW8
        RbgGMwLvvJQMghhswLyS0DGhZULYC51ORsutitLE1E/Ac8nBcy58T9c3adDSCYOR
        Z30dBZrVTEVTNKh3AzkjnRxaPYg6XXjRaQZHEiOWIpfWBB9V+utCFzMb1+I46l0/
        wDOPlf2+uaXvzThDv9U0t9YzTF9N1xLrCrKD3hVtmINfOfB//VEqQO2PiC4GSgVQ
        q3VUhVmPLVBoHrAbVNjqol2pTpVRlMowSIfehBOwjO3NJR333PotAZAMbYPv9DiA
        ==
X-ME-Sender: <xms:BFctX9BsyVoA0QG5NabrbKiBPS823wOrLwT97xm0k8QGDV_-_U84aA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrkedvgdeiiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:BFctX7hQPJdUhE-yTfrYTA9LV9qc2bAWH5zVXIXIPdtaxyeyxOWmmw>
    <xmx:BFctX4kGNIYnjRf9NU30_YM0wt2kZZynhiEm-wKjkj9fKysSTEqucg>
    <xmx:BFctX3xKNfvgXD4pqf_LbCxD5rGeOgGXOHm07RIJlaocWNb7J7lA5Q>
    <xmx:BFctX5PiRFflLDfOGbEv3GX-ZRGOvT5TgNQ3Aovob_98G32FFODGqVzfg64>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1495D3280064;
        Fri,  7 Aug 2020 09:28:35 -0400 (EDT)
Subject: FAILED: patch "[PATCH] Smack: fix use-after-free in smk_write_relabel_self()" failed to apply to 4.14-stable tree
To:     ebiggers@google.com, casey@schaufler-ca.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 07 Aug 2020 15:28:41 +0200
Message-ID: <159680692182136@kroah.com>
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

From beb4ee6770a89646659e6a2178538d2b13e2654e Mon Sep 17 00:00:00 2001
From: Eric Biggers <ebiggers@google.com>
Date: Wed, 8 Jul 2020 13:15:20 -0700
Subject: [PATCH] Smack: fix use-after-free in smk_write_relabel_self()

smk_write_relabel_self() frees memory from the task's credentials with
no locking, which can easily cause a use-after-free because multiple
tasks can share the same credentials structure.

Fix this by using prepare_creds() and commit_creds() to correctly modify
the task's credentials.

Reproducer for "BUG: KASAN: use-after-free in smk_write_relabel_self":

	#include <fcntl.h>
	#include <pthread.h>
	#include <unistd.h>

	static void *thrproc(void *arg)
	{
		int fd = open("/sys/fs/smackfs/relabel-self", O_WRONLY);
		for (;;) write(fd, "foo", 3);
	}

	int main()
	{
		pthread_t t;
		pthread_create(&t, NULL, thrproc, NULL);
		thrproc(NULL);
	}

Reported-by: syzbot+e6416dabb497a650da40@syzkaller.appspotmail.com
Fixes: 38416e53936e ("Smack: limited capability for changing process label")
Cc: <stable@vger.kernel.org> # v4.4+
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index c21b656b3263..840a192e9337 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -2720,7 +2720,6 @@ static int smk_open_relabel_self(struct inode *inode, struct file *file)
 static ssize_t smk_write_relabel_self(struct file *file, const char __user *buf,
 				size_t count, loff_t *ppos)
 {
-	struct task_smack *tsp = smack_cred(current_cred());
 	char *data;
 	int rc;
 	LIST_HEAD(list_tmp);
@@ -2745,11 +2744,21 @@ static ssize_t smk_write_relabel_self(struct file *file, const char __user *buf,
 	kfree(data);
 
 	if (!rc || (rc == -EINVAL && list_empty(&list_tmp))) {
+		struct cred *new;
+		struct task_smack *tsp;
+
+		new = prepare_creds();
+		if (!new) {
+			rc = -ENOMEM;
+			goto out;
+		}
+		tsp = smack_cred(new);
 		smk_destroy_label_list(&tsp->smk_relabel);
 		list_splice(&list_tmp, &tsp->smk_relabel);
+		commit_creds(new);
 		return count;
 	}
-
+out:
 	smk_destroy_label_list(&list_tmp);
 	return rc;
 }

