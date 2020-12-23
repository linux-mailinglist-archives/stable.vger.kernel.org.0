Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA79F2E1DFC
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 16:35:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726390AbgLWPdb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 10:33:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:43946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726558AbgLWPdb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Dec 2020 10:33:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7725E23355;
        Wed, 23 Dec 2020 15:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608737570;
        bh=1dQhSI+dob1gFEXz9OXKomPDYDL6Nskav45NYb5yp0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DGPL0TNQyZLGcJqOTcheQwN/t2cu+LEdfteKy+QWeEH5TZUtakp2+VvGNi1Tbxud6
         wp9MtlTelFzGOUV5+RRtS+nNpbqYfzvy9jjyBtDYBjt9V2kvpMg4TPvmUI/qHhkVik
         zzgVu4/pTK3pv8qxe8yIlsOyaAT6a1R8hu07bdzw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Gabriel Ribba Esteva <gabriel.ribbae@gmail.com>
Subject: [PATCH 5.10 12/40] ARM: dts: exynos: fix roles of USB 3.0 ports on Odroid XU
Date:   Wed, 23 Dec 2020 16:33:13 +0100
Message-Id: <20201223150516.159866485@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201223150515.553836647@linuxfoundation.org>
References: <20201223150515.553836647@linuxfoundation.org>
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


