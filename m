Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8F211343C
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:23:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730594AbfLDSXE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:23:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:49932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730203AbfLDSEb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:04:31 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A59B2081B;
        Wed,  4 Dec 2019 18:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482670;
        bh=+ki55RV1IzPV8OlLCUZQK5QE1EvFkv2OU2Lgd/dUtRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gu/vqV6kKgB+sZOGrYiHyyuAUpnZLOSZ/fEg8/mcCy6z02fVeVY65tso7YIxjm55d
         c2pzAdWVgOsF3W1UadFUZkvg6Jsa90X+8x71dOPWCDPuKqRS3KdnstOLtlSziXwohD
         URpuZq9webY+S7KX85ZGJgmQREqIVzfCnLpnfNq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Stafford Horne <shorne@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 087/209] openrisc: Fix broken paths to arch/or32
Date:   Wed,  4 Dec 2019 18:54:59 +0100
Message-Id: <20191204175327.655874234@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175321.609072813@linuxfoundation.org>
References: <20191204175321.609072813@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index b16e95a4e875f..1107d34e45bf1 100644
--- a/arch/openrisc/kernel/entry.S
+++ b/arch/openrisc/kernel/entry.S
@@ -184,7 +184,7 @@ handler:							;\
  *	 occured. in fact they never do. if you need them use
  *	 values saved on stack (for SPR_EPC, SPR_ESR) or content
  *       of r4 (for SPR_EEAR). for details look at EXCEPTION_HANDLE()
- *       in 'arch/or32/kernel/head.S'
+ *       in 'arch/openrisc/kernel/head.S'
  */
 
 /* =====================================================[ exceptions] === */
diff --git a/arch/openrisc/kernel/head.S b/arch/openrisc/kernel/head.S
index 90979acdf165b..4d878d13b8606 100644
--- a/arch/openrisc/kernel/head.S
+++ b/arch/openrisc/kernel/head.S
@@ -1551,7 +1551,7 @@ _string_nl:
 
 /*
  * .data section should be page aligned
- *	(look into arch/or32/kernel/vmlinux.lds)
+ *	(look into arch/openrisc/kernel/vmlinux.lds.S)
  */
 	.section .data,"aw"
 	.align	8192
-- 
2.20.1



