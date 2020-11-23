Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5BDE2C09D1
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:19:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730459AbgKWNM5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:12:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:59286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732413AbgKWMpu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:45:50 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA2E620888;
        Mon, 23 Nov 2020 12:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135550;
        bh=vohCckSqRRp3KjIx4v6NKWKUY22acKKH3Rk0PSZP9h4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tr6wXAA2gvXCnVFZhp90xzAiMXsUS0hT3Si/PLUaBLotC9hv4Yyn0mLL2x6WHX86m
         MsJrMOcl/hmLV0/c5Vr+BPb2/sWslaxE6qnejCOv7mLlqSggNa2yzNc5TcXBhTI5KE
         N/bMkghIIhgh9hR5QxwNbdHi5CkwmtLhj66GjCsY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Patrick Delaunay <patrick.delaunay@st.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 107/252] ARM: dts: stm32: Fix LED5 on STM32MP1 DHCOM PDK2
Date:   Mon, 23 Nov 2020 13:20:57 +0100
Message-Id: <20201123121840.751174410@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit 7e5f3155dcbb4d724386b30cc232002d9b9d81f5 ]

On the prototype DHCOM, the LED5 was connected to pin PG2 of the
STM32MP15xx, however on the production SoM this was changed to pin
PC6. Update the connection in the DT.

Fixes: 81d5fc719798 ("ARM: dts: stm32: Add GPIO LEDs for STM32MP1 DHCOM PDK2")
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Patrice Chotard <patrice.chotard@st.com>
Cc: Patrick Delaunay <patrick.delaunay@st.com>
Cc: linux-stm32@st-md-mailman.stormreply.com
To: linux-arm-kernel@lists.infradead.org
Signed-off-by: Alexandre Torgue <alexandre.torgue@st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi b/arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi
index 7cddeb1a545a3..13f52b79454e1 100644
--- a/arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi
+++ b/arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi
@@ -82,7 +82,7 @@
 
 		led-0 {
 			label = "green:led5";
-			gpios = <&gpiog 2 GPIO_ACTIVE_HIGH>;
+			gpios = <&gpioc 6 GPIO_ACTIVE_HIGH>;
 			default-state = "off";
 		};
 
-- 
2.27.0



