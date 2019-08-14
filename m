Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE5A08C780
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 04:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730122AbfHNCYO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 22:24:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:53114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730116AbfHNCYN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 22:24:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DB2F20842;
        Wed, 14 Aug 2019 02:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565749452;
        bh=sNjcijFzaiXPZDlUW/SriUVtBEx8J/jXHdLIfW3jKQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q1H7MbZKsVe8Jv0pjBoM0jNJHsCePYGrZLqVyu0sd/1We2fCentTv2qfw/KvwCPU7
         V/sFW8MkUaxMb87mZWpulf7uoiexUE7ypTJXl4VSMVnWjPlA7o8Qqbh9g4P3HzcD63
         Fd6FdmYKf4E6akGyOfpCycSn7G6YSN7J3WqTsgyo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Valdis=20Kl=C4=93tnieks?= <valdis.kletnieks@vt.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 30/33] x86/lib/cpu: Address missing prototypes warning
Date:   Tue, 13 Aug 2019 22:23:20 -0400
Message-Id: <20190814022323.17111-30-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814022323.17111-1-sashal@kernel.org>
References: <20190814022323.17111-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Valdis Klētnieks <valdis.kletnieks@vt.edu>

[ Upstream commit 04f5bda84b0712d6f172556a7e8dca9ded5e73b9 ]

When building with W=1, warnings about missing prototypes are emitted:

  CC      arch/x86/lib/cpu.o
arch/x86/lib/cpu.c:5:14: warning: no previous prototype for 'x86_family' [-Wmissing-prototypes]
    5 | unsigned int x86_family(unsigned int sig)
      |              ^~~~~~~~~~
arch/x86/lib/cpu.c:18:14: warning: no previous prototype for 'x86_model' [-Wmissing-prototypes]
   18 | unsigned int x86_model(unsigned int sig)
      |              ^~~~~~~~~
arch/x86/lib/cpu.c:33:14: warning: no previous prototype for 'x86_stepping' [-Wmissing-prototypes]
   33 | unsigned int x86_stepping(unsigned int sig)
      |              ^~~~~~~~~~~~

Add the proper include file so the prototypes are there.

Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/42513.1565234837@turing-police
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/lib/cpu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/lib/cpu.c b/arch/x86/lib/cpu.c
index 2dd1fe13a37b3..19f707992db22 100644
--- a/arch/x86/lib/cpu.c
+++ b/arch/x86/lib/cpu.c
@@ -1,5 +1,6 @@
 #include <linux/types.h>
 #include <linux/export.h>
+#include <asm/cpu.h>
 
 unsigned int x86_family(unsigned int sig)
 {
-- 
2.20.1

