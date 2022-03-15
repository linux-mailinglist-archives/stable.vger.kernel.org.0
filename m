Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89BCD4D9EED
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 16:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245453AbiCOPo4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 11:44:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349696AbiCOPoz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 11:44:55 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A838412A88;
        Tue, 15 Mar 2022 08:43:42 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22FEVL9X005682;
        Tue, 15 Mar 2022 15:43:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : reply-to : subject : to : cc : references : from :
 in-reply-to : content-type : content-transfer-encoding; s=pp1;
 bh=459r01xmZlAP+2cSVQlS9UqVmJK+42DZpl6dRPzzILs=;
 b=lYEQBSfwgvrVjPkMY8vmVr8ZztqyEl74uZlG+Bu/MkfhC5eRK0E3KnthyyuOPeG328hL
 oFS9Jl2Udt7QNcgcoK/1DnyMR9IJvMY59aR8kY6W9b5eDH0HA+W4rpXTI5rHwfAfbvgy
 dRkVIrYZv65G7AdLDXltqq5lqN/W7MPKbgsSAKW8PW/5lweM0HUsZ6sMmd+KuqKCu3se
 GmRPAYIUJy3EPT+QOYuCtzVKQL1jrkEUDMAbgXhkM/KWdaNDbeR12K8UHGe195z38HXZ
 erpwfMpXyP6xZ1Ge6+Q2Bv7YuZCcZINL1rA4K8SQ5Bse+mFcEmL6h28bj4Y283/kRbEf Hg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3etvbk26t8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 15:43:42 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22FFe3BX017066;
        Tue, 15 Mar 2022 15:43:41 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3etvbk26st-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 15:43:41 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22FFXCIt001387;
        Tue, 15 Mar 2022 15:43:40 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma05wdc.us.ibm.com with ESMTP id 3erk59x9qe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 15:43:40 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22FFhdQ614287452
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Mar 2022 15:43:39 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 173E1C6065;
        Tue, 15 Mar 2022 15:43:39 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 980E7C605F;
        Tue, 15 Mar 2022 15:43:36 +0000 (GMT)
Received: from [9.160.176.198] (unknown [9.160.176.198])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Tue, 15 Mar 2022 15:43:36 +0000 (GMT)
Message-ID: <cb11c10b-0520-02ef-afb5-6f524847d67f@linux.ibm.com>
Date:   Tue, 15 Mar 2022 12:43:34 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.6.2
Reply-To: muriloo@linux.ibm.com
Subject: Re: [PATCH RESEND 1/2] KVM: Prevent module exit until all VMs are
 freed
Content-Language: en-US
To:     David Matlack <dmatlack@google.com>, pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Gleb Natapov <gleb@redhat.com>, Rik van Riel <riel@redhat.com>,
        seanjc@google.com, bgardon@google.com, stable@vger.kernel.org,
        farosas@linux.ibm.com
References: <20220303183328.1499189-1-dmatlack@google.com>
 <20220303183328.1499189-2-dmatlack@google.com>
From:   =?UTF-8?Q?Murilo_Opsfelder_Ara=c3=bajo?= <muriloo@linux.ibm.com>
Organization: IBM
In-Reply-To: <20220303183328.1499189-2-dmatlack@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: bmcD82FCleoXPe_xRkh2OLyuTvBmgPBM
X-Proofpoint-ORIG-GUID: xPOGm2O2ZRhdPuIZrcwqS2YAq_Xn5tRr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-15_03,2022-03-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 malwarescore=0 priorityscore=1501 suspectscore=0 clxscore=1011
 lowpriorityscore=0 impostorscore=0 mlxscore=0 bulkscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203150101
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, David.

Some comments below.

On 3/3/22 15:33, David Matlack wrote:
> Tie the lifetime the KVM module to the lifetime of each VM via
> kvm.users_count. This way anything that grabs a reference to the VM via
> kvm_get_kvm() cannot accidentally outlive the KVM module.
> 
> Prior to this commit, the lifetime of the KVM module was tied to the
> lifetime of /dev/kvm file descriptors, VM file descriptors, and vCPU
> file descriptors by their respective file_operations "owner" field.
> This approach is insufficient because references grabbed via
> kvm_get_kvm() do not prevent closing any of the aforementioned file
> descriptors.
> 
> This fixes a long standing theoretical bug in KVM that at least affects
> async page faults. kvm_setup_async_pf() grabs a reference via
> kvm_get_kvm(), and drops it in an asynchronous work callback. Nothing
> prevents the VM file descriptor from being closed and the KVM module
> from being unloaded before this callback runs.
> 
> Fixes: af585b921e5d ("KVM: Halt vcpu if page it tries to access is swapped out")
> Cc: stable@vger.kernel.org
> Suggested-by: Ben Gardon <bgardon@google.com>
> [ Based on a patch from Ben implemented for Google's kernel. ]
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>   virt/kvm/kvm_main.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 35ae6d32dae5..b59f0a29dbd5 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -117,6 +117,8 @@ EXPORT_SYMBOL_GPL(kvm_debugfs_dir);
>   
>   static const struct file_operations stat_fops_per_vm;
>   
> +static struct file_operations kvm_chardev_ops;
> +
>   static long kvm_vcpu_ioctl(struct file *file, unsigned int ioctl,
>   			   unsigned long arg);
>   #ifdef CONFIG_KVM_COMPAT
> @@ -1131,6 +1133,11 @@ static struct kvm *kvm_create_vm(unsigned long type)
>   	preempt_notifier_inc();
>   	kvm_init_pm_notifier(kvm);
>   
> +	if (!try_module_get(kvm_chardev_ops.owner)) {
> +		r = -ENODEV;
> +		goto out_err;
> +	}
> +

Doesn't this problem also affects the other functions called from
kvm_dev_ioctl()?

Is it possible that the module is removed while other ioctl's are still running,
e.g. KVM_GET_API_VERSION and KVM_CHECK_EXTENSION, even though they don't use
struct kvm?

I wonder if this try_module_get() (along with module_put() in the out path of
the function) shouldn't be placed in the upper function kvm_dev_ioctl() so it
would cover all the other ioctl's.

>   	return kvm;
>   
>   out_err:
> @@ -1220,6 +1227,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
>   	preempt_notifier_dec();
>   	hardware_disable_all();
>   	mmdrop(mm);
> +	module_put(kvm_chardev_ops.owner);
>   }
>   
>   void kvm_get_kvm(struct kvm *kvm)
> 
> base-commit: b13a3befc815eae574d87e6249f973dfbb6ad6cd
> prerequisite-patch-id: 38f66d60319bf0bc9bf49f91f0f9119e5441629b
> prerequisite-patch-id: 51aa921d68ea649d436ea68e1b8f4aabc3805156

-- 
Murilo
