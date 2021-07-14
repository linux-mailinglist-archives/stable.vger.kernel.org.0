Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5473D3C8F80
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234000AbhGNTwm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:52:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:44850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239944AbhGNTt2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:49:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92A2861422;
        Wed, 14 Jul 2021 19:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291878;
        bh=VX0WOPdLAKqMaeZj13M4WvQ9VDRY7ckZKxEkg6hplDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ae4BuYIJG31CZPEh6ugZX4aIPkWY1TsES0e478ZRjF3rk1N/EoYCUtheTcJixKj8Z
         tJv0bXD2geU0ec52yA7xx6gzPq7cHDcHc+ISg4izl/5Rlx2a5G0tLD4oiQfXQ4jj5/
         Q9QNs3hUyqaTwcoyx4MdX9uS8PeS+FvSk+rmBowDbJxV4V7X0CgGU4ad6VAx01lDHP
         PZCpRi9G6c3NlFj2SAWCu92BBcqeYVTCd3p2SsY96O2woeXGNQMNMRz3YRH++XCeXd
         rys1G9N8Ttcr6ZfQuxKNBBPLrZKEhJAWK4CAEIGIbh7oTxqtnIVjGUJhAFhOFFGlZ6
         kO04cVxcSIRKA==
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
Subject: [PATCH AUTOSEL 5.10 63/88] ARM: dts: stm32: Drop unused linux,wakeup from touchscreen node on DHCOM SoM
Date:   Wed, 14 Jul 2021 15:42:38 -0400
Message-Id: <20210714194303.54028-63-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194303.54028-1-sashal@kernel.org>
References: <20210714194303.54028-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit 5247a50c8b53ca214a488da648e1bb35c35c2597 ]

Fix the following dtbs_check warning:
touchscreen@38: 'linux,wakeup' does not match any of the regexes: 'pinctrl-[0-9]+'

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
 arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi b/arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi
index a2d903c0d57f..59b3239bcd76 100644
--- a/arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi
+++ b/arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi
@@ -187,7 +187,6 @@ touchscreen@38 {
 		reg = <0x38>;
 		interrupt-parent = <&gpiog>;
 		interrupts = <2 IRQ_TYPE_EDGE_FALLING>; /* GPIO E */
-		linux,wakeup;
 	};
 };
 
-- 
2.30.2

