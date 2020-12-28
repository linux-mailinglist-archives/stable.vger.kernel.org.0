Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 056622E3648
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 12:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbgL1LPM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 06:15:12 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:47539 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727032AbgL1LPM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 06:15:12 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 3E5D282C;
        Mon, 28 Dec 2020 06:14:06 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 06:14:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=n9bjYc
        ox0Ni2uf3WjqJY97onBhLFpz6Cfp5Fumy85lE=; b=cJJjbUyLtyqUJ0UJQwCb64
        m++5Ifk0I6lymqZJwwMAFfHZNJPCVqYHiClTt32SqK+xRQDZQKlFS/XH3Ar/g2Vw
        3TJUZiHC8V8QNbqOx5/TwP9t8eJYSdyAQ6ZA8ZCiIAhaPMZdCFPS5vgQl873CQZ1
        IF0SNgmcnNQnOLtJ8IAbVpvpZ1YXDoPMSWxGYIvdWwfejjV7/lOBi0pQFcUP7jkZ
        D4j3ddg8tCvuZS2MPBRc6n6PtuXDNO3VyiWsTif7agQub9+o9xXn9jxiRYRGs8Bu
        zy39BFVc6o0dWDOjfVnQyXrxoZlKXFLUKkLmcuTT/C7stE7F7B7lq9zrz18xol1g
        ==
X-ME-Sender: <xms:_b3pX2F8RRZ3C4R1he1Utwog2Cl6FNXgGu_ApGJpHZ2CrqV0kf5XoQ>
    <xme:_b3pX3U3t_h2kSeUauW6lT1h9JsywS9ZJBfxKD1EOXW5K-nbhjVobYs9WuTaME6jF
    XuEuZ-Bmnnx7Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:_b3pXwITEg9Ek1ueQTu9A1gK0KnvFI42X09GiCQ_sJyfXx9qtxgbNA>
    <xmx:_b3pXwFQgS6FVwn3wLwHLwGCmKdLwHLskqok7PDWFC8G17jxmbH3aA>
    <xmx:_b3pX8W6H9aUyu6jpf5xA6F__GPlnTTX6ZDC7A5fbfGau8X89wxC_g>
    <xmx:_b3pX1fOuVAXRD49o5KAlOIhPz9BA9ObSEPOpKztkYlGoz4REIbEPOfznbw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 878E8240062;
        Mon, 28 Dec 2020 06:14:05 -0500 (EST)
Subject: FAILED: patch "[PATCH] md/raid10: initialize r10_bio->read_slot before use." failed to apply to 5.4-stable tree
To:     kvigor@gmail.com, songliubraving@fb.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 12:15:20 +0100
Message-ID: <160915412088113@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 93decc563637c4288380912eac0eb42fb246cc04 Mon Sep 17 00:00:00 2001
From: Kevin Vigor <kvigor@gmail.com>
Date: Fri, 6 Nov 2020 14:20:34 -0800
Subject: [PATCH] md/raid10: initialize r10_bio->read_slot before use.

In __make_request() a new r10bio is allocated and passed to
raid10_read_request(). The read_slot member of the bio is not
initialized, and the raid10_read_request() uses it to index an
array. This leads to occasional panics.

Fix by initializing the field to invalid value and checking for
valid value in raid10_read_request().

Cc: stable@vger.kernel.org
Signed-off-by: Kevin Vigor <kvigor@gmail.com>
Signed-off-by: Song Liu <songliubraving@fb.com>

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index b7bca6703df8..3153183b7772 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1127,7 +1127,7 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 	struct md_rdev *err_rdev = NULL;
 	gfp_t gfp = GFP_NOIO;
 
-	if (r10_bio->devs[slot].rdev) {
+	if (slot >= 0 && r10_bio->devs[slot].rdev) {
 		/*
 		 * This is an error retry, but we cannot
 		 * safely dereference the rdev in the r10_bio,
@@ -1508,6 +1508,7 @@ static void __make_request(struct mddev *mddev, struct bio *bio, int sectors)
 	r10_bio->mddev = mddev;
 	r10_bio->sector = bio->bi_iter.bi_sector;
 	r10_bio->state = 0;
+	r10_bio->read_slot = -1;
 	memset(r10_bio->devs, 0, sizeof(r10_bio->devs[0]) * conf->geo.raid_disks);
 
 	if (bio_data_dir(bio) == READ)

