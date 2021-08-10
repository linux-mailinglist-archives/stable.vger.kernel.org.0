Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D99BA3E7EA5
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232447AbhHJRei (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:34:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:36356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232134AbhHJReK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:34:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9418A610E9;
        Tue, 10 Aug 2021 17:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628616828;
        bh=BxyRilvOsNR5B8yCmk3oOd0Miex7++8DTbSL15v8jIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hMshoGpGv0Y2fiAzDMg4UX4Ja8PGvWp2QGxtNH4ODOBD/MG+zp3fNL/oAHQ3+LMeB
         I1i7gnH4zffczNshODh2lBA3otXo6cgLsebdq0a4iWKOAQdNeshv6aH5wsP7CuV6Ux
         Hq8+BALFkbgHfTO03/j5bEI4jzjSmMO3H5m23N+U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 10/85] arm64: dts: armada-3720-turris-mox: remove mrvl,i2c-fast-mode
Date:   Tue, 10 Aug 2021 19:29:43 +0200
Message-Id: <20210810172948.555441367@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172948.192298392@linuxfoundation.org>
References: <20210810172948.192298392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

[ Upstream commit ee7ab3f263f8131722cff3871b9618b1e7478f07 ]

Some SFP modules are not detected when i2c-fast-mode is enabled even when
clock-frequency is already set to 100000. The I2C bus violates the timing
specifications when run in fast mode. So disable fast mode on Turris Mox.

Same change was already applied for uDPU (also Armada 3720 board with SFP)
in commit fe3ec631a77d ("arm64: dts: uDPU: remove i2c-fast-mode").

Fixes: 7109d817db2e ("arm64: dts: marvell: add DTS for Turris Mox")
Signed-off-by: Pali Rohár <pali@kernel.org>
Reviewed-by: Marek Behún <kabel@kernel.org>
Acked-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts b/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
index 874bc3954c8e..025e02d23da9 100644
--- a/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
+++ b/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
@@ -118,6 +118,7 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&i2c1_pins>;
 	clock-frequency = <100000>;
+	/delete-property/ mrvl,i2c-fast-mode;
 	status = "okay";
 
 	rtc@6f {
-- 
2.30.2



