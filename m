Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 945FF2FC805
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 03:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730346AbhATCbM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 21:31:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:46600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730384AbhATB3G (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 20:29:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B1BF23407;
        Wed, 20 Jan 2021 01:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611106049;
        bh=1rfwSpVJ+UEYl/EIDIKbdLpUVSO+QYuuMjMAelssO6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kWPthReLQzMzIsihOhaLz5wqAHkmhGRtfz175sBHeNZFMNA4OoLm02Mi3UjsYea52
         UEN049sSnfokfsnnzzJBlGj1Eb0T6pgzrcYrhvKsY5tiEXi5cEidizOlt2olikwRK5
         pYTf7GNnXxJyaPBB262mZYxaY3S06FNHqjNZUyMXu6frTEW7xMrKfRW7TBzuDy9M12
         +hg69LhksLCY26Exw07tbfkpmMJp6NztRtvBIlhDpBbyqZMtzlubarQTmAb5RB6hsZ
         lCgxyl0V/YgbqTseLMowARFe/Q0mPkhJK/vrbYp1AnToNqBI3e43U35pp9cmf3QoqX
         rmsbPFuehBktA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sagar Shrikant Kadam <sagar.kadam@sifive.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 18/26] dts: phy: add GPIO number and active state used for phy reset
Date:   Tue, 19 Jan 2021 20:26:55 -0500
Message-Id: <20210120012704.770095-18-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210120012704.770095-1-sashal@kernel.org>
References: <20210120012704.770095-1-sashal@kernel.org>
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
index cc04e66752aac..1ad3dc2fb6343 100644
--- a/arch/riscv/boot/dts/sifive/hifive-unleashed-a00.dts
+++ b/arch/riscv/boot/dts/sifive/hifive-unleashed-a00.dts
@@ -85,6 +85,7 @@ &eth0 {
 	phy0: ethernet-phy@0 {
 		compatible = "ethernet-phy-id0007.0771";
 		reg = <0>;
+		reset-gpios = <&gpio 12 GPIO_ACTIVE_LOW>;
 	};
 };
 
-- 
2.27.0

