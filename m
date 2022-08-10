Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22B5558F383
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 22:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233300AbiHJU0o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Aug 2022 16:26:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232464AbiHJU0n (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 16:26:43 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C72B2716B
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 13:26:42 -0700 (PDT)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27AENAYX005645;
        Wed, 10 Aug 2022 13:26:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version; s=PPS06212021;
 bh=mPkDX0Dghn4nAK06+HZMIpxyaX914AyvK4zmMGT42zM=;
 b=pfGuiCQRj/ASSQ80PLtFOl+iM9LuMzQfjoYhT70niNe+S02XtTtqikJtX2vtGYNv1svE
 oq6Ro+lFMulR4PxIPaGp2UK3TeQmLK5CCBEOxDzO+VxHI4dNxoBh/erAEqLqRA4rQPNJ
 +8Kyhg2I47Rb3v52n4Fds+h7oukYZb2cELwk3tZxZlj1YiyrtnQTbpu2cG3qU6bge4am
 A+SwOGsqFpgKQkkUjbq6gg0J5PCC6D4vA+HiGWUQ9Nf4farKZgmz/S2STKL8fx1YGmlh
 fLXUfTOCPtmD11gzAkh2q3w6hAtu6HLbLHK4qN7mofV4XxSeqUSbzseR9qFFK3QbBgjW sQ== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3huwr7rx10-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Aug 2022 13:26:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Etgg3I2PLSzkKXaYK6Ee1p43IbO3XVTpluCy5LLhkL9kZzxsxf56Gr/5YfpqWp8LdS/xkBIY6yR2PeJPmh5WZwBRoD2hzl/M31d83OcLomWJ5g4MkGG2pQ+6hn82tzafQnNBUXKeDfdWbTTYLADpXfjPE2vVNn/0KyfTQl5LGyZKwfiUkSjywxgnDuMP1hLMAzAl0V/Mk7qMv4Y0J9I6PU6d1cx6idg/4MqXZ+9jUs2xNSmThBxPCE5PQ9IDG0YuDGvvqFUvdW+JycG5VRKNZYIFWtrRlPUnG190wnh1/6KxUVAJ3AYBhRrI43D14j4rFynfTjv8HQ5rHdvYQF/SyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mPkDX0Dghn4nAK06+HZMIpxyaX914AyvK4zmMGT42zM=;
 b=GUGvGOpty/h/syh4jr8Z66qTtqLZqIhlfW9pA7XC88oAoqr5l4HHNhkP02V3cAZIt2wW3lqtinvSKpI19kvu4EFltXco7btsmTW1MKo3XCEuL9HU5wtnB+NIPmXGDEOFOjsVmoO3n9EZ9KiDSU6nb8tIi2W682NmJB+JC3DeYq8Vqx6f4g/n+PFRQd6thjf9MJAYoqVjI6vILM6zrBjbPVZJFStSiLDIaSCF2s2AY5AZcg9mda/Tsc1rg1scH8wEDNQX+s5/lXZ0b3UfG3NrPo8mO8aulsUTYhjYMkj/KreDnS538M3cu99fOsqyeBLvbJT/GUfGnuAEkgjaPdptLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com (2603:10b6:a03:2d9::22)
 by CH0PR11MB5217.namprd11.prod.outlook.com (2603:10b6:610:e0::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Wed, 10 Aug
 2022 20:26:37 +0000
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::c1cd:e945:f9e:b71f]) by SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::c1cd:e945:f9e:b71f%9]) with mapi id 15.20.5504.021; Wed, 10 Aug 2022
 20:26:37 +0000
From:   Stefan Ghinea <stefan.ghinea@windriver.com>
To:     stable@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Ghinea <stefan.ghinea@windriver.com>
Subject: [PATCH 4.19 1/3] KVM: Add infrastructure and macro to mark VM as bugged
Date:   Wed, 10 Aug 2022 23:26:22 +0300
Message-Id: <20220810202625.32529-1-stefan.ghinea@windriver.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0001.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::6) To SJ0PR11MB4989.namprd11.prod.outlook.com
 (2603:10b6:a03:2d9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5ee72a33-f174-421d-c93c-08da7b0e9ff9
X-MS-TrafficTypeDiagnostic: CH0PR11MB5217:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LoDOZL6oU/+7OLkprw19T/QccTn6gIDDFoz9flfUGPIZJaYd/0h0VfkK3dGCV8Zf74iB4gFLk9D4qNPYIIfmeLHVv/XOph0xPLAHnv8PbUmuH/lHScSvcKL8IyVX2vJf7nufZvha18d87HsRXxGvsIgWODMBZ/G/qJizWnNBjIorE19KTLfj0Dm/MQUiMLSI0v9V5CQpaeBpFgOkGEfG7q4PCqZygt2a85AISJpwAUaEOnVgh3ddgN1IdyoNAZ8NehAiv3SWxxNYcxQTVIDsqkqJSLdlC2S6uazKdmakmOT5qiCDkoCwQV+IEmFPtef+BLLOodE/dSjRUTTKd1+uY3B75p74jMMeoVpkl8SNa9e75mGlAl0lBnnzH9LglhbtKrmCx5pOsaQ6S0pvaHoVjNWP2kT9nAABtlS4J38GZEcsgk2kfgXWVb0ueV8ZKKCdwHYibxaHLoTNoy54tqtn1Ez15rjv8lyrit8DpDIU6Ta1OoXY+XRmB1ywOdj4n4kbIPIwnBYD/o1HXgjQpZo0kz0fQhO59m1WLcOMPeGJ9bVu8/p3o/OV4EuTumfgqsHvP+EweeW5ek7fP3WPwhkOYzxWoewSreXFxqlJaPuMZQxyP58PAo9MBBN9OsEbXne9owAkPzTLtrv/ftKMKwZDo7ozQy4DIjvOVVNn/RZuX/NK+12HW/l10gNICMSX+zrZutbyhiurReB0SSPP+znGnVTM7FFvbiVlB1pV92yi33MWwW4ldGhLBfi4nG+K7g8tXGDEBmLnZVScTcLF1wwsM0njyQ2r+xxLoT4D2r1ZLN8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4989.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(39850400004)(396003)(376002)(366004)(346002)(54906003)(6916009)(316002)(36756003)(8936002)(478600001)(86362001)(6486002)(5660300002)(44832011)(2906002)(6666004)(2616005)(83380400001)(38100700002)(38350700002)(41300700001)(52116002)(6506007)(8676002)(66946007)(66476007)(4326008)(66556008)(107886003)(186003)(6512007)(26005)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HrgtEGhut0DzQmqxIFewDIA3UTSxFikuhVYGTj2vvqSOV23/UGHWVtrUyYJI?=
 =?us-ascii?Q?6eGYbHZderGkrq/USmQ1K+bu0zPAnrxhDvfvUNUawm1ZC7gDNwxBCi5B0TAv?=
 =?us-ascii?Q?Mas9/snbbkELh3BngXJ8hMghL6IkBpORwQaXyMEDFXRQ7pBZgD5DBbfxDIQ0?=
 =?us-ascii?Q?n0JdZ7wC/enbU2FZNis7NQ0/dtUkxCYdmLv8OHz0PS5AwbVFmuc5KjiobyVo?=
 =?us-ascii?Q?Q4qEIzhDmNMg/umKXx7guLqQlhKjR3/Qb7Hfdl5TX1y7dt+u0F2madwEvWlL?=
 =?us-ascii?Q?cuwLfERm7mo4hmthTVRE6WHZFt9KyVqQnecdm9vjA4xv+E8xmGIpwR5wa8QQ?=
 =?us-ascii?Q?3AOWUxLS48qrLpA/TZTlauPRA4CJ3OUxRKBwa5pENsiLWH+mmXeuF9Kou3Xx?=
 =?us-ascii?Q?T5DVf51CpPRyZxd5zO6885Kc40egnbqtftzv8C8RfdxnAZUPc9AUtiAK4bNw?=
 =?us-ascii?Q?yki/hJsjDYApNQuJ9pLSfabJ4dWXjDYewlLDskcBO93NXV8vXW414AIC6Tvp?=
 =?us-ascii?Q?tt+LthlmPfLqBmFlJNf5TAbkOJNHlmsv9QmULWbqFW8CjRVH05+uBTIuwiPA?=
 =?us-ascii?Q?aiEyN4aSBsQyiSu+vW3PJc7jLa1Fj0uySxQAUGSoA+So9FbET4Gt+WhvRzew?=
 =?us-ascii?Q?NrZa3K+yxS+Dmsaz7Zp+i8xXrmZzBdVLv+oysIUeeNLDmk57R3EhG0e8NAJV?=
 =?us-ascii?Q?rumoGeqypZtN9BMi2ecbW8BEtHeKTAJ7QYesSd7nAwsHSIDsA7hg0eJpP5Kz?=
 =?us-ascii?Q?DJ9FTv58ibgPh4F9ShhqmoCMftstVGc1l1Xgd8ppJ8IeRoOSCBBls2qON9BR?=
 =?us-ascii?Q?hCz+shhe6pxUn0T4L3SvIMMjpM3rjyoCsXca6uVf5UKiLbXs/vOBHEMRhZTq?=
 =?us-ascii?Q?JuVMlOoOCxX3jjdzrWf5IVBh48xEZEdO1uIoc/0RcBW4CGXoVKRSJXyOvNl/?=
 =?us-ascii?Q?Jyag+9jcMnw95hMCkgy8+/NidGnVSIH/fY/6C7Nst4BLwvBevrbkTQlB9TYu?=
 =?us-ascii?Q?r1Y27TEo+WC+Nc+YcpxYso5exxm6r6RbtCB+a1tXPvZEfDPXHq3tEIjALzlw?=
 =?us-ascii?Q?MCBwtHst33dMfy6Z3OiStfhNPANGZHaEX+EkQA5FMiLGZsO268RlCXT1q1MM?=
 =?us-ascii?Q?xV6p5gbWH3WTjh8ggkcNGh7DiRwVcZJwGf74dALm/JmRwV4f7zNpnPuU8OYr?=
 =?us-ascii?Q?PaYNh4IXysQdC0nDAhBW7fZhWjrBN2UYkEOv3Xite/J5mP+nqKshYHt7s46H?=
 =?us-ascii?Q?MWMUKDXwS/Rx0LkqxoePECRYb3nV3wzKJ2XdOU3npKXMaUGShO19p39iOppg?=
 =?us-ascii?Q?ySQBAXhZlSdBQpXPaCzvD2bU82OAasGarYb/pEMC4V3afotq1FpcOnIgXJP2?=
 =?us-ascii?Q?PXXknn2N0Pf8wMNNa3WgZTp3O9PZArrMw4M0cLidX+aad4T1vcqd2v3yN6aP?=
 =?us-ascii?Q?N1/phl4q0eWnBZZylJBMDDlaZqkY+tCnZMxu/1BkBIhYjUIq02072LtvkS3P?=
 =?us-ascii?Q?FPrPhF0jbmK9vqe+7FKT4soQr+WFGQHFiiZCtp+eY53T56020TG9tQKHTPD/?=
 =?us-ascii?Q?708fUsf82CuhaRsof2RcSoWlrqtoTDV3swASAR6w9NxFAU4qgkAKc039qgs2?=
 =?us-ascii?Q?0w=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ee72a33-f174-421d-c93c-08da7b0e9ff9
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4989.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 20:26:37.3489
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qy4eBVLfCCkzdCdoJGeAggWtMSgvSI+sgnTv3USkyuGRCsPOFNye5Pl/5nMOfkRNNXaRydl9Any4YRHOcj92LMPjqe+LeCpMTveFCe3+SOs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5217
X-Proofpoint-GUID: dyQH0f6fWQTDkHVBWIiJzmgUtmUW-_Dh
X-Proofpoint-ORIG-GUID: dyQH0f6fWQTDkHVBWIiJzmgUtmUW-_Dh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-10_14,2022-08-10_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 phishscore=0 impostorscore=0 spamscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 adultscore=0 mlxlogscore=699
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
[SG: Adjusted context for kernel version 4.19]
Signed-off-by: Stefan Ghinea <stefan.ghinea@windriver.com>
---
 include/linux/kvm_host.h | 28 +++++++++++++++++++++++++++-
 virt/kvm/kvm_main.c      | 10 +++++-----
 2 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 827f70ce0b49..4f96aef4e8b8 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -128,6 +128,7 @@ static inline bool is_error_page(struct page *page)
 #define KVM_REQ_MMU_RELOAD        (1 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_PENDING_TIMER     2
 #define KVM_REQ_UNHALT            3
+#define KVM_REQ_VM_BUGGED         (4 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQUEST_ARCH_BASE     8
 
 #define KVM_ARCH_REQ_FLAGS(nr, flags) ({ \
@@ -482,6 +483,7 @@ struct kvm {
 	struct srcu_struct srcu;
 	struct srcu_struct irq_srcu;
 	pid_t userspace_pid;
+	bool vm_bugged;
 };
 
 #define kvm_err(fmt, ...) \
@@ -510,6 +512,31 @@ struct kvm {
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
 static inline struct kvm_io_bus *kvm_get_bus(struct kvm *kvm, enum kvm_bus idx)
 {
 	return srcu_dereference_check(kvm->buses[idx], &kvm->srcu,
@@ -770,7 +797,6 @@ void kvm_reload_remote_mmus(struct kvm *kvm);
 
 bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
 				 unsigned long *vcpu_bitmap, cpumask_var_t tmp);
-bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req);
 
 long kvm_arch_dev_ioctl(struct file *filp,
 			unsigned int ioctl, unsigned long arg);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3d45ce134227..6f9c0060a3e5 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2820,7 +2820,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
 	struct kvm_fpu *fpu = NULL;
 	struct kvm_sregs *kvm_sregs = NULL;
 
-	if (vcpu->kvm->mm != current->mm)
+	if (vcpu->kvm->mm != current->mm || vcpu->kvm->vm_bugged)
 		return -EIO;
 
 	if (unlikely(_IOC_TYPE(ioctl) != KVMIO))
@@ -3026,7 +3026,7 @@ static long kvm_vcpu_compat_ioctl(struct file *filp,
 	void __user *argp = compat_ptr(arg);
 	int r;
 
-	if (vcpu->kvm->mm != current->mm)
+	if (vcpu->kvm->mm != current->mm || vcpu->kvm->vm_bugged)
 		return -EIO;
 
 	switch (ioctl) {
@@ -3081,7 +3081,7 @@ static long kvm_device_ioctl(struct file *filp, unsigned int ioctl,
 {
 	struct kvm_device *dev = filp->private_data;
 
-	if (dev->kvm->mm != current->mm)
+	if (dev->kvm->mm != current->mm || dev->kvm->vm_bugged)
 		return -EIO;
 
 	switch (ioctl) {
@@ -3244,7 +3244,7 @@ static long kvm_vm_ioctl(struct file *filp,
 	void __user *argp = (void __user *)arg;
 	int r;
 
-	if (kvm->mm != current->mm)
+	if (kvm->mm != current->mm || kvm->vm_bugged)
 		return -EIO;
 	switch (ioctl) {
 	case KVM_CREATE_VCPU:
@@ -3422,7 +3422,7 @@ static long kvm_vm_compat_ioctl(struct file *filp,
 	struct kvm *kvm = filp->private_data;
 	int r;
 
-	if (kvm->mm != current->mm)
+	if (kvm->mm != current->mm || kvm->vm_bugged)
 		return -EIO;
 	switch (ioctl) {
 	case KVM_GET_DIRTY_LOG: {
-- 
2.37.1

