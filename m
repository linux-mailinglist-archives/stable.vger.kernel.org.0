Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73DC143A1D2
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236232AbhJYTml (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:42:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:57940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237274AbhJYTkg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:40:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9237961175;
        Mon, 25 Oct 2021 19:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190561;
        bh=aVFKg7oukX3E00uSNcU7A9NRtC8TcVyuxoJxIZPT8XE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ybnrgK2Kjw6nsGn1UjscJ21Dxo4C0eNo29Eq4KvjXSVmPwuRNMezodkWbMAHxdfPP
         BVeZsKapIlCnVxT/TaQ8FPrkVNvyU8iPINptRetRUw4rpNmw8BbFV51jFut8zoUjjU
         CjkOb3hFBjjrJskoWqcd419FrAt440TDfSPIegDM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 004/169] arm: dts: vexpress-v2p-ca9: Fix the SMB unit-address
Date:   Mon, 25 Oct 2021 21:13:05 +0200
Message-Id: <20211025191018.299018408@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Herring <robh@kernel.org>

[ Upstream commit 2e9edc07df2ec6f835222151fa4e536e9e54856a ]

Based on 'ranges', the 'bus@4000000' node unit-address is off by 1 '0'.

Link: https://lore.kernel.org/r/20210819184239.1192395-5-robh@kernel.org
Cc: Andre Przywara <andre.przywara@arm.com>
Cc: Sudeep Holla <sudeep.holla@arm.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/vexpress-v2m.dtsi    | 2 +-
 arch/arm/boot/dts/vexpress-v2p-ca9.dts | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/vexpress-v2m.dtsi b/arch/arm/boot/dts/vexpress-v2m.dtsi
index ec13ceb9ed36..79ba83d1f620 100644
--- a/arch/arm/boot/dts/vexpress-v2m.dtsi
+++ b/arch/arm/boot/dts/vexpress-v2m.dtsi
@@ -19,7 +19,7 @@
  */
 
 / {
-	bus@4000000 {
+	bus@40000000 {
 		motherboard {
 			model = "V2M-P1";
 			arm,hbi = <0x190>;
diff --git a/arch/arm/boot/dts/vexpress-v2p-ca9.dts b/arch/arm/boot/dts/vexpress-v2p-ca9.dts
index 4c5847955856..1317f0f58d53 100644
--- a/arch/arm/boot/dts/vexpress-v2p-ca9.dts
+++ b/arch/arm/boot/dts/vexpress-v2p-ca9.dts
@@ -295,7 +295,7 @@
 		};
 	};
 
-	smb: bus@4000000 {
+	smb: bus@40000000 {
 		compatible = "simple-bus";
 
 		#address-cells = <2>;
-- 
2.33.0



