Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 882E1680FF0
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 14:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236761AbjA3N6I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 08:58:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236773AbjA3N6E (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 08:58:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 453C329E27
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 05:57:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6FC8B81168
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 13:57:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 237FDC4339C;
        Mon, 30 Jan 2023 13:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087074;
        bh=6yS6fNW8Jxu+oB/VWrxWiGiK7fSGXIMdM5q2rf6Ie6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YGHOc5UfsBTA1e9etNgDGQTrHHfNlLUSjw1ox3B9VAjm/5DtSVjbwsCRgHiqvUdMd
         fqO/x8TpwYX/GbekTo0DNXKFMKVF6/vTQC4CjFvm/djD1KxjVGqysHnpaKpCQjeKSL
         iZR4m4FnzOBI/PBJ1DkXjquhW12uq2y7vjIUZsTA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        Marek Vasut <marex@denx.de>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 088/313] ARM: dts: stm32: Fix qspi pinctrl phandle for stm32mp15xx-dhcor-som
Date:   Mon, 30 Jan 2023 14:48:43 +0100
Message-Id: <20230130134340.742022119@linuxfoundation.org>
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

From: Patrice Chotard <patrice.chotard@foss.st.com>

[ Upstream commit 7ffd2266bd32d9f31a4e918443c733906cff0d19 ]

Chip select pinctrl phandle was missing in several stm32mp15x based boards.

Fixes: ea99a5a02ebc ("ARM: dts: stm32: Create separate pinmux for qspi cs pin in stm32mp15-pinctrl.dtsi")

Signed-off-by: Patrice Chotard <patrice.chotard@foss.st.com>
Cc: Marek Vasut <marex@denx.de>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-arm-kernel@lists.infradead.org
Reviewed-by: Marek Vasut <marex@denx.de>
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32mp15xx-dhcor-som.dtsi | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/stm32mp15xx-dhcor-som.dtsi b/arch/arm/boot/dts/stm32mp15xx-dhcor-som.dtsi
index 134a798ad3f2..bb40fb46da81 100644
--- a/arch/arm/boot/dts/stm32mp15xx-dhcor-som.dtsi
+++ b/arch/arm/boot/dts/stm32mp15xx-dhcor-som.dtsi
@@ -247,8 +247,12 @@ &pwr_regulators {
 
 &qspi {
 	pinctrl-names = "default", "sleep";
-	pinctrl-0 = <&qspi_clk_pins_a &qspi_bk1_pins_a>;
-	pinctrl-1 = <&qspi_clk_sleep_pins_a &qspi_bk1_sleep_pins_a>;
+	pinctrl-0 = <&qspi_clk_pins_a
+		     &qspi_bk1_pins_a
+		     &qspi_cs1_pins_a>;
+	pinctrl-1 = <&qspi_clk_sleep_pins_a
+		     &qspi_bk1_sleep_pins_a
+		     &qspi_cs1_sleep_pins_a>;
 	reg = <0x58003000 0x1000>, <0x70000000 0x200000>;
 	#address-cells = <1>;
 	#size-cells = <0>;
-- 
2.39.0



