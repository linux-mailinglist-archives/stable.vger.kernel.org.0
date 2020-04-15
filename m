Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39E681A9D20
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 13:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408987AbgDOLnQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 07:43:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:35036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408978AbgDOLnO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:43:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3EBDD21582;
        Wed, 15 Apr 2020 11:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586950994;
        bh=Mc1pIuQsFh+DB+kAcRNt4P2NwE+ll1nbXbIDWqB5Y6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pm9dSKrB7jcGwpIPcOmyY2mHLprxEHp7SgENhdiGFuKRNgbQLAvFE4+t3QXuzf3t9
         sy8M4m1o3tRu58uqhJmuzO6LqgCxmLkPnF4Dzo4VaEX2fZjoeKaj2YXI4Jkk1lkNgL
         UDw9n7zzAjSWMK2wJCob6vmRfm4wOyEuyjBanzIA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alex Smith <alex.smith@imgtec.com>,
        "H . Nikolaus Schaller" <hns@goldelico.com>,
        Paul Cercueil <paul@crapouillou.net>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 040/106] MIPS: DTS: CI20: add DT node for IR sensor
Date:   Wed, 15 Apr 2020 07:41:20 -0400
Message-Id: <20200415114226.13103-40-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114226.13103-1-sashal@kernel.org>
References: <20200415114226.13103-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Smith <alex.smith@imgtec.com>

[ Upstream commit f5e8fcf85a25bac26c32a0000dbab5857ead9113 ]

The infrared sensor on the CI20 board is connected to a GPIO and can
be operated by using the gpio-ir-recv driver. Add a DT node for the
sensor to allow that driver to be used.

Signed-off-by: Alex Smith <alex.smith@imgtec.com>
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Reviewed-by: Paul Cercueil <paul@crapouillou.net>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/boot/dts/ingenic/ci20.dts | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/mips/boot/dts/ingenic/ci20.dts b/arch/mips/boot/dts/ingenic/ci20.dts
index c340f947baa03..fc4e64200c3d5 100644
--- a/arch/mips/boot/dts/ingenic/ci20.dts
+++ b/arch/mips/boot/dts/ingenic/ci20.dts
@@ -62,6 +62,11 @@
 		enable-active-high;
 	};
 
+	ir: ir {
+		compatible = "gpio-ir-receiver";
+		gpios = <&gpe 3 GPIO_ACTIVE_LOW>;
+	};
+
 	wlan0_power: fixedregulator@1 {
 		compatible = "regulator-fixed";
 		regulator-name = "wlan0_power";
-- 
2.20.1

