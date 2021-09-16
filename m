Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 175E840DF6B
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232915AbhIPQJj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:09:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:48850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233709AbhIPQIc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:08:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0828361356;
        Thu, 16 Sep 2021 16:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808431;
        bh=zv2U393LUqG9qv8Squqau6qezSl4qKipcRyNbdq6g+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NrC1Rqt5sXBbquImXfuKAyC2KOI473zrC2lTtWlTYgkJB7fPgdg9c5oFSMQHmuRSf
         Ni0J6bvPJHuxhSz+ip/MLGsBPSNqHWcuHLrQHFQQdDHsKrNl+7zv26dLQVoi7dBYyA
         dEbi2A1jYAYsZ0ICMh+tejOOMwxdgVzmbjfumpRo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joel Stanley <joel@jms.id.au>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 088/306] powerpc/config: Renable MTD_PHYSMAP_OF
Date:   Thu, 16 Sep 2021 17:57:13 +0200
Message-Id: <20210916155757.063308632@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
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
index 949ff9ccda5e..dbf3ff8adc65 100644
--- a/arch/powerpc/configs/mpc885_ads_defconfig
+++ b/arch/powerpc/configs/mpc885_ads_defconfig
@@ -34,6 +34,7 @@ CONFIG_MTD_CFI_GEOMETRY=y
 # CONFIG_MTD_CFI_I2 is not set
 CONFIG_MTD_CFI_I4=y
 CONFIG_MTD_CFI_AMDSTD=y
+CONFIG_MTD_PHYSMAP=y
 CONFIG_MTD_PHYSMAP_OF=y
 # CONFIG_BLK_DEV is not set
 CONFIG_NETDEVICES=y
-- 
2.30.2



