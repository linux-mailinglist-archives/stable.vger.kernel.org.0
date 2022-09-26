Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A78445EABFF
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 18:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234494AbiIZQGK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 12:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234502AbiIZQFn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 12:05:43 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC927B865B;
        Mon, 26 Sep 2022 07:53:24 -0700 (PDT)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28QEr8CQ000716;
        Mon, 26 Sep 2022 07:53:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=Jb6V+06BEdF9Ac01xYmXtxA2KlEjLpK/+r68H8wCNKI=;
 b=GgEh955brCbAgXwahCepattwIOPGj/O4jz3/vqUdGNsPMs5XU1mXr5JxCs1ylzIuqH+D
 jtMYDUKE4cLjEgwOeIJXXaQditv8qevnLih3sH09QpeJAwKazazxzWugkiJtVJnlIXwA
 xnZb4V2GjAaSEeRttmPighqsisYwS32ajAbX8kW05JwkTUC/QZVFSXzu2i3+XInnbsXw
 5vOv6PO7AubLiJ2uEvJLcaeFJKp1PkBQbhndCxfaUbN8cOe5OpO9QRbIbQ2bPvJSd88e
 vcOAqJTKsPf9oYOGSZrDnoKVLRhNDlPiBlx8g6br5U1kpd6pNYbX1FVx6PxBhzKKEdNG uw== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3jt1dk9cpj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Sep 2022 07:53:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=An4Ke7aUid7DSWReZhwGK2MDU2eKKJ465zRS2mA6jgCsAoYSj+yYIcpEMCHwCu+UC8YUXSzc+AR7dnPuMAEzC00C2uZ/cYP1ojPUnZHmbIcje8nBKq8F3UOPv+E1mEu0AGD46OgD9FM350NBaiqr3YYRQve+hYJAodxrY5lsk1vojINtnBizwsXc9f0EaAln+oh4sRubeupqUvXX5C9rzHixjGSVQH2YHjcoraM2toN37FNvSgEaTrteivKQ3BiFvLqNddQz32DXdIkT8V35tw+yScph7MkTwSQ539gX0PcHQ/R3badDxabf69aosSp+Wzo17DRkPITTtdo0ru2+rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jb6V+06BEdF9Ac01xYmXtxA2KlEjLpK/+r68H8wCNKI=;
 b=Fr96J3MzUQtaDZI+vg1060Ul3XLgFCwYIoBWpKzdoDNnSerTmPJqf9ewM2CN81udUEooMJQRhjPzS8/fL6nVgnUSkiZey69y5QX08XC3APgkdLk36quuuihdU1BJvIAIeHxk3ZzrUmkFv34csbkSbRocjjExsq+uqDJ2hnHLLWDreFU2kN0ukL5Byw5pBKBmYY5wDik0hioBzIcU4eHSP+3bGOz6G330pLVw84E+aR7fT+FUig0YCwHymTHloNHfKTT8RDTpyR+/N8M44rRlKNIjGM+iEuTuBB7jCuy/C89z0Se6BGPQDTy1gGGDMwjSLrYdsdv8z/XJHXuzULw8MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by BL3PR11MB6385.namprd11.prod.outlook.com (2603:10b6:208:3b5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Mon, 26 Sep
 2022 14:53:05 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::9df7:43d1:af9d:4d3f]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::9df7:43d1:af9d:4d3f%6]) with mapi id 15.20.5654.026; Mon, 26 Sep 2022
 14:53:05 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     kvm@vger.kernel.org, liam.merwick@oracle.com,
        Mingwei Zhang <mizhang@google.com>,
        Sean Christpherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.4 1/1] KVM: SEV: add cache flush to solve SEV cache incoherency issues
Date:   Mon, 26 Sep 2022 17:52:47 +0300
Message-Id: <20220926145247.3688090-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.37.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0121.eurprd06.prod.outlook.com
 (2603:10a6:803:a0::14) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5327:EE_|BL3PR11MB6385:EE_
X-MS-Office365-Filtering-Correlation-Id: 998f8a43-0148-4eb5-23f0-08da9fced174
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sfdV/cLuxL/eZUzPBahJrPsgkO5C04QiwG5+ILgLn2sK63I6sJ9bRztv6iZe1PC04y2GHOtYRlJNcuA9HjP/RzQj9SF0N41PJSaWhMhXmN1+n5Kwl8vs4ieTLz3z78Qy/1SZHB5HsbrKzcKsbtSfat1Lmvcnc5ZBzhFh7u82tBVi7+2HRhZCr/561pp1KzYRWsMSFC+Be+HrPswEhxNud0Qxw14CJE3+o5ZSabQbadf36RGFOs5D2Eai0J7ooAl9Gx/X+DOY/3VcuMSxgHawNK1KhrmKS82DJ4HYdgUtpSXbh61TKK6beWNnGTe8sZRrZavb3mNqyYoUgmfbH5AZPad23Iv7cQhLqAO5HCrGI+oUqEmmWrNIO/xWV/L4PRzXqLnmXdGH9LWubb2AxmQ2FK1QoT3Qs+ijzTb3vKosbPrM236SCBueQ0PIqGq7yvlU6exoZXMkcFzLyRuc5ncDOia7UECmkwa4A89N6ygMJ0FOVwBx1boJiHOh4XaEnzcuyehPxt4Ogd+klfsPmAfvaDFt/zRx6s/g9NqRO5q8H2sJMi3XG4rfZN4Dws5e+9KGDnTYCpmsUPuMbpUk+9j7DONpnaIEMDoGOAc0S9VlEu031L1AmDHF7SqHE4NF1kILl3vr+hKIYsxLeHNYxOnVzrVAbgg4xJUyIZ0pY0rtm01rlInN2z/eT+v4bbO+Bet1r1EBgOmdRVBJ2kBwcj4Wbl45+IYjJ62m2VCLBlsB0Ac9X9aNBStrgf7soRXLp+ivBmsRbzyIggHaE/kNkOV7+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39850400004)(346002)(396003)(366004)(136003)(376002)(451199015)(86362001)(38100700002)(38350700002)(36756003)(2906002)(1076003)(186003)(5660300002)(26005)(44832011)(6512007)(6486002)(107886003)(6666004)(52116002)(41300700001)(478600001)(6506007)(83380400001)(2616005)(316002)(54906003)(6916009)(8676002)(4326008)(8936002)(66476007)(66946007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7bB1LQwVMgfZ7+0f0i8nJBhiUVuLjpKO+KDsSEbOLJVgiMufWIX9osKxpyLu?=
 =?us-ascii?Q?dLOpRlpTOfOoZ/OO7mKo2dERyo4X2e/w3zeDPLJ5AokCZcfs84NxjpPm4iUD?=
 =?us-ascii?Q?5OqarPqafQibJ2Tp3Ncg8xqPF70QMdDZrjdcgZMQg+lE6p4XFH1WWbEjuWez?=
 =?us-ascii?Q?bkrWLgdvAs2mhG+CFa9yutKvjK0yXfaPxbld/SJgJ3vWDqIpeWdjOyfyezFu?=
 =?us-ascii?Q?FwEn3kUQKbo1ImOmEHRVM4rsE0hD7DH28sad76IzfeOyuYU0/vIRvYV5HiDn?=
 =?us-ascii?Q?IZd6W2TzV/jMVoSwsI1XEeKntkeLzKIJuyTIoO74QY2W9qISiUXutdbZHJ8t?=
 =?us-ascii?Q?r1BnpsZacyOoViw6RCaqixCd8MUalOvcJXOPYqPCNoQeBVZSS94JG28ioXvw?=
 =?us-ascii?Q?6jLcZwlDtStZcb3bQxTHrjJANTYQJehO5v2dtvVv99evB9Apw4fTHQgnBFBt?=
 =?us-ascii?Q?o5os9bAuJDq7lmWT/WIS5ljcUEJDnUKePUzNd7RsT6xgg1KYPR2p+kSs8LWj?=
 =?us-ascii?Q?KSjREFmdMrzDb6ytoSb2KDeoqdmagnWa15yHYbU8sk3vxL2PtrRCKS8xh6Uw?=
 =?us-ascii?Q?68Ckr090edLreUnaKBND0A364eocZ4HOAG+ma/y62ky9DbUDRTfMeiFWMoKm?=
 =?us-ascii?Q?mfygpjKmkG8KR4RSBLl9KC0FGkVQGe395poKiWGbV68fSNOHIygUntr/yGQe?=
 =?us-ascii?Q?9WH/K7sJnqe0cFVYAcdK42Y6Y1alZh+m5XW7EL8EF0yY29P7HFRVsYdi/a6r?=
 =?us-ascii?Q?ioC4481nr5hIbpCN0Z/swtsfvw5ryhrrFHBNmq6LL3oFEIuQ7XqFLs3yaoRO?=
 =?us-ascii?Q?NKCimgvMPmR15YvOGCPc4Opyg9Wu/hdzUdD+xfnkYtqGYCStYYCHHC1+VE9L?=
 =?us-ascii?Q?4hc1jr6veNxl8qvD0yzv+38lEd08LVH+8GWyHJQdw3pJSBp/djK4T9LiP0Yd?=
 =?us-ascii?Q?dRuRU2R21DDEgUCRs+o+M/VO46ngK5ucHdpGPWFzKUE67Wf+7oun6VGXYgLS?=
 =?us-ascii?Q?HIFCcOKfQHFkerae8oswznKrfI+RDJYwZl7R3du6nGmIZQcJy9Cw8cblxbxi?=
 =?us-ascii?Q?nY1nV7JDJxrHEEvciSt2j9CfgjeSqpzzmLo8ewQ2AcFgLt0HWg1s++0Crrwc?=
 =?us-ascii?Q?PMP3qgnr/8zrEt0J2KV0PkmU4uaUmXOToPJdxt/wd9jtuN8Hf3g2X2sYb/fA?=
 =?us-ascii?Q?ekfKttUfv8jgNY1AE8bw2EKzCOyFA9NmkamhV+ZhmH+aZKF3YbHuLHQogH2x?=
 =?us-ascii?Q?sRljoSAjs0mgyKVgYn68kijQEHJbe/9Pe4B7gnMVOGUs0zQvAnP2btUSecJ4?=
 =?us-ascii?Q?BVh3Msd3K6ilOXGS8oONDP9kzW4zxY/2tXQS46FkEBV0Zqg49g0225N6sw//?=
 =?us-ascii?Q?Cm1Gtym2tW3csEBQbhqM88b4EzbRJhFe/vQ9SytRnb6TiJguBmQoOSrjuE+j?=
 =?us-ascii?Q?PJ2njLRMF0gri0812dcVVSMhCeMP4LotSkdD34+qK4EWgNMiZIio+vGbLtFO?=
 =?us-ascii?Q?0oZxUhZcJjeMZMC8IOr8F0xCrt3olONWDf8yJ2i+nF/I5cLKTQrR6+HALxpp?=
 =?us-ascii?Q?hDQzANP+hX5vJUSj7ltDSsZEkQXkaTQ9GeivabT5x7UUFbGLTnVMk+3tznwS?=
 =?us-ascii?Q?ow=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 998f8a43-0148-4eb5-23f0-08da9fced174
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2022 14:53:05.4193
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sgd9oBUfld7Quxi1EBelKW7LavILcmLe+0qVyea5xK3v5fjaYoIF+jONQbK51cPXjxV4s2gvMOHS1bpHysAOhiXyDVX3MZjOdU2SbU5Ho0Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6385
X-Proofpoint-GUID: -RD1jTqYFRUJ9gmMdLOwf_welVMyGC87
X-Proofpoint-ORIG-GUID: -RD1jTqYFRUJ9gmMdLOwf_welVMyGC87
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-26_08,2022-09-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 malwarescore=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 clxscore=1015 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209260094
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mingwei Zhang <mizhang@google.com>

commit 683412ccf61294d727ead4a73d97397396e69a6b upstream.

Flush the CPU caches when memory is reclaimed from an SEV guest (where
reclaim also includes it being unmapped from KVM's memslots).  Due to lack
of coherency for SEV encrypted memory, failure to flush results in silent
data corruption if userspace is malicious/broken and doesn't ensure SEV
guest memory is properly pinned and unpinned.

Cache coherency is not enforced across the VM boundary in SEV (AMD APM
vol.2 Section 15.34.7). Confidential cachelines, generated by confidential
VM guests have to be explicitly flushed on the host side. If a memory page
containing dirty confidential cachelines was released by VM and reallocated
to another user, the cachelines may corrupt the new user at a later time.

KVM takes a shortcut by assuming all confidential memory remain pinned
until the end of VM lifetime. Therefore, KVM does not flush cache at
mmu_notifier invalidation events. Because of this incorrect assumption and
the lack of cache flushing, malicous userspace can crash the host kernel:
creating a malicious VM and continuously allocates/releases unpinned
confidential memory pages when the VM is running.

Add cache flush operations to mmu_notifier operations to ensure that any
physical memory leaving the guest VM get flushed. In particular, hook
mmu_notifier_invalidate_range_start and mmu_notifier_release events and
flush cache accordingly. The hook after releasing the mmu lock to avoid
contention with other vCPUs.

Cc: stable@vger.kernel.org
Suggested-by: Sean Christpherson <seanjc@google.com>
Reported-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
Message-Id: <20220421031407.2516575-4-mizhang@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[OP: applied kvm_arch_guest_memory_reclaimed() calls in
__kvm_set_memory_region() and kvm_mmu_notifier_invalidate_range_start();
OP: adjusted kvm_arch_guest_memory_reclaimed() to not use static_call_cond()]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/svm.c              |  9 +++++++++
 arch/x86/kvm/x86.c              |  6 ++++++
 include/linux/kvm_host.h        |  2 ++
 virt/kvm/kvm_main.c             | 16 ++++++++++++++--
 5 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4bc476d7fa6c..7167f94ed250 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1204,6 +1204,7 @@ struct kvm_x86_ops {
 	int (*mem_enc_op)(struct kvm *kvm, void __user *argp);
 	int (*mem_enc_reg_region)(struct kvm *kvm, struct kvm_enc_region *argp);
 	int (*mem_enc_unreg_region)(struct kvm *kvm, struct kvm_enc_region *argp);
+	void (*guest_memory_reclaimed)(struct kvm *kvm);
 
 	int (*get_msr_feature)(struct kvm_msr_entry *entry);
 
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 1efcc7d4bc88..95f1293babae 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5072,6 +5072,14 @@ static void reload_tss(struct kvm_vcpu *vcpu)
 	load_TR_desc();
 }
 
+static void sev_guest_memory_reclaimed(struct kvm *kvm)
+{
+	if (!sev_guest(kvm))
+		return;
+
+	wbinvd_on_all_cpus();
+}
+
 static void pre_sev_run(struct vcpu_svm *svm, int cpu)
 {
 	struct svm_cpu_data *sd = per_cpu(svm_data, cpu);
@@ -7385,6 +7393,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.mem_enc_op = svm_mem_enc_op,
 	.mem_enc_reg_region = svm_register_enc_region,
 	.mem_enc_unreg_region = svm_unregister_enc_region,
+	.guest_memory_reclaimed = sev_guest_memory_reclaimed,
 
 	.nested_enable_evmcs = NULL,
 	.nested_get_evmcs_version = NULL,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d0b297583df8..bb391ff7a901 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8046,6 +8046,12 @@ void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
 		kvm_make_all_cpus_request(kvm, KVM_REQ_APIC_PAGE_RELOAD);
 }
 
+void kvm_arch_guest_memory_reclaimed(struct kvm *kvm)
+{
+	if (kvm_x86_ops->guest_memory_reclaimed)
+		kvm_x86_ops->guest_memory_reclaimed(kvm);
+}
+
 void kvm_vcpu_reload_apic_access_page(struct kvm_vcpu *vcpu)
 {
 	struct page *page = NULL;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index dd4cdad76b18..9a35585271d8 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1408,6 +1408,8 @@ static inline long kvm_arch_vcpu_async_ioctl(struct file *filp,
 void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
 					    unsigned long start, unsigned long end);
 
+void kvm_arch_guest_memory_reclaimed(struct kvm *kvm);
+
 #ifdef CONFIG_HAVE_KVM_VCPU_RUN_PID_CHANGE
 int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu);
 #else
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 0008fc49528a..b1cb2ef209ca 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -164,6 +164,10 @@ __weak void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
 {
 }
 
+__weak void kvm_arch_guest_memory_reclaimed(struct kvm *kvm)
+{
+}
+
 bool kvm_is_zone_device_pfn(kvm_pfn_t pfn)
 {
 	/*
@@ -324,6 +328,12 @@ void kvm_reload_remote_mmus(struct kvm *kvm)
 	kvm_make_all_cpus_request(kvm, KVM_REQ_MMU_RELOAD);
 }
 
+static void kvm_flush_shadow_all(struct kvm *kvm)
+{
+	kvm_arch_flush_shadow_all(kvm);
+	kvm_arch_guest_memory_reclaimed(kvm);
+}
+
 int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 {
 	struct page *page;
@@ -435,6 +445,7 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 		kvm_flush_remote_tlbs(kvm);
 
 	spin_unlock(&kvm->mmu_lock);
+	kvm_arch_guest_memory_reclaimed(kvm);
 	srcu_read_unlock(&kvm->srcu, idx);
 
 	return 0;
@@ -538,7 +549,7 @@ static void kvm_mmu_notifier_release(struct mmu_notifier *mn,
 	int idx;
 
 	idx = srcu_read_lock(&kvm->srcu);
-	kvm_arch_flush_shadow_all(kvm);
+	kvm_flush_shadow_all(kvm);
 	srcu_read_unlock(&kvm->srcu, idx);
 }
 
@@ -844,7 +855,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
 #if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
 	mmu_notifier_unregister(&kvm->mmu_notifier, kvm->mm);
 #else
-	kvm_arch_flush_shadow_all(kvm);
+	kvm_flush_shadow_all(kvm);
 #endif
 	kvm_arch_destroy_vm(kvm);
 	kvm_destroy_devices(kvm);
@@ -1143,6 +1154,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		 *	- kvm_is_visible_gfn (mmu_check_roots)
 		 */
 		kvm_arch_flush_shadow_memslot(kvm, slot);
+		kvm_arch_guest_memory_reclaimed(kvm);
 
 		/*
 		 * We can re-use the old_memslots from above, the only difference
-- 
2.37.3

