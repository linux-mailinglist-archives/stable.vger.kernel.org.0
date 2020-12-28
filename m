Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 172132E3978
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388624AbgL1NYA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:24:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:52600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388603AbgL1NX7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:23:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34EA722472;
        Mon, 28 Dec 2020 13:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161798;
        bh=MkK3j7ZomOYFFJqGfh8X0raUHFSG9RMvM+M6u7FC2fo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Phy1uGljV6X8NoorvN9Sooxvlyz8QUjZaaMGzrjsNVSSAyefOCgS/CfShmyJaKFsR
         AxU+5VVNcHPSU7sxP572pIDqtiQzP9YdLiM9m3zm2oSLtV2lY0wz1eSilOIorOiQUI
         eWzY0AHsfGFIHH6onlJ2QDtYHnUI/Lh7I2hnTthg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Gabriel Ribba Esteva <gabriel.ribbae@gmail.com>
Subject: [PATCH 4.19 084/346] ARM: dts: exynos: fix roles of USB 3.0 ports on Odroid XU
Date:   Mon, 28 Dec 2020 13:46:43 +0100
Message-Id: <20201228124923.862782343@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

commit ecc1ff532b499d20304a4f682247137025814c34 upstream.

On Odroid XU board the USB3-0 port is a microUSB and USB3-1 port is USB
type A (host).  The roles were copied from Odroid XU3 (Exynos5422)
design which has it reversed.

Fixes: 8149afe4dbf9 ("ARM: dts: exynos: Add initial support for Odroid XU board")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201015182044.480562-1-krzk@kernel.org
Tested-by: Gabriel Ribba Esteva <gabriel.ribbae@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/exynos5410-odroidxu.dts |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/boot/dts/exynos5410-odroidxu.dts
+++ b/arch/arm/boot/dts/exynos5410-odroidxu.dts
@@ -626,11 +626,11 @@
 };
 
 &usbdrd_dwc3_0 {
-	dr_mode = "host";
+	dr_mode = "peripheral";
 };
 
 &usbdrd_dwc3_1 {
-	dr_mode = "peripheral";
+	dr_mode = "host";
 };
 
 &usbdrd3_0 {


