Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 701153A02FD
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234907AbhFHTLo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:11:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:53136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236962AbhFHTJN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:09:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB8DC6193A;
        Tue,  8 Jun 2021 18:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178072;
        bh=WQxKP0BX8pnexk7KcVyY7fiFam6TBmPeGmbL88cDBHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RAmoBgrzFnLB1+X51g5dl6br+DCLi5XuPwvOBEWsB5kgwOf90r63w1AA0SjfvA29o
         aSfIpy8OjrooWjonslnoQFWca1vzzuZ5g+RUmUg9MiE/tRI8rYR4DCgAJmzoFr0RsC
         BHeMV87Ct27unKh1aRtXseg5e3kJeykdJC1w4QIQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vignesh Raghavendra <vigneshr@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Nishanth Menon <nm@ti.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 066/161] arm64: dts: ti: j7200-main: Mark Main NAVSS as dma-coherent
Date:   Tue,  8 Jun 2021 20:26:36 +0200
Message-Id: <20210608175947.695248037@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vignesh Raghavendra <vigneshr@ti.com>

[ Upstream commit 52ae30f55a2a40cff549fac95de82f25403bd387 ]

Traffic through main NAVSS interconnect is coherent wrt ARM caches on
J7200 SoC.  Add missing dma-coherent property to main_navss node.

Also add dma-ranges to be consistent with mcu_navss node
and with AM65/J721e main_navss and mcu_navss nodes.

Fixes: d361ed88455fe ("arm64: dts: ti: Add support for J7200 SoC")
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Reviewed-by: Peter Ujfalusi <peter.ujfalusi@gmail.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
Link: https://lore.kernel.org/r/20210510180601.19458-1-vigneshr@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-j7200-main.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/ti/k3-j7200-main.dtsi b/arch/arm64/boot/dts/ti/k3-j7200-main.dtsi
index 17477ab0fd8e..3398f174f09b 100644
--- a/arch/arm64/boot/dts/ti/k3-j7200-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j7200-main.dtsi
@@ -85,6 +85,8 @@
 		#size-cells = <2>;
 		ranges = <0x00 0x30000000 0x00 0x30000000 0x00 0x0c400000>;
 		ti,sci-dev-id = <199>;
+		dma-coherent;
+		dma-ranges;
 
 		main_navss_intr: interrupt-controller1 {
 			compatible = "ti,sci-intr";
-- 
2.30.2



