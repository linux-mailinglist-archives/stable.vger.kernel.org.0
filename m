Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E744344B55D
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:17:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245383AbhKIWUf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:20:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:40432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245437AbhKIWT5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:19:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1AFCB61038;
        Tue,  9 Nov 2021 22:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496231;
        bh=NG62fGXEuGcBhXpyle96CLm80C3YfEagyN/tl5HDwLk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GzifxJutSRT5ciZQDqVNdFD5E07B+biuyl4pOrH3RmLmq+XIyvA2Z4eLRjHHwLhpC
         AyHbKH3OzRTql53nFj18mwwQLavtLbDTxt7YS6ogvRkalBc5KUF5YDHLBnl6X4V8r1
         pjTn5dReB2dkloqiEXuSpl2A9YHiSlof7+jXlJcqvR/bQQpHLBBD/E3op6BilZooib
         tza4Lz1RrTmd+/B9j0XgT7DkmSLCJWPcrym9p9L3VYuYbu2LxAjVe0m35rBUrDn8TN
         6i7IegAxNshy0CnZQzR8G7SzW+oqU+m6/pOziZ00xYJK4CGiFp4DwTGL6CJEHC+G0G
         maqSU51Vseayw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        catalin.marinas@arm.com, will.deacon@arm.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 11/82] arm64: dts: broadcom: bcm4908: Move reboot syscon out of bus
Date:   Tue,  9 Nov 2021 17:15:29 -0500
Message-Id: <20211109221641.1233217-11-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221641.1233217-1-sashal@kernel.org>
References: <20211109221641.1233217-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit 6cf9f70255b90b540b9cbde062f18fea29024a75 ]

This fixes following error for every bcm4908 DTS file:
bus@ff800000: reboot: {'type': 'object'} is not allowed for {'compatible': ['syscon-reboot'], 'regmap': [[15]], 'offset': [[52]], 'mask': [[1]]}

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi b/arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi
index a5a64d17d9ea6..4736416317531 100644
--- a/arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi
+++ b/arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi
@@ -326,12 +326,12 @@
 				#reset-cells = <1>;
 			};
 		};
+	};
 
-		reboot {
-			compatible = "syscon-reboot";
-			regmap = <&timer>;
-			offset = <0x34>;
-			mask = <1>;
-		};
+	reboot {
+		compatible = "syscon-reboot";
+		regmap = <&timer>;
+		offset = <0x34>;
+		mask = <1>;
 	};
 };
-- 
2.33.0

