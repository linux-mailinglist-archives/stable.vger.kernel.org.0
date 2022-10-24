Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21AB460B042
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232771AbiJXQDW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:03:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232370AbiJXQC2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:02:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27151112A86;
        Mon, 24 Oct 2022 07:55:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9559AB81680;
        Mon, 24 Oct 2022 12:26:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F354FC433D6;
        Mon, 24 Oct 2022 12:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614371;
        bh=fVjz5Ks1uqp8ZxMRnCA4ldqH2dXUZmbtXtJd8+Cg3r0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uINb36pSX2qsT1/FwFZEO6fOlTeoDyPqpCfT31zrZk0ZiT8jocBts1ZWNwg4d9dg1
         tTrCnLR6ZnX6y7PdbJBNdxPMRrpbXjtDkI5xvEzeyQTWDQPIvSIDwk6TriRkqom5rP
         KG2LldHZUppDmGV45UhtePY3fg63nFUXXNm4QS0s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 236/390] serial: 8250: Add an empty line and remove some useless {}
Date:   Mon, 24 Oct 2022 13:30:33 +0200
Message-Id: <20221024113032.840433308@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 26f7591632d74f637f346f5d642d8ebe6b433fc9 ]

This fixes the following checkpatch.pl warnings:
   WARNING: Missing a blank line after declarations
   WARNING: braces {} are not necessary for any arm of this statement

Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/257ffd691b4a062ad017333c9430d69da6dbd29a.1619594713.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 039d4926379b ("serial: 8250: Toggle IER bits on only after irq has been set up")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index 98ce484f1089..aae9d26ce4f4 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -332,9 +332,9 @@ static int univ8250_setup_irq(struct uart_8250_port *up)
 	 * hardware interrupt, we use a timer-based system.  The original
 	 * driver used to do this with IRQ0.
 	 */
-	if (!port->irq) {
+	if (!port->irq)
 		mod_timer(&up->timer, jiffies + uart_poll_timeout(port));
-	} else
+	else
 		retval = serial_link_irq_chain(up);
 
 	return retval;
@@ -766,6 +766,7 @@ void serial8250_suspend_port(int line)
 	if (!console_suspend_enabled && uart_console(port) &&
 	    port->type != PORT_8250) {
 		unsigned char canary = 0xa5;
+
 		serial_out(up, UART_SCR, canary);
 		if (serial_in(up, UART_SCR) == canary)
 			up->canary = canary;
-- 
2.35.1



