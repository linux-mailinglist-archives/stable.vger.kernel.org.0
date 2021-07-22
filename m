Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 874E83D27C9
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 18:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbhGVPwt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:52:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:56000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230136AbhGVPws (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:52:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DFD56135B;
        Thu, 22 Jul 2021 16:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971603;
        bh=3OjFSqsrZaCP0UOgMoqGNc3kTeZ7Pq8Cd7MbKAjpFqg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VXEBHT1EmcQ0hiuWNwxhQHdq+rYnJ/QOSDtXnKXOeSNf1SgXXoc92kz+qpn/7NgDN
         pWzPF0sD8pGhb482pTZyEbofUffzFTtT9jj7kRPYuGBuScbILMyzNpD7o/lMZJ1/QE
         YyLBZGA1RZjagqb5JiUh0mUgAr7jcFwapTf6vTDc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Jonker <jbx6244@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 28/71] ARM: dts: rockchip: fix supply properties in io-domains nodes
Date:   Thu, 22 Jul 2021 18:31:03 +0200
Message-Id: <20210722155618.804289579@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155617.865866034@linuxfoundation.org>
References: <20210722155617.865866034@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Jonker <jbx6244@gmail.com>

[ Upstream commit f07edc41220b14ce057a4e6d7161b30688ddb8a2 ]

A test with rockchip-io-domain.yaml gives notifications
for supply properties in io-domains nodes.
Fix them all into ".*-supply$" format.

Signed-off-by: Johan Jonker <jbx6244@gmail.com>
Link: https://lore.kernel.org/r/20210606181632.13371-1-jbx6244@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/rk3288-rock2-som.dtsi | 2 +-
 arch/arm/boot/dts/rk3288-vyasa.dts      | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/rk3288-rock2-som.dtsi b/arch/arm/boot/dts/rk3288-rock2-som.dtsi
index 9f9e2bfd1295..7b79a21f9bbb 100644
--- a/arch/arm/boot/dts/rk3288-rock2-som.dtsi
+++ b/arch/arm/boot/dts/rk3288-rock2-som.dtsi
@@ -218,7 +218,7 @@
 	flash0-supply = <&vcc_flash>;
 	flash1-supply = <&vccio_pmu>;
 	gpio30-supply = <&vccio_pmu>;
-	gpio1830 = <&vcc_io>;
+	gpio1830-supply = <&vcc_io>;
 	lcdc-supply = <&vcc_io>;
 	sdcard-supply = <&vccio_sd>;
 	wifi-supply = <&vcc_18>;
diff --git a/arch/arm/boot/dts/rk3288-vyasa.dts b/arch/arm/boot/dts/rk3288-vyasa.dts
index ba06e9f97ddc..acfb7dc2df56 100644
--- a/arch/arm/boot/dts/rk3288-vyasa.dts
+++ b/arch/arm/boot/dts/rk3288-vyasa.dts
@@ -357,10 +357,10 @@
 	audio-supply = <&vcc_18>;
 	bb-supply = <&vcc_io>;
 	dvp-supply = <&vcc_io>;
-	flash0-suuply = <&vcc_18>;
+	flash0-supply = <&vcc_18>;
 	flash1-supply = <&vcc_lan>;
 	gpio30-supply = <&vcc_io>;
-	gpio1830 = <&vcc_io>;
+	gpio1830-supply = <&vcc_io>;
 	lcdc-supply = <&vcc_io>;
 	sdcard-supply = <&vccio_sd>;
 	wifi-supply = <&vcc_18>;
-- 
2.30.2



