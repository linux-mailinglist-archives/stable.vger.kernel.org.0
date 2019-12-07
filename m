Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A789C115C26
	for <lists+stable@lfdr.de>; Sat,  7 Dec 2019 13:06:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbfLGMGo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Dec 2019 07:06:44 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:53535 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726185AbfLGMGo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Dec 2019 07:06:44 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 389C8227DF;
        Sat,  7 Dec 2019 07:06:43 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sat, 07 Dec 2019 07:06:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=oNGTzK
        64nE6g0JpClNeaHIqjpK4m1JY4WPSXBh33jto=; b=mIERyxd7qWHTi8o9rF8aD2
        HVnuObbPw+7uB1yaicnqjFbw6KWsXA+wpyYnz3keGSE0Z1XZmT8q9tUSifTiUE+k
        3WqvqYJoPPRxfwwjwmvnbiKMVTNYqRdUgJIJzMLf009ChlF940bPwQ06LBqIVg1f
        z6cCFkoOlCyusIoNaBv7QeNFucaXFLodA0y2OkkO05PQPJOVkTps/iJSTofXcuqJ
        Z3nUrWMyc3yh+LZ7ADV7wFOea4q3mxveFQNixkcbME8uU5Covmp5j2k45A6td95l
        hF78VhtUBih6ctbyTsNUIbka6HGTJ0c8AGls07OegV/7si5svylDTNFevbnLUzyQ
        ==
X-ME-Sender: <xms:05XrXaR20-8YtVbnotfyTcyRBatKKhUMdOx9GZJI8_Mdd4JacJa6DA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudekhedgfeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:05XrXScxPA2Ow0zov3XRkApZbwRdSyw1rZUkYe45gRns_qduIG0b_A>
    <xmx:05XrXVUl9jqHCkJ1C6WR4xbVpqkEqpMzk8g1GbujNl7Nj_jYFk8dbg>
    <xmx:05XrXca12PS_uPLc1IjYqrzw4fWI4Jy5rvjbfIBmvOgr9nHsA0YyWg>
    <xmx:05XrXf29mQztx5dLa0d4F76DmbfQEIN1FTKjjtQc1Lhu11IVz3UHGA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id CE288306035B;
        Sat,  7 Dec 2019 07:06:42 -0500 (EST)
Subject: FAILED: patch "[PATCH] fuse: verify write return" failed to apply to 4.19-stable tree
To:     mszeredi@redhat.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 07 Dec 2019 13:06:33 +0100
Message-ID: <157572039319182@kroah.com>
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

From 8aab336b14c115c6bf1d4baeb9247e41ed9ce6de Mon Sep 17 00:00:00 2001
From: Miklos Szeredi <mszeredi@redhat.com>
Date: Tue, 12 Nov 2019 11:49:04 +0100
Subject: [PATCH] fuse: verify write return

Make sure filesystem is not returning a bogus number of bytes written.

Fixes: ea9b9907b82a ("fuse: implement perform_write")
Cc: <stable@vger.kernel.org> # v2.6.26
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index db48a5cf8620..795d0f24d8b4 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1096,6 +1096,8 @@ static ssize_t fuse_send_write_pages(struct fuse_io_args *ia,
 	ia->write.in.flags = fuse_write_flags(iocb);
 
 	err = fuse_simple_request(fc, &ap->args);
+	if (!err && ia->write.out.size > count)
+		err = -EIO;
 
 	offset = ap->descs[0].offset;
 	count = ia->write.out.size;

