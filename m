Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF4EA3C3CC3
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 15:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232789AbhGKNPB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 09:15:01 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:59595 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232544AbhGKNPB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 09:15:01 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 1A85A1AC0745;
        Sun, 11 Jul 2021 09:12:14 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 11 Jul 2021 09:12:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=+CAA8Y
        eKS8AkJS7UYJYOWqGOEiF6zsjM+MDOULFXViI=; b=YoXNRxC0giysJjbojGqT5f
        gSeSmBqTefLwtevmCwXWScTlWZ4+1w1PExkW66tzdI7ORa4tV5x6Obhp940A2K8G
        WcJvm4mmpx6/atoDKOtTmNhJ1qkVgnKx1Tk3ljsPXBYF4Xy1kbl+TUuP9guWVuZL
        7akb8ShVhQ5ynptVVEjeg4e0JHqlj0YwQ51VkhSJQ4Rtxv5BRhzFZdYRErQ4c+qo
        TnM8qoknTftALUJyKjDwhmgww1NHDvMn4uv04QqSPhTlQ7dYKoLBoz695cVirJPV
        6Pz3Pxy5/O58b7wEWSxQrg5Af5sAUyGDiPyNpw+6HKCoXTrlE827s9bnmNLIQD7A
        ==
X-ME-Sender: <xms:Le7qYGPwkFphb-HAGEpjmiGT7BW0VEJ8ogOgFLmcdZchXD0iSDhZMw>
    <xme:Le7qYE9o6YSwhnjF0oYMXmtvCzfYqz1F2m8el0aWRhnWRBNy955_4E0rC9xi2DgkE
    eup1EL7l12l6g>
X-ME-Received: <xmr:Le7qYNS7TO1din38hDJ8-zdZrqYxoYSgvut76KRPLNlifpG-DSoAkUVZLCRJwTDL4rjVEHTmcdLWYKos4ILFEb3OuQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtgdeitdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:Le7qYGvdvz54GsCioqh3-5sIW9KrGl5-Ou17DVQOlpdZk6sbUxn6gw>
    <xmx:Le7qYOcshz39sDivs1uftrKBvrwjEL6lJOEyeH6HZ-OIwQa6K36xVg>
    <xmx:Le7qYK1EwNwQSkwli4zyRYZlhgJHTIb4S39IjI0xVgDU1Xg5q3csVg>
    <xmx:Le7qYPpPfpbz1-7J_PGA31Jy1ZVw5w9XHoL0VFEGZhQIxLHLxE6S5LCHzE4>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Jul 2021 09:12:13 -0400 (EDT)
Subject: FAILED: patch "[PATCH] fuse: reject internal errno" failed to apply to 4.9-stable tree
To:     mszeredi@redhat.com, anatoly.trosinenko@gmail.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Jul 2021 15:11:59 +0200
Message-ID: <162600911919776@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 49221cf86d18bb66fe95d3338cb33bd4b9880ca5 Mon Sep 17 00:00:00 2001
From: Miklos Szeredi <mszeredi@redhat.com>
Date: Tue, 22 Jun 2021 09:15:35 +0200
Subject: [PATCH] fuse: reject internal errno

Don't allow userspace to report errors that could be kernel-internal.

Reported-by: Anatoly Trosinenko <anatoly.trosinenko@gmail.com>
Fixes: 334f485df85a ("[PATCH] FUSE - device functions")
Cc: <stable@vger.kernel.org> # v2.6.14
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 6e63bcba2a40..b8d58aa08206 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1867,7 +1867,7 @@ static ssize_t fuse_dev_do_write(struct fuse_dev *fud,
 	}
 
 	err = -EINVAL;
-	if (oh.error <= -1000 || oh.error > 0)
+	if (oh.error <= -512 || oh.error > 0)
 		goto copy_finish;
 
 	spin_lock(&fpq->lock);

