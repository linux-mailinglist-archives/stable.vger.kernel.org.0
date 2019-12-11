Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B766411AD0A
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 15:06:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729671AbfLKOGp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 09:06:45 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:36047 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729664AbfLKOGp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 09:06:45 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 4E9B5A34;
        Wed, 11 Dec 2019 09:06:44 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 11 Dec 2019 09:06:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=vtcXkx
        uF/hK0EWaXKtcPWifRyNfViQvm1U9OwPeKf5M=; b=pAU+NHH692eXqW65FeJqv3
        ggysME4ds4Ow6BAezYU2t5n95M4ubHBVoxohTM/FjSCfBbmAORY4RyFmScCpkolt
        k9t6cswBSsK041wWAwkiFVQbH8I+/Qf0TBQRyNZX2KEjga9/rZFkgws1e1a9vFjT
        aBDnfhQ6ExIR05TzIB1st1cZgwOyll3ycICbs8hrrTvCqSAYG+VL5q6t/fgxqjEz
        8CCBmi5QC/qDvjvyTI1yhGu02Evl0q1/eYA616vWv7ED7RUVrJta0FTXL16tOARK
        IqGOVy5BybG4VIvDaN/8orRpZL8BiFSh3XqKYsnOwl5H4hQyPx/B1BikHnSO+VyA
        ==
X-ME-Sender: <xms:8_fwXQQxQTJilvilHoqT2NcUriMw29siHP7mv90-Wv0jFHhruO5b4A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudelhedgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepvd
X-ME-Proxy: <xmx:8_fwXXP6Z6bt5BzKFveeLshqJYXRGVYl1ag1pHvhrxj1QKUV3DFUqA>
    <xmx:8_fwXepPL7H7iKDWBQw0DDZFhdgoCBm_ChZb2l9MlTJ22RynaiqCrA>
    <xmx:8_fwXfWXFOcNK18oui0D5aY8e1_1EJdYceA3wY-HyXuLP19UwvoJWA>
    <xmx:8_fwXQM6geZNIhLOyJ7cvJTQ33hTZHrzXa6sJ82lbflzqbZGQj33eg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 862263060112;
        Wed, 11 Dec 2019 09:06:43 -0500 (EST)
Subject: WTF: patch "[PATCH] net: wireless: ti: wl1251 use new SDIO_VENDOR_ID_TI_WL1251" was seriously submitted to be applied to the 5.4-stable tree?
To:     hns@goldelico.com, kvalo@codeaurora.org, stable@vger.kernel.org,
        ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 11 Dec 2019 15:06:42 +0100
Message-ID: <15760732020175@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch below was submitted to be applied to the 5.4-stable tree.

I fail to see how this patch meets the stable kernel rules as found at
Documentation/process/stable-kernel-rules.rst.

I could be totally wrong, and if so, please respond to 
<stable@vger.kernel.org> and let me know why this patch should be
applied.  Otherwise, it is now dropped from my patch queues, never to be
seen again.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d8620bbc32541a30f84154007defad917f5179f0 Mon Sep 17 00:00:00 2001
From: "H. Nikolaus Schaller" <hns@goldelico.com>
Date: Thu, 7 Nov 2019 11:30:44 +0100
Subject: [PATCH] net: wireless: ti: wl1251 use new SDIO_VENDOR_ID_TI_WL1251
 definition

SDIO_VENDOR_ID_TI_WL1251 is now defined in mmc/sdio_ids.h separately
from SDIO_VENDOR_ID_TI for wl1271.

Fixes: 884f38607897 ("mmc: core: move some sdio IDs out of quirks file")
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Acked-by: Kalle Valo <kvalo@codeaurora.org>
Cc: <stable@vger.kernel.org> # v4.11+
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

diff --git a/drivers/net/wireless/ti/wl1251/sdio.c b/drivers/net/wireless/ti/wl1251/sdio.c
index f1224b948f83..ac677309dab6 100644
--- a/drivers/net/wireless/ti/wl1251/sdio.c
+++ b/drivers/net/wireless/ti/wl1251/sdio.c
@@ -52,7 +52,7 @@ static void wl1251_sdio_interrupt(struct sdio_func *func)
 }
 
 static const struct sdio_device_id wl1251_devices[] = {
-	{ SDIO_DEVICE(SDIO_VENDOR_ID_TI, SDIO_DEVICE_ID_TI_WL1251) },
+	{ SDIO_DEVICE(SDIO_VENDOR_ID_TI_WL1251, SDIO_DEVICE_ID_TI_WL1251) },
 	{}
 };
 MODULE_DEVICE_TABLE(sdio, wl1251_devices);

