Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5B8C6BABAC
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 10:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231776AbjCOJIr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 05:08:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231460AbjCOJIS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 05:08:18 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2128.outbound.protection.outlook.com [40.107.21.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62BA47B115
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 02:07:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cm5xZlwENCsahxoi3/w56wUSzQfhGcAz4YU3BvQsLZo14ESVsQNEAIYOIiHRQH2dPRg85zULcMSPYlGHPo4m/0VVgu14gM1w6TKf73Z7S2Oa06ZUnNAMEjxFbB66aBRidMxk1r6d67IGAkuZ51qMc+TVy1oEA6Cs0NURymu92eVyHRORdOk+GQTBt5yObVUAS7F403Fko58xIB2W+WxtshcRlcjOATni+gj16hOBYJ1ZByN6hG9hCJ7q23IPDoYeApf7zlGguCYLyLB9AAJxGKJTKqtziV0IEqksC2o6l8q8Oq3fJBs8rcmIYsBklpg8lwnhuqPTPq/fVVRrqjv2CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qmBSL8G9PbY32UP9Ske+KhzaiT4csScmy8cyZ83gJB4=;
 b=bnsdVz2GjnpSW9ce8zXZjemZZPIxdzI0twd3BAzdPzAugCeVrRK200R7y24AzkzxMHHVg3jXFd6T78MkKZ17a0ZqEfYZR/GhNiFZXVEsH/Q23rn9v9hFQqy6q8aggrxveuIluOUoNfr9ickJppE5BUU/7k5dM5XD95uVA5eKHctMEqrlOyrzzHdenzfVprLGc11636Gdc/xAF13qXm5FD9L9U3i+bSQXhLOax9AHDS0moqCXRQ/bFishi8flU3t99pQgfrcWjdp1KmCurJsEX3dk2I8sltq3cYbPyghujYYagv62NQ9mlUYHLyyiyizvBHv01GiseE6gYehXciOVSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=uipath.com; dmarc=pass action=none header.from=uipath.com;
 dkim=pass header.d=uipath.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uipath.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qmBSL8G9PbY32UP9Ske+KhzaiT4csScmy8cyZ83gJB4=;
 b=jfsEwwAtoFIYDl5u/6/WniLTdQ2+i33aydrD2SBCQl2nGIKVCya1M/Z7mnEpMxqJwl0D6AJL/OUeBOyCpEdcRKDk7SyO8M4HLWHaskNxElGcnyU/+3jwuWMqhFY2+8QgFoJJO2RlwFEVti5UXKS8AyhuR2EreWi9dBfHL1Wiqy7c8RRxYIHhOjn1xfLieAwNIif7NjGp3FGfEY2q0Fgf/iyDhBL2ja4xNdaUGxkwC2T0fstCYlBv942VHuYzzVLXpO0Xy4ajX6Hsx4jDhJCGET8trV71wheW6EZhj8qJk/OLhHe+RHNOlLc32i9cNVYfBkXWoGWBmf2YD5xF08D4ng==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=uipath.com;
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com (2603:10a6:803:b1::28)
 by AS4PR02MB8358.eurprd02.prod.outlook.com (2603:10a6:20b:515::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 09:07:27 +0000
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::224e:d6bd:a174:9605]) by VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::224e:d6bd:a174:9605%6]) with mapi id 15.20.6178.026; Wed, 15 Mar 2023
 09:07:27 +0000
From:   Alexandru Matei <alexandru.matei@uipath.com>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alexandru Matei <alexandru.matei@uipath.com>,
        Mihai Petrisor <mihai.petrisor@uipath.com>,
        Viorel Canja <viorel.canja@uipath.com>
Subject: [PATCH 5.15.y v2 3/3] KVM: VMX: Fix crash due to uninitialized current_vmcs
Date:   Wed, 15 Mar 2023 11:06:56 +0200
Message-Id: <20230315090656.4258-4-alexandru.matei@uipath.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230315090656.4258-1-alexandru.matei@uipath.com>
References: <20230315090656.4258-1-alexandru.matei@uipath.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR03CA0046.eurprd03.prod.outlook.com
 (2603:10a6:803:118::35) To VI1PR02MB4527.eurprd02.prod.outlook.com
 (2603:10a6:803:b1::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR02MB4527:EE_|AS4PR02MB8358:EE_
X-MS-Office365-Filtering-Correlation-Id: 78ca748d-61a0-476c-4ef6-08db2534b2c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DFFMyzCD6Ad57QiGvqeNavkcJ5G77BMrBKh6HT5r9Kihv6IpcsnOIphscs2QEx4JGjP7f5fi1e6Z4wOyaPOGrWyhqz1dHaYIn/5MS1QJ+Dp9JxHnF+yopOuXva+C1fpLsWdquPfVdbhgXBA1jKLwzi21qHx6i/OsVaBy0NGWyUzfHRjwSwP9cJwjLbRyV1g/loZDczqSYqpQRpf2slko36TTpGjhNLNCyNtFI6qf3N1KTrZfxht2LN+ocp+vRC4WbzQAMe15jOLq1JWpzhLH9XqE5QxINZ8aHMCn+uYNHUh3r0GmcR5KU2d48KICRFpH/Pg7NDaiCOEKJg00xrnOaRaPb4q1V9XzI6Fdv2G4z8EdZCUHvrmFCjf4x+02Px+h9wjERLtlO08r6M9mYkVWAT47HYCAXDRyBW2neoxsyPyJ6nCJ2BduanLi/EGEEr0ndLkQBQZ7G30mMeA7YxVc5OIyNL3vM2KrC5Xm0RwRQRGQaekmKOmMuLGfpOL3b+A7AB6mzg+Sk8eVoEgGTa3o2+AsMFAjnhpMDpQlRMg9JQPnssZoylnZwEiAhf16PYvc+pyU44TLzNhVASYyACbna7ZGkjL7CRZcL64CT+ewyiuaXvbBjpR4YQ6unTYSIe8t
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR02MB4527.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(39860400002)(376002)(366004)(396003)(451199018)(8936002)(44832011)(5660300002)(41300700001)(6916009)(4326008)(8676002)(86362001)(36756003)(38100700002)(2906002)(2616005)(6506007)(6512007)(1076003)(186003)(478600001)(83380400001)(966005)(6486002)(107886003)(6666004)(26005)(66556008)(66946007)(66476007)(54906003)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?G+GrdapqJgN6caSyFTzk1aEntPnC/Zsg+rq89oSO20c84d0+DfJJdZwKSzB9?=
 =?us-ascii?Q?PvwGek1Ov2m9qt2WBfcAKT6AGNi4DM6lk3bp4iaahcZmjXqkvH6n/6hbN+u7?=
 =?us-ascii?Q?4MgOVvwyvcvc2tvjvsG6/GP+9qL7mNbOcGQeG5n0kAH2zCxgKYteXO4zaZeS?=
 =?us-ascii?Q?RVHGRKzJQybrZy+nY6irJl/QrX5DqG7yN6pVa6uKjJQGlp3d4zREDp3Vv510?=
 =?us-ascii?Q?D18/lA66YXzxVTrY67lu6Mzk/XdujRvKxaLF8pwIGygoB28ntkYsu5nQcfdg?=
 =?us-ascii?Q?3ofGvzdkPdaCBYRpR5Cz9TKiYx/swNJNATlutpmmRCpbajKCJhiHglbMmGwO?=
 =?us-ascii?Q?WTSxkZMxb8gD9CwwhavPS9sbOIDfncDUyzOxAwvWjfuFNVK2pcrUd1xLibEG?=
 =?us-ascii?Q?t1KvZmba0DO+cGR8od9+MaYj3572pFNthWygdDdD4J6e+iEsZ2Vx6ipCalOP?=
 =?us-ascii?Q?++zwpw5QdQ12YccVCzwDSWygXVPEXHtJcWBWhUfDGlF8thuWXsEvApSdDNzw?=
 =?us-ascii?Q?92CXEg4hmNBQn1PdbRFz3dSzlpXspUhg2iRfuKXrna23hgDZdPYCB07WY7Z0?=
 =?us-ascii?Q?Vb/YGt0OWQiM5Igd8rIAKMtUTZ8nP6iXdZQ3ruEE8fbj9w1mnGb1reHjOam9?=
 =?us-ascii?Q?qojs7TPWOjZ0rfhaMwKd58QZyZnP9WtogcYKSShdK91VbZhfpkKgwo8MOfyM?=
 =?us-ascii?Q?85yQdsVwJUj6juIVKSU4xRaMo77itWB/ehbF2W34fyNZ58IjiHrOeuGpdte8?=
 =?us-ascii?Q?Ju2AjYccI6z4ro6PGNJ3dzKyox9n8F18d8iR/do8T8nr6WfERihdGTjR1VA5?=
 =?us-ascii?Q?g6n13yz4PmllGB/NyCDLpSb913dOxPfmZ7pnk9R19ITr2aGkr3rUSQCN+OYC?=
 =?us-ascii?Q?KG6mXjb1MSM0C4OzviDPsd44tYfe3pZHzsy/3EM7aSZ0KB502WeHHry1kTVy?=
 =?us-ascii?Q?f8DVWn9lRbU9kBfTXSFm8TB9aGT4VTpZI5SobzCGuHXdUpwtn7KNS7ZkxJg1?=
 =?us-ascii?Q?Dp1wUJJ+qXvZciRN1FOL1tVRhOqNH820Bvqw/Rj1Szx8qpq4dm7mYpyMLEJ0?=
 =?us-ascii?Q?+DDDzaa6UwdgR5F5sh8EYXzTgATdGHQYtTSDFpNESwTo4jUbNEc5KkG6pFhd?=
 =?us-ascii?Q?HOe8OdjPP0r8kGDVxcDvSiV2INJPXo/UqnyoKy/zHeD4o8NZAM1MD+rTTboq?=
 =?us-ascii?Q?heUN7ywmASjj6n4wnxyCNXSlEXmNr8t8D1qgD+Kyc7XaO86s445BfI25UbY0?=
 =?us-ascii?Q?UTw4OiXCSsADJA5XA8rgfIWhBLApB5Mhdj/S+uSKa1SSDmB7+0YhHcCD6dAF?=
 =?us-ascii?Q?LNvt5y47isMrijtuCzKN0tXK8+3hJO+o7+BL9yv3fhQj//QgO+/18Sc33EKt?=
 =?us-ascii?Q?CXA8kKlkABItIihdWktOhf6PCSsglFp4J2g3xHwJGN2q2cdo9rSTnjpzsluT?=
 =?us-ascii?Q?41eo8CjLVuveEpQa+5TFElC/EQvGS+HIHAtShrT9p71ZmjSquaDqiY1OC6hD?=
 =?us-ascii?Q?yaCxTPRD6potezlfea3jiYT/NL3OFHYWR5ZczNU3YHP4MWGVIi8AQA+EDC1F?=
 =?us-ascii?Q?BZT2UFzhrqqxMzVX6Z/CnGk1QTmuF0S5swL4XxL7F383BraVkINEdRTDbBz8?=
 =?us-ascii?Q?vA=3D=3D?=
X-OriginatorOrg: uipath.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78ca748d-61a0-476c-4ef6-08db2534b2c4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR02MB4527.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 09:07:27.2512
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d8353d2a-b153-4d17-8827-902c51f72357
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NzqTpJe61Gck2X9SW9TuP1vAno6D8eqskDH94dTRmGIU9c/NzAJNVY8U5fXcxgENaWIVFIptEaORnBv+B2sZuIAcaq/hmDtNuN51XZ/Xp78=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR02MB8358
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
index b43976e4b963..57451cf622d3 100644
--- a/arch/x86/kvm/vmx/evmcs.h
+++ b/arch/x86/kvm/vmx/evmcs.h
@@ -162,16 +162,6 @@ static inline u16 evmcs_read16(unsigned long field)
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
@@ -192,7 +182,6 @@ static inline u64 evmcs_read64(unsigned long field) { return 0; }
 static inline u32 evmcs_read32(unsigned long field) { return 0; }
 static inline u16 evmcs_read16(unsigned long field) { return 0; }
 static inline void evmcs_load(u64 phys_addr) {}
-static inline void evmcs_touch_msr_bitmap(void) {}
 #endif /* IS_ENABLED(CONFIG_HYPERV) */
 
 #define EVMPTR_INVALID (-1ULL)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9c8353b17d8e..9ce45554d637 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3779,8 +3779,13 @@ static void vmx_msr_bitmap_l01_changed(struct vcpu_vmx *vmx)
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
 
 void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
-- 
2.25.1

