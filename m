Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA6463D29BC
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234238AbhGVQGK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:06:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:42418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234472AbhGVQEv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:04:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0DFD861C1C;
        Thu, 22 Jul 2021 16:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972323;
        bh=RrB883tsRtXkWPyyZAEB+tXrMgeyKsyY0LbFGjanPSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ohUb6YEweYY38Vk4rk2I1Ls7KKWv7b9SBG94cHPmbzQSya878H0AU78Zv5ENCTt/n
         zXsRe46cj7NYqcLeUoYJ5oxj+acTi55ptL32BSz/RvbD/Dtbj3bG1xbHNMAorpMPaX
         epHX1ER6dReeQE8WacNvLKXMxTdo40l+YUGZ6iig=
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
Subject: [PATCH 5.13 069/156] ARM: dts: stm32: Drop unused linux,wakeup from touchscreen node on DHCOM SoM
Date:   Thu, 22 Jul 2021 18:30:44 +0200
Message-Id: <20210722155630.625145277@linuxfoundation.org>
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
index b8c8f0b284c3..c5ea08fec535 100644
--- a/arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi
+++ b/arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi
@@ -187,7 +187,6 @@
 		reg = <0x38>;
 		interrupt-parent = <&gpiog>;
 		interrupts = <2 IRQ_TYPE_EDGE_FALLING>; /* GPIO E */
-		linux,wakeup;
 	};
 };
 
-- 
2.30.2



