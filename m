Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE1A58F37F
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 22:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233293AbiHJUZi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Aug 2022 16:25:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233285AbiHJUZh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 16:25:37 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F3B726AF3
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 13:25:36 -0700 (PDT)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27AENAYT005645;
        Wed, 10 Aug 2022 13:25:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version; s=PPS06212021;
 bh=152H1H7xDY0Xvmq9GHzfjYu7kgSoLg1zh2rAM0w7thM=;
 b=dZMfEIcabQB3meOikz1HozwGzkY/kQYZ7jpSHy5VSN59ra9H6WAAiaEZ2Kg9Ta7VsI1V
 1ZRjpLi/je2zmlPxz047H0v0U+7gS9N2lWMQ997NPsXRP09VR8tTr8VOVagk3Yggok8S
 WzSlXq43IdqumtXvpLWE1D2t/uQgQ1q/5zOiCOYlYToCpyy7zpgafqz3TYx1EH9c3XLd
 K84G0V05LjbOMLuYw2NoqNLqU0t5woXAiwHtc/Qx6rSW68F03Y98yKfshsMmiT61tFRQ
 qWA2cneWJrfLM6HHpVfdecBff6+/Z6/F36WHnRikM5TJnPBNTL1wJ3lwD4Rr47YPPQ4X Ww== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3huwr7rwyy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Aug 2022 13:25:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RhYx6QemwdVHCOnuk5DtgV0AHHSuUn5SjLv34QFWi2YlMEPmYhSENQ+jhnBNDXh6dxlhgqYl/R8V63SZH+twFEE8nng29jSozPwEVqEeGJjsLwkwA1AOUsJwziIld+Lf05k8DJloFcfGipiCw3wSSDGVhVaObdi9b6iP5k4n7d9o4pj3R5HT9uAAoU3McmWiFuYLcjFzsQK22kGRSoNxMPdWGZdmUg4yuxg73Hc0cmczcAm6TKcMsmgp31YZhsCEqsjDEdS/oILUdXCzmxEii5PmlO6OsMDuGk0/TbFxu4Ubr1fX5C8z5+UOEatW7l/EnjKBSjgpSTuNmnnj0j9pqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=152H1H7xDY0Xvmq9GHzfjYu7kgSoLg1zh2rAM0w7thM=;
 b=DbXSNiDW/vz7iz3mWMzlmlRGm+WtvLr8e9UmInF7b8/rC4CJoPSUsokZ1CwxCaBgvLIBikXAqyKGgTnPzXg9EYkTAOqf10YowNti8WVdkb3SD8QJikiwlRYt8jTZ/t/BTI/Ih2/uGSi6dTgr32UoVqCzrMGfJMQq93JKDWHRJPTv1L5DAi58BxM2daeI6LbSQDmvjLjK2F4BcW79nbQRGA5SVO/ZaL6S4VRgwRVdnIOE3kmG5R7U5GL6JcVRa3P1DbQNPvR41vgE4A4ngiTJvkV7i4ijopVbFffNebyKygVektP8ItGi4tK42YwmuGvJ0/fO5Fw2qxJ3HCQDNW8Vzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com (2603:10b6:a03:2d9::22)
 by BY5PR11MB4339.namprd11.prod.outlook.com (2603:10b6:a03:1be::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Wed, 10 Aug
 2022 20:25:22 +0000
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::c1cd:e945:f9e:b71f]) by SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::c1cd:e945:f9e:b71f%9]) with mapi id 15.20.5504.021; Wed, 10 Aug 2022
 20:25:22 +0000
From:   Stefan Ghinea <stefan.ghinea@windriver.com>
To:     stable@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Ghinea <stefan.ghinea@windriver.com>
Subject: [PATCH 5.10 1/3] KVM: Add infrastructure and macro to mark VM as bugged
Date:   Wed, 10 Aug 2022 23:24:37 +0300
Message-Id: <20220810202439.32051-1-stefan.ghinea@windriver.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0010.eurprd05.prod.outlook.com
 (2603:10a6:800:92::20) To SJ0PR11MB4989.namprd11.prod.outlook.com
 (2603:10b6:a03:2d9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ebcac25e-89c7-49c8-6d62-08da7b0e7351
X-MS-TrafficTypeDiagnostic: BY5PR11MB4339:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pH3sqj3IIjU46qtVrIxx89oPCYhHlhdT1hHS2ec/Wcnp4fTkt9UGdwM/vUP2lBx0R3Ps61T3koDRS2oQbVlAEA62cJXafesPz2T3GPi5Qbzlp8tu0ylcsNkNqCrMmVB384b2xtvOjxD4OWjFZ19Mrsj0bPzbo4s/U16o3y3A2aDbFiNNIP3OMUpCHB8sfgDuISEz7r3r/AIHHWG3wJnTXlNf6Q+hVVXCK+xu2mPYtzwdl55GQ5Clh4apY4KeIccfwUIZT86QcWZkhTftdERKaaAvqUKhK88D3+I6g4YIlrMxl1zbBD4gbmSlo+PREqalLeY51xnPSEMwxVcWfzAbC8qHgeDHi6XwiVwQUE3jsBwFrIUP8VMJX7cDFJqdTftvfv4HjWJXR7O9j6fdRq6ZzAeaV3LL2hFGOW9wcmrEBO6RyDEFumeCpsfbi6MVFdpE9Nyclyf9tYO6edJKesfR59p8aqu1J4b/fUqQFpQqOoVB95bsgGAcJ7EjtEGDpajXyyqcf//XZGxhsnmHaBkAQCxoB1tzM/ZXyKXxohdR3M1vctMXDf8obqVqyHW2TJjNb5SqLkeqsnwhliIZyRdksA72XrEotxfGtSoY0s2CFlxU6X0DJXZmKznV28URxeKI84N6mec5p+B3nLwS2IJb4V02MIoXg/blTJoMV55MGGFzph4spjUqI4usj3YBCx0B0v9D3w8I5kSmg+3/SJ/Z6uuJ6oUjiFYwYc/iJdd6z+phbVykaJN9iBI63Y5Mmr5Z9GkS370GZbv2z+sy308hIxqPepUsZC93Q2Xdd1c+34c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4989.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(366004)(346002)(39850400004)(376002)(136003)(6666004)(52116002)(38350700002)(6506007)(186003)(1076003)(107886003)(2616005)(6512007)(8936002)(5660300002)(26005)(44832011)(36756003)(6486002)(41300700001)(478600001)(38100700002)(86362001)(83380400001)(316002)(6916009)(54906003)(2906002)(66946007)(4326008)(66476007)(66556008)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?P2ulZNUqKIY6QiDVUKkzvZlqtvFVE1dX/ty7t9z2S6sWnShDrl1ZFty8S3Yg?=
 =?us-ascii?Q?PEfi0fsz+9Svl67iTssdCdEjHqlHhxFuClMQbgCJsvrLQrwCibIDRseQ1Ngm?=
 =?us-ascii?Q?X0usHGRq6kLd/MNO4rkFyI+fZ43+MORSjQhyJr88uC8zxH6EjuL0142s4Vwd?=
 =?us-ascii?Q?w/Dksqd3iNAPPf/R5GQSM3I0IhP+7zgDfUyvVbvREWZIenxwAeDasF2tFS2F?=
 =?us-ascii?Q?BYqJyJYqVU9lLObp9Snvxf8EM68YZERDyDvAArVWu5PxaAd1KO5x6bOyt0op?=
 =?us-ascii?Q?kAvrAloYJDrVg3VWHUPl36yRqEE3UJMk1mRHu+E5sgo9edDraOsDRlP/88mY?=
 =?us-ascii?Q?2vNPl87vvhcPmi9qGI/FPept0Y44ztM/FPCmlmf1JK582j6nlgc7IZNTJGJ6?=
 =?us-ascii?Q?VpOX2+IBxAUhDdiLta1fjPTvGpIbHNu/EmTwpGLD6rTkrbolOeIq4R9AKfuH?=
 =?us-ascii?Q?SeixhPx9m0eCewnuvNef1dDnq3H62+E0JYh2mAwJT+nipid/wJ/X1Fu+aptc?=
 =?us-ascii?Q?AHz+yxa8wqf9ztTWCtvhoL2QS0mYeiAz7SuRYn//6zDMt7wHbgYJL46KxsZA?=
 =?us-ascii?Q?7hmqp6OKi9oiLFK99x0iPcPR9jHYkWgCLUNHhwi/Q8wDQhY31B4k57vF68sO?=
 =?us-ascii?Q?GoYl3FAkk0wvJbtF7lH+9RjvuC3mP8kbEvgFkDIzo1ub8IO8dP1ACLLUmyF9?=
 =?us-ascii?Q?dlZNmWkAs3QJ4NztA7+eAd2uZpuoW0NPf5PdKS2CrFqJF0FAciiCqylzmW0c?=
 =?us-ascii?Q?EFnj92evyfZ0XCXfnlUbiKfxPQGRLFlQU3eSmKztk8zRUvifDLXTSd+SG0Ir?=
 =?us-ascii?Q?8s/VHs2Df9FZneRPFGv7+b2SPZmmQMNHuzsuCZAG7IGa6k1fYGBdIb44Ywz5?=
 =?us-ascii?Q?Sjfm4kzlc0Rg5REJ0jddFLjMUqbXU55Ncr+CtDbOFhxAjptTmkVNVhkVv9tV?=
 =?us-ascii?Q?TAuxpSjouYKAEli4N33ltCySB/Ph2Wo88SDfL0/2LxbbWDsztdyGPTU9NFNk?=
 =?us-ascii?Q?uKOjFkjpD6SHyt7htEJvMU0qkL86s4DhYH6Z0KJwWvv84qBzaJ3GOf7rHLYe?=
 =?us-ascii?Q?wCpXcssCxlORhJ1k9iwzV/WxPjMWwUN5KPTpXktQxGG08HYtJ3I1jy5wNgFc?=
 =?us-ascii?Q?5O4S46mGnxU5/WbmWfviRN+Zz8SsDMFkhZ9eD7rKkel9P31PtyhiXVDiWigv?=
 =?us-ascii?Q?B9qWCsMA7En7kefq1evUf0bioYAWybDLBKzqngx01RiEtaoJJJCNQowu9d+1?=
 =?us-ascii?Q?lgjahLgbb42eMiCvaUPBZXnZeI2FFyjGGliHTGemLqsv9Bx5H1xmwAHNCfW6?=
 =?us-ascii?Q?HvElPcAksS6U8+3i1mAHdhbAaXNs7tuuYlUTPUmmjkKZfXjwVonLxveQ9Abe?=
 =?us-ascii?Q?4kWyTtajGKlbTTrBQboE82kXrS+0ijN7cQBP9ozjecWLc2ABxL9jyos4soRs?=
 =?us-ascii?Q?dDeqShzZYQl1bjPyGoxAtwjamGxwQa0YNsRMTL1TqI4T5tUoMSKtabkApG2N?=
 =?us-ascii?Q?yvZAcksof1YT1mk0xl0H31Sa5x1vKDN71NBGeyUAPDobBmg0/HSLHrZIuGZb?=
 =?us-ascii?Q?mLQ+dMyFUMGkvU5+XD6f782vqKzNQgmgeXQLru0AxmifzdxffCSHELQAs5sc?=
 =?us-ascii?Q?5Q=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebcac25e-89c7-49c8-6d62-08da7b0e7351
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4989.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 20:25:22.2696
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ixgzi7EFt4igIreldV1vv9WyTUhk2hbkRO2XdpiF0H+cMvwNzL5Au9j/HyxfgpzbuugWnSSHFeNElKFD8cKg3mgt518c4yC1lhgqewWjZyE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4339
X-Proofpoint-GUID: Btx-4KAlM0KrdgCUw24ybiSfjHiOO9rP
X-Proofpoint-ORIG-GUID: Btx-4KAlM0KrdgCUw24ybiSfjHiOO9rP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-10_14,2022-08-10_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011
 priorityscore=1501 phishscore=0 impostorscore=0 spamscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 adultscore=0 mlxlogscore=863
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208100061
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

commit 0b8f11737cffc1a406d1134b58687abc29d76b52 upstream

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Message-Id: <3a0998645c328bf0895f1290e61821b70f048549.1625186503.git.isaku.yamahata@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[SG: Adjusted context for kernel version 5.10]
Signed-off-by: Stefan Ghinea <stefan.ghinea@windriver.com>
---
 include/linux/kvm_host.h | 28 +++++++++++++++++++++++++++-
 virt/kvm/kvm_main.c      | 10 +++++-----
 2 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 439fbe0ee0c7..94871f12e536 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -146,6 +146,7 @@ static inline bool is_error_page(struct page *page)
 #define KVM_REQ_MMU_RELOAD        (1 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_PENDING_TIMER     2
 #define KVM_REQ_UNHALT            3
+#define KVM_REQ_VM_BUGGED         (4 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQUEST_ARCH_BASE     8
 
 #define KVM_ARCH_REQ_FLAGS(nr, flags) ({ \
@@ -505,6 +506,7 @@ struct kvm {
 	struct srcu_struct irq_srcu;
 	pid_t userspace_pid;
 	unsigned int max_halt_poll_ns;
+	bool vm_bugged;
 };
 
 #define kvm_err(fmt, ...) \
@@ -533,6 +535,31 @@ struct kvm {
 #define vcpu_err(vcpu, fmt, ...)					\
 	kvm_err("vcpu%i " fmt, (vcpu)->vcpu_id, ## __VA_ARGS__)
 
+bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req);
+static inline void kvm_vm_bugged(struct kvm *kvm)
+{
+	kvm->vm_bugged = true;
+	kvm_make_all_cpus_request(kvm, KVM_REQ_VM_BUGGED);
+}
+
+#define KVM_BUG(cond, kvm, fmt...)				\
+({								\
+	int __ret = (cond);					\
+								\
+	if (WARN_ONCE(__ret && !(kvm)->vm_bugged, fmt))		\
+		kvm_vm_bugged(kvm);				\
+	unlikely(__ret);					\
+})
+
+#define KVM_BUG_ON(cond, kvm)					\
+({								\
+	int __ret = (cond);					\
+								\
+	if (WARN_ON_ONCE(__ret && !(kvm)->vm_bugged))		\
+		kvm_vm_bugged(kvm);				\
+	unlikely(__ret);					\
+})
+
 static inline bool kvm_dirty_log_manual_protect_and_init_set(struct kvm *kvm)
 {
 	return !!(kvm->manual_dirty_log_protect & KVM_DIRTY_LOG_INITIALLY_SET);
@@ -850,7 +877,6 @@ void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
 bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
 				 struct kvm_vcpu *except,
 				 unsigned long *vcpu_bitmap, cpumask_var_t tmp);
-bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req);
 bool kvm_make_all_cpus_request_except(struct kvm *kvm, unsigned int req,
 				      struct kvm_vcpu *except);
 bool kvm_make_cpus_request_mask(struct kvm *kvm, unsigned int req,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c5dbac10c372..bb7adddd6a85 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3252,7 +3252,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
 	struct kvm_fpu *fpu = NULL;
 	struct kvm_sregs *kvm_sregs = NULL;
 
-	if (vcpu->kvm->mm != current->mm)
+	if (vcpu->kvm->mm != current->mm || vcpu->kvm->vm_bugged)
 		return -EIO;
 
 	if (unlikely(_IOC_TYPE(ioctl) != KVMIO))
@@ -3458,7 +3458,7 @@ static long kvm_vcpu_compat_ioctl(struct file *filp,
 	void __user *argp = compat_ptr(arg);
 	int r;
 
-	if (vcpu->kvm->mm != current->mm)
+	if (vcpu->kvm->mm != current->mm || vcpu->kvm->vm_bugged)
 		return -EIO;
 
 	switch (ioctl) {
@@ -3524,7 +3524,7 @@ static long kvm_device_ioctl(struct file *filp, unsigned int ioctl,
 {
 	struct kvm_device *dev = filp->private_data;
 
-	if (dev->kvm->mm != current->mm)
+	if (dev->kvm->mm != current->mm || dev->kvm->vm_bugged)
 		return -EIO;
 
 	switch (ioctl) {
@@ -3743,7 +3743,7 @@ static long kvm_vm_ioctl(struct file *filp,
 	void __user *argp = (void __user *)arg;
 	int r;
 
-	if (kvm->mm != current->mm)
+	if (kvm->mm != current->mm || kvm->vm_bugged)
 		return -EIO;
 	switch (ioctl) {
 	case KVM_CREATE_VCPU:
@@ -3948,7 +3948,7 @@ static long kvm_vm_compat_ioctl(struct file *filp,
 	struct kvm *kvm = filp->private_data;
 	int r;
 
-	if (kvm->mm != current->mm)
+	if (kvm->mm != current->mm || kvm->vm_bugged)
 		return -EIO;
 	switch (ioctl) {
 #ifdef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
-- 
2.37.1

