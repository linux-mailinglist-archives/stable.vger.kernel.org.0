Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F67B3E80CA
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235798AbhHJRw1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:52:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:43222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237312AbhHJRuW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:50:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08FF26126A;
        Tue, 10 Aug 2021 17:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617353;
        bh=31txEqwTPGPHZrDBtM17rzjaqa5l+sdEscuwlIenaME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VGdP+qOv1bjCmfl5Iq7AOSqdhbkxz/KWyqyCuWZiyVSKpSWHLFxEIGX3m2FKCHqS8
         hig1StnmN+mUxfYjFyRnQ1nTF16544CbKXOKKkDZ0Rz7FcZ74KDZYDzZfXKWK2c5Na
         oyCSGLxeamXmpJaTTQAfLo614+PhZYDpbxCP+BHw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 021/175] arm64: dts: armada-3720-turris-mox: remove mrvl,i2c-fast-mode
Date:   Tue, 10 Aug 2021 19:28:49 +0200
Message-Id: <20210810173001.653424072@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
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
index f2d7d6f071bc..a05b1ab2dd12 100644
--- a/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
+++ b/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
@@ -121,6 +121,7 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&i2c1_pins>;
 	clock-frequency = <100000>;
+	/delete-property/ mrvl,i2c-fast-mode;
 	status = "okay";
 
 	rtc@6f {
-- 
2.30.2



