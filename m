Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C547B3C8F47
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241101AbhGNTwR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:52:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:47276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238902AbhGNTss (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:48:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E10D61416;
        Wed, 14 Jul 2021 19:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291839;
        bh=61zfSRzG8fZ7cjyr30XK1KAYJ+D4Q/kZXSuqGCbjFjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DcNVH0GdcNVhIjEe0LoH7CMn3C8K+o8wDvyev5VvgrU1qVLcrSOI2r0Riu1qfeNiV
         H+69y8BeFWnBK/yK3AIRU8fAQQWMByFXs55dzFaKY5AYWIABOnNhBH7U508L2LTWln
         4Eg92+nXDpUzEfQtQdk9eoBvGNQAkAHC5LovqP9wbfEZXE/ABS8cXs6dFISlkO7/87
         9/SbWdiKDmQ7LIl7UYuUXGCvioFCDiC2hRC05Gxynz6U70tkZpWHIyt14s3Xu74Uv7
         qO5m62M0lA/0Kus5sVqLwmgKdz3I5lcQvHiTUNfSg1XzrNMC3ZJMsMNrA7Cl4QIjd5
         MsVotCoKkcYXQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 36/88] ARM: dts: omap5-board-common: align gpio hog names with dt-schema
Date:   Wed, 14 Jul 2021 15:42:11 -0400
Message-Id: <20210714194303.54028-36-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194303.54028-1-sashal@kernel.org>
References: <20210714194303.54028-1-sashal@kernel.org>
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
index d8f13626cfd1..45435bb88c89 100644
--- a/arch/arm/boot/dts/omap5-board-common.dtsi
+++ b/arch/arm/boot/dts/omap5-board-common.dtsi
@@ -149,7 +149,7 @@ sound: sound {
 
 &gpio8 {
 	/* TI trees use GPIO instead of msecure, see also muxing */
-	p234 {
+	msecure-hog {
 		gpio-hog;
 		gpios = <10 GPIO_ACTIVE_HIGH>;
 		output-high;
-- 
2.30.2

