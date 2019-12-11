Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E09111B55C
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731654AbfLKPTH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:19:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:47642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732168AbfLKPTG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:19:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1C4524654;
        Wed, 11 Dec 2019 15:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077546;
        bh=k6v9ebSPCzG8fqp3o5nqMhBV4T7TyDMFqX+h2Cy5mr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=brNshz5pna8ePWxOPEkdktCpArrPDxxPNDY14tR1WuqBtzSfJp3mS+0GHuLuFakyX
         Pp+BoJ/4l6dcLuLRlQhannX1mqabnKLzbwmvePI3urquQrIQOmUCVtzcQDKkiCsuaU
         ZGhu2MkYV52EjZqTigibduFAcZfqXn93aCScZCWc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Paul Burton <paul.burton@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>, linux-mips@linux-mips.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 080/243] MIPS: OCTEON: octeon-platform: fix typing
Date:   Wed, 11 Dec 2019 16:04:02 +0100
Message-Id: <20191211150344.509981082@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aaro Koskinen <aaro.koskinen@iki.fi>

[ Upstream commit 2cf1c8933dd93088cfb5f8f58b3bb9bbdf1781b9 ]

Use correct type for fdt_property nameoff field.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Signed-off-by: Paul Burton <paul.burton@mips.com>
Patchwork: https://patchwork.linux-mips.org/patch/21204/
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: James Hogan <jhogan@kernel.org>
Cc: linux-mips@linux-mips.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/cavium-octeon/octeon-platform.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/cavium-octeon/octeon-platform.c b/arch/mips/cavium-octeon/octeon-platform.c
index 807cadaf554e2..5ba181e87d2c1 100644
--- a/arch/mips/cavium-octeon/octeon-platform.c
+++ b/arch/mips/cavium-octeon/octeon-platform.c
@@ -501,7 +501,7 @@ static void __init octeon_fdt_set_phy(int eth, int phy_addr)
 	if (phy_addr >= 256 && alt_phy > 0) {
 		const struct fdt_property *phy_prop;
 		struct fdt_property *alt_prop;
-		u32 phy_handle_name;
+		fdt32_t phy_handle_name;
 
 		/* Use the alt phy node instead.*/
 		phy_prop = fdt_get_property(initial_boot_params, eth, "phy-handle", NULL);
-- 
2.20.1



