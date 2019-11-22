Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B43051060B1
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 06:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728076AbfKVFvR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 00:51:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:56208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728069AbfKVFvQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:51:16 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 643A32070E;
        Fri, 22 Nov 2019 05:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401876;
        bh=NuGwt9UuVhd1Ho4x3f8+0NO0nzyik9SvmiHRiNlBNRY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lPdLHHwFrNGY6eNkXvCKZsUDqKaNAAlV6tASZthXHv7Yx6jswwHoTVbmKOXU7ZehQ
         9AN/lpFZ0RDahFneFyQOYboBqLyLeNPVIk61Y6sld9/kQodp4V9z6zRbAoagfaaFrv
         ziTgCbTIaCI6yVYQfh7l1TA6TQfY431bCoDE54aQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Stafford Horne <shorne@gmail.com>,
        Sasha Levin <sashal@kernel.org>, openrisc@lists.librecores.org
Subject: [PATCH AUTOSEL 4.19 111/219] openrisc: Fix broken paths to arch/or32
Date:   Fri, 22 Nov 2019 00:47:23 -0500
Message-Id: <20191122054911.1750-104-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

[ Upstream commit 57ce8ba0fd3a95bf29ed741df1c52bd591bf43ff ]

OpenRISC was mainlined as "openrisc", not "or32".
vmlinux.lds is generated from vmlinux.lds.S.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Stafford Horne <shorne@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/openrisc/kernel/entry.S | 2 +-
 arch/openrisc/kernel/head.S  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/openrisc/kernel/entry.S b/arch/openrisc/kernel/entry.S
index 0c826ad6e994c..ee6159d2ed22e 100644
--- a/arch/openrisc/kernel/entry.S
+++ b/arch/openrisc/kernel/entry.S
@@ -240,7 +240,7 @@ handler:							;\
  *	 occured. in fact they never do. if you need them use
  *	 values saved on stack (for SPR_EPC, SPR_ESR) or content
  *       of r4 (for SPR_EEAR). for details look at EXCEPTION_HANDLE()
- *       in 'arch/or32/kernel/head.S'
+ *       in 'arch/openrisc/kernel/head.S'
  */
 
 /* =====================================================[ exceptions] === */
diff --git a/arch/openrisc/kernel/head.S b/arch/openrisc/kernel/head.S
index 9fc6b60140f00..31ed257ff0618 100644
--- a/arch/openrisc/kernel/head.S
+++ b/arch/openrisc/kernel/head.S
@@ -1728,7 +1728,7 @@ _string_nl:
 
 /*
  * .data section should be page aligned
- *	(look into arch/or32/kernel/vmlinux.lds)
+ *	(look into arch/openrisc/kernel/vmlinux.lds.S)
  */
 	.section .data,"aw"
 	.align	8192
-- 
2.20.1

