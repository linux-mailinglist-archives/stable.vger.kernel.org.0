Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0115743A076
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234984AbhJYTav (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:30:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:48384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234917AbhJYT3Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:29:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02DBF61179;
        Mon, 25 Oct 2021 19:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635189976;
        bh=2i/SmkelTVJDN4ukHIRESkLDHoefkzHPPIw9v0mXuDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dT4OtmwqNSndP9LCJy/COFVCQOabMulD1N/J8fBrC4DcZA80Mk/Eh2Tnf4Wz3SY8F
         g19p+M5jm3TqQs5szWfZ0IJYrxRDbnCOIgeJKwI6/d6JytS0NBE/F7tWj60LX1OE3d
         HDoPLYVk+XX4QlMinC6+9J4Ke+3T3aU3VtHEwgws=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 05/58] xtensa: xtfpga: use CONFIG_USE_OF instead of CONFIG_OF
Date:   Mon, 25 Oct 2021 21:14:22 +0200
Message-Id: <20211025190938.488785599@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190937.555108060@linuxfoundation.org>
References: <20211025190937.555108060@linuxfoundation.org>
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
index 829115bb381f..61c5e2c45439 100644
--- a/arch/xtensa/platforms/xtfpga/setup.c
+++ b/arch/xtensa/platforms/xtfpga/setup.c
@@ -81,7 +81,7 @@ void __init platform_calibrate_ccount(void)
 
 #endif
 
-#ifdef CONFIG_OF
+#ifdef CONFIG_USE_OF
 
 static void __init xtfpga_clk_setup(struct device_node *np)
 {
@@ -299,4 +299,4 @@ static int __init xtavnet_init(void)
  */
 arch_initcall(xtavnet_init);
 
-#endif /* CONFIG_OF */
+#endif /* CONFIG_USE_OF */
-- 
2.33.0



