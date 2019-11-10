Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3DFBF65FC
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:11:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728150AbfKJDK1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 22:10:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:42924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727290AbfKJCoC (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:44:02 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B02521655;
        Sun, 10 Nov 2019 02:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353842;
        bh=CGJbKln3Rkg2sxB7qY0MAuLx3+hEzsvt48vMiraYkKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NkkOtPuh3D9aHujc6Y70hHLwYQm9ujsLtTRrTR44dj0Bq5Iyo3wgIlDxh/aLFGTMH
         Lx2Rcj4WKJRq0Qhs+BhAkphEyIzNkbcgVurYq8Rwbg9Ov8BHXKMtMGS9NXt2mCHEAM
         ZRvN74fPrmZIxTqSvLcJNODB7F34LMgJJtjcbEEU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-amlogic@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 130/191] ARM: dts: meson8b: odroidc1: enable the SAR ADC
Date:   Sat,  9 Nov 2019 21:39:12 -0500
Message-Id: <20191110024013.29782-130-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit fd6643142a0c5ab4d423ed7173a0be414d509214 ]

Odroid-C1 exposes ADC channels 0 and 1 on the GPIO headers. NOTE: Due
to the SoC design these are limited to 1.8V (instead of 3.3V like all
other pins).
Enable the SAR ADC to enable voltage measurements on these pins.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/meson8b-odroidc1.dts | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/meson8b-odroidc1.dts b/arch/arm/boot/dts/meson8b-odroidc1.dts
index 8fdeeffecbdbc..8a09071d712a5 100644
--- a/arch/arm/boot/dts/meson8b-odroidc1.dts
+++ b/arch/arm/boot/dts/meson8b-odroidc1.dts
@@ -153,6 +153,11 @@
 	pinctrl-names = "default";
 };
 
+&saradc {
+	status = "okay";
+	vref-supply = <&vcc_1v8>;
+};
+
 &sdio {
 	status = "okay";
 
-- 
2.20.1

