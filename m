Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E781440E609
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351473AbhIPRR1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:17:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:41016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351291AbhIPRPY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:15:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6357A61B65;
        Thu, 16 Sep 2021 16:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810387;
        bh=zc3aboCk0saY7I/sLex5/I6UwQO7I+Kz3RvTDi6mJTE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iQoojTiGm+4+fsW+2EAJnoquDlWlwiOrMdRMm7dx4sepl4Gs/JNEUkfcGDRGtNU+Z
         gQD6l7LEWWTtPoKBUkIQa2zVhgwXM7PrYfsrmTwiXVX3NfT47LArdNdo1WLT3q4JN1
         2oIWSGC/3OztUPqLnTY/l9u6cpzi45Fx7Y0uVnvQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joel Stanley <joel@jms.id.au>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 121/432] powerpc/config: Renable MTD_PHYSMAP_OF
Date:   Thu, 16 Sep 2021 17:57:50 +0200
Message-Id: <20210916155814.865924741@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
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
index 5cd17adf903f..cd08f9ed2c8d 100644
--- a/arch/powerpc/configs/mpc885_ads_defconfig
+++ b/arch/powerpc/configs/mpc885_ads_defconfig
@@ -33,6 +33,7 @@ CONFIG_MTD_CFI_GEOMETRY=y
 # CONFIG_MTD_CFI_I2 is not set
 CONFIG_MTD_CFI_I4=y
 CONFIG_MTD_CFI_AMDSTD=y
+CONFIG_MTD_PHYSMAP=y
 CONFIG_MTD_PHYSMAP_OF=y
 # CONFIG_BLK_DEV is not set
 CONFIG_NETDEVICES=y
-- 
2.30.2



