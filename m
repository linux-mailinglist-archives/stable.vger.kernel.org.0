Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C40CC44B853
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:39:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345266AbhKIWmF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:42:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:59904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345279AbhKIWjw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:39:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 775AB61B28;
        Tue,  9 Nov 2021 22:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496610;
        bh=4FLFo4QtKGgZSNkxhZDuAi2pcLRTmHCDtelC4gPDTQ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hpim0EKx77TAlKhCz+JE3rK3vqcuF7Z9I3gqd4vQkVNy48f6y/30OWabdbmDZ4zS0
         amk0VF67AN9JpIotmgMWR8z1k9Y1tEvy0Ial0CCoYlaJVzfWdxXsZkp0aF6OlzbJIr
         8qnASOAL5dva2gKXWg3jR2Juu5fzVYvk48ATr31ikzFLAi2RD9T+Q/5AVsntWGPLE0
         0dG7mJGAg4sugYvKlFYQggF0Lu1yiIL6ojRO/0WA+uO3piTI1p3W4m6QDfyqbkXPg8
         LekPFP/Fw+0cyYTZN9y1R4dIviisIdp12EgMl4/05g7fH2+8wZMrXW6VINXOruMY6e
         7cHG0tzi7lLjg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Roger Quadros <rogerq@kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, bcousson@baylibre.com,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 12/21] ARM: dts: omap: fix gpmc,mux-add-data type
Date:   Tue,  9 Nov 2021 17:23:01 -0500
Message-Id: <20211109222311.1235686-12-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109222311.1235686-1-sashal@kernel.org>
References: <20211109222311.1235686-1-sashal@kernel.org>
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
index 82e98ee3023ad..3dbeb7a6c569c 100644
--- a/arch/arm/boot/dts/omap3-overo-tobiduo-common.dtsi
+++ b/arch/arm/boot/dts/omap3-overo-tobiduo-common.dtsi
@@ -25,7 +25,7 @@
 		compatible = "smsc,lan9221","smsc,lan9115";
 		bank-width = <2>;
 
-		gpmc,mux-add-data;
+		gpmc,mux-add-data = <0>;
 		gpmc,cs-on-ns = <0>;
 		gpmc,cs-rd-off-ns = <42>;
 		gpmc,cs-wr-off-ns = <36>;
-- 
2.33.0

