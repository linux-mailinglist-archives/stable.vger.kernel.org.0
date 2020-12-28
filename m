Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 923222E3D13
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439141AbgL1OKw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:10:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:45350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439139AbgL1OKv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:10:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 38DA22063A;
        Mon, 28 Dec 2020 14:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164610;
        bh=GY47Ga5M7yCnVyyJnOkLfADXtU/+q4Or4YA0/8G4AF8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hMtBclOye1HLfOKxhUBjnqul97+5NbsVBhWwsMoiSQ2tokrvcNpD8o2xD1gOYv/Ip
         Tb7TOOrm+POcUx9ViZ9M4khQiSDBb5ne70Snqft3kU+YXzfHmAfG9tosrx+5W+mGeb
         By/uIv0KH3rZbv6LieLHxHXBUTAa/l5Vz3tjkFWI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 235/717] arm64: dts: ls1028a: fix FlexSPI clock input
Date:   Mon, 28 Dec 2020 13:43:53 +0100
Message-Id: <20201228125032.248068943@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Walle <michael@walle.cc>

[ Upstream commit 588b17eda1356e06efa4b888d0af02c80a2788f6 ]

On the LS1028A the FlexSPI clock is connected to the first HWA output,
see Figure 7 "Clock subsystem block diagram".

Fixes: c77fae5ba09a ("arm64: dts: ls1028a: Add FlexSPI support")
Signed-off-by: Michael Walle <michael@walle.cc>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
index 060b0d5c2669e..33aa0efa2293a 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
@@ -309,7 +309,7 @@
 			      <0x0 0x20000000 0x0 0x10000000>;
 			reg-names = "fspi_base", "fspi_mmap";
 			interrupts = <GIC_SPI 25 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&clockgen 4 3>, <&clockgen 4 3>;
+			clocks = <&clockgen 2 0>, <&clockgen 2 0>;
 			clock-names = "fspi_en", "fspi";
 			status = "disabled";
 		};
-- 
2.27.0



