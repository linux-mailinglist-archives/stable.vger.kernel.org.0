Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3C1158F387
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 22:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233315AbiHJU1O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Aug 2022 16:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233318AbiHJU1N (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 16:27:13 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41D6F275D2
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 13:27:12 -0700 (PDT)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27AESowY024592;
        Wed, 10 Aug 2022 13:27:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version; s=PPS06212021;
 bh=1inr0f3LVudO32kawaq9G2u1FfKDLMGVcL+oZIJUVBQ=;
 b=lafVRp7G+aLz1R+VUnCsamlkTNYiknUnyM2LsyL8a7eIx/Mf7Ww55migS5hK0MswmJq3
 0aJDLlSD19OcEwm3EV0V2+Pb2K/XWjXwDldNad1v/nShknV8rgiebFy2IitTiGt/Ox+6
 iekduAmWwwIWm14yxlG3+ZRF3hhsVsA4nkgwJAy0vXe4U+1KkkTWpAn+aE5xENAezBPV
 HHo/PMihNyN8V0mVIq95ZYiZigre8PWccrJq/HRlETe3zi7NM8+rARwN94mrARoIBVMo
 z6HY2wAliXF0wzkKqjRWGAQL/ED1j4OGxXQdFQghYcQ0/GLYSg1jOY/rMMHfcp6IOy2W 4Q== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3huwrcgwwh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Aug 2022 13:27:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EmN0hmjpPbStKiwjA9ATDXx3KrxzoW8Z8QYXT8EHnfLqSTSJerft4nCVFfKdmPV1E+iZFcDgmWm4P1oxq0Q09AFgJulQl8F+2BjROSJ9Dw9m2NR1G796LkyD4iSvPZZHXM2amXS9SP4/ePlLQZnP9W68KBrHjmfcbUCB8W+6lXUoMDTLJL4n/hx6ii3yo8cZcp+QRVIu8Xlj3XTt9BdEcUm4brCZvzod9tbKSWejmwWx9r4Xojz2T+5JANkcyISPS4/xRry4HxqVS2xpd2Mz+hR8h+LO5O8wveagXCLwPKe6i6wbfJN9p+m7/Igl90frXHSJgM/WX/C7URGNxp5GSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1inr0f3LVudO32kawaq9G2u1FfKDLMGVcL+oZIJUVBQ=;
 b=j6wd8iXSrkexeLaFIRvoFU2wetC1V9W72+dALoER6rTXTKu7tHZ8oidU+50wb2SFfzcaHbEEkqY0pM90Xgw3PGXr267ayuMGWxY0CF0RZUD3iDdbEmQaBQOqoJe/3ZuKFd5snR67iSCb3lEeJLbM0MAkANZ69uGKQSCI8/76kqoesSebHrmHnReei5BC58ZsgBH/WS4vy2uCNptT/J3Q7u28SUiEH3uF5/cR/pu58FHW5hrCHM64+GAKppQBKaYkxqKU9X3jmM4l7Y6jL+XYgDJi2bKOjSBv18G7e2Maj4sc5F3KFKTGzHI8/uHjTHeedv8+pVS75+Q/J/E3o92wmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com (2603:10b6:a03:2d9::22)
 by CH0PR11MB5217.namprd11.prod.outlook.com (2603:10b6:610:e0::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Wed, 10 Aug
 2022 20:27:07 +0000
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::c1cd:e945:f9e:b71f]) by SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::c1cd:e945:f9e:b71f%9]) with mapi id 15.20.5504.021; Wed, 10 Aug 2022
 20:27:07 +0000
From:   Stefan Ghinea <stefan.ghinea@windriver.com>
To:     stable@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Ghinea <stefan.ghinea@windriver.com>
Subject: [PATCH 4.14 1/3] KVM: Add infrastructure and macro to mark VM as bugged
Date:   Wed, 10 Aug 2022 23:26:53 +0300
Message-Id: <20220810202655.32600-1-stefan.ghinea@windriver.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0083.namprd03.prod.outlook.com
 (2603:10b6:a03:331::28) To SJ0PR11MB4989.namprd11.prod.outlook.com
 (2603:10b6:a03:2d9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7f1bf193-5b76-410b-0b37-08da7b0eb221
X-MS-TrafficTypeDiagnostic: CH0PR11MB5217:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wP+Z88jO6Zj3o0XwiSGOZU1qCS9cdR6pZangI8Lm+/dPwfAiqnDIthWEJ2NZ8vj3xZI0CCtoX6aiAeJoi/3bm3v3ZdnAFI2H0EouAvbJozA5I9DGWhnAtkaUcDSOKN931jQ7+9SooGUfYAGZkAQ4QRXfByv4iIygfxao3oGUHjrRAOSpyFuJmqwArGE2AKM4CTyt8DXBfBR4z/YoRGCwHoxjXZWtj/5RDDEOlyM3r4UWNa60DZkFvh6vYfXX/TkKsIWqQA464ffxZelOODtArM4a5b0uAo1ph/t/vWyCk/Z3HO2M3GLOJAkyiYJougV+5kr/BnaNvc5ooAdIaKjjIkAU+e0+SI0yt17gLcm0G6bU0SKWijcWPDYP4xrEW8yur5rTHp1lFCYHgKC2KG23XlnAeIwQcPUCxmv/CIKCz5/JmXcL2TKWSC17r/EbdlXoCgn6FUG79BkkzzjCAcBdkElKl3Bo3sx7/btjhivqZbRCdqTr+NRuKx23Oac43nOmz4/DmvOIrCTjckHnOEfBcTI68prI4sMPcnL0EHz8Nbw5GRE47R6T3pRumSgCdUkrfuGpIiHpKSJ1KNwuO9YvxnckfYLDOf1295lXNJerySc+eg95F89UOoCJzjoTr5IbeJ54/lL48OJTwdFDiyqVlBlxzrlz3XeQrWO3GqjVV7xpMPhKmyvG6J25ACNBP0VG2BFMwnaR5xAYd8+SrByknsdtEw+2jMud9got5PcsdyoKcDk70ommyS1J8+B4b/16olVRhTg+cYKwW5je8nbvgesNYwCaQfjpIcJaHoswFCw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4989.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(39850400004)(396003)(376002)(366004)(346002)(54906003)(6916009)(316002)(36756003)(8936002)(478600001)(86362001)(6486002)(5660300002)(44832011)(2906002)(6666004)(2616005)(83380400001)(38100700002)(38350700002)(41300700001)(52116002)(6506007)(8676002)(66946007)(66476007)(4326008)(66556008)(107886003)(186003)(6512007)(26005)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yMyBwjWMClfzoXWM1lHaLCcBJwVk/KUJ0IEg+y0WE47W1VCcnVar1aWs/qAE?=
 =?us-ascii?Q?mBajYU2Ip2LUNNSxcmJ/8yC2syK1Qcf/KYbJ5h7KOPigoepyHad1dHbAj8ML?=
 =?us-ascii?Q?khJF1yrHDUEXR3mzntwvoUlxqtZXzoZ84aGX7W2FsYGBiLuu7g/68HcBIamj?=
 =?us-ascii?Q?Old6WFnfJgYUg70idDLWw3bnf2d1bI5j1J3D628D83psR0H6Cla+kMryAqG6?=
 =?us-ascii?Q?vUNosW7WQF5/rU3ZHDVG+QcsVPfh40x6QeaH1TTx/FyM7ZqA8maEJ5770p80?=
 =?us-ascii?Q?73xrcm7qPXieErre0gW5K/x4qrXk4jY4wEI1sphYobAsq4/PgJiqbAjQlJy1?=
 =?us-ascii?Q?FC9NkXu5pZwimJxjD/AjqgkLqe4XBYxvB+470NvZCnJnj1espcsNchZK3JCE?=
 =?us-ascii?Q?7YdvGcguYSufc9OaeHeu/6fmS7BFQ1nq7DuDc3xuCNWWIYFS5OVCF1kD7oWG?=
 =?us-ascii?Q?EsG7L6Uu4z9wIpk+EeN2Wd7K/S/KRagjCgzNdfaVEe7Np5XhHqVFCkVTme0S?=
 =?us-ascii?Q?6r4kF1PYe3NEaEA3PPn4DQTypd0PVIBgITl3qz/brN1mTr+qBp7NBRfYsk5A?=
 =?us-ascii?Q?EI54DLsjl238t9T0SIr/hhol4xSyk6JDb+nA+BJ6pZYxH/yXrgWxQb7NqHk1?=
 =?us-ascii?Q?rVGXwGugmVxGIrKYi42NnoG79EsyACfplCWNQ0GXHdA/sZQ97NVw8Mi2vOA4?=
 =?us-ascii?Q?KKFsrhf1dqLv3/zPnc4sE+QxiSuuhTcLQ7qtq6/bqd1an5BZr8IxUB/p0jpM?=
 =?us-ascii?Q?p3r3SUkp39spjuwePo/vntpI/0S90+hRLUzDwK/kDhxD6Jd7Cy6AWWvqRwcW?=
 =?us-ascii?Q?KW+Pkew5Q6UB/GmEh3MvUvSPxC/GTUV4rj0kV3bk4qL7WhY6mSMOhJ8vvlKY?=
 =?us-ascii?Q?lnyY38u7ioGKS5G+1Boo3LYSzzBsofmp+MNmlNnqQHYMVISMgGAObwEaK/pp?=
 =?us-ascii?Q?tSBarUhljMJCBiTnCHdyPlV2xQUc4aTZ7hSef6uyxpXMe+9sHlaWPhfCJ16y?=
 =?us-ascii?Q?/HZoy33cdIfxnLHmvlH5gzVyzBw29bVTkiuGwLETVOIUi8nnBbT/Ij/iJ+Mi?=
 =?us-ascii?Q?0wrrZ9B5d6/TnEld/CKXqqvuBmUYCF8Zwem3OZf+tUBTUN8f1xzUjmfGVIcQ?=
 =?us-ascii?Q?zKDcyY/BjCGXNw380+TZF377XRZDlLA04Gv0CaWfBXc41GMi2vGkkuxWHaxd?=
 =?us-ascii?Q?cJESo46biLcq9DePS1q1Ndd2A2BThFjwLzt7Z3iERdXnHH4ttznRvNdZ5B3J?=
 =?us-ascii?Q?dzXBJkhJZ6jjIrRR14ok7eGwS2TnQYPKggvCezJoB3UOz5KR6TYvXdY0jvyN?=
 =?us-ascii?Q?XZwIjCh4HNyGAEN7h5FOqyISzknOpbXjP7emNwgJV1UOd4wXDO8xT85bPc/J?=
 =?us-ascii?Q?eR8d2cvOpWZwAM+MlxJ/T5lL6I2qXIszrFR7VovafVrTgKIUXr3ZnVtN0+W3?=
 =?us-ascii?Q?eI2UTDj4I2yqQKvg3HTnCb+QzFnYrr2L9/IPqq+PIhZWoaU6HY1lNvkPkhBm?=
 =?us-ascii?Q?weuCLukfAbNtlxzXs+qAK+K0SDXX/40JQn1A5bD6pVFxovUmW0p63DwfaeS9?=
 =?us-ascii?Q?hmGDls6/ck7ja/YQ3h8i3NUASfDMJgu4Krf7U3qnwoJXxWelpsBvuy4E9yTp?=
 =?us-ascii?Q?YQ=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f1bf193-5b76-410b-0b37-08da7b0eb221
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4989.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 20:27:07.7895
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OgiJ1HF7+AQRwGEKWsWkM5LH5OqI/6hd1dapfW6gnWa1FyYSXGckgVvqPPL+ewS7av6jmSWdGKxYl1IlM6vMsZB4ynFaGxk23C3lEAAyrBk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5217
X-Proofpoint-GUID: x_J5jZwlJAsYSot88v3hgw59aQr8o96t
X-Proofpoint-ORIG-GUID: x_J5jZwlJAsYSot88v3hgw59aQr8o96t
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-10_14,2022-08-10_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 impostorscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 spamscore=0 adultscore=0 mlxlogscore=702 phishscore=0 lowpriorityscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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
[SG: Adjusted context for kernel version 4.14]
Signed-off-by: Stefan Ghinea <stefan.ghinea@windriver.com>
---
 include/linux/kvm_host.h | 28 +++++++++++++++++++++++++++-
 virt/kvm/kvm_main.c      | 10 +++++-----
 2 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d5e38ebcfa47..2c6a321899e8 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -127,6 +127,7 @@ static inline bool is_error_page(struct page *page)
 #define KVM_REQ_MMU_RELOAD        (1 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_PENDING_TIMER     2
 #define KVM_REQ_UNHALT            3
+#define KVM_REQ_VM_BUGGED         (4 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQUEST_ARCH_BASE     8
 
 #define KVM_ARCH_REQ_FLAGS(nr, flags) ({ \
@@ -446,6 +447,7 @@ struct kvm {
 	struct kvm_stat_data **debugfs_stat_data;
 	struct srcu_struct srcu;
 	struct srcu_struct irq_srcu;
+	bool vm_bugged;
 	pid_t userspace_pid;
 };
 
@@ -475,6 +477,31 @@ struct kvm {
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
@@ -732,7 +759,6 @@ void kvm_put_guest_fpu(struct kvm_vcpu *vcpu);
 
 void kvm_flush_remote_tlbs(struct kvm *kvm);
 void kvm_reload_remote_mmus(struct kvm *kvm);
-bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req);
 
 long kvm_arch_dev_ioctl(struct file *filp,
 			unsigned int ioctl, unsigned long arg);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 87d522eefbb4..7c4de635f00a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2660,7 +2660,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
 	struct kvm_fpu *fpu = NULL;
 	struct kvm_sregs *kvm_sregs = NULL;
 
-	if (vcpu->kvm->mm != current->mm)
+	if (vcpu->kvm->mm != current->mm || vcpu->kvm->vm_bugged)
 		return -EIO;
 
 	if (unlikely(_IOC_TYPE(ioctl) != KVMIO))
@@ -2864,7 +2864,7 @@ static long kvm_vcpu_compat_ioctl(struct file *filp,
 	void __user *argp = compat_ptr(arg);
 	int r;
 
-	if (vcpu->kvm->mm != current->mm)
+	if (vcpu->kvm->mm != current->mm || vcpu->kvm->vm_bugged)
 		return -EIO;
 
 	switch (ioctl) {
@@ -2922,7 +2922,7 @@ static long kvm_device_ioctl(struct file *filp, unsigned int ioctl,
 {
 	struct kvm_device *dev = filp->private_data;
 
-	if (dev->kvm->mm != current->mm)
+	if (dev->kvm->mm != current->mm || dev->kvm->vm_bugged)
 		return -EIO;
 
 	switch (ioctl) {
@@ -3087,7 +3087,7 @@ static long kvm_vm_ioctl(struct file *filp,
 	void __user *argp = (void __user *)arg;
 	int r;
 
-	if (kvm->mm != current->mm)
+	if (kvm->mm != current->mm || kvm->vm_bugged)
 		return -EIO;
 	switch (ioctl) {
 	case KVM_CREATE_VCPU:
@@ -3264,7 +3264,7 @@ static long kvm_vm_compat_ioctl(struct file *filp,
 	struct kvm *kvm = filp->private_data;
 	int r;
 
-	if (kvm->mm != current->mm)
+	if (kvm->mm != current->mm || kvm->vm_bugged)
 		return -EIO;
 	switch (ioctl) {
 	case KVM_GET_DIRTY_LOG: {
-- 
2.37.1

