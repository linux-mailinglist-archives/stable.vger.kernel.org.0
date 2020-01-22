Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F68F145069
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:47:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387849AbgAVJnO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:43:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:35564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387842AbgAVJnM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:43:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D89CF24689;
        Wed, 22 Jan 2020 09:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579686192;
        bh=i10MW2+Qu7Z85NJhBoA491SH3xqli0eWFNlGQUOlvgA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xAfw69nA9TowUTnqQj3n1j1mr3zN6PQbJXGmm24Pu0uTYjVpaZNebJl7epJzl6kcr
         sC5IW990SJTXXMl/EBD4/hK6W1GEo2b2suxkW58okyxmPpa/eWDgMPSYDRPedM8UeI
         1wVffIB+lq4bxfGIYiVPVj8r6MWQoRqZSlLHc/go=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        Marc Zyngier <maz@kernel.org>,
        Palmer Dabbelt <palmer@sifive.com>
Subject: [PATCH 4.19 081/103] irqchip: Place CONFIG_SIFIVE_PLIC into the menu
Date:   Wed, 22 Jan 2020 10:29:37 +0100
Message-Id: <20200122092814.885385201@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092803.587683021@linuxfoundation.org>
References: <20200122092803.587683021@linuxfoundation.org>
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
@@ -371,8 +371,6 @@ config QCOM_PDC
 	  Power Domain Controller driver to manage and configure wakeup
 	  IRQs for Qualcomm Technologies Inc (QTI) mobile chips.
 
-endmenu
-
 config SIFIVE_PLIC
 	bool "SiFive Platform-Level Interrupt Controller"
 	depends on RISCV
@@ -384,3 +382,5 @@ config SIFIVE_PLIC
 	   interrupt sources are subordinate to the PLIC.
 
 	   If you don't know what to do here, say Y.
+
+endmenu


