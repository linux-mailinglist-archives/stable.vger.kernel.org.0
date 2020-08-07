Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80F1A23EE30
	for <lists+stable@lfdr.de>; Fri,  7 Aug 2020 15:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726186AbgHGN2o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Aug 2020 09:28:44 -0400
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:47635 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726015AbgHGN2j (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Aug 2020 09:28:39 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id A7E53AD6;
        Fri,  7 Aug 2020 09:28:38 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 07 Aug 2020 09:28:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=2Ba1/J
        lxZT33MsHVjGFMWiOG3tldS336PVrodDx3EtU=; b=o8Vi7kb+qX5STdzXDOgkED
        SO6lwOAeeHXa3rUf8TQAbkD9INCVydFAclj2iKDjKzDH80iuM0jGWpvNlRGBDag5
        cWBWNUNnuo35x71M206efpj17jlu/DiF5arhMXQNJNtOMIOJMvEHPvlLV/2bm4OA
        CpSMPTjQ3+YqN3mCgng4c3lPmcnv4+3T+kmuz8wbuw+GsMl9oZaftxWhlc06hXZI
        nhZBwx+ZahH5SoOdI13MlsZZ0wK/TT5koS2iUFMM3+hvk/ouVqZAoxA/89ug7cqV
        N7qMs0s2+KvLGBOY0mtnM/muOi8HGIWRCX/h3TJz3U1aeUEAo7CgRD3otfKI3K2g
        ==
X-ME-Sender: <xms:BlctX09hMZFxcDPQuI9rU2eq7cCxoPAh02jxL3FeH3Qh6zYmLdJr1w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrkedvgdeiiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgv
    rhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:BlctX8uEPa4h9i7KSEkJ1HZT17AIjm0wR_EiuoJ8IIswkB03pXBQNQ>
    <xmx:BlctX6BEBOJvaRvhIuXj4Rnx9rP5Bhn0XhsopkxmUkyiWUZCe-_u-g>
    <xmx:BlctX0dk3FnZbosdS1jGMkhKYr4vB-PBlBdpfItCd1oWSbCkVJMpjQ>
    <xmx:BlctXwZmg2FaG7H7kxkJRk76yrw9Wj82UJ88UZ4faNJJHdx_sPg2YN0n5fo>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C9EA03280066;
        Fri,  7 Aug 2020 09:28:37 -0400 (EDT)
Subject: FAILED: patch "[PATCH] Smack: fix use-after-free in smk_write_relabel_self()" failed to apply to 4.9-stable tree
To:     ebiggers@google.com, casey@schaufler-ca.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 07 Aug 2020 15:28:41 +0200
Message-ID: <159680692190131@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
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

