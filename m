Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D49C94A466B
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236759AbiAaL4R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:56:17 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:14450 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1379847AbiAaLyR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:54:17 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20VALpM5005878;
        Mon, 31 Jan 2022 11:54:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=jc2JNsmqbDJCnzfBwqTksS9W3mCw8QOBMkrWxU+FpRI=;
 b=sIKDFFiEOVMg4hIM9hvIv6m+Ve5QTOSknkTVcdda2OcDuGuQGVfGNJusyPHpQWQbEpDW
 MEgT4M9p9Fk07JIHY6yKTDS9HSB7UpXSI4hH4PbScyeXMA/PzK4Sp51/C8BGVkKifVLr
 CeoB2yfhKpgUKN02aWnyU+/hGvqJgCRNm9Z7WA0zKAo2fOd7yp78fJevmQVtuL0rfXft
 Xf8OVaPixTPEvdGWcYe9sUL1UNnshNIGGd8OUYdLv99Q7rAoKn/ZKmgV1ce9mrliXVVt
 e6AlGccJQGV/F3Fddy3SiQ5dFTd8RaPyCQ14kGgkcLVtbPdI6h5UJvnbqtxR5LAQPIy/ 0g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dx66cshdc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Jan 2022 11:54:13 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20VBnGas014679;
        Mon, 31 Jan 2022 11:54:12 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dx66cshcq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Jan 2022 11:54:12 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20VBkJVP005252;
        Mon, 31 Jan 2022 11:54:10 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3dvvuj3216-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Jan 2022 11:54:10 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20VBs4gQ43778356
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Jan 2022 11:54:04 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C0AEDA4062;
        Mon, 31 Jan 2022 11:54:04 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0BA6FA4054;
        Mon, 31 Jan 2022 11:54:04 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.30.167])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Mon, 31 Jan 2022 11:54:03 +0000 (GMT)
Date:   Mon, 31 Jan 2022 12:53:37 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Petr =?UTF-8?B?VGVzYcWZw61r?= <ptesarik@suse.cz>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Michael Mueller <mimu@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH 1/1] KVM: s390: index kvm->arch.idle_mask by vcpu_idx
Message-ID: <20220131125337.05f73251.pasic@linux.ibm.com>
In-Reply-To: <3ca4de98-8f4d-9937-923e-f8865c96f82c@suse.cz>
References: <20210827125429.1912577-1-pasic@linux.ibm.com>
        <3ca4de98-8f4d-9937-923e-f8865c96f82c@suse.cz>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: DLJPiBPGkgXLP74QnMzf_7wRLvHMlYG0
X-Proofpoint-ORIG-GUID: fVGO_KlqpsYh9m2hCs-yqCkwDA-VKiGY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-31_04,2022-01-28_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 mlxlogscore=999 clxscore=1011 bulkscore=0 priorityscore=1501 adultscore=0
 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201310077
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 31 Jan 2022 11:13:18 +0100
Petr Tesařík <ptesarik@suse.cz> wrote:

> Hi Halil,
> 
> Dne 27. 08. 21 v 14:54 Halil Pasic napsal(a):
> > While in practice vcpu->vcpu_idx ==  vcpu->vcp_id is often true,
> > it may not always be, and we must not rely on this.
> > 
> > Currently kvm->arch.idle_mask is indexed by vcpu_id, which implies
> > that code like
> > for_each_set_bit(vcpu_id, kvm->arch.idle_mask, online_vcpus) {
> >                  vcpu = kvm_get_vcpu(kvm, vcpu_id);
> > 		do_stuff(vcpu);
> > }
> > is not legit. The trouble is, we do actually use kvm->arch.idle_mask
> > like this. To fix this problem we have two options. Either use
> > kvm_get_vcpu_by_id(vcpu_id), which would loop to find the right vcpu_id,
> > or switch to indexing via vcpu_idx. The latter is preferable for obvious
> > reasons.  
> 
> I'm just backporting this fix to SLES 12 SP5, and I've noticed that 
> there is still this code in __floating_irq_kick():
> 
> 	/* find idle VCPUs first, then round robin */
> 	sigcpu = find_first_bit(fi->idle_mask, online_vcpus);
> /* ... round robin loop removed ...
> 	dst_vcpu = kvm_get_vcpu(kvm, sigcpu);
> 
> It seems to me that this does exactly the thing that is not legit, but 
> I'm no expert. Did I miss something?
> 

We made that legit by making the N-th bit in idle_mask correspond to the
vcpu whose vcpu_idx == N. The second argument of kvm_get_vcpu() is the
vcpu_idx. IMHO that ain't super-intuitive because it ain't spelled out.

So before this was a mismatch (with a vcpu_id based bitmap we would have
to use kvm_get_vcpu_by_id()), and with this patch applied this code
becomes legit because both idle_mask and kvm_get_vcpu() operate with
vcpu_idx.

Does that make sense?

I'm sorry the commit message did not convey this clearly enough...

Regards,
Halil


> Petr T
> 
> > Let us make switch from indexing kvm->arch.idle_mask by vcpu_id to
> > indexing it by vcpu_idx.  To keep gisa_int.kicked_mask indexed by the
> > same index as idle_mask lets make the same change for it as well.
> > 
> > Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> > Fixes: 1ee0bc559dc3 ("KVM: s390: get rid of local_int array")
> > Cc: <stable@vger.kernel.org> # 3.15+
> > ---
> >   arch/s390/include/asm/kvm_host.h |  1 +
> >   arch/s390/kvm/interrupt.c        | 12 ++++++------
> >   arch/s390/kvm/kvm-s390.c         |  2 +-
> >   arch/s390/kvm/kvm-s390.h         |  2 +-
> >   4 files changed, 9 insertions(+), 8 deletions(-)
> > 
> > diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> > index 161a9e12bfb8..630eab0fa176 100644
> > --- a/arch/s390/include/asm/kvm_host.h
> > +++ b/arch/s390/include/asm/kvm_host.h
> > @@ -957,6 +957,7 @@ struct kvm_arch{
> >   	atomic64_t cmma_dirty_pages;
> >   	/* subset of available cpu features enabled by user space */
> >   	DECLARE_BITMAP(cpu_feat, KVM_S390_VM_CPU_FEAT_NR_BITS);
> > +	/* indexed by vcpu_idx */
> >   	DECLARE_BITMAP(idle_mask, KVM_MAX_VCPUS);
> >   	struct kvm_s390_gisa_interrupt gisa_int;
> >   	struct kvm_s390_pv pv;
> > diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> > index d548d60caed2..16256e17a544 100644
> > --- a/arch/s390/kvm/interrupt.c
> > +++ b/arch/s390/kvm/interrupt.c
> > @@ -419,13 +419,13 @@ static unsigned long deliverable_irqs(struct kvm_vcpu *vcpu)
> >   static void __set_cpu_idle(struct kvm_vcpu *vcpu)
> >   {
> >   	kvm_s390_set_cpuflags(vcpu, CPUSTAT_WAIT);
> > -	set_bit(vcpu->vcpu_id, vcpu->kvm->arch.idle_mask);
> > +	set_bit(kvm_vcpu_get_idx(vcpu), vcpu->kvm->arch.idle_mask);
> >   }
> >   
> >   static void __unset_cpu_idle(struct kvm_vcpu *vcpu)
> >   {
> >   	kvm_s390_clear_cpuflags(vcpu, CPUSTAT_WAIT);
> > -	clear_bit(vcpu->vcpu_id, vcpu->kvm->arch.idle_mask);
> > +	clear_bit(kvm_vcpu_get_idx(vcpu), vcpu->kvm->arch.idle_mask);
> >   }
> >   
> >   static void __reset_intercept_indicators(struct kvm_vcpu *vcpu)
> > @@ -3050,18 +3050,18 @@ int kvm_s390_get_irq_state(struct kvm_vcpu *vcpu, __u8 __user *buf, int len)
> >   
> >   static void __airqs_kick_single_vcpu(struct kvm *kvm, u8 deliverable_mask)
> >   {
> > -	int vcpu_id, online_vcpus = atomic_read(&kvm->online_vcpus);
> > +	int vcpu_idx, online_vcpus = atomic_read(&kvm->online_vcpus);
> >   	struct kvm_s390_gisa_interrupt *gi = &kvm->arch.gisa_int;
> >   	struct kvm_vcpu *vcpu;
> >   
> > -	for_each_set_bit(vcpu_id, kvm->arch.idle_mask, online_vcpus) {
> > -		vcpu = kvm_get_vcpu(kvm, vcpu_id);
> > +	for_each_set_bit(vcpu_idx, kvm->arch.idle_mask, online_vcpus) {
> > +		vcpu = kvm_get_vcpu(kvm, vcpu_idx);
> >   		if (psw_ioint_disabled(vcpu))
> >   			continue;
> >   		deliverable_mask &= (u8)(vcpu->arch.sie_block->gcr[6] >> 24);
> >   		if (deliverable_mask) {
> >   			/* lately kicked but not yet running */
> > -			if (test_and_set_bit(vcpu_id, gi->kicked_mask))
> > +			if (test_and_set_bit(vcpu_idx, gi->kicked_mask))
> >   				return;
> >   			kvm_s390_vcpu_wakeup(vcpu);
> >   			return;
> > diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> > index 4527ac7b5961..8580543c5bc3 100644
> > --- a/arch/s390/kvm/kvm-s390.c
> > +++ b/arch/s390/kvm/kvm-s390.c
> > @@ -4044,7 +4044,7 @@ static int vcpu_pre_run(struct kvm_vcpu *vcpu)
> >   		kvm_s390_patch_guest_per_regs(vcpu);
> >   	}
> >   
> > -	clear_bit(vcpu->vcpu_id, vcpu->kvm->arch.gisa_int.kicked_mask);
> > +	clear_bit(kvm_vcpu_get_idx(vcpu), vcpu->kvm->arch.gisa_int.kicked_mask);
> >   
> >   	vcpu->arch.sie_block->icptcode = 0;
> >   	cpuflags = atomic_read(&vcpu->arch.sie_block->cpuflags);
> > diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
> > index 9fad25109b0d..ecd741ee3276 100644
> > --- a/arch/s390/kvm/kvm-s390.h
> > +++ b/arch/s390/kvm/kvm-s390.h
> > @@ -79,7 +79,7 @@ static inline int is_vcpu_stopped(struct kvm_vcpu *vcpu)
> >   
> >   static inline int is_vcpu_idle(struct kvm_vcpu *vcpu)
> >   {
> > -	return test_bit(vcpu->vcpu_id, vcpu->kvm->arch.idle_mask);
> > +	return test_bit(kvm_vcpu_get_idx(vcpu), vcpu->kvm->arch.idle_mask);
> >   }
> >   
> >   static inline int kvm_is_ucontrol(struct kvm *kvm)
> > 
> > base-commit: 77dd11439b86e3f7990e4c0c9e0b67dca82750ba  

