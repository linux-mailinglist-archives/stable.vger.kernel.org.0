Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CDE63E80D4
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236515AbhHJRw7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:52:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:44064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235319AbhHJRu4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:50:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BCD86127C;
        Tue, 10 Aug 2021 17:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617378;
        bh=47z18lZHVJx6cN21SmFq96wIvNVv0oSuxjzDMUTqTGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=noYfsidRVHyl9fB+b3X9QVFTgPWs4OHrzxkRjcogYUd33wyxxbYmCV1NFVaCLJEM6
         QnSYvjHEs0MDyiLJDx5UCQlHXRx0BhQCAYF466vL87QeaH8dZCRhRjNs5BtxObwrRN
         blAZLkouZcnOmJKf+qgiBOnFChXrvel8pFqAHcxw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dario Binacchi <dariobin@libero.it>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 025/175] ARM: dts: am437x-l4: fix typo in can@0 node
Date:   Tue, 10 Aug 2021 19:28:53 +0200
Message-Id: <20210810173001.780866798@linuxfoundation.org>
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

From: Dario Binacchi <dariobin@libero.it>

[ Upstream commit 0162a9964365fd26e34575e121b17d021204c481 ]

Replace clock-name with clock-names.

Fixes: 2a4117df9b43 ("ARM: dts: Fix dcan driver probe failed on am437x platform")
Signed-off-by: Dario Binacchi <dariobin@libero.it>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/am437x-l4.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/am437x-l4.dtsi b/arch/arm/boot/dts/am437x-l4.dtsi
index a6f19ae7d3e6..f73ecec1995a 100644
--- a/arch/arm/boot/dts/am437x-l4.dtsi
+++ b/arch/arm/boot/dts/am437x-l4.dtsi
@@ -1595,7 +1595,7 @@
 				compatible = "ti,am4372-d_can", "ti,am3352-d_can";
 				reg = <0x0 0x2000>;
 				clocks = <&dcan1_fck>;
-				clock-name = "fck";
+				clock-names = "fck";
 				syscon-raminit = <&scm_conf 0x644 1>;
 				interrupts = <GIC_SPI 49 IRQ_TYPE_LEVEL_HIGH>;
 				status = "disabled";
-- 
2.30.2



