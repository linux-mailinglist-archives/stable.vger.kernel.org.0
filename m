Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD51844B5D6
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236033AbhKIWXs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:23:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:40916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343940AbhKIWWB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:22:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27FC6613B3;
        Tue,  9 Nov 2021 22:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496298;
        bh=yRU2nC94K7wNrUtgKiFvZusWJJCgd3iynH7iUVZAMW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IfuzkhP4jwBc9fM4hSApgywrCY0Yctz8lxuhOqOpqSIaTaqGXaRdPcyhlT4QwD0FD
         a6KXns0druWYYQ3WjixvGMb+Y9L5j4S44HJdC8K7Z1fCBa04hfyYyTmphBBYnPMN+w
         XYnVPkaq9IfmzId37eW6TiQCLah89y5bOe+k/b8bABpHdwX9M8Vi/O9WQR7h2OIRXs
         s/2UvTjHFDIneeMGKK1F6z89wO/eiQN+7vZiRS5tbnekWWKmo278Cha7rKTozn6Ptj
         43yk0biOxpe51tGZNM6QvFuZnvvg2epiajOuibwLWLxFYihF4JbcyKIvkFcyWEPH8V
         Fa0xaSzyBE8Jw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Roger Quadros <rogerq@kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, bcousson@baylibre.com,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 53/82] ARM: dts: omap: fix gpmc,mux-add-data type
Date:   Tue,  9 Nov 2021 17:16:11 -0500
Message-Id: <20211109221641.1233217-53-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221641.1233217-1-sashal@kernel.org>
References: <20211109221641.1233217-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roger Quadros <rogerq@kernel.org>

[ Upstream commit 51b9e22ffd3c4c56cbb7caae9750f70e55ffa603 ]

gpmc,mux-add-data is not boolean.

Fixes the below errors flagged by dtbs_check.

"ethernet@4,0:gpmc,mux-add-data: True is not of type 'array'"

Signed-off-by: Roger Quadros <rogerq@kernel.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/omap-gpmc-smsc9221.dtsi         | 2 +-
 arch/arm/boot/dts/omap3-overo-tobiduo-common.dtsi | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/omap-gpmc-smsc9221.dtsi b/arch/arm/boot/dts/omap-gpmc-smsc9221.dtsi
index 7f6aefd134514..e7534fe9c53cf 100644
--- a/arch/arm/boot/dts/omap-gpmc-smsc9221.dtsi
+++ b/arch/arm/boot/dts/omap-gpmc-smsc9221.dtsi
@@ -29,7 +29,7 @@
 		compatible = "smsc,lan9221","smsc,lan9115";
 		bank-width = <2>;
 
-		gpmc,mux-add-data;
+		gpmc,mux-add-data = <0>;
 		gpmc,cs-on-ns = <0>;
 		gpmc,cs-rd-off-ns = <42>;
 		gpmc,cs-wr-off-ns = <36>;
diff --git a/arch/arm/boot/dts/omap3-overo-tobiduo-common.dtsi b/arch/arm/boot/dts/omap3-overo-tobiduo-common.dtsi
index e5da3bc6f1050..218a10c0d8159 100644
--- a/arch/arm/boot/dts/omap3-overo-tobiduo-common.dtsi
+++ b/arch/arm/boot/dts/omap3-overo-tobiduo-common.dtsi
@@ -22,7 +22,7 @@
 		compatible = "smsc,lan9221","smsc,lan9115";
 		bank-width = <2>;
 
-		gpmc,mux-add-data;
+		gpmc,mux-add-data = <0>;
 		gpmc,cs-on-ns = <0>;
 		gpmc,cs-rd-off-ns = <42>;
 		gpmc,cs-wr-off-ns = <36>;
-- 
2.33.0

