Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07BB560AD02
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 16:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234536AbiJXORP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 10:17:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237080AbiJXOPt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 10:15:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DA9652FD9;
        Mon, 24 Oct 2022 05:55:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A91C61015;
        Mon, 24 Oct 2022 12:54:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A813DC433C1;
        Mon, 24 Oct 2022 12:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666616086;
        bh=iKZ/2Bz6UW9cY4lla+MqAFAxTOi1scQ+KSJMNOOVpDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jdtISw3UuQk9URadgUax3WwDi3mP14R61eynyskCr6RPbVJNe/PVAC/enMJ7MpVe4
         j7UgMtPPyHWneDX71l0eKE+9w11B/Ct/y9KYIQ9ud07rTcHBKXqjN2CXukOoaPeVQi
         FGjhKAGlCTBM4eaNiWqZeR1dcfD5mjyOMo39iLHI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 465/530] ARM: dts: imx6dl: add missing properties for sram
Date:   Mon, 24 Oct 2022 13:33:29 +0200
Message-Id: <20221024113106.099098415@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit f5848b95633d598bacf0500e0108dc5961af88c0 ]

All 3 properties are required by sram.yaml. Fixes the dtbs_check warning:
sram@900000: '#address-cells' is a required property
sram@900000: '#size-cells' is a required property
sram@900000: 'ranges' is a required property

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6dl.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/boot/dts/imx6dl.dtsi b/arch/arm/boot/dts/imx6dl.dtsi
index fdd81fdc3f35..cd3183c36488 100644
--- a/arch/arm/boot/dts/imx6dl.dtsi
+++ b/arch/arm/boot/dts/imx6dl.dtsi
@@ -84,6 +84,9 @@
 		ocram: sram@900000 {
 			compatible = "mmio-sram";
 			reg = <0x00900000 0x20000>;
+			ranges = <0 0x00900000 0x20000>;
+			#address-cells = <1>;
+			#size-cells = <1>;
 			clocks = <&clks IMX6QDL_CLK_OCRAM>;
 		};
 
-- 
2.35.1



