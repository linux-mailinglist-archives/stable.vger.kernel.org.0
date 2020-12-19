Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25AC92DEC4B
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 01:15:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725287AbgLSAPG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Dec 2020 19:15:06 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:18444 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbgLSAPF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Dec 2020 19:15:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1608336905; x=1639872905;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=qlA8wVBPQMAANB3GBWMbUoKFu0jCd9V1TTnxbjRptVE=;
  b=orEd1bUX7yPS51q465iDf/H0xs0NtbIM/Xd095BzN2U88OkDqqGMpskW
   T8yum5jjDyt9R/j10PZQIKT+I3F4VMgj77K228SY+PJaY4ROYVL5+9jYV
   B1eklVrlglsOPcD5N01/aoxGZNEOeknmvMmHm9NUA+SswKBxNCztsKiLT
   Al3A7+MM+HW4JEtOFxKYetG+iYZ4qFzXmZFO9l3dDKHBcfNNlM10M1bu+
   kFu0Ob6UFrFE1eTxXLFO/rfH7uGs2PJW5koVgCeWH2VQdKCSDSmKmIWTN
   J0QcdAumK9VK8CsY9qn/2aocL9EBEL11AekAthqJQczNEsSpsXdvqmTuh
   g==;
IronPort-SDR: pR05DOFXl4viZEZG0UiBMm68t2KYsJ6tSjcq3jruHUpgAjXDQHm2eU1uHEyc9/DUhmVWUzsKYU
 94ty0tdUAEt9VG1HcznCrpnHMxw06yJq4wRWWWSvaopgDEBFnvxY001oL3aVzJi3phhnwnoqYj
 BRrBI7dWKKbcYir7VIpDL+RLzNEfJZUHVFGFyhrt/2O/T9xYOSxdY8EDnSJAf9J7q+n37lgxnR
 K++RPxNDeJuUSjNjJtNYJBkDNyH6i1lItJ5pguaNcYVc0tUAYRtvYnb7ee08iLTxgLoO06zoHz
 Too=
X-IronPort-AV: E=Sophos;i="5.78,431,1599494400"; 
   d="scan'208";a="155556594"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 19 Dec 2020 08:13:59 +0800
IronPort-SDR: RZJrYHJf1yM9b7+GDFCYB02QTTwDGv2mi1/1V3uW9XG4dw3T/PzBsTLdOj8ON1FlgTgUwQ298l
 JKottS0K7bX1yz9W+IOqdv9m6SXrBTq3nca0JFxFykt99xV4cmgaOFixx6ir+jQYko5PdbJwhA
 lo7c9u1cnUZMcSyQVCI/kXBLktT9iM74r9Pjml9YUBsnrHdlBE/ucLzy8ztFLEY1DEPhtZz+Ez
 7Mp9aehbY4MCqc3CRs6ZVXnGSqPZxdj0yaf1HT9sqZXMq0anYdzHjNGK6iaI1SlS5WlR7LFvrz
 vEHuWz9wiqohHiWyxwgIE1gD
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2020 15:59:14 -0800
IronPort-SDR: 6d/6ygrnX1yCCBilFFyUWFPZTNYhYNlq4sBOFOEotphNj/FE7NISXMQhQ3bMV8BkNncDGWRasv
 XSC0e9XwPgoqtU10GzCtaz6rzTnTvSdVXkFGVWBlxQT18yut9LUnbx2GqgrKdQl7LE+CgGukbw
 oX+g+IsuitkPV8VbGTVxu2fVt2erlBkQ7SZ9wSMNekkp1Id+4DeEEq+V6xaJZ9D5WFtC5tM+l6
 fAGrwpstglEYIbW1x4ln3ElFHo4RIAQpDXQvnO3R0aQiILDd3yBzc7iFC1HuCyJ5hlDIwZAEhF
 xuQ=
WDCIronportException: Internal
Received: from cnf009746.ad.shared (HELO jedi-01.hgst.com) ([10.86.62.26])
  by uls-op-cesaip01.wdc.com with ESMTP; 18 Dec 2020 16:14:00 -0800
From:   Atish Patra <atish.patra@wdc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atish.patra@wdc.com>, stable@vger.kernel.org,
        Bin Meng <bin.meng@windriver.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anup Patel <anup.patel@wdc.com>,
        linux-riscv@lists.infradead.org, Mike Rapoport <rppt@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Bin Meng <bmeng.cn@gmail.com>
Subject: [PATCH v2] RISC-V: Fix usage of memblock_enforce_memory_limit
Date:   Fri, 18 Dec 2020 16:13:56 -0800
Message-Id: <20201219001356.2887782-1-atish.patra@wdc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

memblock_enforce_memory_limit accepts the maximum memory size not the
maximum address that can be handled by kernel. Fix the function invocation
accordingly.

Fixes: 1bd14a66ee52 ("RISC-V: Remove any memblock representing unusable memory area")
Cc: stable@vger.kernel.org

Reported-by: Bin Meng <bin.meng@windriver.com>
Tested-by: Bin Meng <bin.meng@windriver.com>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Atish Patra <atish.patra@wdc.com>
---
Changes from v1->v2:
1. Added stable-kernel in cc.
2. Added reported/tested by tag.
---
 arch/riscv/mm/init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 13ba533f462b..bf5379135e39 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -176,7 +176,7 @@ void __init setup_bootmem(void)
 	 * Make sure that any memory beyond mem_start + (-PAGE_OFFSET) is removed
 	 * as it is unusable by kernel.
 	 */
-	memblock_enforce_memory_limit(mem_start - PAGE_OFFSET);
+	memblock_enforce_memory_limit(-PAGE_OFFSET);
 
 	/* Reserve from the start of the kernel to the end of the kernel */
 	memblock_reserve(vmlinux_start, vmlinux_end - vmlinux_start);
-- 
2.25.1

