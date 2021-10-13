Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60B6D42B165
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 02:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236724AbhJMA6K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 20:58:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:41826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236509AbhJMA5s (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Oct 2021 20:57:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1179A610A0;
        Wed, 13 Oct 2021 00:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634086545;
        bh=xZOhryl0XSWzplWr+qj+2hR8QhvZpt1hEK2PI5GGjlQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q/5h5fldBdbSJv8hZS1v9jOtJu7io5fJ09QWUDabXT936cP0bGQ9Eqf7IrvB7KthH
         ghd/3Jh6RvoXyEpeQ2TF1wqwt1i4PbAaRpuMKrJ/R4iIylQuOOCfX+3M/HTrsT373I
         DsTKV6W636wpBayMsmbht2t+MWqAoNHthI1WHN/QE3tecmwRSfFvZZl9JzUabAYGsH
         PRxcz3v0opBfPzqgd79vlhN1xTuQiYBewKdOcobqhAOJeMBMOlz5UBu+peV8KcQpTm
         1yEb4McKhoCbfT8akA5ixFypv7Yht8CYse83MwGyaOpFwTkwmlSB/H/ThhyaOzM1in
         lvCTphO5mihJg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Max Filippov <jcmvbkbc@gmail.com>, Sasha Levin <sashal@kernel.org>,
        chris@zankel.net, linux@roeck-us.net, linux-xtensa@linux-xtensa.org
Subject: [PATCH AUTOSEL 5.10 07/11] xtensa: xtfpga: use CONFIG_USE_OF instead of CONFIG_OF
Date:   Tue, 12 Oct 2021 20:55:27 -0400
Message-Id: <20211013005532.700190-7-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211013005532.700190-1-sashal@kernel.org>
References: <20211013005532.700190-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Max Filippov <jcmvbkbc@gmail.com>

[ Upstream commit f3d7c2cdf6dc0d5402ec29c3673893b3542c5ad1 ]

Use platform data to initialize xtfpga device drivers when CONFIG_USE_OF
is not selected. This fixes xtfpga networking when CONFIG_USE_OF is not
selected but CONFIG_OF is.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/xtensa/platforms/xtfpga/setup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/xtensa/platforms/xtfpga/setup.c b/arch/xtensa/platforms/xtfpga/setup.c
index 4f7d6142d41f..59b7f11f2a3e 100644
--- a/arch/xtensa/platforms/xtfpga/setup.c
+++ b/arch/xtensa/platforms/xtfpga/setup.c
@@ -66,7 +66,7 @@ void __init platform_calibrate_ccount(void)
 
 #endif
 
-#ifdef CONFIG_OF
+#ifdef CONFIG_USE_OF
 
 static void __init xtfpga_clk_setup(struct device_node *np)
 {
@@ -284,4 +284,4 @@ static int __init xtavnet_init(void)
  */
 arch_initcall(xtavnet_init);
 
-#endif /* CONFIG_OF */
+#endif /* CONFIG_USE_OF */
-- 
2.33.0

