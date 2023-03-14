Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1F1F6B8E77
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 10:20:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbjCNJUR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 05:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbjCNJUQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 05:20:16 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2115.outbound.protection.outlook.com [40.107.22.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF2185A6A
        for <stable@vger.kernel.org>; Tue, 14 Mar 2023 02:20:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OpM32pWKuZ5YNYhpMA95shJzmNGdea/xFre/9TjMo4Sa0mF6xU7uZVf3u6KmH9yXJzU45nDG4sMa/HDuVgamZNYusdBH6P3kiE21BQFttbre0L/wrQUgPq9jW2pUHCqKCqhPzsiU2rmEBo7a4AA7oQ/m/2R34wQ++x1phnONv8m78R4h776iHUB2Gu3sOh1+jmxO1gcs6eTWrs7EoNg89eyRHCurc9VT9AsDh9QnBZLl+DLhjikm80OoYO1bDTVQp1n+WhrjjoMyPiQGxfSr59aUWdl/1ResnY5+ADZNCOy4aViUsNAqjizkjL4g9tNJUQ4so+rcIswBOl07krJkGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lb52NjoxsPiJZl+NqwFyKyTlzJM0a89/KknlU/ciUV0=;
 b=EwUTvzxIApDCS39OsUJmxVIQ/xijh9kbudPfeptLziBf880TZ8H/MzuIdSCCnQcjlW3Dx4/f9KFl8OZNSFNtU0Hs90h7M4Bky3cNFEeW2AyBing+JHwtG7TbBMB6WrrykrqAa8bRVUsZbSoLpNmQdaczao8/1bLcSRSNk+sSQBOwKZssaNLzz8KnxkRbalbHjRrR7zh5xtBA81sRPdOqz9fyqlEnnTr8txRtW1UELDa4DvsRrvaUhu3DPv3VfesjwjpXOhtAjfrVgW0zN2Tbd7QaDh1RSp9hu67O9ZFgEZSwCSaGcdcIDdNUlzKeuAU7zn+dQVkX4Fc4c+T74mhOxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=uipath.com; dmarc=pass action=none header.from=uipath.com;
 dkim=pass header.d=uipath.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uipath.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lb52NjoxsPiJZl+NqwFyKyTlzJM0a89/KknlU/ciUV0=;
 b=bMBPAFLlbIkKug28sLw1Rs2hEh/9gQKnU1PB+e0zMjDSTojHn7kenFaZPAstodLBKM0jpXRftIOv9ohzem+6HwF7T1+gW3suZm0C/Vv4hnWE0ztKI6Z/GfM1kZqkg2LsClEC/O81oooW2BgyKbruyjXZZaef1d9rrRjtjOOG2T0FGk7/ZIwBzaqoypeLYAVWR0AXVEtL48pPtNigp7fZS2lnl1Tp8fdG22fUkFEQDPotwnyeh27SUvuBxZ0fdIpOmPp4DtiuYB8ZKt+XaGa/j0xbMzC7d2LolnjXEfCfI8aSAxSd6PXDlEyUyio9cl1znp85rIJ4xK9MQY5F/YsqiA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=uipath.com;
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com (2603:10a6:803:b1::28)
 by PA4PR02MB6543.eurprd02.prod.outlook.com (2603:10a6:102:fe::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Tue, 14 Mar
 2023 09:20:08 +0000
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::224e:d6bd:a174:9605]) by VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::224e:d6bd:a174:9605%6]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 09:20:08 +0000
From:   Alexandru Matei <alexandru.matei@uipath.com>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alexandru Matei <alexandru.matei@uipath.com>,
        Mihai Petrisor <mihai.petrisor@uipath.com>,
        Viorel Canja <viorel.canja@uipath.com>
Subject: [PATCH 5.15.y 3/3] KVM: VMX: Fix crash due to uninitialized current_vmcs
Date:   Tue, 14 Mar 2023 11:19:53 +0200
Message-Id: <20230314091953.3041-4-alexandru.matei@uipath.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230314091953.3041-1-alexandru.matei@uipath.com>
References: <16781188891829@kroah.com>
 <20230314091953.3041-1-alexandru.matei@uipath.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P194CA0029.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:803:3c::18) To VI1PR02MB4527.eurprd02.prod.outlook.com
 (2603:10a6:803:b1::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR02MB4527:EE_|PA4PR02MB6543:EE_
X-MS-Office365-Filtering-Correlation-Id: c656d538-42f5-4a2e-06b6-08db246d4dcd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pguzKunORNNJWrZMKEEN7uk3iSPjSc2w1UI+ICajjt1W8GyafdNPVdHG2I1w0dAtNXDDY993O+tOIOOusjzRRAA7Zzry7WjYZ2Xr8hRE19n5tastm3kkV65LfXRc7wo8Z2jdRhTBtDpMCkr3mU09QG7JWCXvke+7EbAVPLc/nkX1WgdpiWXNZ0FzRg8o1B8IzPhMkvcwZufeesa8MbyP47dHHsEhBa6ar10ajsK2G2w5zCTvpujanwuzamssSZcEYxUuZmXuxC+5gLuPzoOz4q6ZlGttEm70Uj1MpKqF+yGGJpWXmudToMws1SeTbZDz3IkiIpNo4DcVJDM8f5efBcFCIIrnVh2ahSoygLgjMaQfZocuIRG5VhpZh/2UUG8XowCyZQlxbKtDArQat9KBDdg0EB33oOSV0f0LULiAHQDrgByWJsu4yVSKFEfj5JYNxDSrv+nxPwBp5rWuXOClTZjLrFdUEQ+ueSiRaASbcigKIMO1K6scmlnxrzBc+/vYd4ozQa9XP3M33rUX5FhlcxuXP8htA+yMRPi6nF2zG8oWjQ3ULim/etmMb7Jz788aonaEf9IwWboEKvcCLO84KSNrdbqzEWRz0ICp6PX16azLgLn0StCUeMptNk1ZA0Q4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR02MB4527.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(39860400002)(366004)(376002)(136003)(451199018)(5660300002)(41300700001)(44832011)(2906002)(38100700002)(86362001)(36756003)(8936002)(478600001)(6486002)(66476007)(8676002)(66946007)(66556008)(966005)(107886003)(6666004)(6916009)(4326008)(83380400001)(54906003)(316002)(186003)(1076003)(26005)(6512007)(2616005)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qZoBdx+FVZ9urVzyNF9l6rjSaqSpFsxQ9c+QCAoaTRQkQT3ScIbd3dxc88c1?=
 =?us-ascii?Q?VJWT4UeOLRCVdh0TUnXcQYLYnZVlhtnXICS2Nh9R6eMId1OPo3DIQFOJU8Ge?=
 =?us-ascii?Q?1JkA2Ox3kFXrvcagUjrHxspupzrSPEjREcWpWAvtkYNgLnNbE21WH5APJdYp?=
 =?us-ascii?Q?CCG3aUNxthSCiXkuieC0LqL7pV5TxuMPYWUg+31Iwk1ff8Wf6xJsZtp+jsjp?=
 =?us-ascii?Q?NWSLlcbIjdaLX3AjcVFkMT1ukBjOboEQ3qKuAd1FW/Bq4Lkn3YgH0ZakoOMI?=
 =?us-ascii?Q?EyWEQSPa8hbuKXzFX6LFzwAy3Kfql2z0zEeTgfu8TXOcoLx5sv8gqUeZOyg+?=
 =?us-ascii?Q?jnFSF4e9JnY/YSDh4ELBVVy/iyiXWlrzI/5MpR0gj8vzz9ljwipjRjhIVREB?=
 =?us-ascii?Q?kINfBLaFgei1sBRQHgIKL6gIjYAz9QXkrbY1SFQCIHk1dlZFXDzNhODXzFF7?=
 =?us-ascii?Q?PwV792scAUHRBKS2uJQzkOxzd3QkdZAQTYFN2JqQdSbO9zrYbndmiPPG1L5Z?=
 =?us-ascii?Q?aJMdTnxPJilE6LLyV9XvAWUBfplWgkrpp1MnCw6hyaUY9H7Krndwzkb/0vCx?=
 =?us-ascii?Q?pBzW/8WbCEXyZeV5tW6x0jJagpNTLbAV8tFI1hP1831j5jttSbKxhAlWEXWG?=
 =?us-ascii?Q?ZQ/A567xeNZJjsvXxroQIQgC3jH3533hSKfJZrW6uHL9MdhmPqIyiGFiRNXV?=
 =?us-ascii?Q?4S6qvyDHakuItJk3YUX8y4Vkkbqea1lDXYQUAw5J/nsuyD0DbjrBP1WeYNRj?=
 =?us-ascii?Q?xzuqViqGL//99wVfPsqDeo7Sd0WVOOvrt/YhVLvHENjonTBOxbpImQ+SVRKj?=
 =?us-ascii?Q?AHRvk0l9cf3JUvnJVTDqjOmawDq4pnZv/oZYvjHwcJt9zYozB3/Xw8ImQeao?=
 =?us-ascii?Q?mdENlJNas0GQOmRLfpBCsROMq8mGuKGmVPUs1GML2EcGINRLKDXAHILqF2q3?=
 =?us-ascii?Q?ZoA+Tgw+2Uw8kSSr7xHjhcGDxTL81qCibdi/WM7MPeSsUqzH629iPxRfkXIn?=
 =?us-ascii?Q?bjMGyo2QtCx2w3G7dJEDQzAuO3LNLalm1amO577GcQkhwoxTXxngSfrww7zv?=
 =?us-ascii?Q?bIaXkA4V4EOxoux+qMe8sURcm3tJ7oP8JDB5pnMXqCxgp4aAjYHjvnRcfUqt?=
 =?us-ascii?Q?8lH4MN75Z5KpOHy/6k3FypD3JWNVSrgzdVuMy6VuTNCzF2AjVy/521MfH2GT?=
 =?us-ascii?Q?Xi8sbsyauHT4sVNfRyZP2u7nBBRxS6hGgQTnQ4FxiOQMtxd5OC9V7G2/G7rA?=
 =?us-ascii?Q?JH8zzYAF6aZ67LwNGQRKJ9/rI4DaKG6osOMepedZDdQMy1IFuT27T27jhDP+?=
 =?us-ascii?Q?NNjSY9TU9JV0h24amcPmkZY/A6zSlpdVv9Mr/vsKI8a4ogYT7EdZH6ykHEN7?=
 =?us-ascii?Q?lyIAke09zslEfRygdole32wdoydTdCVUDHsp3niuUlS2VnDM3ncX5lEVAik/?=
 =?us-ascii?Q?wv1PvSSpWyT4Wg8ljhPIwa+WwOTW4lNlyq7s6jA1Y9iqir2jad1yidjq56mU?=
 =?us-ascii?Q?A818QckmeU/jpg5l5LkGbVccqGX4qN2GJWPiE6/owYaP+/z2XrnvtRJUFwcR?=
 =?us-ascii?Q?t5iowjrrFoP5SrmpYD8qYQl31r3dEzAzvX7ZGz1LHMaUlY8vLKIxEi/oQFN8?=
 =?us-ascii?Q?Eg=3D=3D?=
X-OriginatorOrg: uipath.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c656d538-42f5-4a2e-06b6-08db246d4dcd
X-MS-Exchange-CrossTenant-AuthSource: VI1PR02MB4527.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 09:20:08.1030
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d8353d2a-b153-4d17-8827-902c51f72357
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3x7KcyF8BNOc16bcoorQox0n48ZTDccMU8VWnU3tfXvG4JIeCABjS2NzBhhYYG5IKOt9DpWO3BdqnAy4U+FRyUcA4bKkr2MmkHFWDL/teqw=
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

