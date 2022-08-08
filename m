Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46A3558C139
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243813AbiHHB5l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:57:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244040AbiHHB4v (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:56:51 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07C325FD3;
        Sun,  7 Aug 2022 18:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 23FB7CE0F6D;
        Mon,  8 Aug 2022 01:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EC42C433D6;
        Mon,  8 Aug 2022 01:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922812;
        bh=sWO6Pp5g2InrYub2zwmzf/lwD3iNaCnG6R6oHFU8Owk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BX6blFDhw/xQmhLLKwZ2yEtwHohjg1GtfYtUU4s6IBXEQDchucnqFV3M0onsIAUni
         s3gpYASXAik2fSkCiV9G3m+7qk2tgDtZ5tTev6JkDvMFrTQA/SC0VooTKa8uSZ7xII
         BAA72TL+hVVFYhRevj5Qx9/f69vBFRRrzfcMYy9rDYsSMTupRYVM+3J8rCIr9Y7vFp
         OVcQIApt7fPQCddVg7wp4LJ31heyluOen31Krpt38WlTMPlTeVYg9SEnl0YEzzsi/l
         jVu6+bvxyXgKYrIHSethom+OI/rr8wAO4ZzBJKliX8QNX1ATIGnOjQX3Wxtae9EcKm
         eDQ1+eQUHldBQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Stein <alexander.stein@ew.tq-group.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.9 4/8] ARM: dts: imx6ul: fix qspi node compatible
Date:   Sun,  7 Aug 2022 21:39:59 -0400
Message-Id: <20220808014005.317064-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808014005.317064-1-sashal@kernel.org>
References: <20220808014005.317064-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 0c6cf86e1ab433b2d421880fdd9c6e954f404948 ]

imx6ul is not compatible to imx6sx, both have different erratas.
Fixes the dt_binding_check warning:
spi@21e0000: compatible: 'oneOf' conditional failed, one must be fixed:
['fsl,imx6ul-qspi', 'fsl,imx6sx-qspi'] is too long
Additional items are not allowed ('fsl,imx6sx-qspi' was unexpected)
'fsl,imx6ul-qspi' is not one of ['fsl,ls1043a-qspi']
'fsl,imx6ul-qspi' is not one of ['fsl,imx8mq-qspi']
'fsl,ls1021a-qspi' was expected
'fsl,imx7d-qspi' was expected

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6ul.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6ul.dtsi b/arch/arm/boot/dts/imx6ul.dtsi
index 41ae79dc4c21..5ec16b26f7c7 100644
--- a/arch/arm/boot/dts/imx6ul.dtsi
+++ b/arch/arm/boot/dts/imx6ul.dtsi
@@ -866,7 +866,7 @@ lcdif: lcdif@021c8000 {
 			qspi: qspi@021e0000 {
 				#address-cells = <1>;
 				#size-cells = <0>;
-				compatible = "fsl,imx6ul-qspi", "fsl,imx6sx-qspi";
+				compatible = "fsl,imx6ul-qspi";
 				reg = <0x021e0000 0x4000>, <0x60000000 0x10000000>;
 				reg-names = "QuadSPI", "QuadSPI-memory";
 				interrupts = <GIC_SPI 107 IRQ_TYPE_LEVEL_HIGH>;
-- 
2.35.1

