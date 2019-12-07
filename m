Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6221115C29
	for <lists+stable@lfdr.de>; Sat,  7 Dec 2019 13:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbfLGMGs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Dec 2019 07:06:48 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:45153 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726185AbfLGMGs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Dec 2019 07:06:48 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 70E6D227D5;
        Sat,  7 Dec 2019 07:06:47 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sat, 07 Dec 2019 07:06:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=oACXAS
        NYsmywmfHcS3WdNsgFj5Yw+fumWKAD+MGHt5o=; b=xWvs8QBQ45fTM3tKsvbJA6
        /qql+/ohsaldJk8+g6k5vfjFxp+nijZmmQ9N5fKv/LIpkmSCHJB+F4s+n9dAX1cn
        FeZGQ5u4pCl3KA/J21/BcCYZrP14cS0eTcSuTcZQmzHLjSB5lPsqYNDBM3W0zzvC
        M9d1u3lV9QZHHfVUADLf8hGaj+eSEpGyybPwgzgejjuwHh0VIZ+D8AETVgTdwBJd
        ijZlty7jzKo9XsU1jmiejTpFssAI6HQN40cefsL1ianwjXfBNBFy4WqUTwVFPRUL
        9q2qrd8JP4qmF65f0GhuRDkF3HC2SKoM9pv7LloGbP/Tg77VnSVDH3oBYt/lhifw
        ==
X-ME-Sender: <xms:15XrXXpxjE8Gztfv0Darrrp3NmBp0qKngmns8tvEOd4nCNOn0ye59A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudekhedgfeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepvd
X-ME-Proxy: <xmx:15XrXan4vSGspSWqaoeEAw_brAnrmJrebpZi34X5Chw_Shde69Qhjg>
    <xmx:15XrXYmFHoUqRuxapC2ygaAGkFzruPiSnjC8FyXvcvK1AGDsheQlyg>
    <xmx:15XrXQJLFdXe2gX1xExqX_-aSMsaw7wdGh6aK-xzVb_HG-IfA4DnCA>
    <xmx:15XrXeh5DrrNGE0rKGblyuqRQ5Qk8FLfpbDQE8u59D_hxMq5vlAzCw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 121BB3060405;
        Sat,  7 Dec 2019 07:06:46 -0500 (EST)
Subject: FAILED: patch "[PATCH] fuse: verify write return" failed to apply to 4.14-stable tree
To:     mszeredi@redhat.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 07 Dec 2019 13:06:34 +0100
Message-ID: <157572039424457@kroah.com>
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

