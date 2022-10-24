Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6ED60A622
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233930AbiJXMcE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234355AbiJXMaH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:30:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91550371A6;
        Mon, 24 Oct 2022 05:03:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E6D11612BF;
        Mon, 24 Oct 2022 12:03:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07B1CC433D6;
        Mon, 24 Oct 2022 12:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613001;
        bh=7GMsAKLqLcGgeJuOdMjpUAgcMRmROOQuPR8u01j9H1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vlYxJn0L3NgYkIWFwac4HvNGReaTsH4fDdl1wcCRj09Zx1HN2Uwks+aQCaRIUdGew
         l4oozsTkEbs0+2PDMhCLTSnko758Aqx6anU0Fy3FqtQJgRVJoexX9Uamw/w5KEBZRd
         6c5uIWTfkTg8N4zZiOn0HaUSGZVq5/UnfuMeZRpk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 201/229] ARM: dts: imx6q: add missing properties for sram
Date:   Mon, 24 Oct 2022 13:32:00 +0200
Message-Id: <20221024113005.656408984@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112959.085534368@linuxfoundation.org>
References: <20221024112959.085534368@linuxfoundation.org>
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
index 0193ee6fe964..a28dce3c6457 100644
--- a/arch/arm/boot/dts/imx6q.dtsi
+++ b/arch/arm/boot/dts/imx6q.dtsi
@@ -158,6 +158,9 @@
 		ocram: sram@900000 {
 			compatible = "mmio-sram";
 			reg = <0x00900000 0x40000>;
+			ranges = <0 0x00900000 0x40000>;
+			#address-cells = <1>;
+			#size-cells = <1>;
 			clocks = <&clks IMX6QDL_CLK_OCRAM>;
 		};
 
-- 
2.35.1



