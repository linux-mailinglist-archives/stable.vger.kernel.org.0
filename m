Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B98EC20C8CA
	for <lists+stable@lfdr.de>; Sun, 28 Jun 2020 17:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725970AbgF1Put (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Jun 2020 11:50:49 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:39513 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726040AbgF1Pus (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Jun 2020 11:50:48 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id E80101940705;
        Sun, 28 Jun 2020 11:50:47 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Sun, 28 Jun 2020 11:50:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ykDEjk
        vPU8H6Hq2qo0XEdXYscS8DJjux0jRqH7p7wvM=; b=hbv23o3gffg8y4dCG3TGOX
        Z063GKYGqvOUTi8yJlAWECX8FeKIxWg3YlMqU27mQcShLZjcPSxZcbFwK9u75p6v
        2jt2hsNTkoU13KTPnnzZPRWSIpkWcMFTwjWwwoKDB55qdHg1VG/SLKGaEmmdzaDp
        OxDbgt84Vl+JD6gsq7LBqFVVnN8LZBdHAw97vk4P+y8S3GxD7Hld+/JXzK4x7k6m
        jDhGPfQiZCWuswhL0Eg/Xj73bV2AftX3h+QVSdLTEosqotHUUW5j5wBqI1philJC
        pxn9v8WdUOrUO7kJnaDB7y7irQ0FN5KOnaZpvbu477+ZaZLMAgfAoT7muZw0iKkg
        ==
X-ME-Sender: <xms:V7z4XtMFocJLYEs-bViGJFnjnRhea-dtCLLZNYdV-bE7YmWzQdzQAQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeliedgleeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpeegnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:V7z4Xv8oRSreTaF7Q2RLIPHnKAsxLFJA8_wo3z5gdrJGsZ2IIdYMUw>
    <xmx:V7z4XsTmuwYxk_ZkgUFIdEnuID8PFP6zUjXvbz7ED5xnBGk5DvT5mw>
    <xmx:V7z4XpvF6KiUvVY08-p5VavkbcBmTXpMfsXx4YG-9M--zRQbrYJvDg>
    <xmx:V7z4XlHJekiarcIXr3CczFnBvuKeOVkByA9g2_lNBGN1QU_rAQrKHA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 891A73067B94;
        Sun, 28 Jun 2020 11:50:47 -0400 (EDT)
Subject: FAILED: patch "[PATCH] cifs/smb3: Fix data inconsistent when zero file range" failed to apply to 4.14-stable tree
To:     zhangxiaoxu5@huawei.com, hulkci@huawei.com, pshilov@microsoft.com,
        stfrench@microsoft.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 28 Jun 2020 17:50:39 +0200
Message-ID: <159335943922362@kroah.com>
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

From 6b69040247e14b43419a520f841f2b3052833df9 Mon Sep 17 00:00:00 2001
From: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Date: Tue, 23 Jun 2020 07:31:54 -0400
Subject: [PATCH] cifs/smb3: Fix data inconsistent when zero file range

CIFS implements the fallocate(FALLOC_FL_ZERO_RANGE) with send SMB
ioctl(FSCTL_SET_ZERO_DATA) to server. It just set the range of the
remote file to zero, but local page cache not update, then the data
inconsistent with server, which leads the xfstest generic/008 failed.

So we need to remove the local page caches before send SMB
ioctl(FSCTL_SET_ZERO_DATA) to server. After next read, it will
re-cache it.

Fixes: 30175628bf7f5 ("[SMB3] Enable fallocate -z support for SMB3 mounts")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
Cc: stable@vger.kernel.org # v3.17
Signed-off-by: Steve French <stfrench@microsoft.com>

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 28553d45604e..876a0d9e3d46 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -3188,6 +3188,11 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 	trace_smb3_zero_enter(xid, cfile->fid.persistent_fid, tcon->tid,
 			      ses->Suid, offset, len);
 
+	/*
+	 * We zero the range through ioctl, so we need remove the page caches
+	 * first, otherwise the data may be inconsistent with the server.
+	 */
+	truncate_pagecache_range(inode, offset, offset + len - 1);
 
 	/* if file not oplocked can't be sure whether asking to extend size */
 	if (!CIFS_CACHE_READ(cifsi))

