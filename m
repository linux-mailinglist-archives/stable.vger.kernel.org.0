Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3AC43A0FE
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235546AbhJYTg5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:36:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:48092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234626AbhJYTbw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:31:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F89B61106;
        Mon, 25 Oct 2021 19:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190091;
        bh=1PWDdXOYgPQxFcs9sYBfKiqlEMzfxUNWi0HZXt5Al5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nPn2E5Hrp9QYrlY96u8RBLWr5o9RA3gGzLajMq0D8G6vJ1gNYfuGCPPunbKkazWAm
         3/PG6P0aip8inUIfoIeJ7gX5AP8QqUerXPkO/+BELaWElsXV7ojzmqCddlmY5awV10
         NyyvbgX6Zt336zSYTWU6V2RInLmvYSEwLcMy/0nA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Herve Codina <herve.codina@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 48/58] ARM: dts: spear3xx: Fix gmac node
Date:   Mon, 25 Oct 2021 21:15:05 +0200
Message-Id: <20211025190945.750507586@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190937.555108060@linuxfoundation.org>
References: <20211025190937.555108060@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herve Codina <herve.codina@bootlin.com>

[ Upstream commit 6636fec29cdf6665bd219564609e8651f6ddc142 ]

On SPEAr3xx, ethernet driver is not compatible with the SPEAr600
one.
Indeed, SPEAr3xx uses an earlier version of this IP (v3.40) and
needs some driver tuning compare to SPEAr600.

The v3.40 IP support was added to stmmac driver and this patch
fixes this issue and use the correct compatible string for
SPEAr3xx

Signed-off-by: Herve Codina <herve.codina@bootlin.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/spear3xx.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/spear3xx.dtsi b/arch/arm/boot/dts/spear3xx.dtsi
index f266b7b03482..cc88ebe7a60c 100644
--- a/arch/arm/boot/dts/spear3xx.dtsi
+++ b/arch/arm/boot/dts/spear3xx.dtsi
@@ -47,7 +47,7 @@
 		};
 
 		gmac: eth@e0800000 {
-			compatible = "st,spear600-gmac";
+			compatible = "snps,dwmac-3.40a";
 			reg = <0xe0800000 0x8000>;
 			interrupts = <23 22>;
 			interrupt-names = "macirq", "eth_wake_irq";
-- 
2.33.0



