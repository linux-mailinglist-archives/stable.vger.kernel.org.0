Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 954E74BDE24
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:46:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232543AbiBUKD1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 05:03:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353495AbiBUJ53 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:57:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B789396A1;
        Mon, 21 Feb 2022 01:26:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D085EB80EB8;
        Mon, 21 Feb 2022 09:26:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DDBCC340E9;
        Mon, 21 Feb 2022 09:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435574;
        bh=KogUK00L+i8EBmOkWaS8EG8eriaWbC3FygQCpclJinU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JGVaXcjVTxG73s5KKLrtdnxEfDNNXfo/uLvET8WQh4Hwz28ir1airi9zUvPu0nX9z
         PGrXwYhslO2j3C3JxLviNvptvTl9zIJDLT/dhKH0hayXC0gJBfZY53gtqIcK7zbxTi
         nVhQS+QfjnvOekymEs8EeYmQmBQrbqaTleedVUiE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Hewitt <christianshewitt@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 210/227] arm64: dts: meson-g12: drop BL32 region from SEI510/SEI610
Date:   Mon, 21 Feb 2022 09:50:29 +0100
Message-Id: <20220221084941.808249270@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Hewitt <christianshewitt@gmail.com>

[ Upstream commit f26573e2bc9dfd551a0d5c6971f18cc546543312 ]

The BL32/TEE reserved-memory region is now inherited from the common
family dtsi (meson-g12-common) so we can drop it from board files.

Signed-off-by: Christian Hewitt <christianshewitt@gmail.com>
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Reviewed-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://lore.kernel.org/r/20220126044954.19069-4-christianshewitt@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-g12a-sei510.dts | 8 --------
 arch/arm64/boot/dts/amlogic/meson-sm1-sei610.dts  | 8 --------
 2 files changed, 16 deletions(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-g12a-sei510.dts b/arch/arm64/boot/dts/amlogic/meson-g12a-sei510.dts
index d8838dde0f0f4..4fb31c2ba31c4 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12a-sei510.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-g12a-sei510.dts
@@ -157,14 +157,6 @@
 		regulator-always-on;
 	};
 
-	reserved-memory {
-		/* TEE Reserved Memory */
-		bl32_reserved: bl32@5000000 {
-			reg = <0x0 0x05300000 0x0 0x2000000>;
-			no-map;
-		};
-	};
-
 	sdio_pwrseq: sdio-pwrseq {
 		compatible = "mmc-pwrseq-simple";
 		reset-gpios = <&gpio GPIOX_6 GPIO_ACTIVE_LOW>;
diff --git a/arch/arm64/boot/dts/amlogic/meson-sm1-sei610.dts b/arch/arm64/boot/dts/amlogic/meson-sm1-sei610.dts
index 427475846fc70..a5d79f2f7c196 100644
--- a/arch/arm64/boot/dts/amlogic/meson-sm1-sei610.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-sm1-sei610.dts
@@ -203,14 +203,6 @@
 		regulator-always-on;
 	};
 
-	reserved-memory {
-		/* TEE Reserved Memory */
-		bl32_reserved: bl32@5000000 {
-			reg = <0x0 0x05300000 0x0 0x2000000>;
-			no-map;
-		};
-	};
-
 	sdio_pwrseq: sdio-pwrseq {
 		compatible = "mmc-pwrseq-simple";
 		reset-gpios = <&gpio GPIOX_6 GPIO_ACTIVE_LOW>;
-- 
2.34.1



