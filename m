Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3839B58C0C1
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243512AbiHHByH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:54:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243244AbiHHBwJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:52:09 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E8CD1A82A;
        Sun,  7 Aug 2022 18:38:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 44125CE0F71;
        Mon,  8 Aug 2022 01:38:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9549DC433C1;
        Mon,  8 Aug 2022 01:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922729;
        bh=rlZoPdOOJ0HA2H9/i8phZ/Z4JXOvD+sXUYV96nhCgFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nMp897A0Fnb8Joflar587lw03OniaOA93GhKV2OBJ6X6LUU6vg/0gT1j4Y/y1VIz4
         NTI2m0F7B1zxLnIvaRVrSMN5RgluOxSX+FuJCb83N0teIXclICa+RhERpkmX2usi2b
         du5M36IvE8pjXcUbG06V5iK+bC7zJHmxlrns4nbBOTWY2MLfg7GC8AJlAGXFvyDRzq
         mY2oV4SmSAGK4qWiroFQFpzJ64DExIwN8MD4LPuOjd/sWrTjatyrGkbEw1xTEyT5Ty
         OIjL/qqyN9pKh3LWqXGGWziga+RjnMNM5TtCpKNoA6ViZmaIRGJurxFfOG0M0cG7I4
         3BX1gF12Zm1UA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Stein <alexander.stein@ew.tq-group.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 08/23] ARM: dts: imx6ul: add missing properties for sram
Date:   Sun,  7 Aug 2022 21:38:15 -0400
Message-Id: <20220808013832.316381-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013832.316381-1-sashal@kernel.org>
References: <20220808013832.316381-1-sashal@kernel.org>
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

[ Upstream commit 5655699cf5cff9f4c4ee703792156bdd05d1addf ]

All 3 properties are required by sram.yaml. Fixes the dtbs_check
warning:
sram@900000: '#address-cells' is a required property
sram@900000: '#size-cells' is a required property
sram@900000: 'ranges' is a required property

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6ul.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/boot/dts/imx6ul.dtsi b/arch/arm/boot/dts/imx6ul.dtsi
index f008036e9294..630643013bdc 100644
--- a/arch/arm/boot/dts/imx6ul.dtsi
+++ b/arch/arm/boot/dts/imx6ul.dtsi
@@ -157,6 +157,9 @@ soc {
 		ocram: sram@900000 {
 			compatible = "mmio-sram";
 			reg = <0x00900000 0x20000>;
+			ranges = <0 0x00900000 0x20000>;
+			#address-cells = <1>;
+			#size-cells = <1>;
 		};
 
 		intc: interrupt-controller@a01000 {
-- 
2.35.1

