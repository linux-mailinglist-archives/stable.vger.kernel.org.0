Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6244F3D299E
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233934AbhGVQFo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:05:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:42454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234495AbhGVQEw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:04:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 547BA61C24;
        Thu, 22 Jul 2021 16:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972326;
        bh=wgVnSA9coDv9nQFOI6Vo3gvUyprsyL4rHQTob/cqICM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I+0BNedI+6xr5RKtmJc5cQoBixGzFJnot0XXpG/xah8YsQp1+ryGDJj4qEKuYqg+0
         ubojeViwqbERNuJ3S4H3xre7AMJfbB+SvXU7Y/7o7eLip5RAeAthCK1xpUHiTpmdXA
         VutS2/4geuE2+YDu4o4cZDLxnsgMnxLJC5kGt9qI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        Patrick Delaunay <patrick.delaunay@foss.st.com>,
        kernel@dh-electronics.com,
        linux-stm32@st-md-mailman.stormreply.com,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 070/156] ARM: dts: stm32: Rename eth@N to ethernet@N on DHCOM SoM
Date:   Thu, 22 Jul 2021 18:30:45 +0200
Message-Id: <20210722155630.655106127@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 31d08423a32f..c3e3466dacaa 100644
--- a/arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi
+++ b/arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi
@@ -150,7 +150,7 @@
 	pinctrl-1 = <&fmc_sleep_pins_b>;
 	status = "okay";
 
-	ksz8851: ks8851mll@1,0 {
+	ksz8851: ethernet@1,0 {
 		compatible = "micrel,ks8851-mll";
 		reg = <1 0x0 0x2>, <1 0x2 0x20000>;
 		interrupt-parent = <&gpioc>;
-- 
2.30.2



