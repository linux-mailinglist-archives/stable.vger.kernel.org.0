Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE583136F1
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233619AbhBHPRp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:17:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:55768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233346AbhBHPMl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:12:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B45E164EC2;
        Mon,  8 Feb 2021 15:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612796975;
        bh=9CJRp/u3iNzKZ/un4207h+JeV9vcFYtNX1cal+lidSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TmO/Qg6R+MItF17n/1NLLSpkvC90ufH6GePpTLzfVwvYPYna32Vn9msMe6jD8JUls
         gHA5UgDeZ1FKgpfdL7KjFtPNIqR8EZAil4JZjfHQ86z2x3/A7wOdzFICWF4Z8dcxtc
         t0JApGvrFt9BF0PT28xIGrQ14xFPQm3rYIhqlj9I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 06/65] arm64: dts: amlogic: meson-g12: Set FL-adj property value
Date:   Mon,  8 Feb 2021 16:00:38 +0100
Message-Id: <20210208145810.481189521@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145810.230485165@linuxfoundation.org>
References: <20210208145810.230485165@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Serge Semin <Sergey.Semin@baikalelectronics.ru>

[ Upstream commit 7386a559caa6414e74578172c2bc4e636d6bd0a0 ]

In accordance with the DWC USB3 bindings the property is supposed to have
uint32 type. It's erroneous from the DT schema and driver points of view
to declare it as boolean. As Neil suggested set it to 0x20 so not break
the platform and to make the dtbs checker happy.

Link: https://lore.kernel.org/linux-usb/20201010224121.12672-16-Sergey.Semin@baikalelectronics.ru/
Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
Fixes: 9baf7d6be730 ("arm64: dts: meson: g12a: Add G12A USB nodes")
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Link: https://lore.kernel.org/r/20201210091756.18057-3-Sergey.Semin@baikalelectronics.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
index 354ef2f3eac67..9533c85fb0a30 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
@@ -2382,7 +2382,7 @@
 				interrupts = <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>;
 				dr_mode = "host";
 				snps,dis_u2_susphy_quirk;
-				snps,quirk-frame-length-adjustment;
+				snps,quirk-frame-length-adjustment = <0x20>;
 				snps,parkmode-disable-ss-quirk;
 			};
 		};
-- 
2.27.0



