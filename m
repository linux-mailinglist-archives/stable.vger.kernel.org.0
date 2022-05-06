Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B85751D698
	for <lists+stable@lfdr.de>; Fri,  6 May 2022 13:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391304AbiEFL3B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 May 2022 07:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391300AbiEFL3A (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 May 2022 07:29:00 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A08A56436;
        Fri,  6 May 2022 04:25:17 -0700 (PDT)
Date:   Fri, 06 May 2022 11:25:14 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1651836315;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SG0xDhrYsbMTMZvnzqXVgARUAputX5grlXdQ0OVHVvE=;
        b=DD+kHIJZoXWfHCrN5D77ljx51RKs2RDD/jhZAopstvLMd99jSeIPosaDt5u2ll5W9sIuUF
        BR89nLr5LInoFMtS50oJaNGnvoWYCEI/kwWmBAIWbLOmHZ5vpm5FeryluWhZc1kaHuWtxW
        xjUoMfqNVH8nTSckZbxeDrqfD2M7UZkyyi4tNX7fjSrKlSYghMVT4dbBSQhDxQ5Rcateci
        atpJc8lffpuyvSoOr/3VQXRypERA0bHFGuJbE9RscKBb7S4sg09SGejb0yfFSqRzsNOEFi
        uP40zJ660/8vOjpVy6cvRtmvRRCj8uc8bHgA9baGyUgdoCRbxnhM3rJ6pOE64A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1651836315;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SG0xDhrYsbMTMZvnzqXVgARUAputX5grlXdQ0OVHVvE=;
        b=8lRHAhOL0TucH6Xz8iMQtm9VNUEeUw4y5OdZLv4r14sFQvrGsvhA/52vH6sXZJ++QSz3yD
        P4k4Ila8PJqDtgDQ==
From:   irqchip-bot for Pali =?utf-8?q?Roh=C3=A1r?= 
        <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-kernel@vger.kernel.org
Subject: [irqchip: irq/irqchip-next] irqchip/armada-370-xp: Do not touch
 Performance Counter Overflow on A375, A38x, A39x
Cc:     pali@kernel.org, stable@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>, Marc Zyngier <maz@kernel.org>,
        tglx@linutronix.de
In-Reply-To: <20220425113706.29310-1-pali@kernel.org>
References: <20220425113706.29310-1-pali@kernel.org>
MIME-Version: 1.0
Message-ID: <165183631461.4207.8890709509221089065.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the irq/irqchip-next branch of irqc=
hip:

Commit-ID:     a3d66a76348daf559873f19afc912a2a7c2ccdaf
Gitweb:        https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platfo=
rms/a3d66a76348daf559873f19afc912a2a7c2ccdaf
Author:        Pali Roh=C3=A1r <pali@kernel.org>
AuthorDate:    Mon, 25 Apr 2022 13:37:05 +02:00
Committer:     Marc Zyngier <maz@kernel.org>
CommitterDate: Fri, 06 May 2022 12:18:37 +01:00

irqchip/armada-370-xp: Do not touch Performance Counter Overflow on A375, A38=
x, A39x

Register ARMADA_370_XP_INT_FABRIC_MASK_OFFS is Armada 370 and XP specific
and on new Armada platforms it has different meaning. It does not configure
Performance Counter Overflow interrupt masking. So do not touch this
register on non-A370/XP platforms (A375, A38x and A39x).

Signed-off-by: Pali Roh=C3=A1r <pali@kernel.org>
Cc: stable@vger.kernel.org
Fixes: 28da06dfd9e4 ("irqchip: armada-370-xp: Enable the PMU interrupts")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220425113706.29310-1-pali@kernel.org
---
 drivers/irqchip/irq-armada-370-xp.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-armada-370-xp.c b/drivers/irqchip/irq-armada=
-370-xp.c
index c877285..ee18eb3 100644
--- a/drivers/irqchip/irq-armada-370-xp.c
+++ b/drivers/irqchip/irq-armada-370-xp.c
@@ -327,7 +327,16 @@ static inline int armada_370_xp_msi_init(struct device_n=
ode *node,
=20
 static void armada_xp_mpic_perf_init(void)
 {
-	unsigned long cpuid =3D cpu_logical_map(smp_processor_id());
+	unsigned long cpuid;
+
+	/*
+	 * This Performance Counter Overflow interrupt is specific for
+	 * Armada 370 and XP. It is not available on Armada 375, 38x and 39x.
+	 */
+	if (!of_machine_is_compatible("marvell,armada-370-xp"))
+		return;
+
+	cpuid =3D cpu_logical_map(smp_processor_id());
=20
 	/* Enable Performance Counter Overflow interrupts */
 	writel(ARMADA_370_XP_INT_CAUSE_PERF(cpuid),
