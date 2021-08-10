Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8FA3E7F4E
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233404AbhHJRjt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:39:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:43990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233181AbhHJRgW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:36:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA86F6109F;
        Tue, 10 Aug 2021 17:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628616935;
        bh=kJII+BTvgoabosld0sLl6LVO1SO39AXY3X5GZVGUmkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZHRdevngCOTVkQUpCBjY+ieXcmRy5wTk3Jh6pPbNnIlbh0j8e5pTuWXd58Gzl15bK
         TkGeIR/WaSux5IhV0nOREunHEsHTeTHYONJMvj9ZMoVVz4tQh7OFykLWV8AKyQG9l6
         r5oXMKpcAdfp+FBiPAFdMi6oEWfS+42JkvS3r9Nw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dario Binacchi <dariobin@libero.it>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 13/85] ARM: dts: am437x-l4: fix typo in can@0 node
Date:   Tue, 10 Aug 2021 19:29:46 +0200
Message-Id: <20210810172948.659452595@linuxfoundation.org>
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
index 6c2949991e29..64fdd5079d49 100644
--- a/arch/arm/boot/dts/am437x-l4.dtsi
+++ b/arch/arm/boot/dts/am437x-l4.dtsi
@@ -1611,7 +1611,7 @@
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



