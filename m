Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79BA511AD0B
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 15:06:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729654AbfLKOG5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 09:06:57 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:36433 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727851AbfLKOG4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 09:06:56 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id D7D2AA17;
        Wed, 11 Dec 2019 09:06:55 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 11 Dec 2019 09:06:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=U/q78W
        err/1g+EjZlAl5VZlwvZTXTIo7s84uR0sbXAQ=; b=v5oId9T0NvmcQjSyTOGHk8
        jmqgoLVS4n3x7dzMTgJqW3AxvFCi5qpNm8gEDz6tb+fbtpRI4jsXwCchx0EWjg/m
        Cj+3hhQ17pjeqrNJ18HgK5VIgnDf9eP4ekrgjxrxCnca5P83Bv4UoKoKO7NOxr8Y
        KHhlEWoP6lwHFz8TY/KaCt2Ah9/HR3OQcJfmB5pGUINEqNONlygRW3gEF+2moKlh
        lHQJa2f9Ra5fbUONZ5EMJvplIxI3S9GRDUDBrS+3MzgDAGtqb8bJhlhhBVBTA/XU
        Ex/EMFJUkrP+Yw181aXMHYt1kbdxjE7ODC/ue5BaHiD38qNLdhqDpSddX26Xhxmw
        ==
X-ME-Sender: <xms:__fwXa4LFLHcAMa5H2rEmE9nPWtEc6ExKLwYdyetrRxlAc2Idc7YnQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudelhedgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepfe
X-ME-Proxy: <xmx:__fwXQTNT1HCRTbGitafVSjiMsVVI_ghVarrsa6QLFiF_umAbkKKgQ>
    <xmx:__fwXd5zlwvOJSFbv4kKQmxrozL_fo_drFUyX8xX2fFjI-qWpjxdbA>
    <xmx:__fwXVTect08pK8vsDJ4SK99lFQhFt0rUu557sLidV9jABBc5V_2WA>
    <xmx:__fwXTvUYOpfOgxgylIJ5waX6aXJGH41d5-eo6lW_KRPhqCoDj-5Qw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C354F80060;
        Wed, 11 Dec 2019 09:06:54 -0500 (EST)
Subject: WTF: patch "[PATCH] net: wireless: ti: remove local VENDOR_ID and DEVICE_ID" was seriously submitted to be applied to the 5.4-stable tree?
To:     hns@goldelico.com, kvalo@codeaurora.org, stable@vger.kernel.org,
        ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 11 Dec 2019 15:06:53 +0100
Message-ID: <1576073213171253@kroah.com>
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

From b2bf5015dae3a427166768bc6ca4f300247f9554 Mon Sep 17 00:00:00 2001
From: "H. Nikolaus Schaller" <hns@goldelico.com>
Date: Thu, 7 Nov 2019 11:30:45 +0100
Subject: [PATCH] net: wireless: ti: remove local VENDOR_ID and DEVICE_ID
 definitions

They are already included from mmc/sdio_ids.h and do not need
a local definition.

Fixes: 884f38607897 ("mmc: core: move some sdio IDs out of quirks file")
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Acked-by: Kalle Valo <kvalo@codeaurora.org>
Cc: <stable@vger.kernel.org> # v4.11+
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

diff --git a/drivers/net/wireless/ti/wl1251/sdio.c b/drivers/net/wireless/ti/wl1251/sdio.c
index ac677309dab6..94569cd695c8 100644
--- a/drivers/net/wireless/ti/wl1251/sdio.c
+++ b/drivers/net/wireless/ti/wl1251/sdio.c
@@ -22,14 +22,6 @@
 
 #include "wl1251.h"
 
-#ifndef SDIO_VENDOR_ID_TI
-#define SDIO_VENDOR_ID_TI		0x104c
-#endif
-
-#ifndef SDIO_DEVICE_ID_TI_WL1251
-#define SDIO_DEVICE_ID_TI_WL1251	0x9066
-#endif
-
 struct wl1251_sdio {
 	struct sdio_func *func;
 	u32 elp_val;
diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
index 7afaf35f2453..9fd8cf2d270c 100644
--- a/drivers/net/wireless/ti/wlcore/sdio.c
+++ b/drivers/net/wireless/ti/wlcore/sdio.c
@@ -26,14 +26,6 @@
 #include "wl12xx_80211.h"
 #include "io.h"
 
-#ifndef SDIO_VENDOR_ID_TI
-#define SDIO_VENDOR_ID_TI		0x0097
-#endif
-
-#ifndef SDIO_DEVICE_ID_TI_WL1271
-#define SDIO_DEVICE_ID_TI_WL1271	0x4076
-#endif
-
 static bool dump = false;
 
 struct wl12xx_sdio_glue {

