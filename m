Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13F402ABB1A
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:28:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733242AbgKINYX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:24:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:46430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733064AbgKINTB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:19:01 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80E262076E;
        Mon,  9 Nov 2020 13:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927941;
        bh=hMDsNTC9oIIbYgMTZk1PmXrosZlYx9+M0PurAwx8uPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jWGprqvesRaOv6MWUQLaYMigAOm5ujCVlQysrphJ4ZIzCuP0B7sjrG6yQSNy8AiTn
         nr44rKXdT39rxUm6auESP+DVsm2WiWE+4vKy2zSKU4VWLKvY8RGVSDHu4eF7qbF+eg
         Sc/3te7AIEqVvEqm6pXLutqoCcbP0CviNcRabQ6s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 074/133] arm64: dts: amlogic: meson-g12: use the G12A specific dwmac compatible
Date:   Mon,  9 Nov 2020 13:55:36 +0100
Message-Id: <20201109125034.292281092@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit 1fdc97ae450ede2b4911d6737a57e6fca63b5f4a ]

We have a dedicated "amlogic,meson-g12a-dwmac" compatible string for the
Ethernet controller since commit 3efdb92426bf4 ("dt-bindings: net:
dwmac-meson: Add a compatible string for G12A onwards").
Using the AXG compatible string worked fine so far because the
dwmac-meson8b driver doesn't handle the newly introduced register bits
for G12A. However, once that changes the driver must be probed with the
correct compatible string to manage these new register bits.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Link: https://lore.kernel.org/r/20200925211743.537496-1-martin.blumenstingl@googlemail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
index 81f490e404ca5..c95ebe6151766 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
@@ -209,7 +209,7 @@
 		};
 
 		ethmac: ethernet@ff3f0000 {
-			compatible = "amlogic,meson-axg-dwmac",
+			compatible = "amlogic,meson-g12a-dwmac",
 				     "snps,dwmac-3.70a",
 				     "snps,dwmac";
 			reg = <0x0 0xff3f0000 0x0 0x10000>,
-- 
2.27.0



