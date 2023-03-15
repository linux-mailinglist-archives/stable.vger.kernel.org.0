Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B08026BABA5
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 10:08:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbjCOJIR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 05:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231949AbjCOJHq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 05:07:46 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2131.outbound.protection.outlook.com [40.107.15.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A6D05B8D
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 02:07:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nV3VDMZx7FEq2qg+RFng7w9hFeWOSlZbCCTFV6HTY+679slLTCcdMFBGeVL2OWpT4uEmyrrVf1MAz3ZTl02bPaIyaR8t/3QmNMQRuICeWYUgwRa4jpKnzQawxaXiSGfWMrdBFKpIx062gYUqqMLeKcoGCzBOXDiIz+WkyJk/PdPVaeX/w+I16HTWt1xko2iFAust125kDYHoRUFayENtWp0hYv/5j2Z2HnTB9YQnv1NKkYxenVvlafYQBdigY6rQK1IYLzSWZ33UIwCKFmzmW1JhxNvvaTmNIcpmnRqKHtFhSwldztVw/9CfU7fkbswOPcTTdJfrBhL05mHoCt9SIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p/8tRHRo5k9/3HqMW01gyYi9aMM8mIeH758ON/S0h10=;
 b=Ytxrc23Ou8veE4oSFHKxehUCdFEtpSKQRTuBqqA7Cw0Qd2KtIZJF3dgW0zdnLG0e0gpEmCiIc3cA+P0XPvuVZIMJq/15U97Nkdssnn/8DChp2G3H3eOWyjZSGkJfZJzTt2n7qpi4wVPtQ49kgCkygr0TJSbGEcxwPAJUhdtTgrwUYE1XWXqXRcsGvjbhqxY2IIh44hLyp9SFRyvyM79P3bdLR89urkIDdN6BNxYlOOLZFBd6IkU50omzQv6vFaREE3vYTL1iOi5LMmbEX8HOjV7/qK2GmIWnuhkCrjmlo7uNuc6gwxGoO6BTFlLomoTNvVZJwYEwp5pSaeko6HXs6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=uipath.com; dmarc=pass action=none header.from=uipath.com;
 dkim=pass header.d=uipath.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uipath.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p/8tRHRo5k9/3HqMW01gyYi9aMM8mIeH758ON/S0h10=;
 b=fiQfb3/I/fEqvCyUj1E1fsziUvSdNtXdr/erM5G9lAiJPg1TRtMIDp3TWtgGQV7y/QmntpVgyQyigmpViFuaeWpoZQ4+ZeVTkTGcbHnY8MCluNsuEyLuK3XHY2HMnWCULth5oIgU8wCUlwWLsdwLOYqMoR3Va0P6bFe/Pnq8zZTSMQe2SgNotzgv8THT2gSoou34g0ESFYCfv2iTKGVfZ6N/vog4Ra/DuxToi6K2aLLg6JByS+WTEOK6eRcKDLNJXEMmL7ASS8CXQA7X8hJlK+rcOLW5q1PLZXyHAY4zkuaKfhx1AJeWbJ74ZT06Zt4u06sD6bgRcgf9m5x6jb3bfw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=uipath.com;
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com (2603:10a6:803:b1::28)
 by PAVPR02MB9866.eurprd02.prod.outlook.com (2603:10a6:102:310::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 09:05:58 +0000
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::224e:d6bd:a174:9605]) by VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::224e:d6bd:a174:9605%6]) with mapi id 15.20.6178.026; Wed, 15 Mar 2023
 09:05:57 +0000
From:   Alexandru Matei <alexandru.matei@uipath.com>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alexandru Matei <alexandru.matei@uipath.com>,
        Mihai Petrisor <mihai.petrisor@uipath.com>,
        Viorel Canja <viorel.canja@uipath.com>
Subject: [PATCH 5.10.y v2 3/3] KVM: VMX: Fix crash due to uninitialized current_vmcs
Date:   Wed, 15 Mar 2023 11:05:28 +0200
Message-Id: <20230315090528.4180-4-alexandru.matei@uipath.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230315090528.4180-1-alexandru.matei@uipath.com>
References: <20230315090528.4180-1-alexandru.matei@uipath.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0105.eurprd06.prod.outlook.com
 (2603:10a6:803:8c::34) To VI1PR02MB4527.eurprd02.prod.outlook.com
 (2603:10a6:803:b1::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR02MB4527:EE_|PAVPR02MB9866:EE_
X-MS-Office365-Filtering-Correlation-Id: 2417d55c-c0e0-4e8a-7e67-08db25347d78
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ySz8ORZ8aD0dC4hzp5FfZpiXCeR6TnHF6qmqmwLkWmE1BtkQRRMI1oe+1PnOwfd/8NSpRrMZ7oN4UIbjS+x+wrW1n3Ux5YVtsW61ywjqR1wzXJTUF7AkPSDOLAMCO+X5MNPCa5Yeuo61Rl4i29SLl0XYkW1qaCtgoNEMBt9cpYggeHBL7BzJvlD/6pkb1K2heTu01td/kVIn4uSF5X+FchHkwT0HPPmkhGLeMlGVFH3LAhXa8DPCfiw2ClhLXqnLI+Y3jRw+rein9oNuP9Hu9NKyiX7DD//cLClydkdVJl7q9mWnacpl4i6pWHq6vwfLQ4/fa1yUT3rj7y9nQ2yNJIXOMIQwKop1enXT6iDiziiysEa79m345ErheqG4JpCmHYTsAAQmB9Ly80t+nUV21x+WHS9rRn+pNPejUKg7hiYbmvYG/mL6ne6sbcRDdgUA76mzl9Jbl8NDbCpYcMRBbSYWSs4noLud/K4UKrig6QMeicFqtMY6t66To/qDyDKztj9B6gXOn3lW8OSEk+xtHxGOi5La67kihqqvG197YtysOCYnGmJSb/YlwNp5HUJcDnvuk0M1aTgpLUI01Ok7hDkZCXX5o/58g2vPJ432vbU9QJUKKQikONtCZmoSmwdy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR02MB4527.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(346002)(376002)(396003)(366004)(136003)(451199018)(316002)(41300700001)(66556008)(66946007)(66476007)(186003)(6512007)(26005)(1076003)(6506007)(54906003)(8936002)(6916009)(8676002)(4326008)(44832011)(478600001)(5660300002)(36756003)(6486002)(966005)(2906002)(107886003)(6666004)(2616005)(86362001)(83380400001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Hl60KQF/9hA6f1RAXvzycXTT9KJCqH+v/NcPis6k3VfI03Wqy/9Hvrnvf3zB?=
 =?us-ascii?Q?PFLHO/HfidbEzDnKcuBJfHgQreSWd5dxAyp0L+N9+R1bS9HjY8wwLwrTIMSd?=
 =?us-ascii?Q?1IN+6aZhTrrPbbfzCMJLm0nH5hv7KnlcdVuo8thYA6yDzQrfhpBOVCrVhqis?=
 =?us-ascii?Q?/Ff4r726Aia9pU897xWySTh+WMZb6xHNO8g8S5B+lbCL1GVOd7q4UHiBNnQx?=
 =?us-ascii?Q?LH0iRMvm3MXzbuW9hbr9Hgnjjk7FPI91+JXNFyEptdQMHR0N/ofIYwXxYXS4?=
 =?us-ascii?Q?yfj+5OmSsu2wOMXDd2mfneAh+nHng8ZRa6k0r6LZiA2wHKGEtetF/SDebgXY?=
 =?us-ascii?Q?2UKXaKqXCU0s7nU+KJaREDKYf3IUHQwqY4hzbq741gXVZGs/tk+zHuJQleFU?=
 =?us-ascii?Q?en1yBn/vZIz/Tfy1ODFRXmKUaTHEibDu46CaDCk/FH8IimOhm8CIiE6QoAm2?=
 =?us-ascii?Q?xH/TUQiNKyY45UdtIYaOKe8HDGxd5JMsxfjIUkn3H8NJWpa100GSaRR9KlEd?=
 =?us-ascii?Q?RAdxj8Qv1p3b+D0zbPx7F2Noniy4CEbZodJhAJjulcj0EsbEGZX8GmbrPl1b?=
 =?us-ascii?Q?AqlVPIT3btdqmR3Kjy9IFUJiNSLQWi1+I9JR+MWPaKhzr21eeK2eMKN0K9EU?=
 =?us-ascii?Q?wNHNm8ESML79YUhCO+6pkxcPiixvkwYISpVPWKquWi+xYmTerFdVsyOmnibe?=
 =?us-ascii?Q?maw3uoLXRNOOAgubEtPVtKF8RIqi9CwwINtTyDIOOTQEYialLG9SUWiQDHiR?=
 =?us-ascii?Q?0gv+BXPHDLOXeqbg9FKPbnLgtcjOdl2KCaYkJpt02uu1GJE5irB/xM6NhXyt?=
 =?us-ascii?Q?kzvHZ8qg6DIYTFTTS87xOMT0u/lrVMAUsbgq9jRJ5hWP9tpdLmV8M+sEdi0+?=
 =?us-ascii?Q?5YG5c4pay7A3nfWZaZgbm/2DAoO503Jd3x18cz6/EsHE21fmK+5hQ4GT5OGn?=
 =?us-ascii?Q?QZUwLisfIkr6zFtTlnCvDMfN5uleMgXETmryOyKI2KTweE2pSKtlwjOQdYV3?=
 =?us-ascii?Q?pNYpKKBu6UNGnCS1dgr0yqfE5PNcmnpmHt+RC1xt+W3NsT5T912L4al/sa3b?=
 =?us-ascii?Q?/Ydr2QC0KWNXH+0L2nOWs9+7hecTTiy2ssv1yXhJm0YjJNVJp0acxfXWiLSu?=
 =?us-ascii?Q?k2sCKu9ehkGbKPTJygrzX7zTDErTzzqiALwYyn46F4Pkyi3tH1kbyjnRhUUC?=
 =?us-ascii?Q?5SLtqz6mrfc0i5Z8yTy54yTtqjQLTbZ2O4fzFM+sAh7BsdWVYvxfCEVxGqcO?=
 =?us-ascii?Q?tLxNy1qQEB6JRvBw6+NrG3In/XrMs+/MdsXVp3jU4AmCEHU+BZwxrbfzXOqh?=
 =?us-ascii?Q?RzjYxa9e1oCtIMXYMHpcRfqipQcRZ1osQns+dbbAqXTSB6/dO4gXqC2TQ6fi?=
 =?us-ascii?Q?p4VvHEt7Q/5xqm8cwG2FgsbV2zRTiJxlqxPyuwI/165eeyGeJukgZ8FMuW3M?=
 =?us-ascii?Q?hMXB8A4ewf3/DdA0Wxe4unGQAVtkp+cnLM73IxSfvVa4+cCJL7PIQ5w5FOA2?=
 =?us-ascii?Q?mYDVxl4EysjpyqNBJ+JjSGNaoDAbnZwGPtdxSgxBZhg3xp/P4j2AFmYegZoF?=
 =?us-ascii?Q?TgZnEjP8x48MHO5bqTfsm/huW8M8Y3M61GUePE/km6Ob9h63wWC7lAZiCZ2g?=
 =?us-ascii?Q?3Q=3D=3D?=
X-OriginatorOrg: uipath.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2417d55c-c0e0-4e8a-7e67-08db25347d78
X-MS-Exchange-CrossTenant-AuthSource: VI1PR02MB4527.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 09:05:57.8507
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d8353d2a-b153-4d17-8827-902c51f72357
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lV5hM0bEgJuoxgJdooJSXyvCF+AJ2JgMGe2Smok4TccC8e3yvFtKksYysUAhsbebFgZztj6epYssyPFP3mSMS6TBpjIOhpjbFzLYBHU0mTg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR02MB9866
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
Signed-off-by: Alexandru Matei <alexandru.matei@uipath.com>
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

