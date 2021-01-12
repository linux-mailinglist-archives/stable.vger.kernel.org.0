Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 611E62F314D
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 14:25:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730158AbhALNRY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 08:17:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:53866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389870AbhALM5S (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 07:57:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D16872312E;
        Tue, 12 Jan 2021 12:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456171;
        bh=lqfhIIKAmyes3uhDE1lG7FzPk5jU+FKGHbA35jjLNzs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uD1s5iS9YAtw10DTNt4X+pOMnNXlVmrVBg9ChAG3IeoCV3b3yF3IP42sOG7qxnvIR
         yxR4BPglmwfv8/y5LMoAbcZf/uteRx1gCZVOazocJzILmUtUNHXk86RD9C2YaCRfUO
         M9VWAwvnaPdX8mGCbPrfmWPoTgUvBZrJBtmBdt4hMxR1484iBepqo4qRJN9SSsGKi3
         L0wo/aABR8ne1RedhnUXSpRQxx54QzTfRC7fZPsPBWzjbR4FLIJKG/CLouAkFuaiX2
         IHSxdoSAJM1sp1OoRCgpvscQSnsr2xWj4gEky8vS+Jk83k6gsR5SoMPcCqzTLi2Go7
         pLoy/48Dbm89Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-kbuild@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 28/51] kconfig: remove 'kvmconfig' and 'xenconfig' shorthands
Date:   Tue, 12 Jan 2021 07:55:10 -0500
Message-Id: <20210112125534.70280-28-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125534.70280-1-sashal@kernel.org>
References: <20210112125534.70280-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 9bba03d4473df0b707224d4d2067b62d1e1e2a77 ]

Linux 5.10 is out. Remove the 'kvmconfig' and 'xenconfig' shorthands
as previously announced.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/Makefile | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index e46df0a2d4f9d..2c40e68853dde 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -94,16 +94,6 @@ configfiles=$(wildcard $(srctree)/kernel/configs/$@ $(srctree)/arch/$(SRCARCH)/c
 	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/kconfig/merge_config.sh -m .config $(configfiles)
 	$(Q)$(MAKE) -f $(srctree)/Makefile olddefconfig
 
-PHONY += kvmconfig
-kvmconfig: kvm_guest.config
-	@echo >&2 "WARNING: 'make $@' will be removed after Linux 5.10"
-	@echo >&2 "         Please use 'make $<' instead."
-
-PHONY += xenconfig
-xenconfig: xen.config
-	@echo >&2 "WARNING: 'make $@' will be removed after Linux 5.10"
-	@echo >&2 "         Please use 'make $<' instead."
-
 PHONY += tinyconfig
 tinyconfig:
 	$(Q)$(MAKE) -f $(srctree)/Makefile allnoconfig tiny.config
-- 
2.27.0

