Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 061144EC073
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344094AbiC3Lvi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244664AbiC3Lu6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:50:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 557AA2706C4;
        Wed, 30 Mar 2022 04:47:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF8AAB81C28;
        Wed, 30 Mar 2022 11:47:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2874BC36AE7;
        Wed, 30 Mar 2022 11:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648640867;
        bh=W6/FozryWmHJIOLVr6EslcB5S8a0evFD9y3rf1ZcPUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FKO0azZp2XyGf4xlRCqeB6XpRVt1HSUk6Jk8WjSrobpFlz6SqWObjn9ZoKnVovjL+
         qVnLTgY3KhvI5JbMEJqJSz77n9+/PO1MYERrT17M1gtwaj0B0Frr6+GIXG5uK3k86C
         82EePu8tRvht3wKBw2fXXySaz7YN3sHaQxPt0E3OGo2mAK0NwAFs6Jp6FVwnEkNmcm
         c7e2jNNLl3zkJhTVyHNx/arxaVKhYwOMhcz7tNWE5w3LVlqWpdfy6knlXfGt9FMIip
         t+6RB7fkmjM9pWCG6B+oNqCGvg3iOCd+zKAZuNFPTSpxVn/nq0yE3uQcD/+GSRuz8E
         hIyUZSBaUHdCg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Svyatoslav Ryhel <clamor95@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        mark.rutland@arm.com, linux@armlinux.org.uk, swarren@wwwdotorg.org,
        thierry.reding@gmail.com, gnurou@gmail.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 40/66] ARM: tegra: transformer: Drop reg-shift for Tegra HS UART
Date:   Wed, 30 Mar 2022 07:46:19 -0400
Message-Id: <20220330114646.1669334-40-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330114646.1669334-1-sashal@kernel.org>
References: <20220330114646.1669334-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Svyatoslav Ryhel <clamor95@gmail.com>

[ Upstream commit 79b788bfc787b60699d46b9e273b42ebe18336b3 ]

When the Tegra High-Speed UART is used instead of the regular UART, the
reg-shift property is implied from the compatible string and should not
be explicitly listed.

Signed-off-by: Svyatoslav Ryhel <clamor95@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/tegra20-asus-tf101.dts               | 2 ++
 arch/arm/boot/dts/tegra30-asus-transformer-common.dtsi | 2 ++
 arch/arm/boot/dts/tegra30-pegatron-chagall.dts         | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/tegra20-asus-tf101.dts b/arch/arm/boot/dts/tegra20-asus-tf101.dts
index 020172ee7340..e3267cda15cc 100644
--- a/arch/arm/boot/dts/tegra20-asus-tf101.dts
+++ b/arch/arm/boot/dts/tegra20-asus-tf101.dts
@@ -442,11 +442,13 @@
 
 	serial@70006040 {
 		compatible = "nvidia,tegra20-hsuart";
+		/delete-property/ reg-shift;
 		/* GPS BCM4751 */
 	};
 
 	serial@70006200 {
 		compatible = "nvidia,tegra20-hsuart";
+		/delete-property/ reg-shift;
 		status = "okay";
 
 		/* Azurewave AW-NH615 BCM4329B1 */
diff --git a/arch/arm/boot/dts/tegra30-asus-transformer-common.dtsi b/arch/arm/boot/dts/tegra30-asus-transformer-common.dtsi
index 85b43a86a26d..c662ab261ed5 100644
--- a/arch/arm/boot/dts/tegra30-asus-transformer-common.dtsi
+++ b/arch/arm/boot/dts/tegra30-asus-transformer-common.dtsi
@@ -1080,6 +1080,7 @@
 
 	serial@70006040 {
 		compatible = "nvidia,tegra30-hsuart";
+		/delete-property/ reg-shift;
 		status = "okay";
 
 		/* Broadcom GPS BCM47511 */
@@ -1087,6 +1088,7 @@
 
 	serial@70006200 {
 		compatible = "nvidia,tegra30-hsuart";
+		/delete-property/ reg-shift;
 		status = "okay";
 
 		nvidia,adjust-baud-rates = <0 9600 100>,
diff --git a/arch/arm/boot/dts/tegra30-pegatron-chagall.dts b/arch/arm/boot/dts/tegra30-pegatron-chagall.dts
index f4b2d4218849..8ce61035290b 100644
--- a/arch/arm/boot/dts/tegra30-pegatron-chagall.dts
+++ b/arch/arm/boot/dts/tegra30-pegatron-chagall.dts
@@ -1103,6 +1103,7 @@
 
 	uartb: serial@70006040 {
 		compatible = "nvidia,tegra30-hsuart";
+		/delete-property/ reg-shift;
 		status = "okay";
 
 		/* Broadcom GPS BCM47511 */
@@ -1110,6 +1111,7 @@
 
 	uartc: serial@70006200 {
 		compatible = "nvidia,tegra30-hsuart";
+		/delete-property/ reg-shift;
 		status = "okay";
 
 		nvidia,adjust-baud-rates = <0 9600 100>,
-- 
2.34.1

