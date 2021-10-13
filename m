Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 307CE42B1A8
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 02:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237857AbhJMA7f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 20:59:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:42520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237675AbhJMA6t (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Oct 2021 20:58:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCA5260EBB;
        Wed, 13 Oct 2021 00:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634086606;
        bh=BBTq1XMHgxZOIYSLL3kcvMpjtwUESCOr80d3awmgXKA=;
        h=From:To:Cc:Subject:Date:From;
        b=a6VX8gxqF0z6Gok8SZ5jYY9R7V8yWCeAMAoheSH5IWj3uFxrSVP1KogUX7J14nGV0
         QkOcnbELXmQ+E1x/Xkd7lXErIrHIFG/IOnntgspgaTbyznGbGsgekobDsUe+ssnRu8
         Kl9mhrKyZmIKTjXt9bdjELjGkoFjGzBsMJ4M7kigC1FohMhJoO1asX8mk6SzyLLP/G
         Qo1xDvUNI7+SWM4ulEWNeL+Z+6oAN2NRKVETJVv4iRJKwHqhmTkyCDvrPMEXxM2MYU
         fdQOSZiFlAzauFoaxmTWnqaFOeU3cWh+M/QbFK/Q4XKsrz9+l+Qmf7nKveHj21muV1
         Co3cewXtiSIpQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Max Filippov <jcmvbkbc@gmail.com>, Sasha Levin <sashal@kernel.org>,
        chris@zankel.net, linux@roeck-us.net, linux-xtensa@linux-xtensa.org
Subject: [PATCH AUTOSEL 4.9 1/4] xtensa: xtfpga: use CONFIG_USE_OF instead of CONFIG_OF
Date:   Tue, 12 Oct 2021 20:56:40 -0400
Message-Id: <20211013005644.700705-1-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
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

