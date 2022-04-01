Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C368E4EF0B8
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 16:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348049AbiDAOhE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:37:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347391AbiDAOcW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:32:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A0F35F8F8;
        Fri,  1 Apr 2022 07:28:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA93E61CAE;
        Fri,  1 Apr 2022 14:28:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86548C34114;
        Fri,  1 Apr 2022 14:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823318;
        bh=qjxQ+TuJJClyKJGiJyDQnjheZO2HcHaN/3KsyeKu5cY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hGAzgIKSkvZi5K292zCw0hRaxrHSzBc/IyoXcMvSLWPrSCcu1F87ueVE/f7Obrj/H
         j1mjy4vOI5QShCks9Maf7NGs2FOcXW2n0ZCpeiQGyXiPumqB6P+dN/OrtEBRyREckW
         JokuByKkfghKwpDwk3ZryDlPx/0YM+2rZgJs0zEkmkwCAjME3PldGLYJBycvrJxqrA
         EpUIvMdIic8N/qOkc0TwSUbJhlQyJEUBVPGieeOsiYgHaz3/og0JqMFMyjgoY5NH1Z
         oGlpBZIC97hVgVwhU0thbj9/ynhTTpIsK+kEwnDnbBLb8RKvQ5308/OSg2gQxZ541t
         XDp7rsaNgMsHQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>,
        pbonzini@redhat.com, shuah@kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 055/149] kvm: selftests: aarch64: fix some vgic related comments
Date:   Fri,  1 Apr 2022 10:24:02 -0400
Message-Id: <20220401142536.1948161-55-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401142536.1948161-1-sashal@kernel.org>
References: <20220401142536.1948161-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ricardo Koller <ricarkol@google.com>

[ Upstream commit a5cd38fd9c47b23abc6df08d6ee6a71b39038185 ]

Fix the formatting of some comments and the wording of one of them (in
gicv3_access_reg).

Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reported-by: Reiji Watanabe <reijiw@google.com>
Cc: Andrew Jones <drjones@redhat.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220127030858.3269036-5-ricarkol@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kvm/aarch64/vgic_irq.c   | 12 ++++++++----
 tools/testing/selftests/kvm/lib/aarch64/gic_v3.c | 10 ++++++----
 tools/testing/selftests/kvm/lib/aarch64/vgic.c   |  3 ++-
 3 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
index 48e43e24d240..554ca649d470 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
@@ -306,7 +306,8 @@ static void guest_restore_active(struct test_args *args,
 	uint32_t prio, intid, ap1r;
 	int i;
 
-	/* Set the priorities of the first (KVM_NUM_PRIOS - 1) IRQs
+	/*
+	 * Set the priorities of the first (KVM_NUM_PRIOS - 1) IRQs
 	 * in descending order, so intid+1 can preempt intid.
 	 */
 	for (i = 0, prio = (num - 1) * 8; i < num; i++, prio -= 8) {
@@ -315,7 +316,8 @@ static void guest_restore_active(struct test_args *args,
 		gic_set_priority(intid, prio);
 	}
 
-	/* In a real migration, KVM would restore all GIC state before running
+	/*
+	 * In a real migration, KVM would restore all GIC state before running
 	 * guest code.
 	 */
 	for (i = 0; i < num; i++) {
@@ -503,7 +505,8 @@ static void guest_code(struct test_args *args)
 		test_injection_failure(args, f);
 	}
 
-	/* Restore the active state of IRQs. This would happen when live
+	/*
+	 * Restore the active state of IRQs. This would happen when live
 	 * migrating IRQs in the middle of being handled.
 	 */
 	for_each_supported_activate_fn(args, set_active_fns, f)
@@ -844,7 +847,8 @@ int main(int argc, char **argv)
 		}
 	}
 
-	/* If the user just specified nr_irqs and/or gic_version, then run all
+	/*
+	 * If the user just specified nr_irqs and/or gic_version, then run all
 	 * combinations.
 	 */
 	if (default_args) {
diff --git a/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
index e4945fe66620..263bf3ed8fd5 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
@@ -19,7 +19,7 @@ struct gicv3_data {
 	unsigned int nr_spis;
 };
 
-#define sgi_base_from_redist(redist_base) 	(redist_base + SZ_64K)
+#define sgi_base_from_redist(redist_base)	(redist_base + SZ_64K)
 #define DIST_BIT				(1U << 31)
 
 enum gicv3_intid_range {
@@ -105,7 +105,8 @@ static void gicv3_set_eoi_split(bool split)
 {
 	uint32_t val;
 
-	/* All other fields are read-only, so no need to read CTLR first. In
+	/*
+	 * All other fields are read-only, so no need to read CTLR first. In
 	 * fact, the kernel does the same.
 	 */
 	val = split ? (1U << 1) : 0;
@@ -160,8 +161,9 @@ static void gicv3_access_reg(uint32_t intid, uint64_t offset,
 
 	GUEST_ASSERT(bits_per_field <= reg_bits);
 	GUEST_ASSERT(!write || *val < (1U << bits_per_field));
-	/* Some registers like IROUTER are 64 bit long. Those are currently not
-	 * supported by readl nor writel, so just asserting here until then.
+	/*
+	 * This function does not support 64 bit accesses. Just asserting here
+	 * until we implement readq/writeq.
 	 */
 	GUEST_ASSERT(reg_bits == 32);
 
diff --git a/tools/testing/selftests/kvm/lib/aarch64/vgic.c b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
index f5cd0c536d85..7c876ccf9294 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/vgic.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
@@ -152,7 +152,8 @@ static void vgic_poke_irq(int gic_fd, uint32_t intid,
 		attr += SZ_64K;
 	}
 
-	/* All calls will succeed, even with invalid intid's, as long as the
+	/*
+	 * All calls will succeed, even with invalid intid's, as long as the
 	 * addr part of the attr is within 32 bits (checked above). An invalid
 	 * intid will just make the read/writes point to above the intended
 	 * register space (i.e., ICPENDR after ISPENDR).
-- 
2.34.1

