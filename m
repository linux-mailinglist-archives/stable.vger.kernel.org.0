Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD6C33A4A4
	for <lists+stable@lfdr.de>; Sun, 14 Mar 2021 13:10:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235291AbhCNMJ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Mar 2021 08:09:28 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:37729 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235212AbhCNMJT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Mar 2021 08:09:19 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 4CABC1941BC3;
        Sun, 14 Mar 2021 08:09:18 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 14 Mar 2021 08:09:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=fo7fL9
        AuB3a2zJc0/R9Wrb7pWRhBLizeBKtdd2xp43U=; b=bIUvcZEzpn+m76UVHEXCLz
        mQmWALZPss7PlSwpTRY34MAKZVMbeeISpoSnmab14zCjFY9KGnKQYJrkwRev1YJX
        +NZqIHBaSAQgt8IcNdxA1te/aYZq/GfUyb+lfLnXpqqIQcBZkw8E2R58b9+Gywfy
        dLeIp0iZzXulgP/vEkxYmQClMzfH4MtVOpiU+mH0TKQ4Qg9G7ew2HzOMoXiZkWcM
        ge6kPApO8xXdB9hUFWAvhrmSrPc1xyMJ7wgPFTO9OgfBk/HSY/H3PU1+4BPZmlj4
        N6YoJoQVR9mUYHiKahn60YOs3gKvK4f+PDDptyteE9sPBKZEBTSdHimTZcZSSLrg
        ==
X-ME-Sender: <xms:7fxNYLx3qlBtIxBmuHgjI3GBLPFVjCrGFnYWp1yGSKOglvkN2-LNjA>
    <xme:7fxNYDT_bTGGUDjDfZVi3_ZouMXJzRis-XGqJizJXpODKLMB6KxSRateyRXYXzChd
    _cK-l2TplDYEQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvjedgudduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:7fxNYFW5bjLbEEVKD75rp1UpVzT0EVinItCAGVSVVYXXfEMiLL3LzQ>
    <xmx:7fxNYFiz5sgHWsOuGIqjVGp1DasRBr15vS8GZCvOQ4Q8BBFNN5OmTQ>
    <xmx:7fxNYNAwv7Du-JaXkIF2OJhXwFXoJs200nNKVUD7PsV237hCuGZSbg>
    <xmx:7vxNYArM9wGHTuhDFugNaVMXj_53fNjr5OU1thFh_Nghh08W8YLifA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7AA05240054;
        Sun, 14 Mar 2021 08:09:17 -0400 (EDT)
Subject: FAILED: patch "[PATCH] usb: dwc3: qcom: Add missing DWC3 OF node refcount decrement" failed to apply to 4.19-stable tree
To:     Sergey.Semin@baikalelectronics.ru, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 14 Mar 2021 13:09:15 +0100
Message-ID: <1615723755194217@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 1cffb1c66499a9db9a735473778abf8427d16287 Mon Sep 17 00:00:00 2001
From: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Date: Fri, 12 Feb 2021 23:55:19 +0300
Subject: [PATCH] usb: dwc3: qcom: Add missing DWC3 OF node refcount decrement

of_get_child_by_name() increments the reference counter of the OF node it
managed to find. So after the code is done using the device node, the
refcount must be decremented. Add missing of_node_put() invocation then
to the dwc3_qcom_of_register_core() method, since DWC3 OF node is being
used only there.

Fixes: a4333c3a6ba9 ("usb: dwc3: Add Qualcomm DWC3 glue driver")
Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Link: https://lore.kernel.org/r/20210212205521.14280-1-Sergey.Semin@baikalelectronics.ru
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/dwc3/dwc3-qcom.c b/drivers/usb/dwc3/dwc3-qcom.c
index 730e8d6a2aa6..fcaf04483ad0 100644
--- a/drivers/usb/dwc3/dwc3-qcom.c
+++ b/drivers/usb/dwc3/dwc3-qcom.c
@@ -653,16 +653,19 @@ static int dwc3_qcom_of_register_core(struct platform_device *pdev)
 	ret = of_platform_populate(np, NULL, NULL, dev);
 	if (ret) {
 		dev_err(dev, "failed to register dwc3 core - %d\n", ret);
-		return ret;
+		goto node_put;
 	}
 
 	qcom->dwc3 = of_find_device_by_node(dwc3_np);
 	if (!qcom->dwc3) {
+		ret = -ENODEV;
 		dev_err(dev, "failed to get dwc3 platform device\n");
-		return -ENODEV;
 	}
 
-	return 0;
+node_put:
+	of_node_put(dwc3_np);
+
+	return ret;
 }
 
 static struct platform_device *

