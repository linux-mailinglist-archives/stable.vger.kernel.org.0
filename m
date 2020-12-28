Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B82012E3AA7
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403801AbgL1Njy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:39:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:39630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403795AbgL1Njx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:39:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B7042063A;
        Mon, 28 Dec 2020 13:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162777;
        bh=1dQhSI+dob1gFEXz9OXKomPDYDL6Nskav45NYb5yp0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ogTuW6cAdUz1iYJlIyjeCjQQaEP4Nzj+B3PoXsvPY2opLdHqvXjPCTtGtVVfwPkEK
         +CVx8NH24tjHiXOAYavdxh20IM+T10jucwMMjf6Zx9Cg9SKGe3eXU8sodGn8Vf06on
         GASHDTQCpR8T43PxlZ6czzT0Ut0DZo4CfGxbJ1Lo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Gabriel Ribba Esteva <gabriel.ribbae@gmail.com>
Subject: [PATCH 5.4 058/453] ARM: dts: exynos: fix roles of USB 3.0 ports on Odroid XU
Date:   Mon, 28 Dec 2020 13:44:54 +0100
Message-Id: <20201228124940.039840336@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
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
@@ -637,11 +637,11 @@
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


