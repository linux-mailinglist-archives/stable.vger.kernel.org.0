Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58DA18C6F0
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 04:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728721AbfHNCTh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 22:19:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:50456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729801AbfHNCTg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 22:19:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF1F320843;
        Wed, 14 Aug 2019 02:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565749175;
        bh=sNjcijFzaiXPZDlUW/SriUVtBEx8J/jXHdLIfW3jKQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cNY74OmHUdSDDg58TGQjjp63/Z4Tdek26FJgGaY+aMLY+4dcgSUD2S82B17KGCkWh
         eMnSyZOn7B6HB+p170Q0+8XctpPExdAbDs9WNCE/qaH2VrHQtDEZkHefLz15hueC+Y
         rSTuebdas5LePmM1zWd5RpwkrZkH/VETELv5AeQY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Valdis=20Kl=C4=93tnieks?= <valdis.kletnieks@vt.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 39/44] x86/lib/cpu: Address missing prototypes warning
Date:   Tue, 13 Aug 2019 22:18:28 -0400
Message-Id: <20190814021834.16662-39-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021834.16662-1-sashal@kernel.org>
References: <20190814021834.16662-1-sashal@kernel.org>
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

