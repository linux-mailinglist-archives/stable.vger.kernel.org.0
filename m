Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30DDE11B58B
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:54:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731734AbfLKPRr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:17:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:45272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731750AbfLKPRp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:17:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA5292073D;
        Wed, 11 Dec 2019 15:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077465;
        bh=chhKnhH3TcSVULMYiT+GuATWGnv7PSV2XKK/DJt046U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bs0Sp0gdS4VN3hNcdXzvMr79r8d3OQP8RplS3JdgtGkxHphVjPN98z7VwcbJ5N3Di
         7mA9rTQYqQuRRABp+h/LMLknsB/PRiOHhOk7K36snlzeSCEcAKDRGshGDko+7VgPml
         jS7Z3BANxS9mBW6yQzb5xW8KwsI2tslA7EJ4hOFM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Keeping <john@metanate.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 049/243] ARM: dts: rockchip: Fix rk3288-rock2 vcc_flash name
Date:   Wed, 11 Dec 2019 16:03:31 +0100
Message-Id: <20191211150342.410180326@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
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
index 50325489c0ced..32e1ab3366629 100644
--- a/arch/arm/boot/dts/rk3288-rock2-som.dtsi
+++ b/arch/arm/boot/dts/rk3288-rock2-som.dtsi
@@ -25,7 +25,7 @@
 
 	vcc_flash: flash-regulator {
 		compatible = "regulator-fixed";
-		regulator-name = "vcc_sys";
+		regulator-name = "vcc_flash";
 		regulator-min-microvolt = <1800000>;
 		regulator-max-microvolt = <1800000>;
 		startup-delay-us = <150>;
-- 
2.20.1



