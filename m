Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9562A3992
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 02:26:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728321AbgKCB0U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 20:26:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:33520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727703AbgKCBTd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Nov 2020 20:19:33 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A7A222264;
        Tue,  3 Nov 2020 01:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604366373;
        bh=LWj5Z+oKaXUyiTpdDOhnH8soHvKHloBKTMnykHfkm+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XRlj3078NhLbYnslif6p56JtV9a1UTbZsWXRZkwBF3qHDLbIYIbVfkVWzbR5biA6v
         rm/LBbWgOD1ZsJBDun43/lYLvtVeEkMKvh+r+7RtdFNmLyM0d+OZqd/wrUcvYEljHH
         xfpZ21bo/ua5aXuminUFDpeoA0lQdOKPC1OziCkA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org
Subject: [PATCH AUTOSEL 5.8 03/29] arm64: dts: meson-axg-s400: enable USB OTG
Date:   Mon,  2 Nov 2020 20:19:02 -0500
Message-Id: <20201103011928.183145-3-sashal@kernel.org>
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
index cb1360ae1211e..7740f97c240f0 100644
--- a/arch/arm64/boot/dts/amlogic/meson-axg-s400.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-axg-s400.dts
@@ -584,3 +584,9 @@ &uart_AO {
 	pinctrl-0 = <&uart_ao_a_pins>;
 	pinctrl-names = "default";
 };
+
+&usb {
+	status = "okay";
+	dr_mode = "otg";
+	vbus-supply = <&usb_pwr>;
+};
-- 
2.27.0

