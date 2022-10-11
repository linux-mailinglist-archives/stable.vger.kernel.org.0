Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9D55FB622
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 17:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbiJKPAv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 11:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231475AbiJKO7W (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 10:59:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5331B6B8F3;
        Tue, 11 Oct 2022 07:54:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97D80B8124B;
        Tue, 11 Oct 2022 14:54:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9339FC4347C;
        Tue, 11 Oct 2022 14:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665500069;
        bh=lqYSAda2bRntEROAu/5sHl/e+25cGKkspF8iKPCyLf8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qgGIqQ6CDYpSanIk3OpsPwW8XupijB3rptkizLpL3cY3ZW7UkXs6blBwUjpVZQZRO
         /1LzLpnau6Da5fbJGr/l/m5AjmJpkj9+xQqNmneuXc7/1yGNqqo4wg1m+c0y3U8r4U
         WFDui/4X1GIcMFZsXEZHhV18BG2kXPRkChesG1wFyMC3/R0kp8C5IARkiqz1o8QwVI
         ZI/TTAQb+gyeHK/QqwwgeUMQWrCcdtYad4J4pvQ4UVM1WdX9wd/gai334OkzNfk1VM
         9CQ7/dujBRSkiLs7XfmhsdJnotXgRxVuNN2oMU7qKxf9iYCMEKbNBwdTk+9ECEvIiB
         ttDRBKNAPWlzg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Stein <alexander.stein@ew.tq-group.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.9 2/6] ARM: dts: imx6q: add missing properties for sram
Date:   Tue, 11 Oct 2022 10:54:21 -0400
Message-Id: <20221011145425.1625494-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221011145425.1625494-1-sashal@kernel.org>
References: <20221011145425.1625494-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit b11d083c5dcec7c42fe982c854706d404ddd3a5f ]

All 3 properties are required by sram.yaml. Fixes the dtbs_check warning:
sram@900000: '#address-cells' is a required property
sram@900000: '#size-cells' is a required property
sram@900000: 'ranges' is a required property

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6q.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/boot/dts/imx6q.dtsi b/arch/arm/boot/dts/imx6q.dtsi
index 908b269a016b..692afd2f5dd4 100644
--- a/arch/arm/boot/dts/imx6q.dtsi
+++ b/arch/arm/boot/dts/imx6q.dtsi
@@ -82,6 +82,9 @@ soc {
 		ocram: sram@00900000 {
 			compatible = "mmio-sram";
 			reg = <0x00900000 0x40000>;
+			ranges = <0 0x00900000 0x40000>;
+			#address-cells = <1>;
+			#size-cells = <1>;
 			clocks = <&clks IMX6QDL_CLK_OCRAM>;
 		};
 
-- 
2.35.1

