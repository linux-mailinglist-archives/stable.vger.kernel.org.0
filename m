Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA8503F6690
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240353AbhHXRZY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:25:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:58934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240004AbhHXRXc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:23:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FE0361B21;
        Tue, 24 Aug 2021 17:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824626;
        bh=MxG2oS952SQGKC1PU9fh6RUobnh4+ri9zpyh4Ng2q/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VAOeeoNOZT0SynSt6bL6qMc41Rjc1jg4YTpDMhMj1yzdxl6Mh8UYGWzn7hFEy8iug
         JYc8wbNq2NJ5UWHDeve+w80rrcuTpFcZKDBXed/XVZBmC/ZjQo4tGTeTQvaeDEUOnQ
         fYzqoAHgh/7/Wtwh7SvpXcpvGCfDDqbUGmX7UoFAaa4H7GqWX51xY/HRCYvehV7mNg
         eRxYRu4+ABEWOJiCk+xsOfFo6d5YdUy39PalUlDLXXG9vcnmz+DpzNv4usDfZ122CD
         D6RxehLStZtFv71K0sBtDqyTg38D894dcUlsq0AtknGFXI/9JzQJCpBnz5Sk9jQgU6
         gIeuG2QvXOArQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sudeep Holla <sudeep.holla@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 57/84] ARM: dts: nomadik: Fix up interrupt controller node names
Date:   Tue, 24 Aug 2021 13:02:23 -0400
Message-Id: <20210824170250.710392-58-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170250.710392-1-sashal@kernel.org>
References: <20210824170250.710392-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.205-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.205-rc1
X-KernelTest-Deadline: 2021-08-26T17:02+00:00
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
index fca76a696d9d..9ba4d1630ca3 100644
--- a/arch/arm/boot/dts/ste-nomadik-stn8815.dtsi
+++ b/arch/arm/boot/dts/ste-nomadik-stn8815.dtsi
@@ -755,14 +755,14 @@
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

