Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2EA18F6AA
	for <lists+stable@lfdr.de>; Mon, 23 Mar 2020 15:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728531AbgCWOS3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Mar 2020 10:18:29 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:60975 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728359AbgCWOS3 (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 23 Mar 2020 10:18:29 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 062D4501;
        Mon, 23 Mar 2020 10:18:27 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 23 Mar 2020 10:18:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=pw8BOI
        69N/53CLVN3tHoAnOB6mO66Msy+gLvZ5jTz3Y=; b=gktR29oycsRxvo9nJ3VuiC
        81AZ6B5W54BbCS+1ETqI8EvsxHxeenM0i/So99XutXi3ec8+ykET2G8f2SgAwHBR
        YEKokQvI9cuXQWcJVl2a83KmuD+LPMko2GxKV//GbuS5eWpzlmBw0OtbWWm9Y08A
        QtT9fvQe30+UZw79hYMJgQo719R4u0OgreP+AOBUCBLSxDI8eUIAVC36gxV3uxna
        cVuOgRZ0nfA1ut8eW/V50ia0oBJSdKKYoeQPcR0QCd6D9jaGWub0m42JmBeNiryP
        /tiaU4spbLYma8vrevQKtqOLge5IxcpOM/796u7fMKSA3M1RrIR/mInX1MYp9IRQ
        ==
X-ME-Sender: <xms:MsV4XvHgWUjL5uvisnvLjuYG3qz47hjIXV6k9ajuqMY1ntIEOMn2_Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudegkedgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:MsV4Xl0v-iXOAkGA_9LthdKTk6p7RRX7BBciMiaEdjevK6CXsGx29A>
    <xmx:MsV4XlblgnSoLe_Z1jd7l0SsICnoTL9ogjbw1lyJj1L_aNZSwcVq9g>
    <xmx:MsV4Xko0jKPst48vhEEGIosjTv06ebH32C4sQGEL4k1dksFD_Q1yqA>
    <xmx:M8V4Xj8e7-P-tm3sgKVs-fhJ4rtD9s-Qq5sYfJftRx99lArsdp844w>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 48FC8306321F;
        Mon, 23 Mar 2020 10:18:26 -0400 (EDT)
Subject: FAILED: patch "[PATCH] iio: light: vcnl4000: update sampling periods for vcnl4200" failed to apply to 4.19-stable tree
To:     tomas@novotny.cz, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, agx@sigxcpu.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 23 Mar 2020 15:18:25 +0100
Message-ID: <1584973105253103@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From b42aa97ed5f1169cfd37175ef388ea62ff2dcf43 Mon Sep 17 00:00:00 2001
From: Tomas Novotny <tomas@novotny.cz>
Date: Tue, 18 Feb 2020 16:44:50 +0100
Subject: [PATCH] iio: light: vcnl4000: update sampling periods for vcnl4200
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Vishay has published a new version of "Designing the VCNL4200 Into an
Application" application note in October 2019. The new version specifies
that there is +-20% of part to part tolerance. This explains the drift
seen during experiments. The proximity pulse width is also changed from
32us to 30us. According to the support, the tolerance also applies to
ambient light.

So update the sampling periods. As the reading is blocking, current
users may notice slightly longer response time.

Fixes: be38866fbb97 ("iio: vcnl4000: add support for VCNL4200")
Reviewed-by: Guido Günther <agx@sigxcpu.org>
Signed-off-by: Tomas Novotny <tomas@novotny.cz>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

diff --git a/drivers/iio/light/vcnl4000.c b/drivers/iio/light/vcnl4000.c
index b0e241aaefb4..98428bf430bd 100644
--- a/drivers/iio/light/vcnl4000.c
+++ b/drivers/iio/light/vcnl4000.c
@@ -167,10 +167,10 @@ static int vcnl4200_init(struct vcnl4000_data *data)
 	data->vcnl4200_ps.reg = VCNL4200_PS_DATA;
 	switch (id) {
 	case VCNL4200_PROD_ID:
-		/* Integration time is 50ms, but the experiments */
-		/* show 54ms in total. */
-		data->vcnl4200_al.sampling_rate = ktime_set(0, 54000 * 1000);
-		data->vcnl4200_ps.sampling_rate = ktime_set(0, 4200 * 1000);
+		/* Default wait time is 50ms, add 20% tolerance. */
+		data->vcnl4200_al.sampling_rate = ktime_set(0, 60000 * 1000);
+		/* Default wait time is 4.8ms, add 20% tolerance. */
+		data->vcnl4200_ps.sampling_rate = ktime_set(0, 5760 * 1000);
 		data->al_scale = 24000;
 		break;
 	case VCNL4040_PROD_ID:

