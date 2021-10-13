Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2498F42B13A
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 02:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236669AbhJMA5P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 20:57:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:40898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235294AbhJMA5K (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Oct 2021 20:57:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EBAC60EB4;
        Wed, 13 Oct 2021 00:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634086508;
        bh=xZOhryl0XSWzplWr+qj+2hR8QhvZpt1hEK2PI5GGjlQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eFdprLfgD2wBJzUF8f9Va5PxPYlc4+zKj81fErokI/dgjta5jdfbVdjyCucN4cgdO
         F1W3B+Ot6PQR9fmJLjDPLCK7w1gFUhFxkkzQAZ69iJfdFQInG8QsDNBOJw700NhXZq
         0un+LjImgZt0dv5yKxtrbf3sMk6DmxLrR3Fe/JPyl7FEivPcSMz2uYQGLIxPiUDhIS
         /zcM2Ps+9YE0lp0pKNTDwpXIZbPfT5ybeL50gR44XXvoy8PRDSxMnyTLwUv9ma578+
         QCX9vpqtxK0F1uFD/0VTZSkZRnEU7CVxahyNjkQ+1lPy7NiuNrhy163En6AfLgRQhm
         k65U6kCEQfAXA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Max Filippov <jcmvbkbc@gmail.com>, Sasha Levin <sashal@kernel.org>,
        chris@zankel.net, linux@roeck-us.net, linux-xtensa@linux-xtensa.org
Subject: [PATCH AUTOSEL 5.14 10/17] xtensa: xtfpga: use CONFIG_USE_OF instead of CONFIG_OF
Date:   Tue, 12 Oct 2021 20:54:34 -0400
Message-Id: <20211013005441.699846-10-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211013005441.699846-1-sashal@kernel.org>
References: <20211013005441.699846-1-sashal@kernel.org>
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

