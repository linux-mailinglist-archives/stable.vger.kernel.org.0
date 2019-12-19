Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B403126CFD
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728513AbfLSTHu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 14:07:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:34040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727129AbfLSSmk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:42:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06FB024672;
        Thu, 19 Dec 2019 18:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576780960;
        bh=rYWYX7iXGtou88qzKRMc1v3o8tS1ohSmgiL6awNATEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H2j8wVyyfvcwoH2/deovWZvW3kXiC5u4ZHFR7QC7RmSowoA7hQHBKVzntWKrknyUO
         zCtH2Z/ZOsOcwQBMi6A8OuOg6ZGeIrARUQ9l2MuM+Jn9bqdTE7Wng+p6Ncarg4O94N
         aKo93PA4jfihMtibj7l0IHUxrBWokHEpAKENeizA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Keeping <john@metanate.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 025/199] ARM: dts: rockchip: Fix rk3288-rock2 vcc_flash name
Date:   Thu, 19 Dec 2019 19:31:47 +0100
Message-Id: <20191219183216.222044416@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183214.629503389@linuxfoundation.org>
References: <20191219183214.629503389@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Keeping <john@metanate.com>

[ Upstream commit 03d9f8fa2bfdc791865624d3adc29070cf67814e ]

There is no functional change from this, but it is confusing to find two
copies of vcc_sys and no vcc_flash when looking in
/sys/class/regulator/*/name.

Signed-off-by: John Keeping <john@metanate.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/rk3288-rock2-som.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/rk3288-rock2-som.dtsi b/arch/arm/boot/dts/rk3288-rock2-som.dtsi
index bb1f01e037ba7..c1c576875bc85 100644
--- a/arch/arm/boot/dts/rk3288-rock2-som.dtsi
+++ b/arch/arm/boot/dts/rk3288-rock2-som.dtsi
@@ -63,7 +63,7 @@
 
 	vcc_flash: flash-regulator {
 		compatible = "regulator-fixed";
-		regulator-name = "vcc_sys";
+		regulator-name = "vcc_flash";
 		regulator-min-microvolt = <1800000>;
 		regulator-max-microvolt = <1800000>;
 		startup-delay-us = <150>;
-- 
2.20.1



