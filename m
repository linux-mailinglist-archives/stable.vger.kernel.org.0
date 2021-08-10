Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B59393E5D8E
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 16:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242976AbhHJOV4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 10:21:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:54544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243430AbhHJOTv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 10:19:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 28AA86112E;
        Tue, 10 Aug 2021 14:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628605025;
        bh=DoMuIADmnDj9EChJTE7OtZlZBw7FURpr+DUtx3a8aJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QQ/xDZ3zYG5BhH6Lq67uQlnmgJte0I/c7Z0Lmja21XvuxOYz/z/9Z9hHnjtznDO3x
         YWNCZbvv201W/N8iCK9pZjhR7tc8C41m4Si4CFerdeGXOOS/0ooq0zjN0HgWRXEegK
         pFqmM/PLJ1dq0TBBzGTYm4V56o+YAgbsjAeYtwwjOVpRKg96hoBJ1sOHA0SlkGSNA5
         0Essk05l8S7DUTCewaBX5Wi//aaMiF0huhn8DYuOqbDfVxwE1icHPWb7McPul+7/Xc
         /O60WPlgIPzWEirmm/qLry21e6dbNby6ycVW0t6Jm/Yu3UeLwOwQNydqger+q2TCRv
         r733Muv+5k9/w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sudeep Holla <sudeep.holla@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 7/8] ARM: dts: nomadik: Fix up interrupt controller node names
Date:   Tue, 10 Aug 2021 10:16:54 -0400
Message-Id: <20210810141655.3118498-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210810141655.3118498-1-sashal@kernel.org>
References: <20210810141655.3118498-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit 47091f473b364c98207c4def197a0ae386fc9af1 ]

Once the new schema interrupt-controller/arm,vic.yaml is added, we get
the below warnings:

	arch/arm/boot/dts/ste-nomadik-nhk15.dt.yaml:
	intc@10140000: $nodename:0: 'intc@10140000' does not match
	'^interrupt-controller(@[0-9a-f,]+)*$'

Fix the node names for the interrupt controller to conform
to the standard node name interrupt-controller@..

Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20210617210825.3064367-2-sudeep.holla@arm.com
Link: https://lore.kernel.org/r/20210626000103.830184-1-linus.walleij@linaro.org'
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/ste-nomadik-stn8815.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/ste-nomadik-stn8815.dtsi b/arch/arm/boot/dts/ste-nomadik-stn8815.dtsi
index 1077ceebb2d6..87494773f409 100644
--- a/arch/arm/boot/dts/ste-nomadik-stn8815.dtsi
+++ b/arch/arm/boot/dts/ste-nomadik-stn8815.dtsi
@@ -755,14 +755,14 @@ clcd@10120000 {
 			status = "disabled";
 		};
 
-		vica: intc@10140000 {
+		vica: interrupt-controller@10140000 {
 			compatible = "arm,versatile-vic";
 			interrupt-controller;
 			#interrupt-cells = <1>;
 			reg = <0x10140000 0x20>;
 		};
 
-		vicb: intc@10140020 {
+		vicb: interrupt-controller@10140020 {
 			compatible = "arm,versatile-vic";
 			interrupt-controller;
 			#interrupt-cells = <1>;
-- 
2.30.2

