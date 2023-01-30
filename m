Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDB88680FF3
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 14:58:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236691AbjA3N6X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 08:58:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236722AbjA3N6U (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 08:58:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7FD929E2E
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 05:58:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45E4A60FE0
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 13:58:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A37CC433D2;
        Mon, 30 Jan 2023 13:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087083;
        bh=SyhV1wXk19Z1wuhlY9/I4zbKoyKhQ5G+hOCxeoj3U2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MD8PKvjldfjrP76bcc42OCQVf2/sk1+071Sg4zrGB8X2J0HAMpK9dJsueo/0DOp/9
         PFl0WCJKdulZ4JtF5ZxztANKIO3+AFunZSpDlNjXZQ6kej8ZZTCya/USFirtTIfclz
         0YUY7veHAjbkBjTYIjl0jxTHUEAabxDm4rz4LbaU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 091/313] ARM: dts: stm32: Fix qspi pinctrl phandle for stm32mp151a-prtt1l
Date:   Mon, 30 Jan 2023 14:48:46 +0100
Message-Id: <20230130134340.885423222@linuxfoundation.org>
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

[ Upstream commit 175281f80695569c7f9cf062e5d0ddc4addc109f ]

Chip select pinctrl phandle was missing in several stm32mp15x based boards.

Fixes: ea99a5a02ebc ("ARM: dts: stm32: Create separate pinmux for qspi cs pin in stm32mp15-pinctrl.dtsi")

Signed-off-by: Patrice Chotard <patrice.chotard@foss.st.com>
Cc: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32mp151a-prtt1l.dtsi | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/stm32mp151a-prtt1l.dtsi b/arch/arm/boot/dts/stm32mp151a-prtt1l.dtsi
index d865ab5d866b..dd23de85100c 100644
--- a/arch/arm/boot/dts/stm32mp151a-prtt1l.dtsi
+++ b/arch/arm/boot/dts/stm32mp151a-prtt1l.dtsi
@@ -101,8 +101,12 @@ &iwdg2 {
 
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
 	reg = <0x58003000 0x1000>, <0x70000000 0x4000000>;
 	#address-cells = <1>;
 	#size-cells = <0>;
-- 
2.39.0



