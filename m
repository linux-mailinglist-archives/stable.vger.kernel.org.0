Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C14BE304B48
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 22:28:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727887AbhAZErw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:47:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:33074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729496AbhAYSpC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:45:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C237D2075B;
        Mon, 25 Jan 2021 18:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600260;
        bh=FZeHRRpq2jb/QFG27LiqiMl1POAZR8SWz0oyWV8jZuo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C5hcvwm0EzUhnPMcgxhH6raQBk+Ok5EDljh1451MApowrBqOR8qxew7X0ZSRY65pH
         yYIgc4PV5ZS3ccEVVdDzHvr97mzNKo6MtEx38ovdd61gelk7VoniMnsRRRnoDnCX5Y
         rAPHokcNaIfMc/86khEyuh0vanwnPBblRrWKM33U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sagar Shrikant Kadam <sagar.kadam@sifive.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 33/86] dts: phy: add GPIO number and active state used for phy reset
Date:   Mon, 25 Jan 2021 19:39:15 +0100
Message-Id: <20210125183202.461972197@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183201.024962206@linuxfoundation.org>
References: <20210125183201.024962206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagar Shrikant Kadam <sagar.kadam@sifive.com>

[ Upstream commit a0fa9d727043da2238432471e85de0bdb8a8df65 ]

The GEMGXL_RST line on HiFive Unleashed is pulled low and is
using GPIO number 12. Add these reset-gpio details to dt-node
using which the linux phylib can reset the phy.

Signed-off-by: Sagar Shrikant Kadam <sagar.kadam@sifive.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/boot/dts/sifive/hifive-unleashed-a00.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/boot/dts/sifive/hifive-unleashed-a00.dts b/arch/riscv/boot/dts/sifive/hifive-unleashed-a00.dts
index cc04e66752aac..1ad3dc2fb6343 100644
--- a/arch/riscv/boot/dts/sifive/hifive-unleashed-a00.dts
+++ b/arch/riscv/boot/dts/sifive/hifive-unleashed-a00.dts
@@ -85,6 +85,7 @@
 	phy0: ethernet-phy@0 {
 		compatible = "ethernet-phy-id0007.0771";
 		reg = <0>;
+		reset-gpios = <&gpio 12 GPIO_ACTIVE_LOW>;
 	};
 };
 
-- 
2.27.0



