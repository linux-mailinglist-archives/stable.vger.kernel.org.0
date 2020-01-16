Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDE1813F7ED
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733143AbgAPQ4B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:56:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:41928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730591AbgAPQ4A (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:56:00 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E47024686;
        Thu, 16 Jan 2020 16:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193760;
        bh=XoiEwqxvpeLhk9E4C1EKhmXW0UDLXNfpdqqjLrAjmdE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ejLHpXwp46YTrKpYv/kYM6YxKZ2l725kFcD6gJMLEba3p2P4FK7dJBZzpCCr0gVN9
         pf4o+uv6MnCERgAEeJqPBuqGzy6tRAkE/K/mPvw3y71LjgHElAKgROMwEs4RP5m8Ln
         ObGPGHVwXWrjK+djzAHqjK7531B9rQRSixPw+XEk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Phil Elwell <phil@raspberrypi.org>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 047/671] ARM: dts: bcm283x: Correct mailbox register sizes
Date:   Thu, 16 Jan 2020 11:44:38 -0500
Message-Id: <20200116165502.8838-47-sashal@kernel.org>
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

From: Phil Elwell <phil@raspberrypi.org>

[ Upstream commit 227fa865061470a568858baa404a508f6c030fe4 ]

The size field in a Device Tree "reg" property is encoded in bytes, not
words.

Fixes: 614fa22119d6 ("ARM: dts: bcm2835: Add VCHIQ node to the Raspberry Pi boards. (v3)")
Signed-off-by: Phil Elwell <phil@raspberrypi.org>
Acked-by: Stefan Wahren <stefan.wahren@i2se.com>
Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm2835-rpi.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/bcm2835-rpi.dtsi b/arch/arm/boot/dts/bcm2835-rpi.dtsi
index cb2d6d78a7fb..c481eab1bd7c 100644
--- a/arch/arm/boot/dts/bcm2835-rpi.dtsi
+++ b/arch/arm/boot/dts/bcm2835-rpi.dtsi
@@ -32,7 +32,7 @@
 
 		mailbox@7e00b840 {
 			compatible = "brcm,bcm2835-vchiq";
-			reg = <0x7e00b840 0xf>;
+			reg = <0x7e00b840 0x3c>;
 			interrupts = <0 2>;
 		};
 	};
-- 
2.20.1

