Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D0C12A3920
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 02:23:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726042AbgKCBX0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 20:23:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:35770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728202AbgKCBUn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Nov 2020 20:20:43 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30E9A22450;
        Tue,  3 Nov 2020 01:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604366443;
        bh=E3R4tI/CtnFlwK3YLD6WPm4m2NqFBxzT4gtiBJhbzME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HwB1xVgpMXuWZGAMBekEiY2Nf7eIMPPXimMnijRnZMVxfQolgQC1qNbzNtt5ZDws3
         k2iLu/KNsvEiMUSLkiSLT9nrtMmHWfgAP+jPlrsTdmwzD8aHVOOjOE2gFYIMc7Amcq
         g2JZ5y91ohVfkAGU8aG4t/3muVi8XX8BF7/L6bjo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 02/11] arm64: dts: meson-axg-s400: enable USB OTG
Date:   Mon,  2 Nov 2020 20:20:30 -0500
Message-Id: <20201103012039.183672-2-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201103012039.183672-1-sashal@kernel.org>
References: <20201103012039.183672-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neil Armstrong <narmstrong@baylibre.com>

[ Upstream commit f450d2c219f6a6b79880c97bf910c3c72725eb70 ]

This enables USB OTG on the S400 board.

Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Reviewed-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-axg-s400.dts | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/meson-axg-s400.dts b/arch/arm64/boot/dts/amlogic/meson-axg-s400.dts
index d5c01427a5ca0..acd4dbc1222ae 100644
--- a/arch/arm64/boot/dts/amlogic/meson-axg-s400.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-axg-s400.dts
@@ -334,3 +334,9 @@ &saradc {
 	status = "okay";
 	vref-supply = <&vddio_ao18>;
 };
+
+&usb {
+	status = "okay";
+	dr_mode = "otg";
+	vbus-supply = <&usb_pwr>;
+};
-- 
2.27.0

