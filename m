Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48D9E45DF7D
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 18:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241890AbhKYRWL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 12:22:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242330AbhKYRUJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 12:20:09 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5139C0617A1;
        Thu, 25 Nov 2021 09:03:45 -0800 (PST)
Date:   Thu, 25 Nov 2021 17:03:42 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637859823;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tpVsjR3zyegXzOZgohbimQv3GNo2Sawwp0C78ebx4XA=;
        b=BPA/I84idx71oorBTAlt+y3BcqtBeUcMSppML+2dLGyShK9tcZ0ketaNvBWEqZwTScSKBA
        KRIjIgAbbm2rVt3rWSJ9o3kYMB3gtQ5hs+55kwaB8iyqE9w6bYOsdij4RZFugSQjaMgBnT
        bhYIwZWSGUhfFCsfBTvHc572MXe6hRwrylkbbsT6YOnKI1jxU0xE4/DlUX/YzIokH1tKA5
        OUAMPDcZPa6dBr/9t1hnDhciWcDMySQ4Rqc6+yQAC0vTCBExzDArM/6myvsa5tSfGqgZ2p
        uoCcIW3sx7fXFFeLyHFqU+LK5nQvJxWZ2+IOo/CG2+/VhGbl7cSQYdunoCkhyA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637859823;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tpVsjR3zyegXzOZgohbimQv3GNo2Sawwp0C78ebx4XA=;
        b=yAyN5VdZQA7mWghqOocitRfdrIC8nn5gM6cpbqtJJQDQsrIph+iZro5vXmxo+UV7lFCxnQ
        wuGV6PCfP9OuxnAQ==
From:   irqchip-bot for Pali =?utf-8?q?Roh=C3=A1r?= 
        <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-kernel@vger.kernel.org
Subject: [irqchip: irq/irqchip-fixes] irqchip/armada-370-xp: Fix return value
 of armada_370_xp_msi_alloc()
Cc:     pali@kernel.org, stable@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>, tglx@linutronix.de
In-Reply-To: <20211125130057.26705-1-pali@kernel.org>
References: <20211125130057.26705-1-pali@kernel.org>
MIME-Version: 1.0
Message-ID: <163785982212.11128.9032419198526293736.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the irq/irqchip-fixes branch of irq=
chip:

Commit-ID:     ce20eff57361e72878a772ef08b5239d3ae102b6
Gitweb:        https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platfo=
rms/ce20eff57361e72878a772ef08b5239d3ae102b6
Author:        Pali Roh=C3=A1r <pali@kernel.org>
AuthorDate:    Thu, 25 Nov 2021 14:00:56 +01:00
Committer:     Marc Zyngier <maz@kernel.org>
CommitterDate: Thu, 25 Nov 2021 16:49:38=20

irqchip/armada-370-xp: Fix return value of armada_370_xp_msi_alloc()

IRQ domain alloc function should return zero on success. Non-zero value
indicates failure.

Signed-off-by: Pali Roh=C3=A1r <pali@kernel.org>
Fixes: fcc392d501bd ("irqchip/armada-370-xp: Use the generic MSI infrastructu=
re")
Cc: stable@vger.kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20211125130057.26705-1-pali@kernel.org
---
 drivers/irqchip/irq-armada-370-xp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-armada-370-xp.c b/drivers/irqchip/irq-armada=
-370-xp.c
index 80906bf..41ad745 100644
--- a/drivers/irqchip/irq-armada-370-xp.c
+++ b/drivers/irqchip/irq-armada-370-xp.c
@@ -250,7 +250,7 @@ static int armada_370_xp_msi_alloc(struct irq_domain *dom=
ain, unsigned int virq,
 				    NULL, NULL);
 	}
=20
-	return hwirq;
+	return 0;
 }
=20
 static void armada_370_xp_msi_free(struct irq_domain *domain,
