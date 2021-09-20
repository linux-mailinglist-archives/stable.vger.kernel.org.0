Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 973FE4121AC
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358664AbhITSHv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:07:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:33268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358576AbhITSHD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:07:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 782456324B;
        Mon, 20 Sep 2021 17:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158290;
        bh=Yym8bEaKDwwuCUq5lo+2cM1dPMXePaTtmzxRKHHMX8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=geJTfsXv2GoOYNxj6a2KmeRJ8GD120s9Jv6W2yZV91dTCOCH9DhWSjm6fL8PvY0lp
         Ljgj2wovgZkOfdzfHN/LJrS2bwaAXRT90Gd8BvCulE13sM/MCt1ybZZPPVSf6tFOCg
         jdlzqeFiH48U79vSngue9uceg2AXWD72UTrzG6Y0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joel Stanley <joel@jms.id.au>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 056/260] powerpc/config: Renable MTD_PHYSMAP_OF
Date:   Mon, 20 Sep 2021 18:41:14 +0200
Message-Id: <20210920163933.004627805@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joel Stanley <joel@jms.id.au>

[ Upstream commit d0e28a6145c3455b69991245e7f6147eb914b34a ]

CONFIG_MTD_PHYSMAP_OF is not longer enabled as it depends on
MTD_PHYSMAP which is not enabled.

This is a regression from commit 642b1e8dbed7 ("mtd: maps: Merge
physmap_of.c into physmap-core.c"), which added the extra dependency.
Add CONFIG_MTD_PHYSMAP=y so this stays in the config, as Christophe said
it is useful for build coverage.

Fixes: 642b1e8dbed7 ("mtd: maps: Merge physmap_of.c into physmap-core.c")
Signed-off-by: Joel Stanley <joel@jms.id.au>
Acked-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210817045407.2445664-3-joel@jms.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/configs/mpc885_ads_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/configs/mpc885_ads_defconfig b/arch/powerpc/configs/mpc885_ads_defconfig
index 285d506c5a76..2f5e06309f09 100644
--- a/arch/powerpc/configs/mpc885_ads_defconfig
+++ b/arch/powerpc/configs/mpc885_ads_defconfig
@@ -39,6 +39,7 @@ CONFIG_MTD_CFI_GEOMETRY=y
 # CONFIG_MTD_CFI_I2 is not set
 CONFIG_MTD_CFI_I4=y
 CONFIG_MTD_CFI_AMDSTD=y
+CONFIG_MTD_PHYSMAP=y
 CONFIG_MTD_PHYSMAP_OF=y
 # CONFIG_BLK_DEV is not set
 CONFIG_NETDEVICES=y
-- 
2.30.2



