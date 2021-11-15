Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 174C94522F0
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:15:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347915AbhKPBRA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:17:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:38232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243335AbhKOTJM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:09:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F02263409;
        Mon, 15 Nov 2021 18:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000294;
        bh=PCh07qAK0il2Hiz5EjTkl+VlxldW13R1sXSI2z6PtXs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AYhqsdwynHmixTkaLbb2LBlz7hQ8av9dcSkdNp9WdrN5iNydokSVpLvaVrgtOoZVg
         vfyIY7+c3uWdfXGtpSaiZbWxx86Yyz16Ytu9Owxgd6wf3YaND/eJSUQ414TaY0WYuf
         XRzl8AWX6nweYBYSekjHTFKuS5dpgs7c6PkAflu4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>,
        Aswath Govindraju <a-govindraju@ti.com>,
        Nishanth Menon <nm@ti.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 565/849] arm64: dts: ti: j7200-main: Fix "bus-range" upto 256 bus number for PCIe
Date:   Mon, 15 Nov 2021 18:00:48 +0100
Message-Id: <20211115165439.361714103@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kishon Vijay Abraham I <kishon@ti.com>

[ Upstream commit 8bb8429290c0043a78804ae48294b53f781ee426 ]

commit 3276d9f53cf6 ("arm64: dts: ti: k3-j7200-main: Add PCIe device
tree node") incorrectly added PCIe bus numbers from 0 to 15 (copy-paste
from J721E node). Enable all the supported bus numbers from 0 to 255
defined in PCIe spec here.

Fixes: 3276d9f53cf6 ("arm64: dts: ti: k3-j7200-main: Add PCIe device tree node")
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Reviewed-by: Aswath Govindraju <a-govindraju@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
Link: https://lore.kernel.org/r/20210915055358.19997-5-kishon@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-j7200-main.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-j7200-main.dtsi b/arch/arm64/boot/dts/ti/k3-j7200-main.dtsi
index 521a56316fa5c..874cba75e9a5a 100644
--- a/arch/arm64/boot/dts/ti/k3-j7200-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j7200-main.dtsi
@@ -606,7 +606,7 @@
 		clock-names = "fck";
 		#address-cells = <3>;
 		#size-cells = <2>;
-		bus-range = <0x0 0xf>;
+		bus-range = <0x0 0xff>;
 		cdns,no-bar-match-nbits = <64>;
 		vendor-id = <0x104c>;
 		device-id = <0xb00f>;
-- 
2.33.0



