Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BFF06B8E74
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 10:19:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbjCNJTf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 05:19:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbjCNJTd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 05:19:33 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2106.outbound.protection.outlook.com [40.107.22.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75BEF97B6F
        for <stable@vger.kernel.org>; Tue, 14 Mar 2023 02:19:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gjiBuKtcEycLWB8cR7e3YlQ+g+fajU/cpTyIL1rA/ILlM6xeAV//MfsPPMeUXwh7dRgoiAYxS2KwPYW5/BUh7piE9tUCPu4A0fIca6fwESPh970kYzN4SCqiN5YCfnH6e/0TWekw1HGLeWytq+6uGVXV8l+H/HG1ROUCHLgtwH03+O0ypnoZhs5zdK4jALAxO2VUYciv6uJUFnaybFcd0Rzxzk7nlILdC5AWjQGsOSZgK1NCtnOegbLoR98Rtkz7zbn3VkawwYUPYdU9t2dWVCnd31YBLw5b0QMwkUD22bkTxeMNpt4hU5vA5/gPv9yZIUnqQEwCdOlIb0ZoJ2RFJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fmHnnGGjIAMNBo5Is3REMXnn/35bRzHf16aqGGJBR3g=;
 b=IX5HGCiUU8bh3Uv9KAho1OKZP61+yfAzchu8QE/AhlWkfcDgbGjsj296EcK62zJYjJMhv55qplrM0+Tdh7EpsaRh9vPpBGcnEWNrbiLI4unX/lWWmATh95xjSjojrAJ1sAiVpOGy317ic6YwIgYlI0fP5KlV24/WjNjMXEBZVCKainNIISTx2t+pP9GGW91fzEZ7SftuPJ+TuAZFdz5GWjNtyDMhZBbL0l2QSZ+kVUspMxm502JefSzBTialH9Fo4NsYQATU1DEPaQwGHQtjUz+encGwKhR67TynK+ahamvnTrxJlYV5TIVSZIrjmHBhBc5wqeyqUT+CWmEYr11VHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=uipath.com; dmarc=pass action=none header.from=uipath.com;
 dkim=pass header.d=uipath.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uipath.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fmHnnGGjIAMNBo5Is3REMXnn/35bRzHf16aqGGJBR3g=;
 b=Huu81XqHclGA3TBQu8SLygtcGiLDw+Saca6RuIfVJ84TyB6PpgG7OeV4ntxu7G/2N81o0Mlz7IrpOG2uxgHuh/gpnh3NG853Z/HMrormStyDoYy0GYXR32MSjt3Q/6QMcD+eCdist1h200HdVnNhrYyriKwu4jhuLb9Rn5Kvx4NGdzpxITNeGs4mtzDmcvWU/dZTkBEWyvbfNhHdXO8CTB4NmxyUe2J03nMfm7sRRM4GDPckQvbGR5QEndtbCh3EhTN3cfZ1YSpBpccNry4ZOWDjBMGrQ6cRHt1h9Cn/NVJJQLjNMdr8ql0UTiYtw9RbTuypdli7NOdtEJcco2EZUw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=uipath.com;
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com (2603:10a6:803:b1::28)
 by PA4PR02MB6543.eurprd02.prod.outlook.com (2603:10a6:102:fe::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Tue, 14 Mar
 2023 09:19:18 +0000
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::224e:d6bd:a174:9605]) by VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::224e:d6bd:a174:9605%6]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 09:19:18 +0000
From:   Alexandru Matei <alexandru.matei@uipath.com>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alexandru Matei <alexandru.matei@uipath.com>,
        Mihai Petrisor <mihai.petrisor@uipath.com>,
        Viorel Canja <viorel.canja@uipath.com>
Subject: [PATCH 5.10.y 3/3] KVM: VMX: Fix crash due to uninitialized current_vmcs
Date:   Tue, 14 Mar 2023 11:19:01 +0200
Message-Id: <20230314091901.2975-4-alexandru.matei@uipath.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230314091901.2975-1-alexandru.matei@uipath.com>
References: <167811889022881@kroah.com>
 <20230314091901.2975-1-alexandru.matei@uipath.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P194CA0050.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:803:3c::39) To VI1PR02MB4527.eurprd02.prod.outlook.com
 (2603:10a6:803:b1::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR02MB4527:EE_|PA4PR02MB6543:EE_
X-MS-Office365-Filtering-Correlation-Id: 4cceb31c-457c-43b4-52a6-08db246d3039
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lGN3lh820ZP0xIhqWkSFlzfG6cfWsj2j5PjikgoMM3IgGpsu/bMGxIV5ip1bz6XDx5mdSy1kQ0DOsI81/aOdaSCmNLylRm9yWmML8my3WnxQOFInd8Jqp3sTrgFLOW7+yDBnuit8OuNgk7sj2MMpKWVrWO4coNk+P0cDBL/o7kgv9hvbzGv6d297PnV0JzF2RLmDgPk6s2ax5N2Pwtn2C+ju0+5is3cyeG9S7/xfSi3CQnO4TdSg9lqOjRk8h9S2BbLobV4k2ltG/ahwwZZzCRRCkzbIB0NJ23IVTd/FHpxrISP14dFEewmx7FnXLOxygKX1L/3CUNCQQL0tGdjslL/7NesVh159g9r1DOx5TGyDSKGLYXS09Ch8Sd93Wo98YKVov1Uuh2hxIc1gqaJX7Xf/C8ZLg4c9S80nQyHF32lvstevNL3vEa7ya19fI62pPyCYToN105aLgSA3kFAdw6iG5hbxHbJ9To2Fft0RzgTo/k/BiJ+vRzZHhA1hNYJ6xAmFr5luw6lCRuFsd/ieS1MpeRETap8Jluj0xY1bkH0+j76jE42gjWmU36VxlLYvWsHpPBKcUv5Kf6EdfGL+EfbxDnBUQ+hDz6C1GL0wFDopFjQGAMtiF9PLbhpCsgt8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR02MB4527.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(39860400002)(366004)(376002)(136003)(451199018)(5660300002)(41300700001)(44832011)(2906002)(38100700002)(86362001)(36756003)(8936002)(478600001)(6486002)(66476007)(8676002)(66946007)(66556008)(966005)(107886003)(6666004)(6916009)(4326008)(83380400001)(54906003)(316002)(186003)(1076003)(26005)(6512007)(2616005)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NUgOSI55peiMLVN1XHxrVYlQq7aaatwNrvI+WAQ69ULJjEgA0mXjY/3RqajE?=
 =?us-ascii?Q?4xovRt5MbBN4S1Bb1HjB5bs3FaVaFAQMk/TV29AQbu0Q+mkzDZFzCwPZNioc?=
 =?us-ascii?Q?gMZW8XBaHE1E74xYCMrRXXntxUNg+fnNAtq/VRDki+cCUyIC6uoSqsl7ZJzp?=
 =?us-ascii?Q?Bh8Fu1tvVW6leVitnIbPo4T8p8lzZTZ9FWdsE0zGQIG6HvXTnSyEi3vc6AAM?=
 =?us-ascii?Q?pjxv1oHDkgW1g+TE5Sx20Uh6K+80sEFCTWq8DpFC0nNCCzx0j13Fz0fNXKXz?=
 =?us-ascii?Q?OFrtzVuh0AeDm4F3RFV47XLjLzToRG+hiW3UgHzyOAcv4NC7rkCA1o90S/pk?=
 =?us-ascii?Q?nfSwTarMYdXfS1gDcrrtVkpsuPkx5BA2ZYH2muGgz1CLTrDCCkea1hWRub1T?=
 =?us-ascii?Q?w/+VNWf1+5IqfM1Sp0lwzTzWj87twT1q1WdbfD2O8Q6nIQcItZVypde2Be/3?=
 =?us-ascii?Q?KFY3WIBTTjaQBfyOyaFEhDBopIv068+LIRV5Si3NYUquG2olNpd8KI4cz6rb?=
 =?us-ascii?Q?4XXWaAsS0HrCAbK4PV9vK4IWBiC3V7yi0dHzwJHrgsu8sUaEh0Zs4tfcJRiv?=
 =?us-ascii?Q?6EvvGNJcYBhsA3nVduxXj8s4R79HEi4xGT7fLZmuOXQSMV/1OtEv60VYcFBK?=
 =?us-ascii?Q?2cdejD1EQurC+Kkked196CmgThADIeWBCyeY4ZgwKdVLWwPgiXhdTPQRDu9i?=
 =?us-ascii?Q?ESx560rVPUHmKS3dfekyl4S+6JOFt11HqwzjmPGdCu1CqaAa+5iG/zBfpnNm?=
 =?us-ascii?Q?e325sgswaAcfMuoSIQj7CbGfZFTQqKMfhscXNCyGFleOwwJh/WsTQ0fA6Bu2?=
 =?us-ascii?Q?1cdQREunaFhH8RoyEuq1wugCE3QjMI+mw+TquWOoRlHBti2NROXAANYHlYW3?=
 =?us-ascii?Q?M0btIq24FtiwxZuRBgVzHaHlNgKSgfVPRPw7HKcQzGJdZkd4dIaqb+fl3G/P?=
 =?us-ascii?Q?EWZ8JjdxX61Qqy8gwSziUujktMpa8ynyI+UNn+b5i/qSV+cqDpS6MhbxLAtq?=
 =?us-ascii?Q?ejH63K1rC9xrWyujGpa5fzZIdQOliBGPJxaDU8Ui7qb7/zr1g0zLCxldqbIG?=
 =?us-ascii?Q?HuaKMXi1+Ctsw6+Jez61qGVSFVMI8II0IXtLZApVCPKhCTZHe1qVGqXoUhL8?=
 =?us-ascii?Q?4lurPjoo/dl1IRm5qIA7v8nniR4P2S1CstWu2mnp08FMTHGQogog1Tl79FKE?=
 =?us-ascii?Q?+x3C3SRN1WMYcjB++abRB/5C1MF5lkAWCPYT0KutOfZmZxXpo4K6PwL3Kt7x?=
 =?us-ascii?Q?5RlCIZgWZCTEkeBojkV2M2Duivlgkcol7hTJNCoGV0fH33StPZ3BKsplTOyf?=
 =?us-ascii?Q?NqpK3yl/ihKU8l3DdNIaElaKKBPqvuHJmhEPIlQ0ExKYQFRgDrlZJUYwnNaY?=
 =?us-ascii?Q?cReh7X3sfWul6toAufGRQI1gLZ5GGNEOhUuInoF8nDWny00WBGE65FlQOhz3?=
 =?us-ascii?Q?ZodoA8CUX3kYXCzegIzzcsMmZ6uXqvS07m/RjmFykpSeCCrhFCt552vFmZEF?=
 =?us-ascii?Q?Bolu5BEsBZdZBDxhlmV1ClSeHYOX0xZ35PubcHCrN8eZ8UjThETk0RRzWru4?=
 =?us-ascii?Q?wUm/ctw8MglSa4bxPi6f0Yb0626MV1LAHrwJg/NsNUQ/QcdRUJ7V/XLjJFa8?=
 =?us-ascii?Q?bA=3D=3D?=
X-OriginatorOrg: uipath.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cceb31c-457c-43b4-52a6-08db246d3039
X-MS-Exchange-CrossTenant-AuthSource: VI1PR02MB4527.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 09:19:18.4499
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d8353d2a-b153-4d17-8827-902c51f72357
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MkYrvf0NQdlMFpM+NKnj1haY24D34Us5Ex7Z5tAcQc4wQIy0iTnboEwmBFA6X6YWuio3LR9betSPd3sBqZt9DwlIrzLMCVqHZRjrZxrLU3Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR02MB6543
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 93827a0a36396f2fd6368a54a020f420c8916e9b upstream.

KVM enables 'Enlightened VMCS' and 'Enlightened MSR Bitmap' when running as
a nested hypervisor on top of Hyper-V. When MSR bitmap is updated,
evmcs_touch_msr_bitmap function uses current_vmcs per-cpu variable to mark
that the msr bitmap was changed.

vmx_vcpu_create() modifies the msr bitmap via vmx_disable_intercept_for_msr
-> vmx_msr_bitmap_l01_changed which in the end calls this function. The
function checks for current_vmcs if it is null but the check is
insufficient because current_vmcs is not initialized. Because of this, the
code might incorrectly write to the structure pointed by current_vmcs value
left by another task. Preemption is not disabled, the current task can be
preempted and moved to another CPU while current_vmcs is accessed multiple
times from evmcs_touch_msr_bitmap() which leads to crash.

The manipulation of MSR bitmaps by callers happens only for vmcs01 so the
solution is to use vmx->vmcs01.vmcs instead of current_vmcs.

  BUG: kernel NULL pointer dereference, address: 0000000000000338
  PGD 4e1775067 P4D 0
  Oops: 0002 [#1] PREEMPT SMP NOPTI
  ...
  RIP: 0010:vmx_msr_bitmap_l01_changed+0x39/0x50 [kvm_intel]
  ...
  Call Trace:
   vmx_disable_intercept_for_msr+0x36/0x260 [kvm_intel]
   vmx_vcpu_create+0xe6/0x540 [kvm_intel]
   kvm_arch_vcpu_create+0x1d1/0x2e0 [kvm]
   kvm_vm_ioctl_create_vcpu+0x178/0x430 [kvm]
   kvm_vm_ioctl+0x53f/0x790 [kvm]
   __x64_sys_ioctl+0x8a/0xc0
   do_syscall_64+0x5c/0x90
   entry_SYSCALL_64_after_hwframe+0x63/0xcd

Fixes: ceef7d10dfb6 ("KVM: x86: VMX: hyper-v: Enlightened MSR-Bitmap support")
Cc: stable@vger.kernel.org
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Alexandru Matei <alexandru.matei@uipath.com>
Link: https://lore.kernel.org/r/20230123221208.4964-1-alexandru.matei@uipath.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
[manual backport: evmcs.h got renamed to hyperv.h in a later
version, modified in evmcs.h instead]
---
 arch/x86/kvm/vmx/evmcs.h | 11 -----------
 arch/x86/kvm/vmx/vmx.c   |  9 +++++++--
 2 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
index 011929a63823..9180155d5d89 100644
--- a/arch/x86/kvm/vmx/evmcs.h
+++ b/arch/x86/kvm/vmx/evmcs.h
@@ -166,16 +166,6 @@ static inline u16 evmcs_read16(unsigned long field)
 	return *(u16 *)((char *)current_evmcs + offset);
 }
 
-static inline void evmcs_touch_msr_bitmap(void)
-{
-	if (unlikely(!current_evmcs))
-		return;
-
-	if (current_evmcs->hv_enlightenments_control.msr_bitmap)
-		current_evmcs->hv_clean_fields &=
-			~HV_VMX_ENLIGHTENED_CLEAN_FIELD_MSR_BITMAP;
-}
-
 static inline void evmcs_load(u64 phys_addr)
 {
 	struct hv_vp_assist_page *vp_ap =
@@ -196,7 +186,6 @@ static inline u64 evmcs_read64(unsigned long field) { return 0; }
 static inline u32 evmcs_read32(unsigned long field) { return 0; }
 static inline u16 evmcs_read16(unsigned long field) { return 0; }
 static inline void evmcs_load(u64 phys_addr) {}
-static inline void evmcs_touch_msr_bitmap(void) {}
 #endif /* IS_ENABLED(CONFIG_HYPERV) */
 
 enum nested_evmptrld_status {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ee05c0e1cb2a..2c5d8b9f9873 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3792,8 +3792,13 @@ static void vmx_msr_bitmap_l01_changed(struct vcpu_vmx *vmx)
 	 * 'Enlightened MSR Bitmap' feature L0 needs to know that MSR
 	 * bitmap has changed.
 	 */
-	if (static_branch_unlikely(&enable_evmcs))
-		evmcs_touch_msr_bitmap();
+	if (IS_ENABLED(CONFIG_HYPERV) && static_branch_unlikely(&enable_evmcs)) {
+		struct hv_enlightened_vmcs *evmcs = (void *)vmx->vmcs01.vmcs;
+
+		if (evmcs->hv_enlightenments_control.msr_bitmap)
+			evmcs->hv_clean_fields &=
+				~HV_VMX_ENLIGHTENED_CLEAN_FIELD_MSR_BITMAP;
+	}
 }
 
 static __always_inline void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu,
-- 
2.25.1

