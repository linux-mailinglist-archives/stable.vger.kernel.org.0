Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12E585E5A0
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 15:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbfGCNjy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 09:39:54 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:59463 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbfGCNjy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jul 2019 09:39:54 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue009 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MqJuN-1iMuBq47Zz-00nPRK; Wed, 03 Jul 2019 15:39:42 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Vineet Gupta <vgupta@synopsys.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, stable@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        linux-snps-arc@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARC: hide unused function unw_hdr_alloc
Date:   Wed,  3 Jul 2019 15:39:25 +0200
Message-Id: <20190703133940.1493249-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:19QUxxa2AQhjXJXGFQ5Q+GWQGKQpXLF1YnY0kSDAfj0P2T9ssZX
 KP1PGWvi3sji27vCh04S+/7UxT27Re9y7MeU/xKlL8Bjv1bn2w0vxhZZ8oJfhHHdcA2fxdF
 uLcw+cr1B5nNIxLjOPdAH3tAIYR+uY6I2hcm2kFsB8xTP4vs0rEA+R2IMqqp5+OrYuFTB5m
 oF4/yjAjt2+QLbnvy6iUw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:rSO0Zk6wSks=:O5FU+OCGc/n3MF1WRuERet
 N+T013OT4nT/b/BNJdnpri/rYumtNGDRxds9DEriW8Z2/89cU0GAHIfwQLmhqUBzCg0NNN1jv
 FC1Zfub8dCxhTmodAu3ioF95hCdpjySCzYH+RxJoUc1Fw69ikpDXcog6UbTzip7GIzqWSKq71
 MvJfHiEKCZV/52tLXZEdjvl0Us0mbJQuqZSG9jHMYppsjkUZ4ZtJoAcdfwHxgaxcohOSWFQRR
 mBQEu8t95sNMh7DdzDQpZxM2Vvx6n/pn/pzCE4Gvjrx8mgCTlTjPtKGw/qDP2GhncCoXdoQ0G
 9lV9EWS8pj1kkFSlE1Bd90ceUosFELdBbzUewjVGS45zd/qr1tBOg6gzr/cvBvLGPY3gKh94c
 6YU7vmKbfX6/fWDoeN7cSciujC5hSoliTYVHspNOyD2Wz3Tf0xG6pRDaRpNe+O7tjP++cA04I
 nNEERofGBsALOoTaGNtkQwJzKkMUI6euN60SQSo0CBoomjfjWO10T05LB6lBA8uXvHYrTen9L
 TQFej/9Kkwaiy+LhaOq2XbzJ9jAmGW2uLexkBwTOTY6v9iKzVVAoC7KtOvhAKcJ0oXrEH6V7F
 E5iYJdywcpi0XxUxKAZGQBTfWH747p7NkZRqzEG4m4Vy/SceBIepg49PpbRyuPS6m8SZ3T9AZ
 M+871n3IVrgeiw6xWY53L63dHCLvBEMiClToo70zDzhakbMUhyxubxeIXyf4PqAPVeSUSmKtI
 q/GsbY6oCZ0j+n6gAYp1uBHtx6jmjctUoXoalQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As kernelci.org reports, this function is not used in
vdk_hs38_defconfig:

arch/arc/kernel/unwind.c:188:14: warning: 'unw_hdr_alloc' defined but not used [-Wunused-function]

Fixes: bc79c9a72165 ("ARC: dw2 unwind: Reinstante unwinding out of modules")
Link: https://kernelci.org/build/id/5d1cae3f59b514300340c132/logs/
Cc: stable@vger.kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arc/kernel/unwind.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/arc/kernel/unwind.c b/arch/arc/kernel/unwind.c
index 182ce67dfe10..c2663fce7f6c 100644
--- a/arch/arc/kernel/unwind.c
+++ b/arch/arc/kernel/unwind.c
@@ -181,11 +181,6 @@ static void *__init unw_hdr_alloc_early(unsigned long sz)
 	return memblock_alloc_from(sz, sizeof(unsigned int), MAX_DMA_ADDRESS);
 }
 
-static void *unw_hdr_alloc(unsigned long sz)
-{
-	return kmalloc(sz, GFP_KERNEL);
-}
-
 static void init_unwind_table(struct unwind_table *table, const char *name,
 			      const void *core_start, unsigned long core_size,
 			      const void *init_start, unsigned long init_size,
@@ -366,6 +361,10 @@ static void init_unwind_hdr(struct unwind_table *table,
 }
 
 #ifdef CONFIG_MODULES
+static void *unw_hdr_alloc(unsigned long sz)
+{
+	return kmalloc(sz, GFP_KERNEL);
+}
 
 static struct unwind_table *last_table;
 
-- 
2.20.0

