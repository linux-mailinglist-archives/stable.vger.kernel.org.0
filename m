Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1649A3D543D
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 09:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232299AbhGZGqq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 02:46:46 -0400
Received: from mail.loongson.cn ([114.242.206.163]:58700 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231946AbhGZGqg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 02:46:36 -0400
Received: from ambrosehua-HP-xw6600-Workstation.lan (unknown [222.209.10.128])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9DxH+O4Y_5g+_YjAA--.25209S3;
        Mon, 26 Jul 2021 15:26:54 +0800 (CST)
From:   Huang Pei <huangpei@loongson.cn>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        ambrosehua@gmail.com
Cc:     Bibo Mao <maobibo@loongson.cn>, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Li Xuefeng <lixuefeng@loongson.cn>,
        Yang Tiezhu <yangtiezhu@loongson.cn>,
        Gao Juxin <gaojuxin@loongson.cn>,
        Huacai Chen <chenhuacai@loongson.cn>,
        Jinyang He <hejinyang@loongson.cn>
Subject: [PATCH] Revert "MIPS: add PMD table accounting into MIPS'pmd_alloc_one"
Date:   Mon, 26 Jul 2021 15:26:42 +0800
Message-Id: <20210726072642.551510-2-huangpei@loongson.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210726072642.551510-1-huangpei@loongson.cn>
References: <20210726072642.551510-1-huangpei@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf9DxH+O4Y_5g+_YjAA--.25209S3
X-Coremail-Antispam: 1UD129KBjvdXoWrZw47WFW7XrW5Ary7Ww1kGrg_yoWkGFc_Ca
        y29w4Fgry8XryF9ry7W393WFyj934v9a1kuFnYqa9Iya4UAr4kXa1kKwnxAry09rW3CrWf
        uFZ5Cr1xGFn3KjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbyxFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUGwA2048vs2IY02
        0Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xv
        wVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM2
        8EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
        0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
        IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
        Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
        xKxwCY02Avz4vE14v_GF4l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l
        x2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14
        v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IY
        x2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87
        Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIF
        yTuYvjfU173kDUUUU
X-CM-SenderInfo: xkxd0whshlqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 002d8b395fa1c0679fc3c3e68873de6c1cc300a2.

Commit b2b29d6d011944 (mm: account PMD tables like PTE tables) is
introduced between v5.9 and v5.10, so this fix (commit 002d8b395fa1)
should NOT apply to any pre-5.10 branch.

Signed-off-by: Huang Pei <huangpei@loongson.cn>
---
 arch/mips/include/asm/pgalloc.h | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/mips/include/asm/pgalloc.h b/arch/mips/include/asm/pgalloc.h
index dd10854321ca..166842337eb2 100644
--- a/arch/mips/include/asm/pgalloc.h
+++ b/arch/mips/include/asm/pgalloc.h
@@ -62,15 +62,11 @@ do {							\
 
 static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address)
 {
-	pmd_t *pmd = NULL;
-	struct page *pg;
+	pmd_t *pmd;
 
-	pg = alloc_pages(GFP_KERNEL | __GFP_ACCOUNT, PMD_ORDER);
-	if (pg) {
-		pgtable_pmd_page_ctor(pg);
-		pmd = (pmd_t *)page_address(pg);
+	pmd = (pmd_t *) __get_free_pages(GFP_KERNEL, PMD_ORDER);
+	if (pmd)
 		pmd_init((unsigned long)pmd, (unsigned long)invalid_pte_table);
-	}
 	return pmd;
 }
 
-- 
2.25.1

