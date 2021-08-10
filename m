Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78BBF3E7F5E
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233845AbhHJRkN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:40:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:59726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235309AbhHJRja (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:39:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43BA861158;
        Tue, 10 Aug 2021 17:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617029;
        bh=cYh35sPKtNf/rjuk2SmiDsgZg/S0Q5uA9gnr0wKlDjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w2lNFHlIb+WZfqJoJ5Gds2vfuE3zrWh+kZh0thzc/SE7Z6+V8hueJtliiLZ8VMM9T
         WqH9O1RMwpTtCesm2H2aQiYfxPQecMMtR/rOnNv0nqpkIBIiNc2sPwu/C0We+jRojW
         J+WyqVzx8mb1l58s1weUpcB3+xrP6hacs7cxnEvg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 014/135] arm64: dts: armada-3720-turris-mox: remove mrvl,i2c-fast-mode
Date:   Tue, 10 Aug 2021 19:29:08 +0200
Message-Id: <20210810172956.160656020@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
References: <20210810172955.660225700@linuxfoundation.org>
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
index 2d51c6f3915d..bbd34ae12a53 100644
--- a/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
+++ b/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
@@ -120,6 +120,7 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&i2c1_pins>;
 	clock-frequency = <100000>;
+	/delete-property/ mrvl,i2c-fast-mode;
 	status = "okay";
 
 	rtc@6f {
-- 
2.30.2



