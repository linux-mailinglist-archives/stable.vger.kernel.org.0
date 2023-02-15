Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7766985DE
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 21:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbjBOUqQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 15:46:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbjBOUqO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 15:46:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 605E63E60E;
        Wed, 15 Feb 2023 12:46:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0BB3BB823B4;
        Wed, 15 Feb 2023 20:46:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F752C433EF;
        Wed, 15 Feb 2023 20:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676493961;
        bh=lhAXS7hXbodllx8n7UqUkj4H6xj4JSId1r6/xza38kE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QmOMZj4Z8ML7Uywrx6YkRPp+3zO3GVCOffEeOJcXeGJNrbHcX2DWPWHvXxLdp0e73
         bLh3d5Anmv58vxEssPamPjWPR427EYUNbGKIDnFeh0QHBcUyaLSrPUlas/e9zGVr7R
         qPGOGsjtpJoS0FscAqXrqJx4/rOdMXyEPg/XbDQvU4drrjZPz1RrgHv5FbJenYRvHR
         0IzUt4wOomZXJidFQqizGmaR1qKGaN9UWxyBORro6TS0B3fC6b3oP5d6r8FGqkR4kr
         oGGkh+Xasy0Wmm7/pP7IwCcJjREW7OGTsEuGi1rpW/2K4pjzPPenzkcJ1UGbEmdZrD
         DlDQCjRUaQ9Sg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jensen Huang <jensenhuang@friendlyarm.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, pgwipeout@gmail.com,
        michael.riesch@wolfvision.net, s.hauer@pengutronix.de,
        frattaroli.nicolas@gmail.com, macromorgan@hotmail.com,
        yifeng.zhao@rock-chips.com, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 6.1 05/24] arm64: dts: rockchip: add missing #interrupt-cells to rk356x pcie2x1
Date:   Wed, 15 Feb 2023 15:45:28 -0500
Message-Id: <20230215204547.2760761-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230215204547.2760761-1-sashal@kernel.org>
References: <20230215204547.2760761-1-sashal@kernel.org>
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

From: Jensen Huang <jensenhuang@friendlyarm.com>

[ Upstream commit a323e6b5737bb6e3d3946369b97099abb7dde695 ]

This fixes the following issue:
  pcieport 0000:00:00.0: of_irq_parse_pci: failed with rc=-22

Signed-off-by: Jensen Huang <jensenhuang@friendlyarm.com>
Link: https://lore.kernel.org/r/20230113064457.7105-1-jensenhuang@friendlyarm.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk356x.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk356x.dtsi b/arch/arm64/boot/dts/rockchip/rk356x.dtsi
index 164708f1eb674..1d423daae971b 100644
--- a/arch/arm64/boot/dts/rockchip/rk356x.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk356x.dtsi
@@ -966,6 +966,7 @@ pcie2x1: pcie@fe260000 {
 		clock-names = "aclk_mst", "aclk_slv",
 			      "aclk_dbi", "pclk", "aux";
 		device_type = "pci";
+		#interrupt-cells = <1>;
 		interrupt-map-mask = <0 0 0 7>;
 		interrupt-map = <0 0 0 1 &pcie_intc 0>,
 				<0 0 0 2 &pcie_intc 1>,
-- 
2.39.0

