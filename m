Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB6B13F860
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731048AbgAPQzI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:55:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:40070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730682AbgAPQzH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:55:07 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5175824656;
        Thu, 16 Jan 2020 16:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193707;
        bh=MjlK7QQIMLtiwZMtfGCJVeq9TdAvUUqsvkIw//F19u4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t3M2P9jzaa7mcugPnfOPRFF9X8/u49Ud+/aiXknYZw7HKRJLJ4Ubrooxt1ae1U7zX
         kgFPpNwxY4BN/6py4PNSBFXxHLfsZq+WXSRnK8ClU77BiG4fAlgcBj3kRmvvALmKuV
         XVMIxe6TDo72wJxE4wGRZJTvexy2R+i9O2cxL7+A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Rosin <peda@axentia.se>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 003/671] ARM: dts: at91: nattis: make the SD-card slot work
Date:   Thu, 16 Jan 2020 11:43:54 -0500
Message-Id: <20200116165502.8838-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165502.8838-1-sashal@kernel.org>
References: <20200116165502.8838-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Rosin <peda@axentia.se>

[ Upstream commit f52eb2067929d533babe106fbc131c88db3eff3d ]

The cd-gpios signal is assumed active-low by the driver, and the
cd-inverted property is needed if it is, in fact, active-high. Fix
this oversight.

Fixes: 0e4323899973 ("ARM: dts: at91: add devicetree for the Axentia Nattis with Natte power")
Signed-off-by: Peter Rosin <peda@axentia.se>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/at91-nattis-2-natte-2.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/at91-nattis-2-natte-2.dts b/arch/arm/boot/dts/at91-nattis-2-natte-2.dts
index bfa5815a0721..4308a07b792e 100644
--- a/arch/arm/boot/dts/at91-nattis-2-natte-2.dts
+++ b/arch/arm/boot/dts/at91-nattis-2-natte-2.dts
@@ -221,6 +221,7 @@
 		reg = <0>;
 		bus-width = <4>;
 		cd-gpios = <&pioD 5 GPIO_ACTIVE_HIGH>;
+		cd-inverted;
 	};
 };
 
-- 
2.20.1

