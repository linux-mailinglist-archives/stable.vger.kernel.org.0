Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1B084B7131
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 17:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240554AbiBOPg3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 10:36:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240720AbiBOPf2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 10:35:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B307C12FF;
        Tue, 15 Feb 2022 07:31:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 387B2612D7;
        Tue, 15 Feb 2022 15:31:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F732C340EB;
        Tue, 15 Feb 2022 15:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644939070;
        bh=mkpPlGw8hV9sNXnauUZO4avIHLUkgLetqvwpAsmGNJQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ehO/QHXSL+AeY0CZCTFVcgdhoyPosutynvSwIB7oiELtJVzYomBngu1ib/Dysazyu
         NMcT5I6PoTsmFZp5ynlLHmkOkcRpgazI7727cvBRhUHVSfYrB1V9VhPEyf5xwKvENe
         ZHqiOGaBjpvxg5Jz2pjJh7swlgzvBbbHeVI4R6aHSRyOtjQZnSb+xxJdzDsTb0ucjz
         Hq/lkEi9wIcdTZZPok3Vf1fOvazG+KihcE/5oNtl6hNHBAqd5Zd72HMT65icoFnTW+
         eoYPEfPMICy6yt/kxjIWr8AE06trqn6QR32RUIa8ssf1ToQ2T7bRUe3AiBlGqX5+/m
         RyDg7bbtS+I9w==
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
Subject: [PATCH AUTOSEL 4.19 03/11] irqchip/sifive-plic: Add missing thead,c900-plic match string
Date:   Tue, 15 Feb 2022 10:30:56 -0500
Message-Id: <20220215153104.581786-3-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220215153104.581786-1-sashal@kernel.org>
References: <20220215153104.581786-1-sashal@kernel.org>
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
index 532e9d68c7042..767cdd3f773bb 100644
--- a/drivers/irqchip/irq-sifive-plic.c
+++ b/drivers/irqchip/irq-sifive-plic.c
@@ -258,3 +258,4 @@ static int __init plic_init(struct device_node *node,
 
 IRQCHIP_DECLARE(sifive_plic, "sifive,plic-1.0.0", plic_init);
 IRQCHIP_DECLARE(riscv_plic0, "riscv,plic0", plic_init); /* for legacy systems */
+IRQCHIP_DECLARE(thead_c900_plic, "thead,c900-plic", plic_init); /* for firmware driver */
-- 
2.34.1

