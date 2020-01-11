Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6312A137FD5
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730654AbgAKKX3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:23:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:50614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728833AbgAKKX2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:23:28 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65D602082E;
        Sat, 11 Jan 2020 10:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738208;
        bh=VpTE1uMYQYHAjVi/WQfKAjM9ST04k+XHCIZY0MSvKwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0wxa94HHhWyyLftoTOFKyJmhKHR/8LvNywFT5YSk7yBbNAkD3XRQUZ/OWaHDjHlnH
         kBICWKIkQYFpL6biEuP2YAvIe8jStDdPJIRSzpuE3S23urGWZ+EABNPWNwwbj4HaJ4
         y/MaW5DMY4UjhW7WoGS7AOF/GFl18aSwgbXQ5sQA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Simon Horman <simon.horman@netronome.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 033/165] ARM: dts: BCM5301X: Fix MDIO node address/size cells
Date:   Sat, 11 Jan 2020 10:49:12 +0100
Message-Id: <20200111094923.963516146@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 093c3f94e922d83a734fc4da08cc5814990f32c6 ]

The MDIO node on BCM5301X had an reversed #address-cells and
 #size-cells properties, correct those, silencing checker warnings:

.../linux/arch/arm/boot/dts/bcm4708-asus-rt-ac56u.dt.yaml: mdio@18003000: #address-cells:0:0: 1 was expected

Reported-by: Simon Horman <simon.horman@netronome.com>
Fixes: 23f1eca6d59b ("ARM: dts: BCM5301X: Specify MDIO bus in the DT")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm5301x.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/bcm5301x.dtsi b/arch/arm/boot/dts/bcm5301x.dtsi
index 372dc1eb88a0..2d9b4dd05830 100644
--- a/arch/arm/boot/dts/bcm5301x.dtsi
+++ b/arch/arm/boot/dts/bcm5301x.dtsi
@@ -353,8 +353,8 @@
 	mdio: mdio@18003000 {
 		compatible = "brcm,iproc-mdio";
 		reg = <0x18003000 0x8>;
-		#size-cells = <1>;
-		#address-cells = <0>;
+		#size-cells = <0>;
+		#address-cells = <1>;
 	};
 
 	mdio-bus-mux@18003000 {
-- 
2.20.1



