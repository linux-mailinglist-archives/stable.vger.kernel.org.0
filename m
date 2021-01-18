Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4B592FA38E
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 15:51:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404985AbhARObm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 09:31:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:37938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390825AbhARLn3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:43:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C194022D2C;
        Mon, 18 Jan 2021 11:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970194;
        bh=lqfhIIKAmyes3uhDE1lG7FzPk5jU+FKGHbA35jjLNzs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KLjzimSmaj7l8LqfTfZw7rWSSSPYHqpiOLdXGd7SM9tyYZo2O3CwQGHINiOp4fzLR
         rSvyPs6A83XgTSPR7EYXgM8JiapVnCdm8imeKbC1TkoBau9d6dR2O71NiG+o0xnHLF
         dkzkoXZ88/VBsC0t4LBZkOaQcRTLGKiC+Ca5SrjM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 077/152] kconfig: remove kvmconfig and xenconfig shorthands
Date:   Mon, 18 Jan 2021 12:34:12 +0100
Message-Id: <20210118113356.479183926@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



