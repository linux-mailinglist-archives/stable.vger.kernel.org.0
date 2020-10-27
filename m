Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E72EB29B7E7
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:08:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1798478AbgJ0P2R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:28:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:36140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1797082AbgJ0PVd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:21:33 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D9E020657;
        Tue, 27 Oct 2020 15:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812091;
        bh=6M83Bp7CN6q9gAdkscBTEoyTQP1NK/STJR2yLE6JlhU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gfAZDFd6mI+Ic1e/EDS/+7Dtef7EU+u0j29N6xdtsktFBvijrP0R2Neu6DA0Ao/Jr
         9ZWYeSZXkoZ/o04Jfpjzr+fud0tvQVUURa+YiQE9cw9nMwEU4MCzQicRUkmzu8YJSZ
         OjFnqLcAdhQGlXHLQF1nAL/Y/BMpXvo1oskE3l3c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Michal Simek <monstr@monstr.eu>,
        Michal Simek <michal.simek@xilinx.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 090/757] microblaze: fix kbuild redundant file warning
Date:   Tue, 27 Oct 2020 14:45:40 +0100
Message-Id: <20201027135454.774235152@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 4a17e8513376bb23f814d3e340a5692a12c69369 ]

Fix build warning since this file is already listed in
include/asm-generic/Kbuild.

../scripts/Makefile.asm-generic:25: redundant generic-y found in arch/microblaze/include/asm/Kbuild: hw_irq.h

Fixes: 630f289b7114 ("asm-generic: make more kernel-space headers mandatory")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Michal Simek <michal.simek@xilinx.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Masahiro Yamada <masahiroy@kernel.org>
Link: https://lore.kernel.org/r/4d992aee-8a69-1769-e622-8d6d6e316346@infradead.org
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/microblaze/include/asm/Kbuild | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/microblaze/include/asm/Kbuild b/arch/microblaze/include/asm/Kbuild
index 2e87a9b6d312f..63bce836b9f10 100644
--- a/arch/microblaze/include/asm/Kbuild
+++ b/arch/microblaze/include/asm/Kbuild
@@ -1,7 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 generated-y += syscall_table.h
 generic-y += extable.h
-generic-y += hw_irq.h
 generic-y += kvm_para.h
 generic-y += local64.h
 generic-y += mcs_spinlock.h
-- 
2.25.1



