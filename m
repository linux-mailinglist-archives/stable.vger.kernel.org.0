Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0369323EE2E
	for <lists+stable@lfdr.de>; Fri,  7 Aug 2020 15:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbgHGN2h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Aug 2020 09:28:37 -0400
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:44379 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726015AbgHGN2d (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Aug 2020 09:28:33 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id D0D24ADF;
        Fri,  7 Aug 2020 09:28:29 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 07 Aug 2020 09:28:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=+RkQ3J
        OZSmaQbMwRhZSDk90B6m9GdN38YibVnN4vpII=; b=US7on3fDQhO8jInCMDoPKA
        XwO3OAo43KpoYKqfyi2Uk997wyYNcJBmzFWCSx5c+aUg1EPDuXrkyTxu+jeS5fxB
        bKG8cTR5Ysij+dLr/wGIAIFpYGhjOSA7nCx0dxH0CvbiVj4h8LCRdkhizs5Ho+Bs
        qH5aDx6Ll4KbKC2p9pG07VGFCs7P1gAoq3XRbh0XD/nHcgcUEqAKEbNCL27eI6t3
        /17KksmIownuIOc2wLOmwbdijQ1HMc6Mq4Ss9qset6h2BbhaQH0s8jWlKTbuPAok
        xAXIkrr5HU1WeUNmApGYfbXGGRKS4UvDOtMcJvjRcLD8zEW9a/rwczi88bpKU8IA
        ==
X-ME-Sender: <xms:_VYtXywaTIw-LB0tlG0v3YbLRXU8Q9gYH1CeQKKL4H3AgAHdY37zTw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrkedvgdeiiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:_VYtX-TIcKxZLeZtvwiSWJYZNpQdHWKpK08DeNfPw8i1UupWPM_wRw>
    <xmx:_VYtX0W5EqKSt-IUtDmMC9sHSJv1pTWBBFlh5gfObL5ED8mENB6Jkw>
    <xmx:_VYtX4hM7LovINAwFKTVr78S5CCwCndsPpv0ds4NU3myXlmvnNyPwg>
    <xmx:_VYtXz-0B1zgBnbqa88izsEE2OwEW6L0019cFSz4WGrpCWTkiYA560GDRpw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E11103060067;
        Fri,  7 Aug 2020 09:28:28 -0400 (EDT)
Subject: FAILED: patch "[PATCH] Smack: fix use-after-free in smk_write_relabel_self()" failed to apply to 4.4-stable tree
To:     ebiggers@google.com, casey@schaufler-ca.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 07 Aug 2020 15:28:40 +0200
Message-ID: <1596806920934@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
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

