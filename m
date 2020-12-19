Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA8922DEC55
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 01:22:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726209AbgLSAV7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Dec 2020 19:21:59 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:51770 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726004AbgLSAV7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Dec 2020 19:21:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1608337318; x=1639873318;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=7C1PBe/g/CkOPTuOpOWjCYxZlRKGKI8thmXJHPYZm3s=;
  b=GhwsQNkidQt7+xlJQReVkQdoh8PxYl3sJOMA/I9enBusKyolgfZKgUdY
   zoYCWIde2HDuJyvPIBhTy2ZosWRauS2l8agIzJ0m53Te7aWfariUfEYol
   lkQ1gjyRqABb48ZvGoXmRzxojEbM5FzNDBkbuq3zn08uusgY9+8dr/Op2
   NNtC89GU/JRiUwRK6ZUS2IdDvApxHLgr4ZaGP0uOUnZLWbg3BqgZr9MA6
   G8tYXz+TagdOK+p5GTgL/X4uZPcQHeWuT/3RZ6GF4+b9Yjuz46AOWxPuo
   Jv4HTiCJJTIA9+v2tWu4UOkpOmfRpdevJMh/sEFfn6ZtuwuMBNwS08ta8
   A==;
IronPort-SDR: anxTCCfC4EEcPEcPpyfyCbScDH2gusqdVN3vE6wKmXnTzSJG0sffgTwqn4VYGnMHGd2g423qAV
 2bV+g81JDGpAmpE7wxOIOIIjaMnBhJmEYnh0lLP4UK+njWwD3+97ESuM0Sj75DyI7mA1F8kWfD
 Fq306if6HAvvs8KJGJ6GR1sUSijOCQIMmy5JyD8dmy/rnUR/nJS+7ALbqe01tiUvQI7mCYxJ/L
 XtpfbqQ45D5GBJ5Z0dd/jL5qr2s+xBIbxtcEdBCd8pQn+SiaFt0PfJ/Qz2N/sC9Jk2PIghgKHz
 NZc=
X-IronPort-AV: E=Sophos;i="5.78,431,1599494400"; 
   d="scan'208";a="265735619"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 19 Dec 2020 08:20:53 +0800
IronPort-SDR: vh9+BLnls7Q9KLTr2QeaI8IlzG/dAjffaQf8bAP3un/Td6R0TAdbwOEEOLj9RaKRH4uZ3TY5ux
 6gaFH46PB8PHB5eNHU0Ye6QwlUxQGfJtUYHDkZAoSdzbruS+AkAz8zs6E6d6yeyPfSWw+x2Yqo
 AN0JOFfKWekMDcqvLnwrpUoAFtgphqkA38vvPjedC6TyIq8TrQqR0C4KSsskiXhGQwrOO7DAYE
 4oOm/k1EupZZK+yDDdZCLQMjEYsdt4XSWX24Ij3B6hZT7tEr3KqBX/wYRAT7WkdzzENqs/3ACR
 vyI1VFyGLBqquKLtJQveCfO8
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2020 16:06:07 -0800
IronPort-SDR: xR/9wNPK7kuxjRf6DRiNJ8vndBCwTpioqV3v3byi+29ye+6JTgK8DVeesgKephW/6LUn0g9aW8
 q0EiM2E0PCMX4kPKYmCWJE8ypCpP1Xqes+g136i0I7XGJTR+DeKUnZVGLDe53BC+ZBZ20beNdB
 xTWwFklYraqou2TPCF7KzSthg2zDy/3c1Wp9Z85TZmQoy8nNt8Mmc1Ox9zSkZtBVQOjXYKwDzp
 b3RiPYuqi6bm+ZCyPhv043Lf9PdHWeLegTg3q8u2ptW8oYBK0x7CsRuVAXF2kU/eSKquxR5SgI
 DWk=
WDCIronportException: Internal
Received: from cnf009746.ad.shared (HELO jedi-01.hgst.com) ([10.86.62.26])
  by uls-op-cesaip02.wdc.com with ESMTP; 18 Dec 2020 16:20:54 -0800
From:   Atish Patra <atish.patra@wdc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atish.patra@wdc.com>, stable@vger.kernel.org,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup.patel@wdc.com>,
        Guo Ren <guoren@linux.alibaba.com>,
        linux-riscv@lists.infradead.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>
Subject: [PATCH] riscv: Trace irq on only interrupt is enabled
Date:   Fri, 18 Dec 2020 16:20:51 -0800
Message-Id: <20201219002051.2891577-1-atish.patra@wdc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We should call irq trace only if interrupt is going to be enabled during
excecption handling. Otherwise, it results in following warning during
boot with lock debugging enabled.

[    0.000000] ------------[ cut here ]------------
[    0.000000] DEBUG_LOCKS_WARN_ON(early_boot_irqs_disabled)
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/locking/lockdep.c:4085 lockdep_hardirqs_on_prepare+0x22a/0x22e
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 5.10.0-00022-ge20097fb37e2-dirty #548
[    0.000000] epc: c005d5d4 ra : c005d5d4 sp : c1c01e80
[    0.000000]  gp : c1d456e0 tp : c1c0a980 t0 : 00000000
[    0.000000]  t1 : ffffffff t2 : 00000000 s0 : c1c01ea0
[    0.000000]  s1 : c100f360 a0 : 0000002d a1 : c00666ee
[    0.000000]  a2 : 00000000 a3 : 00000000 a4 : 00000000
[    0.000000]  a5 : 00000000 a6 : c1c6b390 a7 : 3ffff00e
[    0.000000]  s2 : c2384fe8 s3 : 00000000 s4 : 00000001
[    0.000000]  s5 : c1c0a980 s6 : c1d48000 s7 : c1613b4c
[    0.000000]  s8 : 00000fff s9 : 80000200 s10: c1613b40
[    0.000000]  s11: 00000000 t3 : 00000000 t4 : 00000000
[    0.000000]  t5 : 00000001 t6 : 00000000

Fixes: 3c4697982982 ("riscv:Enable LOCKDEP_SUPPORT & fixup TRACE_IRQFLAGS_SUPPORT")
Cc: stable@vger.kernel.org

Signed-off-by: Atish Patra <atish.patra@wdc.com>
---
 arch/riscv/kernel/entry.S | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/kernel/entry.S b/arch/riscv/kernel/entry.S
index 524d918f3601..7dea5ee5a3ac 100644
--- a/arch/riscv/kernel/entry.S
+++ b/arch/riscv/kernel/entry.S
@@ -124,15 +124,15 @@ skip_context_tracking:
 	REG_L a1, (a1)
 	jr a1
 1:
-#ifdef CONFIG_TRACE_IRQFLAGS
-	call trace_hardirqs_on
-#endif
 	/*
 	 * Exceptions run with interrupts enabled or disabled depending on the
 	 * state of SR_PIE in m/sstatus.
 	 */
 	andi t0, s1, SR_PIE
 	beqz t0, 1f
+#ifdef CONFIG_TRACE_IRQFLAGS
+	call trace_hardirqs_on
+#endif
 	csrs CSR_STATUS, SR_IE
 
 1:
-- 
2.25.1

