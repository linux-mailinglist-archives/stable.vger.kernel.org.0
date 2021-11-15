Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39117450E45
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240862AbhKOSN5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:13:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:48896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240212AbhKOSHW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:07:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C85DA63396;
        Mon, 15 Nov 2021 17:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998212;
        bh=P6ygygwOTzHSwqvIz4Y8YytaX5bWY+QCAyKFT9408NY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VGu4lMYUcZO5UgDyUNvGLW3SOvuxMiklGozNjho8OVCMGxhnNMhGhbTwTZtZjWQV6
         xq+ZeA/C9bRuxHryLJZBeJrsC8BIC0l0ko5/r5gNcrR/D8IV2WRjUNP2pWeZqHa5tk
         T+CxNJse+/eNeFuEY96KylHazRpZzZ9tfW8F7FMk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>,
        Aswath Govindraju <a-govindraju@ti.com>,
        Nishanth Menon <nm@ti.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 396/575] arm64: dts: ti: k3-j721e-main: Fix "bus-range" upto 256 bus number for PCIe
Date:   Mon, 15 Nov 2021 18:02:01 +0100
Message-Id: <20211115165357.467061528@linuxfoundation.org>
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

[ Upstream commit 5f46633565b1c1e1840a927676065d72b442dac4 ]

commit 4e5833884f66 ("arm64: dts: ti: k3-j721e-main: Add PCIe device
tree nodes") restricted PCIe bus numbers from 0 to 15 (due to SMMU
restriction in J721E). However since SMMU is not enabled, allow the full
supported bus numbers from 0 to 255.

Fixes: 4e5833884f66 ("arm64: dts: ti: k3-j721e-main: Add PCIe device tree nodes")
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Reviewed-by: Aswath Govindraju <a-govindraju@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
Link: https://lore.kernel.org/r/20210915055358.19997-3-kishon@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-j721e-main.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-j721e-main.dtsi b/arch/arm64/boot/dts/ti/k3-j721e-main.dtsi
index 4e010253b028a..85526f72b4616 100644
--- a/arch/arm64/boot/dts/ti/k3-j721e-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j721e-main.dtsi
@@ -629,7 +629,7 @@
 		clock-names = "fck";
 		#address-cells = <3>;
 		#size-cells = <2>;
-		bus-range = <0x0 0xf>;
+		bus-range = <0x0 0xff>;
 		vendor-id = <0x104c>;
 		device-id = <0xb00d>;
 		msi-map = <0x0 &gic_its 0x0 0x10000>;
@@ -678,7 +678,7 @@
 		clock-names = "fck";
 		#address-cells = <3>;
 		#size-cells = <2>;
-		bus-range = <0x0 0xf>;
+		bus-range = <0x0 0xff>;
 		vendor-id = <0x104c>;
 		device-id = <0xb00d>;
 		msi-map = <0x0 &gic_its 0x10000 0x10000>;
@@ -727,7 +727,7 @@
 		clock-names = "fck";
 		#address-cells = <3>;
 		#size-cells = <2>;
-		bus-range = <0x0 0xf>;
+		bus-range = <0x0 0xff>;
 		vendor-id = <0x104c>;
 		device-id = <0xb00d>;
 		msi-map = <0x0 &gic_its 0x20000 0x10000>;
@@ -776,7 +776,7 @@
 		clock-names = "fck";
 		#address-cells = <3>;
 		#size-cells = <2>;
-		bus-range = <0x0 0xf>;
+		bus-range = <0x0 0xff>;
 		vendor-id = <0x104c>;
 		device-id = <0xb00d>;
 		msi-map = <0x0 &gic_its 0x30000 0x10000>;
-- 
2.33.0



