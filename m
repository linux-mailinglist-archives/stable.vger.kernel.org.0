Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4397058F382
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 22:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233298AbiHJU00 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Aug 2022 16:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233285AbiHJU0Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 16:26:25 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD81327165
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 13:26:23 -0700 (PDT)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27AKLWOh022584;
        Wed, 10 Aug 2022 20:26:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version; s=PPS06212021;
 bh=LhyrCF/UGX5zJc2Ol+3nGvjbhoUHvVlwhSAEUZZ4bOI=;
 b=kJJuYeiXRHnqdPIEYpCHq64vEH3nMmpK/SuFuz0PPZfxLpV6StQMHc5x1LPnRj/LaENB
 8do3krAgElfu+sMm3HK3Rwrh/17vyt+V5aHX5OO0AG2IG0A7oFQ0AAIz2AaPS6rq8O4n
 CQIDGsYs5OSDTVh3I0By+8Zn/RX+Ja+iPvNrrw3Af34JxG9ngT+RAfUHbTcCW8AWg/k4
 QAnCSDWi1x4XdNulPApqFYfv//lm9r5iHixDjTMVvm4+FTrDTPRHXZsIyMhf49C9hLst
 /Jt82TQiCWl6hU+J/+udJIyy+2Sj3ziOEV4EyjagXpdnhj3WBY3p0kjSJ2n7gz/y9XsP 7w== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3huwrd0wgx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Aug 2022 20:26:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZGX/9624npEF7prlqzuB/b41W1p6z4pH6Q27Lwy6M5SzJ5LydZccmGpwJJ59O1rfwA35OWeP7IDy81XTS96968QGhv3qmU7obHS0gbKixRkIwY7HgUREPd3vE37pNGDUeCYuwHzfnCge8nef5l4BYxX++a72E6673o+lOrkBEKmkmZCHqYltIwaz/I9TsjnuX+yl8goGCQt4YmLAJ3poAJamhtKsXz/d6RrQZceqbNR+MJUbnZLJczfzZqyUIov+lzSiHYPdTTk4eMP/Ix9BkfdnNtL0x/mSLBFBkBo/xFO4iWxO26zCsR8I1DLlAmkaQk1Zp3J7CSScQIbXJAD3Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LhyrCF/UGX5zJc2Ol+3nGvjbhoUHvVlwhSAEUZZ4bOI=;
 b=YD6vXrbBBTW/JHxhNtlyseUmQboUslV1UGAg3JDZG8sxjHQQ36kOzlnLMXgQ+WBVIHh3ISnCKKH9CGntxAe1rViwTzrJqNLRazliQVzsX4SPDNP7SmooBAkzGgAGAbpVbsaLsbqILtyKmBVPAega4Gnllxm02DGznS8PleKHkk+lp1oOzJprgBdrXYd9G8xMkjBp3D1KUqaazs/llg5TEAg2JTvxh62AJmMUKo7dAYI5TwtsimFwzwLLWuyHtVqZQtoeo03fATYmjwTuNIZok282zSUiagE2CzR6hTxiSiSgo7tce4AbSb19dQgMMbITS0b6qRdz3Tw9VeCFpB2ddA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com (2603:10b6:a03:2d9::22)
 by BYAPR11MB2920.namprd11.prod.outlook.com (2603:10b6:a03:82::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.18; Wed, 10 Aug
 2022 20:26:07 +0000
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::c1cd:e945:f9e:b71f]) by SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::c1cd:e945:f9e:b71f%9]) with mapi id 15.20.5504.021; Wed, 10 Aug 2022
 20:26:07 +0000
From:   Stefan Ghinea <stefan.ghinea@windriver.com>
To:     stable@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Ghinea <stefan.ghinea@windriver.com>
Subject: [PATCH 5.4 1/3] KVM: Add infrastructure and macro to mark VM as bugged
Date:   Wed, 10 Aug 2022 23:25:50 +0300
Message-Id: <20220810202552.32242-1-stefan.ghinea@windriver.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0701CA0035.eurprd07.prod.outlook.com
 (2603:10a6:800:90::21) To SJ0PR11MB4989.namprd11.prod.outlook.com
 (2603:10b6:a03:2d9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bd34d7d1-4cf4-460b-794c-08da7b0e8e43
X-MS-TrafficTypeDiagnostic: BYAPR11MB2920:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J5jrscShL1L3xR+2CmjwaCI/HIM6LmQhTGddj/6fN2LVYwMBQ7ypFc9zSpmnKGFn0F6xYBLS8GfdEclwNPcXEYu8Dp0JdXJzYzo3XSQBmOfoqMs/vaY4bKWaQbeZKSpFTu6GIoAwD33V8TLx31GcTN9Y90JYuwq+VgoTdjDRl1F6AJsJ8PMt8CLPyMhZga4PLMzAhjNpI1mGAk8jBTMKUdVvMtu1fx6yW/AHfI19AAL+hzhZo4S55FCuaFnfHQb+0U796BpMN8AhD/O8pg9CsGBLYVjjFOmwj9KktLhv+nj6igq56vLYnVIFjEt4ztiVLIhcPz1Xk7lsrln9rETRdmx8nZ5fXhGvVNa8+98gW2KE7nr4qx9ygxNZ8yyJRcjlKyiyhxmxvKgvyWiZ4N3KO4TdgiUfEeaKc8yX2kdh+nUTNSE/0Aaj78k139k6nMYkmyNe+FD36LkbAfXvxEUEi+60Xa1bmxpl2TDP13QgyhzaDKU51I004HiOKxzfDPiC0nCJy8BW34pWwWlwxhp6AxdmGWJKkezIdyAEB1UpaISVWcQTD+RNwLxh8tgFzQbmfSBq1cxM0IBrtVMjA449KYKntvusQR4/LiJv5O6p/JzJ0JDHAF+1tgpLDUDDsaJUlen852f5uCxmg/nasI3I2cBzAVaT2VMwmxDpW1RG/WJrPmbdtHzLdse4cCKDkftfKcwPJAvVU6HwYhOa252OSYqK7OmZ1gd75ytoqcEANCwkSniK4EHrn/d6NEU6MYKYBoUtM9p+B3lL/CafJnb6xoaE7C1NBhy1GJY3pGm3M7M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4989.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(396003)(376002)(366004)(39850400004)(6486002)(107886003)(478600001)(86362001)(1076003)(186003)(6916009)(6512007)(26005)(52116002)(83380400001)(6506007)(41300700001)(2616005)(6666004)(2906002)(5660300002)(66476007)(66946007)(38350700002)(66556008)(38100700002)(8936002)(316002)(8676002)(44832011)(54906003)(4326008)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4VTV2v7sanrHMtWQdbGvNuHMANURB1O4cI+Klo4vzKXjDkk1zRN3EByrHbt6?=
 =?us-ascii?Q?zjFDHpDkRPTIF2arYtIRA5EPop1WxRgd+x3oXKCsbUfcqvgrVNWDavx4Fnzu?=
 =?us-ascii?Q?ChfMFDeaznFGDLAlQr7nwbg+IkiInxwHap54v+ss/odTKluAdbD+dUWFrN1e?=
 =?us-ascii?Q?h/ecExKlGHSmniKb+MZB5emIRz8Q87z2Dlt1oCZeNt9PIaziS7XKHTJzGPW/?=
 =?us-ascii?Q?kfJydwffbf9MQj7IUQXRLFBafnISMJEDKVe+Fu9tctS3Fen4VRF1R0PXFP48?=
 =?us-ascii?Q?fmF4wsXVDtfVWYdTze3n+2LTa2oimACPdNbbTK9UBqC1lxcpXsm16o+1e4Eg?=
 =?us-ascii?Q?/DAhxuXk7SLNzk36Q+7vXBp4GBIHHosM9XsLMMMOydfA/uHRH/ahovy29xhq?=
 =?us-ascii?Q?exHSix1M1X4jkCO+peR9/Tr8NrMSpAROyKHSL9yjC+Nezmb13VNVq92kZ4or?=
 =?us-ascii?Q?gclghmCm2S9Aw0vYtWR01Ir92A8C3eY3PIXEdswWoVo3wEZK9ZcqlLuA9SuG?=
 =?us-ascii?Q?XfCG3VP6PenAuV8xp6PNEKUxM+fsw1xLsiOkzwaIor1knOp2iPO6i5dmUYtm?=
 =?us-ascii?Q?pibAxj7vbNTihsSYdOA1z34SFbYwE/0yzn75rwkmSBGv5k53Ol5OpS8VrAJG?=
 =?us-ascii?Q?lipuN3g+XVy4rT/Of+KOCElgPcTcmmF23UHBfj0GzsOX0HflzMEnu9mL4Eu0?=
 =?us-ascii?Q?b1UZX34xrcDFbbG5xTGIKIvgMvzse8u+nL4TMsQBiLXRgo72hn+QxZy+yK7J?=
 =?us-ascii?Q?/Uz44yZsVzpmuPQY3HrOYuE9RhqWwlEFxl2cFA8cvPKu3haFTjANeZcDX6xK?=
 =?us-ascii?Q?bjbkKh4PZD8rH4JvP69UuE6v/OKo7eIfI9hjAQnRH+xWRAeZeZxgaGrR7pWO?=
 =?us-ascii?Q?kA16jMfvneI6kp6avpBRQ8HR8Ma57A3NxwD/KYFrB/tJ8ZbSnuysmwms5hym?=
 =?us-ascii?Q?2HnCHYT9lvsIn1FPwOb4uI0Ru2TxVlhXhuMREUKuCYz6FcH7zV1nwhCt6YD4?=
 =?us-ascii?Q?GBGeVk5t0ZQJ/EKgBxSHtG2cvdHxXv15nFBYb8JQnQpf/8YCTC3J/5ivf4MU?=
 =?us-ascii?Q?ocJdmK1HGj+ljB6Q8kimrkzs5UKgiUCAxyosnUCZKWH59a7lhNJYA0f0Kbq8?=
 =?us-ascii?Q?HB74eO/Md47lMcbMxVNYj+YMXLqGehuWhfibCb7dCujfxeWjSrkhEv0FMqlZ?=
 =?us-ascii?Q?C3hbrQ0WW/P7tnlOFcjr3qsnLGnOSeI9JRAIleUgBpu2o60PNO6DiL2ZuXOS?=
 =?us-ascii?Q?4aNfFKY+9zroIwGNaAeUPbD7Fd3DACLJEEpq6UA9tIBNi3RYZUUOvJ7ztLeP?=
 =?us-ascii?Q?6V3s8x8Yuq57xUxWl31ueaoK3rKs7ppsIm827kur7a/rQBhJZ1jjB/QHLryE?=
 =?us-ascii?Q?6DB8VnXaaOBxmaCoUe5zeHM+YcaDqIGuK6hYse1qe0rvkr4qIBGPSpOCf3WZ?=
 =?us-ascii?Q?gwBNFg5NIaes2IamG+BdrOCeNgpa4h24LV2QUyh7OeQ6RwTyqx6Ga+sU6Ik2?=
 =?us-ascii?Q?mfthDd0BUAIUaU4n5jJ4iH/Cu3uoHC48QZ2YQzzWizUPxTouvLdMf4E45g2s?=
 =?us-ascii?Q?MW1yBgdp5gsO7mpVfqGhCU6DxkNchYbwY/Bmv3/+ElRfuIvSwRsB2vA1hFK5?=
 =?us-ascii?Q?0g=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd34d7d1-4cf4-460b-794c-08da7b0e8e43
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4989.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 20:26:07.4766
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1hbQ9rCyGHkwszUlxYtR8yB/pki117xfiV3RYUpMxHGkrEVT4tscDmoErizCDmOjWch/MsBpCKFPAp58BmOaRoNgsfIONrTHhcxh5gcXVp4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2920
X-Proofpoint-GUID: MT4C9fV03ewtCs2jfsCtw1Dr0VePN-hS
X-Proofpoint-ORIG-GUID: MT4C9fV03ewtCs2jfsCtw1Dr0VePN-hS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-10_14,2022-08-10_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 impostorscore=0
 bulkscore=0 mlxlogscore=823 mlxscore=0 lowpriorityscore=0 spamscore=0
 phishscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
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
[SG: Adjusted context for kernel version 5.4]
Signed-off-by: Stefan Ghinea <stefan.ghinea@windriver.com>
---
 include/linux/kvm_host.h | 28 +++++++++++++++++++++++++++-
 virt/kvm/kvm_main.c      | 10 +++++-----
 2 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 19e8344c51a8..dd4cdad76b18 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -146,6 +146,7 @@ static inline bool is_error_page(struct page *page)
 #define KVM_REQ_MMU_RELOAD        (1 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_PENDING_TIMER     2
 #define KVM_REQ_UNHALT            3
+#define KVM_REQ_VM_BUGGED         (4 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQUEST_ARCH_BASE     8
 
 #define KVM_ARCH_REQ_FLAGS(nr, flags) ({ \
@@ -502,6 +503,7 @@ struct kvm {
 	struct srcu_struct srcu;
 	struct srcu_struct irq_srcu;
 	pid_t userspace_pid;
+	bool vm_bugged;
 };
 
 #define kvm_err(fmt, ...) \
@@ -530,6 +532,31 @@ struct kvm {
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
@@ -790,7 +817,6 @@ void kvm_reload_remote_mmus(struct kvm *kvm);
 
 bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
 				 unsigned long *vcpu_bitmap, cpumask_var_t tmp);
-bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req);
 
 long kvm_arch_dev_ioctl(struct file *filp,
 			unsigned int ioctl, unsigned long arg);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 287444e52ccf..ec1cd059816d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2937,7 +2937,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
 	struct kvm_fpu *fpu = NULL;
 	struct kvm_sregs *kvm_sregs = NULL;
 
-	if (vcpu->kvm->mm != current->mm)
+	if (vcpu->kvm->mm != current->mm || vcpu->kvm->vm_bugged)
 		return -EIO;
 
 	if (unlikely(_IOC_TYPE(ioctl) != KVMIO))
@@ -3144,7 +3144,7 @@ static long kvm_vcpu_compat_ioctl(struct file *filp,
 	void __user *argp = compat_ptr(arg);
 	int r;
 
-	if (vcpu->kvm->mm != current->mm)
+	if (vcpu->kvm->mm != current->mm || vcpu->kvm->vm_bugged)
 		return -EIO;
 
 	switch (ioctl) {
@@ -3209,7 +3209,7 @@ static long kvm_device_ioctl(struct file *filp, unsigned int ioctl,
 {
 	struct kvm_device *dev = filp->private_data;
 
-	if (dev->kvm->mm != current->mm)
+	if (dev->kvm->mm != current->mm || dev->kvm->vm_bugged)
 		return -EIO;
 
 	switch (ioctl) {
@@ -3410,7 +3410,7 @@ static long kvm_vm_ioctl(struct file *filp,
 	void __user *argp = (void __user *)arg;
 	int r;
 
-	if (kvm->mm != current->mm)
+	if (kvm->mm != current->mm || kvm->vm_bugged)
 		return -EIO;
 	switch (ioctl) {
 	case KVM_CREATE_VCPU:
@@ -3618,7 +3618,7 @@ static long kvm_vm_compat_ioctl(struct file *filp,
 	struct kvm *kvm = filp->private_data;
 	int r;
 
-	if (kvm->mm != current->mm)
+	if (kvm->mm != current->mm || kvm->vm_bugged)
 		return -EIO;
 	switch (ioctl) {
 #ifdef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
-- 
2.37.1

