Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78B39115C28
	for <lists+stable@lfdr.de>; Sat,  7 Dec 2019 13:06:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbfLGMGr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Dec 2019 07:06:47 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:57025 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726185AbfLGMGr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Dec 2019 07:06:47 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 098F8227D5;
        Sat,  7 Dec 2019 07:06:46 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sat, 07 Dec 2019 07:06:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=oqTFGg
        QZNsFswHBHRjkEI/Ll/5X2XylSuIbA6PqQT+U=; b=gSLSJvkHOrG9YxeFYlKNVN
        sS/27ylrB6syoENyS9PTSSa8AZcsSrs1R1f3q+qKJAKorZNM6tW7MXnp1KJpyLlO
        BZmwhhJtW9HrcC2jottLGbcNgdElakfU/94MyuTr5Z0iczkxlBukn0Lxc+SJhozf
        W2YMkHfVgqEl1E/JU+g+3Fq9Vc8czdmOFBsMaQzXIUY8CZvK6Xnf1CQL/Kyevc62
        yHHEdKVIQHMHQv0iWpg1R87za20GEV5v69sH4vTtxiMfWxc2RgOUb7LtxSdmxHdH
        NQ/Ap7/VpQ76Q8h56v9L+x0WTBA9DzMEDeRmEhAW7REOmHq8WpxnTdk6t4Pj4Lbg
        ==
X-ME-Sender: <xms:1ZXrXZWEcKsWhEF2IkfZWq-3fekjfJXK5MFSQJv56_wcBLrVC1SuSg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudekhedgfeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepvd
X-ME-Proxy: <xmx:1ZXrXTYsstOyULB6Xzod7syJ3keGdabWBGQT_ktMqeV5AejODcvjTA>
    <xmx:1ZXrXQ1UIKAzvmX4if-g58ARp-3i_p6nsQUmQtaEnrT0FA7D76u-MQ>
    <xmx:1ZXrXYsC-Rc-FFocNKHbf03E7XRur5RUVKd_b7lcc5pKRSnwZKuhJw>
    <xmx:1pXrXbWbro-L8WtcP6fo1fqYmHXtD1TdejNwA4kIQELKfh3g-2WhLw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9F4A03060405;
        Sat,  7 Dec 2019 07:06:45 -0500 (EST)
Subject: FAILED: patch "[PATCH] fuse: verify write return" failed to apply to 4.4-stable tree
To:     mszeredi@redhat.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 07 Dec 2019 13:06:34 +0100
Message-ID: <1575720394254248@kroah.com>
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

