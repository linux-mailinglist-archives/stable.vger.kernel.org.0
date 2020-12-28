Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9759B2E4301
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:34:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407321AbgL1Nxf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:53:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:55090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391574AbgL1Nxd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:53:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 46E2420791;
        Mon, 28 Dec 2020 13:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163597;
        bh=XubKWarNOxBCmx7TJlKv76iQoBzLSVjpQkDeH+wZ8VI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P1oviaNApfnp6Bu7VY2c87FezPYes6kqg58cZA/VHAtcOsRBvCKDhOy8BOCwlIuGI
         ECXsoO0JfS7eGKJS8z6a6fXI6tbLMPGqBPxwtnT3unISoVvPppZgtiBTAJEvCXBtii
         c0faBHPl/GYVuA/f70/J6iXtQ6xNXrserR87Nb24=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Kocialkowski <contact@paulk.fr>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 311/453] ARM: sunxi: Add machine match for the Allwinner V3 SoC
Date:   Mon, 28 Dec 2020 13:49:07 +0100
Message-Id: <20201228124952.179813848@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Kocialkowski <contact@paulk.fr>

[ Upstream commit ad2091f893bd5dfe2824f0d6819600d120698e9f ]

The Allwinner V3 SoC shares the same base as the V3s but comes with
extra pins and features available. As a result, it has its dedicated
compatible string (already used in device trees), which is added here.

Signed-off-by: Paul Kocialkowski <contact@paulk.fr>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://lore.kernel.org/r/20201031182137.1879521-2-contact@paulk.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-sunxi/sunxi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-sunxi/sunxi.c b/arch/arm/mach-sunxi/sunxi.c
index 933b6930f024f..a0ca5e7a68de2 100644
--- a/arch/arm/mach-sunxi/sunxi.c
+++ b/arch/arm/mach-sunxi/sunxi.c
@@ -66,6 +66,7 @@ static const char * const sun8i_board_dt_compat[] = {
 	"allwinner,sun8i-h2-plus",
 	"allwinner,sun8i-h3",
 	"allwinner,sun8i-r40",
+	"allwinner,sun8i-v3",
 	"allwinner,sun8i-v3s",
 	NULL,
 };
-- 
2.27.0



