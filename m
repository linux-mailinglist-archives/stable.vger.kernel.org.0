Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A695C2E64A2
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:53:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404013AbgL1Nlk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:41:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:41474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391697AbgL1NlP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:41:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96D46205CB;
        Mon, 28 Dec 2020 13:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162835;
        bh=c/WdG2kTJ+akFRyNBqEhKOUv6iOMKYx+0kvbT10/V3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xteOciC+n3lctBNuYTYqVXuqi8atq57xZ1+qtwnz/1D9xiNC0UgQ7JbI6tA0t/1to
         CrR8DLL75ar8c7+NVXFWqAB3coZ01kO0vCLjG6/0V3Ezms0YXCDX54jCSVIyEMIa4z
         XMoJSZWpUbcjEpGQ2AOu2eMzqXnUmEsVzBDj6lqI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Biju Das <biju.das.jz@bp.renesas.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 078/453] arm64: dts: renesas: cat875: Remove rxc-skew-ps from ethernet-phy node
Date:   Mon, 28 Dec 2020 13:45:14 +0100
Message-Id: <20201228124940.992747798@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit 53e573dc39fba1834f3e4fa002cb754b61a30701 ]

The CAT875 sub board from Silicon Linux uses Realtek phy and the driver
does not support rxc-skew-ps property.

Fixes: 6b170cd3ed02949f ("arm64: dts: renesas: cat875: Add ethernet support")
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Link: https://lore.kernel.org/r/20201015132350.8360-2-biju.das.jz@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/cat875.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/renesas/cat875.dtsi b/arch/arm64/boot/dts/renesas/cat875.dtsi
index aaefc3ae56d50..dbdb8b093e733 100644
--- a/arch/arm64/boot/dts/renesas/cat875.dtsi
+++ b/arch/arm64/boot/dts/renesas/cat875.dtsi
@@ -22,7 +22,6 @@
 	status = "okay";
 
 	phy0: ethernet-phy@0 {
-		rxc-skew-ps = <1500>;
 		reg = <0>;
 		interrupt-parent = <&gpio2>;
 		interrupts = <21 IRQ_TYPE_LEVEL_LOW>;
-- 
2.27.0



