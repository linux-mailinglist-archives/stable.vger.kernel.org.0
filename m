Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9A442A398A
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 02:26:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727825AbgKCBTh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 20:19:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:33562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727774AbgKCBTg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Nov 2020 20:19:36 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEDD5223AB;
        Tue,  3 Nov 2020 01:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604366375;
        bh=ciz0Hq87QYdXx/TDRlLaRC+TrlVmErU6VQ0NfyW5GK4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qxH9J5a8306iqlm2XFY2fhc2JPG/iNjHJX/E3AN6u2/Yv3F/HgIVqoaiKgRl7eU0i
         uuHimvIsscKcGlfQj+TekvCwnGbD2TgBDLammz9xLu3jVqu6W4twUIrELi7T9VDOjd
         Ago4dU3i78M8XQcUVC0eqxLLTJRC0wbRHoVrTPJo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org
Subject: [PATCH AUTOSEL 5.8 05/29] arm64: dts: amlogic: meson-g12: use the G12A specific dwmac compatible
Date:   Mon,  2 Nov 2020 20:19:04 -0500
Message-Id: <20201103011928.183145-5-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201103011928.183145-1-sashal@kernel.org>
References: <20201103011928.183145-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 6ec40af658ba0..748bcdf5fa285 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
@@ -176,7 +176,7 @@ map {
 		};
 
 		ethmac: ethernet@ff3f0000 {
-			compatible = "amlogic,meson-axg-dwmac",
+			compatible = "amlogic,meson-g12a-dwmac",
 				     "snps,dwmac-3.70a",
 				     "snps,dwmac";
 			reg = <0x0 0xff3f0000 0x0 0x10000>,
-- 
2.27.0

