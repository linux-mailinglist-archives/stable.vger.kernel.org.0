Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13886115C27
	for <lists+stable@lfdr.de>; Sat,  7 Dec 2019 13:06:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbfLGMGp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Dec 2019 07:06:45 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:34495 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726185AbfLGMGp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Dec 2019 07:06:45 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 9ACBB227DE;
        Sat,  7 Dec 2019 07:06:44 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sat, 07 Dec 2019 07:06:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=LQjt1w
        i2gSwkOC0GW+tKcaaqo7NZYHgW7Mr5ABgBQfU=; b=SeWKkZ1PKFs3k+1MzNNfrC
        PgHItS9cn0W1fwlUagCudHSI+od2sal3MVqEt2WIdrDd+/O+++Na+7cM5pg/dCsA
        7qujeEQOaSOHnnEmZbUDBLVbuUNd2ZwTPTPu/I3q+2oe/1IT69J672U+YHfzf0EY
        pHeaS6t+upySk9MEbz0V7x81/v8eEXBgMzGLc+n9NeJSLW1jerZk4EHzOTz6wOtB
        3+q6OaGIEXN0PPiffKx7N4Bapuj7lxFlu85Fs5Hyu6LbgVVl1SQ+DqT+KRc2INsf
        XS0q5MuzuNoyMA77KIvxm/AoMcVcfLkjE0NYhfkU6uOJSrddi4zN/Iuxoui85uzg
        ==
X-ME-Sender: <xms:1JXrXV-_IX6hsX6LxSfcOORSjDQds-8TQaA1J8hB3GQSr2OxicBp8w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudekhedgfeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepvd
X-ME-Proxy: <xmx:1JXrXZ1mnRYZlp4I5Nf-TioOopzkSs5XLtEmbSWEMBap8jtC4lSy4g>
    <xmx:1JXrXafTJlEtTC0kMefcIHwXNhvaSkj0RYHrwhc1U95xUwtpKZy9iQ>
    <xmx:1JXrXQDIagz857YxAY_xrg3D_MjLKFPb6eiGZEG3VfXivhD7bvef7Q>
    <xmx:1JXrXYRZk_lTqfDnHp7s1vQvznPVhjhRCaOgK099_o_2DG3TXuASgQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3D9D030603B7;
        Sat,  7 Dec 2019 07:06:44 -0500 (EST)
Subject: FAILED: patch "[PATCH] fuse: verify write return" failed to apply to 4.9-stable tree
To:     mszeredi@redhat.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 07 Dec 2019 13:06:34 +0100
Message-ID: <1575720394203151@kroah.com>
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

