Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E12E260897F
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234099AbiJVIgT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234473AbiJVIfh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:35:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AFC025E9D;
        Sat, 22 Oct 2022 01:04:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC1A760B49;
        Sat, 22 Oct 2022 08:04:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A502AC433D7;
        Sat, 22 Oct 2022 08:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425841;
        bh=01jDxhgdXrSDbn6vPLVwOQpBBL5rmQYUKZArmb7rDrI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=awLK3IyBK9niqc9lhBQPnS4KHw2q/yVkkViLuTR6tihaYc6cUjjMYHW38QlkOjapj
         QU4ptzhFzawNz5WKHF2RAfJawG44GuYGh8TcqD0QJ4NdPC6llyGNkXZwa/hMUeYNk9
         VoCXfEkgzuaqgHBB8DyRCYAJyTWhzPaw48YSJc6U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 634/717] ARM: dts: imx6sl: add missing properties for sram
Date:   Sat, 22 Oct 2022 09:28:33 +0200
Message-Id: <20221022072526.483888522@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 60c9213a1d9941a8b33db570796c3f9be8984974 ]

All 3 properties are required by sram.yaml. Fixes the dtbs_check warning:
sram@900000: '#address-cells' is a required property
sram@900000: '#size-cells' is a required property
sram@900000: 'ranges' is a required property

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6sl.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/boot/dts/imx6sl.dtsi b/arch/arm/boot/dts/imx6sl.dtsi
index 06a515121dfc..cfd6b4972ae7 100644
--- a/arch/arm/boot/dts/imx6sl.dtsi
+++ b/arch/arm/boot/dts/imx6sl.dtsi
@@ -115,6 +115,9 @@
 		ocram: sram@900000 {
 			compatible = "mmio-sram";
 			reg = <0x00900000 0x20000>;
+			ranges = <0 0x00900000 0x20000>;
+			#address-cells = <1>;
+			#size-cells = <1>;
 			clocks = <&clks IMX6SL_CLK_OCRAM>;
 		};
 
-- 
2.35.1



