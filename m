Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 515CD45143F
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349160AbhKOUDu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:03:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:45212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344254AbhKOTYN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8250763654;
        Mon, 15 Nov 2021 18:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002474;
        bh=Qu5ebb7LkPrK8WpT9/gVyPOEZI6UeCOW6Ud2RwNmAYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0kppJFb1da5ewIUAYoKaGI4f03eoouH3zaUmpZjmbwt1BD+Uixq4bxUU7VRmVoQvn
         lZe6dcovFhXNfqDVy+zpvRlISO9j2vgNNC42O/960jgnIkWsMt9zFXqgL9DVnsxBYP
         GSvoNdpfzDz+UVsdWEitFSzz4zL7N3acDuYXuWXQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>,
        Aswath Govindraju <a-govindraju@ti.com>,
        Nishanth Menon <nm@ti.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 580/917] arm64: dts: ti: k3-j721e-main: Fix "max-virtual-functions" in PCIe EP nodes
Date:   Mon, 15 Nov 2021 18:01:15 +0100
Message-Id: <20211115165448.443794086@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
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
index cf3482376c1e6..43be5d23130b4 100644
--- a/arch/arm64/boot/dts/ti/k3-j721e-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j721e-main.dtsi
@@ -636,7 +636,7 @@
 		clocks = <&k3_clks 239 1>;
 		clock-names = "fck";
 		max-functions = /bits/ 8 <6>;
-		max-virtual-functions = /bits/ 16 <4 4 4 4 0 0>;
+		max-virtual-functions = /bits/ 8 <4 4 4 4 0 0>;
 		dma-coherent;
 	};
 
@@ -684,7 +684,7 @@
 		clocks = <&k3_clks 240 1>;
 		clock-names = "fck";
 		max-functions = /bits/ 8 <6>;
-		max-virtual-functions = /bits/ 16 <4 4 4 4 0 0>;
+		max-virtual-functions = /bits/ 8 <4 4 4 4 0 0>;
 		dma-coherent;
 	};
 
@@ -732,7 +732,7 @@
 		clocks = <&k3_clks 241 1>;
 		clock-names = "fck";
 		max-functions = /bits/ 8 <6>;
-		max-virtual-functions = /bits/ 16 <4 4 4 4 0 0>;
+		max-virtual-functions = /bits/ 8 <4 4 4 4 0 0>;
 		dma-coherent;
 	};
 
@@ -780,7 +780,7 @@
 		clocks = <&k3_clks 242 1>;
 		clock-names = "fck";
 		max-functions = /bits/ 8 <6>;
-		max-virtual-functions = /bits/ 16 <4 4 4 4 0 0>;
+		max-virtual-functions = /bits/ 8 <4 4 4 4 0 0>;
 		dma-coherent;
 		#address-cells = <2>;
 		#size-cells = <2>;
-- 
2.33.0



