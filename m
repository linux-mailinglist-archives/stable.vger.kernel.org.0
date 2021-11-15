Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57BC0450E3F
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:12:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240819AbhKOSNw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:13:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:49942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240192AbhKOSHS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:07:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F8C26338A;
        Mon, 15 Nov 2021 17:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998195;
        bh=OhvQmHveZ43YpaxzUOtqQm8CB8J2Ymfcz7ncHTzOUQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hoPRL+aBmBaxFj+fZo64MkD4G6dfYSqZ3m6J6X+208OIbkwhXZ57fHhtvEjElYg4n
         KUhEiW+8O9Pk6gJtN6yvL7/N/tEbHUPrGiMt88bA4+iWb+wGsOWtYDLFTwLpEnWREY
         Vlpy7R0ggeK0DgqtcvnvsLuwwabsPBGXX1OprZrk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>,
        Aswath Govindraju <a-govindraju@ti.com>,
        Nishanth Menon <nm@ti.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 395/575] arm64: dts: ti: k3-j721e-main: Fix "max-virtual-functions" in PCIe EP nodes
Date:   Mon, 15 Nov 2021 18:02:00 +0100
Message-Id: <20211115165357.428469958@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kishon Vijay Abraham I <kishon@ti.com>

[ Upstream commit 9af3ef954975c383eeb667aee207d9ce6fbef8c4 ]

commit 4e5833884f66 ("arm64: dts: ti: k3-j721e-main: Add PCIe device
tree nodes") added "max-virtual-functions" to have 16 bit values.
Fix "max-virtual-functions" in PCIe endpoint (EP) nodes to have 8 bit
values instead of 16.

Fixes: 4e5833884f66 ("arm64: dts: ti: k3-j721e-main: Add PCIe device tree nodes")
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Reviewed-by: Aswath Govindraju <a-govindraju@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
Link: https://lore.kernel.org/r/20210915055358.19997-2-kishon@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-j721e-main.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-j721e-main.dtsi b/arch/arm64/boot/dts/ti/k3-j721e-main.dtsi
index 6ffdebd601223..4e010253b028a 100644
--- a/arch/arm64/boot/dts/ti/k3-j721e-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j721e-main.dtsi
@@ -656,7 +656,7 @@
 		clock-names = "fck";
 		cdns,max-outbound-regions = <16>;
 		max-functions = /bits/ 8 <6>;
-		max-virtual-functions = /bits/ 16 <4 4 4 4 0 0>;
+		max-virtual-functions = /bits/ 8 <4 4 4 4 0 0>;
 		dma-coherent;
 	};
 
@@ -705,7 +705,7 @@
 		clock-names = "fck";
 		cdns,max-outbound-regions = <16>;
 		max-functions = /bits/ 8 <6>;
-		max-virtual-functions = /bits/ 16 <4 4 4 4 0 0>;
+		max-virtual-functions = /bits/ 8 <4 4 4 4 0 0>;
 		dma-coherent;
 	};
 
@@ -754,7 +754,7 @@
 		clock-names = "fck";
 		cdns,max-outbound-regions = <16>;
 		max-functions = /bits/ 8 <6>;
-		max-virtual-functions = /bits/ 16 <4 4 4 4 0 0>;
+		max-virtual-functions = /bits/ 8 <4 4 4 4 0 0>;
 		dma-coherent;
 	};
 
@@ -803,7 +803,7 @@
 		clock-names = "fck";
 		cdns,max-outbound-regions = <16>;
 		max-functions = /bits/ 8 <6>;
-		max-virtual-functions = /bits/ 16 <4 4 4 4 0 0>;
+		max-virtual-functions = /bits/ 8 <4 4 4 4 0 0>;
 		dma-coherent;
 		#address-cells = <2>;
 		#size-cells = <2>;
-- 
2.33.0



