Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25B4620C8CC
	for <lists+stable@lfdr.de>; Sun, 28 Jun 2020 17:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbgF1Pu5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Jun 2020 11:50:57 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:45307 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726040AbgF1Pu5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Jun 2020 11:50:57 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 6FBAE1940713;
        Sun, 28 Jun 2020 11:50:56 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sun, 28 Jun 2020 11:50:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=51X9tR
        3C1TJHI4uisPVqfpLhL+VfdaKGssyWiq0KuYo=; b=FGxshN/loTz9OzgZcK77h0
        AKVUipZ9ePdPj0/C4VVSESJDtfUKqgK5t7m/0ahkW9fiDvRlYTUxCL7u7xkYp5eK
        229R+lb/kvN5qZ6bFtcE9xGJe7Fytr/tZUJIqlsR3RQeZfQVk+DuauO8ctbDITbx
        Cn6xUUZdf0T96dzhYow+7/7Ms45bz8RxENkrSprAdkpPiSvr1jTfnXeSSRn/Zdwr
        RY7dGS/jw7YHp5hrO6Cy6M19sQuAIJpQx5LsIagY3ukauU1fsgGzIHjiCRAsx/Ec
        2W9/XMJwrgL66QRFFej51SltytZ/cpjRpfHaeWHSMYhhZmLkkvP5HUWLR2Y3YcYQ
        ==
X-ME-Sender: <xms:YLz4Xqy8vW42XDEWbmkNHOuion3Vkxwx85bTeXAR0hl8b1LVsPuRRw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeliedgleeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpeejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:YLz4XmT50fyLxLlaPN7qxfTPUovILYd1gVSw4xCFg3mP7DVye8Glrg>
    <xmx:YLz4XsVfB-N6OS7OWwnUNFZdP7YaAjcGPbBMsuonc6uoiuv83fM_Dg>
    <xmx:YLz4Xggxrq68lK0phwhszfJojLMLES7If36n1ygnVq_lAz0tZtZXDg>
    <xmx:YLz4Xl5VZ94g_3LAmtfPMdLtKWsi64SbBVPzJAmML2R5_V43MHdfqw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id EA1B9328005D;
        Sun, 28 Jun 2020 11:50:55 -0400 (EDT)
Subject: FAILED: patch "[PATCH] cifs/smb3: Fix data inconsistent when zero file range" failed to apply to 4.19-stable tree
To:     zhangxiaoxu5@huawei.com, hulkci@huawei.com, pshilov@microsoft.com,
        stfrench@microsoft.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 28 Jun 2020 17:50:40 +0200
Message-ID: <159335944015982@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
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

