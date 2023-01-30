Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BED5E680F83
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 14:54:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbjA3Nyb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 08:54:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbjA3Nyb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 08:54:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93B2E38EB4
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 05:54:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3950E61025
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 13:54:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C168C433EF;
        Mon, 30 Jan 2023 13:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675086857;
        bh=bZH+MAdjymZlf+eW08d4e6Z45X8AmQ6T3oPYNXPJq3g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U+sxmne0HvEIZk2GDUmVhXQ27uflqB0z55xsZLGVKEHfzA4bw9Ne+fMa5r3SgMoOP
         PpTsxP/fnx/+hlHvY5+5vFjFTW3hVQ2coiYDnNBk9qlxGzhVOI1W7JZdY4ic3VkUvC
         qjPKBeB6QhKUol4bEeDb4bUC7nwCKNarG4Rf0vVk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Marco Felsch <m.felsch@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 020/313] arm64: dts: imx8mp-evk: pcie0-refclk cosmetic cleanup
Date:   Mon, 30 Jan 2023 14:47:35 +0100
Message-Id: <20230130134337.588881589@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Felsch <m.felsch@pengutronix.de>

[ Upstream commit 9a65c759e4666476a6642ad87b4db8a67cb957d0 ]

Use the correct indention.

Fixes: d50650500064 ("arm64: dts: imx8mp-evk: Add PCIe support")
Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-evk.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-evk.dts b/arch/arm64/boot/dts/freescale/imx8mp-evk.dts
index b4c1ef2559f2..126c839b45f2 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-evk.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-evk.dts
@@ -36,8 +36,8 @@ memory@40000000 {
 
 	pcie0_refclk: pcie0-refclk {
 		compatible = "fixed-clock";
-			#clock-cells = <0>;
-			clock-frequency = <100000000>;
+		#clock-cells = <0>;
+		clock-frequency = <100000000>;
 	};
 
 	reg_can1_stby: regulator-can1-stby {
-- 
2.39.0



