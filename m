Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA5E44B725E
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 17:42:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbiBOPff (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 10:35:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240619AbiBOPfC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 10:35:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B27F9C086A;
        Tue, 15 Feb 2022 07:30:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5FAF7B81AF1;
        Tue, 15 Feb 2022 15:30:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCD90C340F1;
        Tue, 15 Feb 2022 15:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644939045;
        bh=D+Ib7wkm+pUgHIFpFkgZMNVJA3CmXTMDtP5x7u0Q6fc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=owPH6hmPWgvIdleQTPHeC+UH3qazJQhmAMW0/iHVsMrNXy6srvK6bNgPucWwa8P/h
         7SPgL3FJvp+riQ28IRFTOuC/jW5ikNphqQ3wM3Zluh3ocx4iD7uRJ3lejB5Etk9qTZ
         9t4lJ2NagG2ivfdy6ElShWKv3khXkeccOmqBfwQ3JkwpH6pEuooRKrHkpv8QElJQjo
         JXABGCdDPwIijvOOGNNu6S/SZAlA/euuNZr32qmazsMoCAxuFXgMVBlVfqw8KxnEFt
         zP1LAKG826EQJV8V3Uf9eYQ9jGpmR9g3OFkIHQYkOglLhNDOPKz001AG/Y6YuCUASn
         x4r+s1H0r/NMg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guo Ren <guoren@linux.alibaba.com>,
        Anup Patel <anup@brainfault.org>,
        Marc Zyngier <maz@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Samuel Holland <samuel@sholland.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>, paul.walmsley@sifive.com,
        aou@eecs.berkeley.edu, linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 04/17] irqchip/sifive-plic: Add missing thead,c900-plic match string
Date:   Tue, 15 Feb 2022 10:30:24 -0500
Message-Id: <20220215153037.581579-4-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220215153037.581579-1-sashal@kernel.org>
References: <20220215153037.581579-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guo Ren <guoren@linux.alibaba.com>

[ Upstream commit 1d4df649cbb4b26d19bea38ecff4b65b10a1bbca ]

The thead,c900-plic has been used in opensbi to distinguish
PLIC [1]. Although PLICs have the same behaviors in Linux,
they are different hardware with some custom initializing in
firmware(opensbi).

Qute opensbi patch commit-msg by Samuel:

  The T-HEAD PLIC implementation requires setting a delegation bit
  to allow access from S-mode. Now that the T-HEAD PLIC has its own
  compatible string, set this bit automatically from the PLIC driver,
  instead of reaching into the PLIC's MMIO space from another driver.

[1]: https://github.com/riscv-software-src/opensbi/commit/78c2b19218bd62653b9fb31623a42ced45f38ea6

Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Cc: Anup Patel <anup@brainfault.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Samuel Holland <samuel@sholland.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Samuel Holland <samuel@sholland.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220130135634.1213301-3-guoren@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-sifive-plic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/irqchip/irq-sifive-plic.c b/drivers/irqchip/irq-sifive-plic.c
index 7cd7b140dfe97..9dad45d928bfe 100644
--- a/drivers/irqchip/irq-sifive-plic.c
+++ b/drivers/irqchip/irq-sifive-plic.c
@@ -313,3 +313,4 @@ static int __init plic_init(struct device_node *node,
 
 IRQCHIP_DECLARE(sifive_plic, "sifive,plic-1.0.0", plic_init);
 IRQCHIP_DECLARE(riscv_plic0, "riscv,plic0", plic_init); /* for legacy systems */
+IRQCHIP_DECLARE(thead_c900_plic, "thead,c900-plic", plic_init); /* for firmware driver */
-- 
2.34.1

