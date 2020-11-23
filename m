Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEBEF2C1103
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 17:49:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388739AbgKWQqC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 11:46:02 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:37142 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387509AbgKWQqC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Nov 2020 11:46:02 -0500
Date:   Mon, 23 Nov 2020 16:45:58 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1606149960;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ogLvqf0Bj+toXu2RJnRnKoGi8YkpKVwa8dItBgaBt0s=;
        b=VOK+uSMRaOQm6tAmhHYFOz/hE/tQaqgYlcJRYAYRfLUd8IjuxtEE0ATbwdCny5FKmn5Dh/
        Ld1u83i47yFXyvYLFVlLEbXdVjQ2XMU+EF9amxFgvErm5IXcgaVDRSg7qmOHylCRTxG9fE
        W/HsYwTuK/VsopPtz8IaX5hvZ1NbNIL7QGZP8SGADF3BN3Lpo8UbUofoT72anoWAr4Plir
        czacpJmH8LrIkrb3H/T16fj7/1Fc1QzRTlm59VVrpavpVxymUvU1bQwi8X+uhF79Ml+Ez5
        +g0G0+vY5MW+l1Ia+/+3tR2bWVMhGV3wYSolq6+BISNXDRG22Ib+5aTqh1d5gw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1606149960;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ogLvqf0Bj+toXu2RJnRnKoGi8YkpKVwa8dItBgaBt0s=;
        b=pEKe16x3ji2a/Q74X1cZd1GzSjh/NlK0u7wOTXiTWFkKLHu036XKKY/p6X8HuQSKUxpcqo
        c6zYh0h8U1EUf2AA==
From:   "irqchip-bot for Chen Baozi" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-kernel@vger.kernel.org
Subject: [irqchip: irq/irqchip-next] irqchip/exiu: Fix the index of fwspec for
 IRQ type
Cc:     Chen Baozi <chenbaozi@phytium.com.cn>,
        Marc Zyngier <maz@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>, stable@vger.kernel.org,
        tglx@linutronix.de
In-Reply-To: <20201117032015.11805-1-cbz@baozis.org>
References: <20201117032015.11805-1-cbz@baozis.org>
MIME-Version: 1.0
Message-ID: <160614995899.11115.18133033549355488513.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam: Yes
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the irq/irqchip-next branch of irqchip:

Commit-ID:     d001e41e1b15716e9b759df5ef00510699f85282
Gitweb:        https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms/d001e41e1b15716e9b759df5ef00510699f85282
Author:        Chen Baozi <chenbaozi@phytium.com.cn>
AuthorDate:    Tue, 17 Nov 2020 11:20:15 +08:00
Committer:     Marc Zyngier <maz@kernel.org>
CommitterDate: Sun, 22 Nov 2020 10:27:23 

irqchip/exiu: Fix the index of fwspec for IRQ type

Since fwspec->param_count of ACPI node is two, the index of IRQ type
in fwspec->param[] should be 1 rather than 2.

Fixes: 3d090a36c8c8 ("irqchip/exiu: Implement ACPI support")
Signed-off-by: Chen Baozi <chenbaozi@phytium.com.cn>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://lore.kernel.org/r/20201117032015.11805-1-cbz@baozis.org
Cc: stable@vger.kernel.org
---
 drivers/irqchip/irq-sni-exiu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-sni-exiu.c b/drivers/irqchip/irq-sni-exiu.c
index 1d02762..abd011f 100644
--- a/drivers/irqchip/irq-sni-exiu.c
+++ b/drivers/irqchip/irq-sni-exiu.c
@@ -136,7 +136,7 @@ static int exiu_domain_translate(struct irq_domain *domain,
 		if (fwspec->param_count != 2)
 			return -EINVAL;
 		*hwirq = fwspec->param[0];
-		*type = fwspec->param[2] & IRQ_TYPE_SENSE_MASK;
+		*type = fwspec->param[1] & IRQ_TYPE_SENSE_MASK;
 	}
 	return 0;
 }
