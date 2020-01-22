Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 993831455DC
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731272AbgAVNZ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:25:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:45632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730690AbgAVNZ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:25:29 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3375024694;
        Wed, 22 Jan 2020 13:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699528;
        bh=GGrmAWP3SeTwzXqpVrbmPh+E3/GJcea54nILZqLVLVY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r6vAFSlNwkoz6MTp7ypBRHCyHitbEX/1kWKpC5aq3t+ZIwzmhytEZ7WvL4pke4BK6
         /l/EwAeLoXNj1ZmO9r21lL37iDB5AppxeXB9024K0h8VFvMRSsLjTqY5+INXtedn4G
         Awo7HJqFvvsk9JvBinQOHSBWOyuTM+8TEqpnSzj8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        Marc Zyngier <maz@kernel.org>,
        Palmer Dabbelt <palmer@sifive.com>
Subject: [PATCH 5.4 173/222] irqchip: Place CONFIG_SIFIVE_PLIC into the menu
Date:   Wed, 22 Jan 2020 10:29:19 +0100
Message-Id: <20200122092846.091001474@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Neuschäfer <j.neuschaefer@gmx.net>

commit 0149385537e6d36f535fcd83cfcabf83a32f0836 upstream.

Somehow CONFIG_SIFIVE_PLIC ended up outside of the "IRQ chip support"
menu.

Fixes: 8237f8bc4f6e ("irqchip: add a SiFive PLIC driver")
Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Palmer Dabbelt <palmer@sifive.com>
Acked-by: Palmer Dabbelt <palmer@sifive.com>
Link: https://lore.kernel.org/r/20191002144452.10178-1-j.neuschaefer@gmx.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/irqchip/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -483,8 +483,6 @@ config TI_SCI_INTA_IRQCHIP
 	  If you wish to use interrupt aggregator irq resources managed by the
 	  TI System Controller, say Y here. Otherwise, say N.
 
-endmenu
-
 config SIFIVE_PLIC
 	bool "SiFive Platform-Level Interrupt Controller"
 	depends on RISCV
@@ -496,3 +494,5 @@ config SIFIVE_PLIC
 	   interrupt sources are subordinate to the PLIC.
 
 	   If you don't know what to do here, say Y.
+
+endmenu


