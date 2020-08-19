Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED694249D9F
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 14:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbgHSMRT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 08:17:19 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:58107 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727944AbgHSMRN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 08:17:13 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id C739DA13;
        Wed, 19 Aug 2020 08:17:11 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 08:17:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=VXwQ70
        v9AI9FSzOoPBjyFYBjplHzcIhdGM/Av7dL84c=; b=gksUbhxcfNDJDDT3iiBbm9
        7GxYLYnguHWCocpUw8v+SvzaGLlmfkuhAl1LqHR1ZLFbYFFhzEChGLYDOGWb2L4W
        0cjSTVVk2FtoOlRG+wmy9OZ+9k2s7tzeKrlaF33lrc7mVIY+s2a5DnKpiYWhCRTv
        nH+qWkJ2GxkbWQeDQiVCOafHmzOF9m/gnRZwmX6m/eH9MCgmqa6lOcmUQhEHO7xh
        1xczwXgjl4ajwTfxaCbkryNauLdaw3T2+vFgNeygaJiye9ff/IJzhmlOS05A9uWw
        yUtoSUjVwQCHlgqqtiqhM4g6EleisTqFV1Hz4hLXlvhWVRVSOFSVryfr41tFOXbQ
        ==
X-ME-Sender: <xms:Rxg9X1nl5FC8LP-6fl6GJ7JNeVYR1-jcvdsJlFCEbNdPSz_9JNaXNw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedgfeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepgfehgeeiteeufeekfeffffegjeevteejkeekgfejud
    efieduueduveegjefhudeinecuffhomhgrihhnpehrvgguhhgrthdrtghomhenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:Rxg9Xw25hfvvFQPujPnSOtnC4mB6rg3pRgLKD7atiAAaP00nP3nVWA>
    <xmx:Rxg9X7rQjRHRWXK1Qh3E96zthg_wfmFShb0QaF1OieNgAlvfqx3q3w>
    <xmx:Rxg9X1lnRN8eibDWOWltvzRrt9ZxktkbkH-RuDMC8U7Lw7UpbGnyRA>
    <xmx:Rxg9Xw-LGjFXzo95KjoMmHaz-dPOgv7BPKEPKGM7tNEOF6eYfA20ZIcMI-8>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1743D30600B1;
        Wed, 19 Aug 2020 08:17:10 -0400 (EDT)
Subject: FAILED: patch "[PATCH] bcache: avoid nr_stripes overflow in bcache_device_init()" failed to apply to 5.4-stable tree
To:     colyli@suse.de, axboe@kernel.dk, raeburn@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 19 Aug 2020 14:17:26 +0200
Message-ID: <1597839446156203@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

