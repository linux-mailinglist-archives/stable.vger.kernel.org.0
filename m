Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3F4C593BA9
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346827AbiHOUXK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347257AbiHOUWI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:22:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CC024B0FD;
        Mon, 15 Aug 2022 12:01:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4AF0EB810A1;
        Mon, 15 Aug 2022 19:01:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A68CC433C1;
        Mon, 15 Aug 2022 19:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590104;
        bh=H9BOwCrBvhJ2D/pmVP5DNxKN0ES8c7NcKffve4+d2QI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ixSfGsj0HRGeNoj65W6aeMM6mcUmYDQJ2CTZHgPIILMVS158YQXuRd4g3PcO5nikJ
         pQ+S30Yym5LgJWeet7NBxOJtPuR0m5gzS+7tMXw0brjW53xEIUgebOAVs/VPBmEvdM
         qnLCYZ/Kfn8i09qpz14xeySM4zXBkRfHt4wk/jkQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0152/1095] ARM: dts: imx6ul: fix keypad compatible
Date:   Mon, 15 Aug 2022 19:52:31 +0200
Message-Id: <20220815180435.871283446@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 7d15e0c9a515494af2e3199741cdac7002928a0e ]

According to binding, the compatible shall only contain imx6ul and imx21
compatibles. Fixes the dt_binding_check warning:
keypad@20b8000: compatible: 'oneOf' conditional failed, one must be fixed:
['fsl,imx6ul-kpp', 'fsl,imx6q-kpp', 'fsl,imx21-kpp'] is too long
Additional items are not allowed ('fsl,imx6q-kpp', 'fsl,imx21-kpp' were
unexpected)
Additional items are not allowed ('fsl,imx21-kpp' was unexpected)
'fsl,imx21-kpp' was expected

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6ul.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6ul.dtsi b/arch/arm/boot/dts/imx6ul.dtsi
index 2fcbd9d91521..df8b4ad62418 100644
--- a/arch/arm/boot/dts/imx6ul.dtsi
+++ b/arch/arm/boot/dts/imx6ul.dtsi
@@ -544,7 +544,7 @@ fec2: ethernet@20b4000 {
 			};
 
 			kpp: keypad@20b8000 {
-				compatible = "fsl,imx6ul-kpp", "fsl,imx6q-kpp", "fsl,imx21-kpp";
+				compatible = "fsl,imx6ul-kpp", "fsl,imx21-kpp";
 				reg = <0x020b8000 0x4000>;
 				interrupts = <GIC_SPI 82 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clks IMX6UL_CLK_KPP>;
-- 
2.35.1



