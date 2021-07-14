Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECB783C90AB
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 22:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239063AbhGNT4B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:56:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:48560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235114AbhGNTul (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:50:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05F66613C3;
        Wed, 14 Jul 2021 19:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626292069;
        bh=bWQwVFVceoAv9fr5JFAU54yDuz0sjTzlAuf24UKZ3uo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gfcH9ae5DHFbfioK/jw7+X9zAl7wN5if7Zs7WHC0vm6684IvyEa65HWwjA8hNr/nv
         JMlLuYmoQCbWsWDDBcGyOgw4CdBglTHBFdakA68nr+SUm8GEPPvxsMbGGTDtfkLNm6
         NFSvQrNz5fxJQxmaNUcc7Cbt/+tq5OPyzUMu/UwTVG6zLVDhAVTvtnp+kpFELfOWcl
         y8HE0VuGWRCtoVESXhIz4GW+ftkh5gUAxenzJZCfdpZxFIRAFbX95QX+M5SQV/y5WO
         pbcNF+LRwvwTH5SwInhTFsA5LBsaDxe4cu0lwM0DfaMLK5hLuJWtA9ETeEaHWPaT3K
         Oo27kPU5LsyaQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 17/28] ARM: dts: omap5-board-common: align gpio hog names with dt-schema
Date:   Wed, 14 Jul 2021 15:47:12 -0400
Message-Id: <20210714194723.55677-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194723.55677-1-sashal@kernel.org>
References: <20210714194723.55677-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

[ Upstream commit 4823117cb80eedf31ddbc126b9bd92e707bd9a26 ]

The GPIO Hog dt-schema node naming convention expect GPIO hogs node names
to end with a 'hog' suffix.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/omap5-board-common.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/omap5-board-common.dtsi b/arch/arm/boot/dts/omap5-board-common.dtsi
index c58f14de0145..62c3dd76e6c1 100644
--- a/arch/arm/boot/dts/omap5-board-common.dtsi
+++ b/arch/arm/boot/dts/omap5-board-common.dtsi
@@ -146,7 +146,7 @@ sound: sound {
 
 &gpio8 {
 	/* TI trees use GPIO instead of msecure, see also muxing */
-	p234 {
+	msecure-hog {
 		gpio-hog;
 		gpios = <10 GPIO_ACTIVE_HIGH>;
 		output-high;
-- 
2.30.2

