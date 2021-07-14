Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86F853C8E20
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234894AbhGNTqi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:46:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:38508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235344AbhGNTp5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:45:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68814613F5;
        Wed, 14 Jul 2021 19:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291740;
        bh=Qlm1sNsuMP1SYmQKkz1C6jynodpO46XtBgAG0H8zmfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UPn8EVKSX3zteMW0YJahiAseOSKvpfi8oBKaGbufilBsW14GVMI2b/bXchBVccfdj
         9nZLwMK+KzhQy3d1F2jyO9DTQQe1A4hXFmx85XjlVk1ak8TFZ7p4dyVjZl98ykpYiH
         KEbEmmVwMTazXx4ADvoXFMYqxwhIBd4C1p0MGxstiHf6eB5VkqyQlpiB84T82rNqqh
         mJmebD6sR397znapSfQLSjseV4Ou+C2+Svtp4fyR/3G+G9MIZS9qDaKICo7VJpSiJr
         j6rRctCZT/NO8j3+Wa4UJKtrGmU5DwhbPDEvFknTmvwE+NB1UZO1vY2pwq4Tpdt6Iz
         mZg8OrttqEIXg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        Patrick Delaunay <patrick.delaunay@foss.st.com>,
        kernel@dh-electronics.com,
        linux-stm32@st-md-mailman.stormreply.com,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.12 073/102] ARM: dts: stm32: Rename eth@N to ethernet@N on DHCOM SoM
Date:   Wed, 14 Jul 2021 15:40:06 -0400
Message-Id: <20210714194036.53141-73-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194036.53141-1-sashal@kernel.org>
References: <20210714194036.53141-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit b586250df24226f8a257e11e1f5953054c54fd35 ]

Fix the following dtbs_check warning:
eth@1,0: $nodename:0: 'eth@1,0' does not match '^ethernet(@.*)?$'

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc: Patrice Chotard <patrice.chotard@foss.st.com>
Cc: Patrick Delaunay <patrick.delaunay@foss.st.com>
Cc: kernel@dh-electronics.com
Cc: linux-stm32@st-md-mailman.stormreply.com
To: linux-arm-kernel@lists.infradead.org
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi b/arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi
index 2617815e42a6..1c1c4198f2c1 100644
--- a/arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi
+++ b/arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi
@@ -140,7 +140,7 @@ &fmc {
 	pinctrl-1 = <&fmc_sleep_pins_b>;
 	status = "okay";
 
-	ksz8851: ks8851mll@1,0 {
+	ksz8851: ethernet@1,0 {
 		compatible = "micrel,ks8851-mll";
 		reg = <1 0x0 0x2>, <1 0x2 0x20000>;
 		interrupt-parent = <&gpioc>;
-- 
2.30.2

