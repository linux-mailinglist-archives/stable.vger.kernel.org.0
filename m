Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8084C249D9E
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 14:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727970AbgHSMRN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 08:17:13 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:43171 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726794AbgHSMRL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 08:17:11 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 509089E5;
        Wed, 19 Aug 2020 08:17:05 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 08:17:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=j2CBPd
        Iof0FS+Jz9nfmTwp1quiZ2H5o7LAfZ3jR191A=; b=W9dYKi2oLSDVnY6bjRgsqd
        rTCJtJO8WJ2COTGlqsqGXPHrFktEIuRVJE3p4uoctwcDDqCm7tWdkxhXe/yQ8RnO
        9R4A1Dy/srI1+i1SyVJOGsGCP2GkL33KzsNbLBQTBM4cylJNF8buA5F75KXAVVdc
        2F5F1R+04hQZfb8ZuMNggacJmTzNSRoS92fS4HlurmS5wV8egSVxEJE/NwHkcXLv
        mQtOWX9S50AUVFgHMeVz9VrXVHiotoOBknKQO4WbBPRfABi+jm8z5kb22K31hz0I
        BLGemsUIUxzmW/QmSGiV0iis6VPk4lqrkM+/gN6mKSZoxytUlihmHfM061K2Wm+w
        ==
X-ME-Sender: <xms:QBg9XxutIuKvb7-o9eYrl9Bcvnrqb8Cs6kbCh5ISsxMCZJYbc_Z9Pg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedgfeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepgfehgeeiteeufeekfeffffegjeevteejkeekgfejud
    efieduueduveegjefhudeinecuffhomhgrihhnpehrvgguhhgrthdrtghomhenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:QBg9X6cSJLexjMLT8NrP1k5Fd7nA5UCiUDtoXj1Yr-0kiq3kZz3MsQ>
    <xmx:QBg9X0xTcl4PPTczlJdzntqZhYjf_gx3_ggBOAijRp_jF1Ri2oNm_w>
    <xmx:QBg9X4Mrd-Qo-ZQ2mL3r8v0zna1r63HxH9w9lxEleztDjmvKy_LIVw>
    <xmx:QBg9X-ENwpTqPPRU9VbBNIkrrWY8k4U0snSHaSTh7S23ViWWzkNwCVIa2lk>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 14AE130600B1;
        Wed, 19 Aug 2020 08:17:03 -0400 (EDT)
Subject: FAILED: patch "[PATCH] bcache: avoid nr_stripes overflow in bcache_device_init()" failed to apply to 5.7-stable tree
To:     colyli@suse.de, axboe@kernel.dk, raeburn@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 19 Aug 2020 14:17:25 +0200
Message-ID: <1597839445818@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.7-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 65f0f017e7be8c70330372df23bcb2a407ecf02d Mon Sep 17 00:00:00 2001
From: Coly Li <colyli@suse.de>
Date: Sat, 25 Jul 2020 20:00:21 +0800
Subject: [PATCH] bcache: avoid nr_stripes overflow in bcache_device_init()

For some block devices which large capacity (e.g. 8TB) but small io_opt
size (e.g. 8 sectors), in bcache_device_init() the stripes number calcu-
lated by,
	DIV_ROUND_UP_ULL(sectors, d->stripe_size);
might be overflow to the unsigned int bcache_device->nr_stripes.

This patch uses the uint64_t variable to store DIV_ROUND_UP_ULL()
and after the value is checked to be available in unsigned int range,
sets it to bache_device->nr_stripes. Then the overflow is avoided.

Reported-and-tested-by: Ken Raeburn <raeburn@redhat.com>
Signed-off-by: Coly Li <colyli@suse.de>
Cc: stable@vger.kernel.org
Link: https://bugzilla.redhat.com/show_bug.cgi?id=1783075
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 4a77bfd4009f..0f90616dc8d3 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -835,19 +835,19 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
 	struct request_queue *q;
 	const size_t max_stripes = min_t(size_t, INT_MAX,
 					 SIZE_MAX / sizeof(atomic_t));
-	size_t n;
+	uint64_t n;
 	int idx;
 
 	if (!d->stripe_size)
 		d->stripe_size = 1 << 31;
 
-	d->nr_stripes = DIV_ROUND_UP_ULL(sectors, d->stripe_size);
-
-	if (!d->nr_stripes || d->nr_stripes > max_stripes) {
-		pr_err("nr_stripes too large or invalid: %u (start sector beyond end of disk?)\n",
-			(unsigned int)d->nr_stripes);
+	n = DIV_ROUND_UP_ULL(sectors, d->stripe_size);
+	if (!n || n > max_stripes) {
+		pr_err("nr_stripes too large or invalid: %llu (start sector beyond end of disk?)\n",
+			n);
 		return -ENOMEM;
 	}
+	d->nr_stripes = n;
 
 	n = d->nr_stripes * sizeof(atomic_t);
 	d->stripe_sectors_dirty = kvzalloc(n, GFP_KERNEL);

