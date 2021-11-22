Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9852745882A
	for <lists+stable@lfdr.de>; Mon, 22 Nov 2021 03:57:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233082AbhKVDAV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Nov 2021 22:00:21 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:60525 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229870AbhKVDAU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Nov 2021 22:00:20 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 1FFCF5C01A1;
        Sun, 21 Nov 2021 21:57:10 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 21 Nov 2021 21:57:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=traverse.com.au;
         h=from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm2; bh=DRVC5L3MNdlCbCaUbXt77+4Bue
        gyLacB1omkIW83YMg=; b=GTZF+j+4gto4z5zUfqgNeDGF8q94qKtAyN00SrJJuA
        uEUxFW1gLPRebv7oDEFoSg1AOT42RbXT2kd9G5LLTbVmRgRfU12yzCzxm9Bm+eF3
        bJZR7apDeob2Ak0grrzsSGTQMT3YpvQF+ssH4/T/vOtzMpHKdZHpAqLDNHhQCSGY
        rQvw4gyz8WiY0m2SlvRSjwWwIqPR02RbqjFUpPhL4T/7tKkVTkmRI7V16MNy+rNn
        OKQGwSCp3G0bfRarutRhVBCQnaDvcX1t31YcfgDTTd2rhKrofTBFUNXQxC8CChlb
        kHxQIjxDHkvQluWbLc5/CqXS1xN8yTA6qu1j0DutAptQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=DRVC5L3MNdlCbCaUb
        Xt77+4BuegyLacB1omkIW83YMg=; b=YOHzAMf6PyoxfQqlBuSa8dSXygW7GTXsT
        FTOLMx98hSJDeDLUgj7TzjOfzmzQ2MtCdNkrkcIIDtq2tisTwqWZNeAel1M7e4fA
        Q/w8nZ82RKV5osSKCXbsyR4vMkVCgSIAjGpbfyqmzxVkiNwiVzRWuDmdjh+uNejX
        tgf5D8ziz2Lmw/zhtEgPXz9ZdvEaoCQ3JfrsGtCUw1dZ2VYcQVXT2hlZSZ/fO8Pu
        2+oSKBDSgV60I33TWQTD3BTr6aDAmiD0834iuyKSP7DX3iL5O4X9t5MLw6B1UxSF
        yZ8Ex06NzkkzrrX94UbE/399FKA+8OMcEkYpMS75M9+mc8MZqoZKw==
X-ME-Sender: <xms:BQebYSDM9TaB9bdGrDsNw2ADSX-adOBZG5NUQFbGXPDLyLNNksvSyQ>
    <xme:BQebYcjFgnFs4MgiWR4mqQvel3s3tDWEFKx0kISt3YH1o9UOWHvy5xshnZHQSo4yk
    5hEU5CA373epk2wWlg>
X-ME-Received: <xmr:BQebYVk-II4fTXJeYXA77SHMMYWrPJiVFIHxFV6U6yZVhekHjt0kUpNtrpNvxPlo7707nNYMZqGxCSqAutculSFal7GYX3dA3mjiU1F8VLrN-Suhws2PKvjTJYO10Xo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrgeefgdehgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgggfestdekredtredttdenucfhrhhomhepofgrthhhvgifucfo
    tgeurhhiuggvuceomhgrthhtsehtrhgrvhgvrhhsvgdrtghomhdrrghuqeenucggtffrrg
    htthgvrhhnpefgkeehgfeiheffteduheevveduuedttdetieffuefgveeutddttdegleef
    keelvdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hmrghtthesthhrrghvvghrshgvrdgtohhmrdgruh
X-ME-Proxy: <xmx:BQebYQzurWi6d9GEhmUYQXWFUTxwTzxAgRhUc_HkSl_NVwC-sZjUNA>
    <xmx:BQebYXTnQO0694VqqbhcBvU-3IFvchlCaSWGZ-joyYhtITx4b3DxMg>
    <xmx:BQebYbZga8w2z6fUWinfqNX8ZNnFL76u0K8pWY_Cg-m1TzFwDiGXKw>
    <xmx:BgebYYLB6wZ1Lkdl6yNerCKNxSWlXK11Lfmq5ykxRaisKLFAaM4MMw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 21 Nov 2021 21:57:07 -0500 (EST)
From:   Mathew McBride <matt@traverse.com.au>
To:     Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>
Cc:     Mathew McBride <matt@traverse.com.au>, stable@vger.kernel.org
Subject: [PATCH] arm64: dts: ten64: remove redundant interrupt declaration for gpio-keys
Date:   Mon, 22 Nov 2021 02:55:54 +0000
Message-Id: <20211122025554.15338-1-matt@traverse.com.au>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

gpio-keys already 'inherits' the interrupts from the controller
of the specified GPIO, so having another declaration is redundant.
On >=v5.15 this started causing an oops under gpio_keys_probe as
the IRQ was already claimed.

Signed-off-by: Mathew McBride <matt@traverse.com.au>
Fixes: 418962eea358 ("arm64: dts: add device tree for Traverse Ten64 (LS1088A)")
Cc: stable@vger.kernel.org
---
 arch/arm64/boot/dts/freescale/fsl-ls1088a-ten64.dts | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1088a-ten64.dts b/arch/arm64/boot/dts/freescale/fsl-ls1088a-ten64.dts
index 3063851c2fb9..d3f03dcbb8c3 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1088a-ten64.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1088a-ten64.dts
@@ -38,7 +38,6 @@ buttons {
 		powerdn {
 			label = "External Power Down";
 			gpios = <&gpio1 17 GPIO_ACTIVE_LOW>;
-			interrupts = <&gpio1 17 IRQ_TYPE_EDGE_FALLING>;
 			linux,code = <KEY_POWER>;
 		};
 
@@ -46,7 +45,6 @@ powerdn {
 		admin {
 			label = "ADMIN button";
 			gpios = <&gpio3 8 GPIO_ACTIVE_HIGH>;
-			interrupts = <&gpio3 8 IRQ_TYPE_EDGE_RISING>;
 			linux,code = <KEY_WPS_BUTTON>;
 		};
 	};
-- 
2.30.1

