Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 665D511AD08
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 15:06:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729513AbfLKOGW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 09:06:22 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:46309 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727851AbfLKOGW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 09:06:22 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 20A3834F;
        Wed, 11 Dec 2019 09:06:21 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 11 Dec 2019 09:06:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=zJK+dv
        f3zqJegwyC17tcPrey9nLflYtVOcmQItEjh0A=; b=BjAQcjVe9sTBFBXiM8E2CM
        GMEJPvxAxk+B2+BJUptzRmyrjiyt+UlQLMO/4S2Sdu1oa7hrgsi1WqE3SBxm3Y4l
        hAix9609s2rs0ah7V1HGCjU4QCBLP5l5OIiKKTuS2wkTq5SjcJktk8w974kMWRg0
        jVnAiz67lSbUd/t+ykJyR2X+89qmg7pMhteaK5icgRerm36vdDBtJzR9P8+5Uzmi
        b27grciohWUTDSpkITXQ8fs9H3RET66aba0fJCmNOEcinQOKiu/pA4EbdfNuTHF1
        NTucullbnCd0i7J1sPZm7Efc1RroKMN2XatodIBnccMqUziqOASl4yu5xjw4yQrA
        ==
X-ME-Sender: <xms:3PfwXTTqMCgnZUYspKylzBl380MTy4k5UUvcVjGTiwGJ3wjjBioB5Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudelhedgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:3PfwXWz3mg6hwa961MKJJGtcAIYCjXeaf7w-ie8QG9U6HBeSFrPbew>
    <xmx:3PfwXdIVEeQsrsCDm54RG0HLqM29iAdRKKfQMkDY6Y_1kSrksoWmjQ>
    <xmx:3PfwXbMSXdCoh1nO4LJW7uTYcNPsAHwOcmvnno-R6wE4nuo3nR9iwQ>
    <xmx:3PfwXbzx5cfxpJkCBkQDeAufdOBpP8JNjvWfvu_hgycDUjxdgzxuNw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D717C30600AB;
        Wed, 11 Dec 2019 09:06:19 -0500 (EST)
Subject: WTF: patch "[PATCH] Documentation: dt: wireless: update wl1251 for sdio" was seriously submitted to be applied to the 5.4-stable tree?
To:     hns@goldelico.com, kvalo@codeaurora.org, robh@kernel.org,
        stable@vger.kernel.org, ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 11 Dec 2019 15:06:18 +0100
Message-ID: <1576073178146235@kroah.com>
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

From 69167ae5a511560e6ae4181364da274b535a743f Mon Sep 17 00:00:00 2001
From: "H. Nikolaus Schaller" <hns@goldelico.com>
Date: Thu, 7 Nov 2019 11:30:34 +0100
Subject: [PATCH] Documentation: dt: wireless: update wl1251 for sdio

The standard method for sdio devices connected to
an sdio interface is to define them as a child node
like we can see with wlcore.

Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Acked-by: Kalle Valo <kvalo@codeaurora.org>
Reviewed-by: Rob Herring <robh@kernel.org>
Cc: <stable@vger.kernel.org> # v4.7+
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

diff --git a/Documentation/devicetree/bindings/net/wireless/ti,wl1251.txt b/Documentation/devicetree/bindings/net/wireless/ti,wl1251.txt
index bb2fcde6f7ff..f38950560982 100644
--- a/Documentation/devicetree/bindings/net/wireless/ti,wl1251.txt
+++ b/Documentation/devicetree/bindings/net/wireless/ti,wl1251.txt
@@ -35,3 +35,29 @@ Examples:
 		ti,power-gpio = <&gpio3 23 GPIO_ACTIVE_HIGH>; /* 87 */
 	};
 };
+
+&mmc3 {
+	vmmc-supply = <&wlan_en>;
+
+	bus-width = <4>;
+	non-removable;
+	ti,non-removable;
+	cap-power-off-card;
+
+	pinctrl-names = "default";
+	pinctrl-0 = <&mmc3_pins>;
+
+	#address-cells = <1>;
+	#size-cells = <0>;
+
+	wlan: wifi@1 {
+		compatible = "ti,wl1251";
+
+		reg = <1>;
+
+		interrupt-parent = <&gpio1>;
+		interrupts = <21 IRQ_TYPE_LEVEL_HIGH>;	/* GPIO_21 */
+
+		ti,wl1251-has-eeprom;
+	};
+};

