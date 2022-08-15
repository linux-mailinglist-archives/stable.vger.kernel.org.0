Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFED3593E33
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345650AbiHOUhT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345149AbiHOUfT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:35:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBFE3371A9;
        Mon, 15 Aug 2022 12:06:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91CBCB81104;
        Mon, 15 Aug 2022 19:06:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC26DC433C1;
        Mon, 15 Aug 2022 19:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590384;
        bh=CBgb56HFKBmdWIWJ/wiKMtuMrogElOROawwgv/vqOZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yWJbzjvrDSJcqTgOPu/wmgfy2ksplL9vrknXwdakFAHj8hL/Yl/GHBs2UBGxcIHW7
         OxJybGhwsLchzn9cxLoVCtqn6r2xmFT11nGqS1jzDuV9VuzXGo3kOLOgV6/a8SIyBT
         kYPrXAVIhZtdnTs+c4quu0M830kxvx/7lDrXU21k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julia Lawall <Julia.Lawall@inria.fr>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0243/1095] ia64: fix typos in comments
Date:   Mon, 15 Aug 2022 19:54:02 +0200
Message-Id: <20220815180439.831224468@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Julia Lawall <Julia.Lawall@inria.fr>

[ Upstream commit 0af96a024f524a5318485cbada73ab7d874895d4 ]

Various spelling mistakes in comments.
Detected with the help of Coccinelle.

Link: https://lkml.kernel.org/r/20220318103729.157574-1-Julia.Lawall@inria.fr
Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/ia64/kernel/palinfo.c | 2 +-
 arch/ia64/kernel/traps.c   | 2 +-
 arch/ia64/mm/init.c        | 2 +-
 arch/ia64/mm/tlb.c         | 4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/ia64/kernel/palinfo.c b/arch/ia64/kernel/palinfo.c
index 64189f04c1a4..b9ae093bfe37 100644
--- a/arch/ia64/kernel/palinfo.c
+++ b/arch/ia64/kernel/palinfo.c
@@ -120,7 +120,7 @@ static const char *mem_attrib[]={
  * Input:
  *	- a pointer to a buffer to hold the string
  *	- a 64-bit vector
- * Ouput:
+ * Output:
  *	- a pointer to the end of the buffer
  *
  */
diff --git a/arch/ia64/kernel/traps.c b/arch/ia64/kernel/traps.c
index 753642366e12..53735b1d1be3 100644
--- a/arch/ia64/kernel/traps.c
+++ b/arch/ia64/kernel/traps.c
@@ -309,7 +309,7 @@ handle_fpu_swa (int fp_fault, struct pt_regs *regs, unsigned long isr)
 			/*
 			 * Lower 4 bits are used as a count. Upper bits are a sequence
 			 * number that is updated when count is reset. The cmpxchg will
-			 * fail is seqno has changed. This minimizes mutiple cpus
+			 * fail is seqno has changed. This minimizes multiple cpus
 			 * resetting the count.
 			 */
 			if (current_jiffies > last.time)
diff --git a/arch/ia64/mm/init.c b/arch/ia64/mm/init.c
index 5d165607bf35..7ae1244ed8ec 100644
--- a/arch/ia64/mm/init.c
+++ b/arch/ia64/mm/init.c
@@ -451,7 +451,7 @@ mem_init (void)
 	memblock_free_all();
 
 	/*
-	 * For fsyscall entrpoints with no light-weight handler, use the ordinary
+	 * For fsyscall entrypoints with no light-weight handler, use the ordinary
 	 * (heavy-weight) handler, but mark it by setting bit 0, so the fsyscall entry
 	 * code can tell them apart.
 	 */
diff --git a/arch/ia64/mm/tlb.c b/arch/ia64/mm/tlb.c
index 135b5135cace..ca060e7a2a46 100644
--- a/arch/ia64/mm/tlb.c
+++ b/arch/ia64/mm/tlb.c
@@ -174,7 +174,7 @@ __setup("nptcg=", set_nptcg);
  * override table (in which case we should ignore the value from
  * PAL_VM_SUMMARY).
  *
- * Kernel parameter "nptcg=" overrides maximum number of simultanesous ptc.g
+ * Kernel parameter "nptcg=" overrides maximum number of simultaneous ptc.g
  * purges defined in either PAL_VM_SUMMARY or PAL override table. In this case,
  * we should ignore the value from either PAL_VM_SUMMARY or PAL override table.
  *
@@ -516,7 +516,7 @@ int ia64_itr_entry(u64 target_mask, u64 va, u64 pte, u64 log_size)
 	if (i >= per_cpu(ia64_tr_num, cpu))
 		return -EBUSY;
 
-	/*Record tr info for mca hander use!*/
+	/*Record tr info for mca handler use!*/
 	if (i > per_cpu(ia64_tr_used, cpu))
 		per_cpu(ia64_tr_used, cpu) = i;
 
-- 
2.35.1



