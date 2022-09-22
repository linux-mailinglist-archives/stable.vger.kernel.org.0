Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56B5E5E5FC6
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 12:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbiIVKXG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 06:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231251AbiIVKXF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 06:23:05 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EAC1D8242;
        Thu, 22 Sep 2022 03:23:03 -0700 (PDT)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28M7ehPW031932;
        Thu, 22 Sep 2022 10:23:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=j+I4u9Zg9YkEq+XcwwDVPJJEK95yA51Ao2ju415usWU=;
 b=kNP1n184s5d2suwbKKlbrhXhSnJ5Z3ueMb0DRrVzylz/d37WlwyxQqQzlGBOpy+wKmSh
 EIwHkiej0mn1HvtBw1u0NuRnmNWhK+MThMBVcBM+4JSVSli2e3Sf/J8kX2RZH4JFbBYQ
 3uhskNd10IOCkoIilL6Y/IvyO+UqGpK2GILwJr3ETFd5o6/blmSfQG/ep8WR++lIFHty
 w/NJCZYgKXTZx02FbIDQUPVbVXUW6N2rw63UstUMjaGte5FwRKzQ9h7cXlW0IrxSCFCl
 bOyq86tG3u/zL3nfyWacT9iUfBKBanva2pZ5MvxdulINpQijOxxLtdvMInm/c5HB/tDo vg== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3jn3f1cbyw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Sep 2022 10:23:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YVDG2DaB5KYHY24mye95T8EtKBs+YG+/ryauzcZYqjGawf5ycQFWMVrAoonE7Tnu1zyNUuyEjJ42YR9u2Hw0YTNmbNEonpWGVrLLT8pT4QpTzst80XLx07C0wsHPXKvvGknB++8RZfRbR34MiZgfauUobmMcv21Xfc+VKIoAJnhsZ0CcH1e372SnWCC79b+YwNcZTFWPFbN7sNJ3cl+IBbsDhLCLL87iOIlEqAbiVBmGnVm+EdO0b8s6KUAUCNpyeOSZ3UTlZ3yXzQz6JYuO4x12fgkMiJy85glXetqMDhsJPLo+nhN1nynEwVRGYTljmYgoFQ6dJfe/iNMIwpUnGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j+I4u9Zg9YkEq+XcwwDVPJJEK95yA51Ao2ju415usWU=;
 b=fDTRJVWXX3HDDqSaPnR9iI2G22loQ+YgRtFD+FIpPDIYXyOMbPtCXotxRiZN3u9Op9KnYI2mBhr1U8K54omIP9qMNTlyCqSemHfjaIxq009j+ZFyn+0l211UrcD45CjluGoOV1ow0+PRVFg1Y9nG1QivhkWD/lSwhjhBhrL8mr4/MBztNcA9YT7wS2OZ/aZxajiQglMafBr9na0zuZ3tgq1ST5qxwCQSmKb0p87wYwmyu3pK0AZxPHDuNhgGDC9OW5BLjosci+vQhoGaqXKxhzE509wux0wauBzy6BuSi2rjHbZcJPynnxzunM/Ggqy7faLWbe9gMwueqYzB6zGbQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by PH7PR11MB6699.namprd11.prod.outlook.com (2603:10b6:510:1ad::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.18; Thu, 22 Sep
 2022 10:22:56 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::44b4:98f4:1cb3:8941]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::44b4:98f4:1cb3:8941%6]) with mapi id 15.20.5654.017; Thu, 22 Sep 2022
 10:22:56 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     kvm@vger.kernel.org, Mingwei Zhang <mizhang@google.com>,
        Sean Christpherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.10 1/1] KVM: SEV: add cache flush to solve SEV cache incoherency issues
Date:   Thu, 22 Sep 2022 13:22:36 +0300
Message-Id: <20220922102236.810127-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.37.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR04CA0068.eurprd04.prod.outlook.com
 (2603:10a6:802:2::39) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5327:EE_|PH7PR11MB6699:EE_
X-MS-Office365-Filtering-Correlation-Id: 16cc9e24-186b-4ac7-4f39-08da9c846a35
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wCXd/cmjRxHPfRy15qltC2V735Mdg6ylSzFoq6AMlFDX8ZPNJu8BHbkb7S1JMC3IRUCLuzEfewEcZo6/YCknczpGEHiAWiByufdwSQPAshQJ1Az/0lqqpL9mXBR3tTBv2s3YHGw11UOuMxP3KfwP5kq8b5KR42pOW20+cTbefGeddqzF852bLi8XtMR6lhQG1ybA9FJkdlqXKi528YD29QAZ5Ekp4YPD0uaiPnDU3TK5RGjxeOyixbe42kUQ/dowusbSjaI9GFgcxKmXK8RW3jpxThGC4lBgyKd/cb3U/oVOUSBsqD7MCeL+xbo9SsT/dIm3ykXr23x1L849giZ+cp+xdoFJYjW6/GTDo/zkz+RnYEivIcqwQZwiXq/GakFxUTWlZU6opCDHSRWUBoNLE6gpyfdQ4+/ZfR7z5iDlW+JJsnC1vxJKqctmX696g2OzxuJThQ/5Ky70T5qBXI2Leoh01mRP7dSLeXuFZwet9iNzkpd16mLwLwMuHiipOode8iNq6GKwMCqUJACEEIi5s1wG3zDUPuEVntsISqFUWZead/Gtcj2wsog5b81ghDdVdDOQuXpSWyy3OI7rDRDvof5cjjs2e+i9Mwdito/LJ6XoyQeXQtlYpXONKjmY+vzOdQiSTn/mmRK+cnKrNqAYppmFjqLOGxni0Hluj2UUUsAD0MNpDBRGpFs7/JT8YtVpMEq/Xhhww8vJ7hPz5uIjeUSp5aD+AG9yJbsxK210lZeQuUwNX9SFk6ZmBLBgR3R1s/Raq10hOpX/hkEHnwBY0w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(346002)(396003)(39850400004)(136003)(451199015)(38100700002)(83380400001)(38350700002)(6486002)(478600001)(6506007)(52116002)(36756003)(6666004)(107886003)(1076003)(41300700001)(186003)(86362001)(66476007)(2616005)(54906003)(6916009)(5660300002)(26005)(8936002)(44832011)(8676002)(66556008)(4326008)(6512007)(316002)(66946007)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TZeJJPygSu1qt33kdhUyLsTDYyA5MU+3DOk3dBqoOuPagO7tMbU6XibPt8Mm?=
 =?us-ascii?Q?hoBwa2xp0ADk+NDBzscYnzqgikYPxPd2hmvuashUKz1QN3fdcVN5AqU8GFdM?=
 =?us-ascii?Q?37EGrCjoTe0HRsKG7sbaIA4z1mfPNtKYWiHSnqn7C7lrxAgyFeq+7FsSeTMN?=
 =?us-ascii?Q?crrTVk/jVPq1TDwx7SmJeb0jyTqt4FZPuvEght/wAasvBD/2mo9QWbtrc/S7?=
 =?us-ascii?Q?AuG2ZaYNIAgZ8z/uZmwTfTvAgVxEg7jJWgmLmmDgmDvBOa2idjw22k06z9Be?=
 =?us-ascii?Q?i8nsKg6+bX97/K+/ctqqhdDSw0Nk686sjAnVRLw2Rdz1/kzPUSABtEUcJZsI?=
 =?us-ascii?Q?L07JTQ5iNvn1oeaubMi2cpW2+LF5DSUaKL7G7HpizSSTPLOAvnJIHKsJblta?=
 =?us-ascii?Q?ZHF9bnyNjYtsRnFnAk59HoTW89P03JZkXedOtWeJntVZrsM3jfMb+SS+mTgh?=
 =?us-ascii?Q?D9FN3TASxv9W3+dtNW4kkXDeDWjcL5GsQX03WeTRfgCFpF/ELU2QvV/5aqCN?=
 =?us-ascii?Q?8NAtPwqnqjdszPtQ+QfXxNxaodkE02tTNMXvGTvytXm/kuvfqyK+60RxwMum?=
 =?us-ascii?Q?3ExpHaCpeSXC3KxUo7i+4zJh/iGJ13Ss0kdM20a4yP+Z2kCFr/s250LOOOqn?=
 =?us-ascii?Q?udbGlHj5sF5kofbrkrHrUv3Yy9MkPKvIrW2YSbFB7gvf95weJUFg5MU+I3ip?=
 =?us-ascii?Q?U4DCnpK0WFBgY5c3VGchGfAF7idaBjG6qyV+qTHfbcjZrnwHntvy93q4UNCX?=
 =?us-ascii?Q?XUkM2qdVVnxhpEyc6nGpgO5a10dt5okpWfpqs2OFkkzP5Nqn24VMJ7eFSfoZ?=
 =?us-ascii?Q?tZLuSI2vwnXFbBgukQxPvJXh/ZfGuTgsxj2E8BpCVjDSsqtpfg/VQjCTwZy4?=
 =?us-ascii?Q?IhVRvpDxoXSh39iznx9O9H/8xG/DheSlVCojpnmQZdGY1oMGznYUH65HKzmh?=
 =?us-ascii?Q?vQrDc+x6T9Eb/TUTDV3GV/LsHuf4FdUEpbavOXZb1QnHOrWmFL74/M1AVnki?=
 =?us-ascii?Q?fnffWOXkIije8afzyfsLm9T2v9uNh8Kn8YwrdFwMGy1jd45Sc6gZyXFkNYmk?=
 =?us-ascii?Q?d871z4u98bRfaAodVAZoVTwltWdQhzJyD1OsgpF8ygjde8aE9R8htJFGdEDW?=
 =?us-ascii?Q?tZXc3c5XNNAiqXciaKrbhzPwYDjjhuu+1jAiWQwfOIeVALtEkiVHIDF/B26o?=
 =?us-ascii?Q?n7YRanzW7ixCZ/FbRz5aJjOdK2Bu5O23Xm8SZnFVz7fgRU3jvUcciBMKmf7F?=
 =?us-ascii?Q?AvuAFe6OgVKr0iM8zZ6/DKv6xhENk5HLadBaYoOfOsziZUM0UEkWvn6+yER8?=
 =?us-ascii?Q?GVM5TJ3zZC8IL5smqsJkrSdtOB45SjdnyvyZo+zw18kUWvdMaDIp1Lc6eWXw?=
 =?us-ascii?Q?L7fuYX8cQKYHSaXt0Kr/A4+iIXIru1fU59Br9ZZ/BOLy7sffHxXmSh7R+TJw?=
 =?us-ascii?Q?fWG9IcuZuCKhknCSojagDKibgjfHvb47wzEfqIWUbgyFSiWktvLXcltWE6Z+?=
 =?us-ascii?Q?oZIIdPQKdLICOmNCVFynno7n96CLhFMdUY6EL04WqnO+6F+olrOpVNUsVdz7?=
 =?us-ascii?Q?4iq1JuTfYXq1KZGoGX6DQhSk5Da3SCnui8DXIw1UAALm5wN6Q5RkGxGPqwr+?=
 =?us-ascii?Q?+w=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16cc9e24-186b-4ac7-4f39-08da9c846a35
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 10:22:56.1278
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nEL4+XmraZ2sGCkrfiR3buCTvga8KfaTIbl7nw3+AeXHcCHJk4iL2tQaNwkeuHJB3PNvaCcsjFpk5BkyC28JflZI4t61NfQ/nplQyrkeDhs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6699
X-Proofpoint-ORIG-GUID: 66l-u-lkJzMqBjvqkZJzyD8CmEyvku1h
X-Proofpoint-GUID: 66l-u-lkJzMqBjvqkZJzyD8CmEyvku1h
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_06,2022-09-22_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 clxscore=1011 priorityscore=1501 adultscore=0 lowpriorityscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 impostorscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209220069
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
[OP: applied kvm_arch_guest_memory_reclaimed() calls in kvm_set_memslot() and
kvm_mmu_notifier_invalidate_range_start();
OP: adjusted kvm_arch_guest_memory_reclaimed() to not use static_call_cond()]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/svm/sev.c          |  8 ++++++++
 arch/x86/kvm/svm/svm.c          |  1 +
 arch/x86/kvm/svm/svm.h          |  2 ++
 arch/x86/kvm/x86.c              |  6 ++++++
 include/linux/kvm_host.h        |  2 ++
 virt/kvm/kvm_main.c             | 16 ++++++++++++++--
 7 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 38c63a78aba6..660012ab7bfa 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1275,6 +1275,7 @@ struct kvm_x86_ops {
 	int (*mem_enc_op)(struct kvm *kvm, void __user *argp);
 	int (*mem_enc_reg_region)(struct kvm *kvm, struct kvm_enc_region *argp);
 	int (*mem_enc_unreg_region)(struct kvm *kvm, struct kvm_enc_region *argp);
+	void (*guest_memory_reclaimed)(struct kvm *kvm);
 
 	int (*get_msr_feature)(struct kvm_msr_entry *entry);
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 7397cc449e2f..c2b34998c27d 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1177,6 +1177,14 @@ void sev_hardware_teardown(void)
 	sev_flush_asids();
 }
 
+void sev_guest_memory_reclaimed(struct kvm *kvm)
+{
+	if (!sev_guest(kvm))
+		return;
+
+	wbinvd_on_all_cpus();
+}
+
 void pre_sev_run(struct vcpu_svm *svm, int cpu)
 {
 	struct svm_cpu_data *sd = per_cpu(svm_data, cpu);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 442705517caf..a0512a91760d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4325,6 +4325,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.mem_enc_op = svm_mem_enc_op,
 	.mem_enc_reg_region = svm_register_enc_region,
 	.mem_enc_unreg_region = svm_unregister_enc_region,
+	.guest_memory_reclaimed = sev_guest_memory_reclaimed,
 
 	.can_emulate_instruction = svm_can_emulate_instruction,
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 10aba1dd264e..f62d13fc6e01 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -491,6 +491,8 @@ int svm_register_enc_region(struct kvm *kvm,
 			    struct kvm_enc_region *range);
 int svm_unregister_enc_region(struct kvm *kvm,
 			      struct kvm_enc_region *range);
+void sev_guest_memory_reclaimed(struct kvm *kvm);
+
 void pre_sev_run(struct vcpu_svm *svm, int cpu);
 int __init sev_hardware_setup(void);
 void sev_hardware_teardown(void);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c5a08ec348e6..f3473418dcd5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8875,6 +8875,12 @@ void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
 		kvm_make_all_cpus_request(kvm, KVM_REQ_APIC_PAGE_RELOAD);
 }
 
+void kvm_arch_guest_memory_reclaimed(struct kvm *kvm)
+{
+	if (kvm_x86_ops.guest_memory_reclaimed)
+		kvm_x86_ops.guest_memory_reclaimed(kvm);
+}
+
 void kvm_vcpu_reload_apic_access_page(struct kvm_vcpu *vcpu)
 {
 	if (!lapic_in_kernel(vcpu))
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 94871f12e536..896e563e2c18 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1489,6 +1489,8 @@ static inline long kvm_arch_vcpu_async_ioctl(struct file *filp,
 void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
 					    unsigned long start, unsigned long end);
 
+void kvm_arch_guest_memory_reclaimed(struct kvm *kvm);
+
 #ifdef CONFIG_HAVE_KVM_VCPU_RUN_PID_CHANGE
 int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu);
 #else
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 578235291e92..c4cce817a452 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -159,6 +159,10 @@ __weak void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
 {
 }
 
+__weak void kvm_arch_guest_memory_reclaimed(struct kvm *kvm)
+{
+}
+
 bool kvm_is_zone_device_pfn(kvm_pfn_t pfn)
 {
 	/*
@@ -340,6 +344,12 @@ void kvm_reload_remote_mmus(struct kvm *kvm)
 	kvm_make_all_cpus_request(kvm, KVM_REQ_MMU_RELOAD);
 }
 
+static void kvm_flush_shadow_all(struct kvm *kvm)
+{
+	kvm_arch_flush_shadow_all(kvm);
+	kvm_arch_guest_memory_reclaimed(kvm);
+}
+
 #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
 static inline void *mmu_memory_cache_alloc_obj(struct kvm_mmu_memory_cache *mc,
 					       gfp_t gfp_flags)
@@ -489,6 +499,7 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 		kvm_flush_remote_tlbs(kvm);
 
 	spin_unlock(&kvm->mmu_lock);
+	kvm_arch_guest_memory_reclaimed(kvm);
 	srcu_read_unlock(&kvm->srcu, idx);
 
 	return 0;
@@ -592,7 +603,7 @@ static void kvm_mmu_notifier_release(struct mmu_notifier *mn,
 	int idx;
 
 	idx = srcu_read_lock(&kvm->srcu);
-	kvm_arch_flush_shadow_all(kvm);
+	kvm_flush_shadow_all(kvm);
 	srcu_read_unlock(&kvm->srcu, idx);
 }
 
@@ -896,7 +907,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
 #if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
 	mmu_notifier_unregister(&kvm->mmu_notifier, kvm->mm);
 #else
-	kvm_arch_flush_shadow_all(kvm);
+	kvm_flush_shadow_all(kvm);
 #endif
 	kvm_arch_destroy_vm(kvm);
 	kvm_destroy_devices(kvm);
@@ -1238,6 +1249,7 @@ static int kvm_set_memslot(struct kvm *kvm,
 		 *	- kvm_is_visible_gfn (mmu_check_root)
 		 */
 		kvm_arch_flush_shadow_memslot(kvm, slot);
+		kvm_arch_guest_memory_reclaimed(kvm);
 	}
 
 	r = kvm_arch_prepare_memory_region(kvm, new, mem, change);
-- 
2.37.3

