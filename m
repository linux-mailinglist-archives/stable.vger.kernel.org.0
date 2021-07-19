Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E39D3CE298
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348505AbhGSPa6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:30:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:38042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347987AbhGSPXz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:23:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04E34613D0;
        Mon, 19 Jul 2021 16:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710413;
        bh=lJy0GM2LntCanx7s/pW97hMaaJEGzFs4g8nxbjHrm6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MOsxB4MRgA1yMQwanCcQx46hyw4igSabB/xNjmGwvZxKHZ/WMHEBozv3Otyt9uTdF
         FWSCLXeep+D4HlESoxy1G9IfKyVYD0WwLUu6f7+GVqoyoo5Ldy1qc9yPpEF+xlO37w
         xpSUX9uTL+TYIQaLGmMQ7Xzuu1eDzGZMMTi67qew=
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
Subject: [PATCH 5.10 205/243] ARM: dts: stm32: Connect PHY IRQ line on DH STM32MP1 SoM
Date:   Mon, 19 Jul 2021 16:53:54 +0200
Message-Id: <20210719144947.547706671@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit 516728273ddfbf51b3d0fcaac05d26e299a7b456 ]

On the production DHCOM STM32MP15xx SoM, the PHY IRQ line is connected
to the PI11 pin. Describe it in the DT as well, so the PHY IRQ can be
used e.g. to detect cable insertion and removal.

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
 arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi b/arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi
index 2d027dafb7bc..71f3e4efce65 100644
--- a/arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi
+++ b/arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi
@@ -127,6 +127,8 @@
 
 		phy0: ethernet-phy@1 {
 			reg = <1>;
+			interrupt-parent = <&gpioi>;
+			interrupts = <11 IRQ_TYPE_LEVEL_LOW>;
 		};
 	};
 };
-- 
2.30.2



