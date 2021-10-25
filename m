Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7953439F97
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234258AbhJYTW0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:22:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:38296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234463AbhJYTVK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:21:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5DE56103C;
        Mon, 25 Oct 2021 19:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635189527;
        bh=BBTq1XMHgxZOIYSLL3kcvMpjtwUESCOr80d3awmgXKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZfQbl/uj6S9X0Ytg8ppIxNaijHrs5fM+tdVKtwdb6HhvKDw1Hc4T/TGSvGGN98NR3
         ayknAz7WGbAXQ6kwqMLh0L924E4Czcuxn5FcKuJau1jvToaBjaAc69JXx9oBIJ7Sw4
         jQKQGBCeRC9mY7pQ9jlYSn1+Rx5wYJ3epVWB+AlU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 26/50] xtensa: xtfpga: use CONFIG_USE_OF instead of CONFIG_OF
Date:   Mon, 25 Oct 2021 21:14:13 +0200
Message-Id: <20211025190937.877836180@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190932.542632625@linuxfoundation.org>
References: <20211025190932.542632625@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 42285f35d313..982e7c22e7ca 100644
--- a/arch/xtensa/platforms/xtfpga/setup.c
+++ b/arch/xtensa/platforms/xtfpga/setup.c
@@ -85,7 +85,7 @@ void __init platform_calibrate_ccount(void)
 
 #endif
 
-#ifdef CONFIG_OF
+#ifdef CONFIG_USE_OF
 
 static void __init xtfpga_clk_setup(struct device_node *np)
 {
@@ -303,4 +303,4 @@ static int __init xtavnet_init(void)
  */
 arch_initcall(xtavnet_init);
 
-#endif /* CONFIG_OF */
+#endif /* CONFIG_USE_OF */
-- 
2.33.0



