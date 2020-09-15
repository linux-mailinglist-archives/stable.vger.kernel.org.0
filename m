Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33A6A26B6FA
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 02:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbgIPAP1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 20:15:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:38308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726918AbgIOOYz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:24:55 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 907B5223C6;
        Tue, 15 Sep 2020 14:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179524;
        bh=iG1bIU5EhUKwfx9UnD06qETtVPAWWEtlDW1My2TVsVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qMsUvhumRXscJrZL0R/Aw+0oTeQaX32HeeBQU2J5Ndsn/R+1oWd20ml6d8nCDijSJ
         GdjAsnBLJEVTcZUjMHf9rwAnOHGi1Rii2xRwUwr84ZDCh5u/mEVQWRd0rD0pdhGdRD
         TXg8Ycl4YVJ1Uro5MmKnji3+pbGz3QYAVCyaXydU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 015/132] arm64: dts: imx8mq: Fix TMU interrupt property
Date:   Tue, 15 Sep 2020 16:11:57 +0200
Message-Id: <20200915140644.840371943@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140644.037604909@linuxfoundation.org>
References: <20200915140644.037604909@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 1f2f98f2703e8134678fe20982886085631eda23 ]

"interrupt" is not a valid property.  Using proper name fixes dtbs_check
warning:

  arch/arm64/boot/dts/freescale/imx8mq-zii-ultra-zest.dt.yaml: tmu@30260000: 'interrupts' is a required property

Fixes: e464fd2ba4d4 ("arm64: dts: imx8mq: enable the multi sensor TMU")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mq.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mq.dtsi b/arch/arm64/boot/dts/freescale/imx8mq.dtsi
index 55a3d1c4bdf04..bc8540f879654 100644
--- a/arch/arm64/boot/dts/freescale/imx8mq.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mq.dtsi
@@ -349,7 +349,7 @@
 			tmu: tmu@30260000 {
 				compatible = "fsl,imx8mq-tmu";
 				reg = <0x30260000 0x10000>;
-				interrupt = <GIC_SPI 49 IRQ_TYPE_LEVEL_HIGH>;
+				interrupts = <GIC_SPI 49 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clk IMX8MQ_CLK_TMU_ROOT>;
 				little-endian;
 				fsl,tmu-range = <0xb0000 0xa0026 0x80048 0x70061>;
-- 
2.25.1



