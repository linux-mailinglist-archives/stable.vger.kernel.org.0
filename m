Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD92E3F6751
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbhHXRcv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:32:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:35606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241830AbhHXRaq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:30:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30B0561B70;
        Tue, 24 Aug 2021 17:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824741;
        bh=6LfsnJwFTfThSeO0bNu9+fIc2tLZYbM6VATVk4uydCw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ij8V/j0gCheu8lJw0cyWroARYooSe7IiL2/LVTS4jfAqVfmWcPHMsD0TrIM96ErMm
         NuloVwCJgYEjLvxpIlKRrvcRppSH65dFQhl6vPiGdcASAqLQ9cG+My1OY7kofr2hHf
         8rTImSHEMGln5mfQzScuJvhOFIiwu/pdaWedFxz1tfQn04o1iJUU4bmHCUF241Vu1h
         hMnADQh9rRkOF2bzYrDQ5Pb6heU8aT3H7L7LdarkZK+typQq63pbRKFy37qmocKbDD
         n8f/oUn+IRJE+nF8JzN3+v8uPm8LmCjrNM1Br73GOr6fqh1fmKIKFAHP6zMLULI4yr
         MPzsKTRmOpNxQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sudeep Holla <sudeep.holla@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 45/64] ARM: dts: nomadik: Fix up interrupt controller node names
Date:   Tue, 24 Aug 2021 13:04:38 -0400
Message-Id: <20210824170457.710623-46-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170457.710623-1-sashal@kernel.org>
References: <20210824170457.710623-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.245-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.245-rc1
X-KernelTest-Deadline: 2021-08-26T17:04+00:00
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
index 733678b75b88..ad3cdf2ca7fb 100644
--- a/arch/arm/boot/dts/ste-nomadik-stn8815.dtsi
+++ b/arch/arm/boot/dts/ste-nomadik-stn8815.dtsi
@@ -756,14 +756,14 @@
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

