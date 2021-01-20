Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 131A52FC7E4
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 03:29:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731872AbhATC31 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 21:29:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:46620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730033AbhATB2c (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 20:28:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A062A221E3;
        Wed, 20 Jan 2021 01:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611106002;
        bh=n/YQAIYwiELBpI4MLk7xVoyV9zbAg1IonRd9oORZrvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qc0IfQqs3HT++mnVGnJ6PCqhc771tQzJJ2+3VsMzQ+TogomwxaXP2RpMCO/Ghhow+
         FVWYthi3oyqzQSP4aBxW99PEiqiVASMPX4w1UBYGIpA/38g9EGf/kIE/4Bjvb9RyDp
         UeGoLhs/UPOJAQSUPbQLa7rqcN+C+nkm9ilClLvhAQJFDVx4qpzjbVc/BrPLD0BISJ
         BLDqW7ekkmU1EYDWTqOt9qh2CYiXG18HrKVaPI8mvEv/fcNJ4W8shzXVUazGeZD5M9
         R9hwJbZq1lojk1LXknAUw2htgdA3ANsBmM7caDejgx3VJlpDTLMAdXscvvYinFMrki
         pcH5geZfm9MBw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sagar Shrikant Kadam <sagar.kadam@sifive.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 30/45] dts: phy: add GPIO number and active state used for phy reset
Date:   Tue, 19 Jan 2021 20:25:47 -0500
Message-Id: <20210120012602.769683-30-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210120012602.769683-1-sashal@kernel.org>
References: <20210120012602.769683-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 60846e88ae4b1..24d75a146e02d 100644
--- a/arch/riscv/boot/dts/sifive/hifive-unleashed-a00.dts
+++ b/arch/riscv/boot/dts/sifive/hifive-unleashed-a00.dts
@@ -90,6 +90,7 @@ &eth0 {
 	phy0: ethernet-phy@0 {
 		compatible = "ethernet-phy-id0007.0771";
 		reg = <0>;
+		reset-gpios = <&gpio 12 GPIO_ACTIVE_LOW>;
 	};
 };
 
-- 
2.27.0

