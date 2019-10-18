Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C898DD32F
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404045AbfJRWPq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:15:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:41334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388150AbfJRWIq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:08:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B6BC222D4;
        Fri, 18 Oct 2019 22:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436525;
        bh=A9SrPWrxdxcoRsjxb35PkZdHMlnw+DL9OVAPVfkxeww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FFIkvENhgcKyy64pHxQAHMRuYs2TvI0E2b/Ky+msMwfzP2+euiJErutUSS/jLZtQ+
         3qEd/SlfKFMmTIRJt93aA1ynjEMEM34LOUt6pyWrUOZmLvTtSar1+ZYHpW39QFHt+i
         c+b4jxoTq5rRvJqKr86oYZDOyXXGOt65I/ySy2uw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 32/56] tty: serial: owl: Fix the link time qualifier of 'owl_uart_exit()'
Date:   Fri, 18 Oct 2019 18:07:29 -0400
Message-Id: <20191018220753.10002-32-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220753.10002-1-sashal@kernel.org>
References: <20191018220753.10002-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 6264dab6efd6069f0387efb078a9960b5642377b ]

'exit' functions should be marked as __exit, not __init.

Fixes: fc60a8b675bd ("tty: serial: owl: Implement console driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/20190910041129.6978-1-christophe.jaillet@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/owl-uart.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/owl-uart.c b/drivers/tty/serial/owl-uart.c
index b9c8593653347..d774f6013d7b6 100644
--- a/drivers/tty/serial/owl-uart.c
+++ b/drivers/tty/serial/owl-uart.c
@@ -754,7 +754,7 @@ static int __init owl_uart_init(void)
 	return ret;
 }
 
-static void __init owl_uart_exit(void)
+static void __exit owl_uart_exit(void)
 {
 	platform_driver_unregister(&owl_uart_platform_driver);
 	uart_unregister_driver(&owl_uart_driver);
-- 
2.20.1

