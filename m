Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06FEB115C25
	for <lists+stable@lfdr.de>; Sat,  7 Dec 2019 13:06:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbfLGMGg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Dec 2019 07:06:36 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:54463 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726185AbfLGMGg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Dec 2019 07:06:36 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 65E31227DA;
        Sat,  7 Dec 2019 07:06:35 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sat, 07 Dec 2019 07:06:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=oDLmLQ
        9+GVg5qM6PlBvSbVOJftauMaeESVkdUaLuSRQ=; b=GMT80e1d5qVEFERJ+Q5aSz
        o8LT3oX7lIP+msHlw7qcWv+utHyqi1ptJfxbMYOFsyPZkdSqBAWcuMnDURseVLT3
        UU8/o5f6YthKYSwF/q6sJ0cIIvh3fgMuQgI5c7AibkkESMTpXQl0g1ozJJUQXGRE
        htgrAiuG9aAMzsMu+UNr/mdG+bvTSl0IvCbW8lzMspTCwiMzQuwwjVXG42eIOVlg
        eal+sUqLtd3imfHc1b8gMOd/r9vqRy3xGHDCq53uRMbGjh8av+xZNiZmRVgsfXGr
        ewKsQm9GP9RuU2y5UjLYGMcweC9LiwT2jmgHsmUW7Tb2cQKAxv7uyu2pAG23qPTQ
        ==
X-ME-Sender: <xms:y5XrXfFsOfsrIyWkn3WRJiZkknPg-dwRgHoZzcYG9nUe3QSC2Z6XrA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudekhedgfeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:y5XrXcXkcncc95HDDM3kKEJ4nt8rIv66W7V6rzquQHgNP7KseVNvmw>
    <xmx:y5XrXXQEPNo1qXqwJ2IKt1Fs63tyj3TrruSGsLIii-JRy7fxQdoxOw>
    <xmx:y5XrXbz4lY3pb95JhQbYZef60iTbcdV7ReamiS3gzHShsAWGrtNAOA>
    <xmx:y5XrXYIkA9fmzLrG2-U8T3IpgJ6If7sc0RCrk0j2INwY534Ou14gEQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E7041306036F;
        Sat,  7 Dec 2019 07:06:34 -0500 (EST)
Subject: FAILED: patch "[PATCH] fuse: verify write return" failed to apply to 5.3-stable tree
To:     mszeredi@redhat.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 07 Dec 2019 13:06:33 +0100
Message-ID: <157572039317983@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.3-stable tree.
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

