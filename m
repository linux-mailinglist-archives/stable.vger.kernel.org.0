Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4BFF31163E
	for <lists+stable@lfdr.de>; Sat,  6 Feb 2021 00:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbhBEW7F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 17:59:05 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:53622 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231778AbhBEMV3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Feb 2021 07:21:29 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 115C30uA146160;
        Fri, 5 Feb 2021 07:20:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=0xuNBImoUyQ+IP7PJ61t5Qf97yOBkDdDWIuWSZuyW2o=;
 b=jalKQ3W1CcDu9bvDOpEgakWxcDMFOxSCfHtlWhJlFA+iWaW70V6RFbZDSkAlC+5BEJTM
 Q5JKsyQzkcexoahcTGft8KU1uI3vYFsIAZ5IixIxnG9NOTKpHmXCXWkcqu5I9WR/KlnA
 o2dV1oUYZsfOeGgxzpPgb7E8yXW4GZxqj80C679eWxGfHCQRIPcx/UOZl6dH7AJO1hro
 rSkhvkhfbTfBaebf+tTZgS4fHPT3O801foG3v7GsLVXou+e4NVV+Np4PcZordtVy4slP
 OherjOEWkxNu2Hkw7GPM52qMdov4CGKrspUEM5JFBeVVv/FiqARPA//mGOptLMkLwFS8 AA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36h5hkgqfd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Feb 2021 07:20:39 -0500
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 115C33qA146295;
        Fri, 5 Feb 2021 07:20:37 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36h5hkgqd8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Feb 2021 07:20:37 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 115CDJTX009922;
        Fri, 5 Feb 2021 12:20:35 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 36evvf3hg0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Feb 2021 12:20:34 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 115CKVYF30015892
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 5 Feb 2021 12:20:31 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 838AFA405B;
        Fri,  5 Feb 2021 12:20:31 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 26FF5A4060;
        Fri,  5 Feb 2021 12:20:31 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.1.216])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  5 Feb 2021 12:20:31 +0000 (GMT)
Date:   Fri, 5 Feb 2021 13:20:09 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, borntraeger@de.ibm.com,
        david@redhat.com, kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 2/2] s390/kvm: VSIE: correctly handle MVPG when in
 VSIE
Message-ID: <20210205132009.6d5566d9@ibm-vm>
In-Reply-To: <2e409ab1-1865-d59a-dc89-2d30f2657a38@linux.ibm.com>
References: <20210202180028.876888-1-imbrenda@linux.ibm.com>
        <20210202180028.876888-3-imbrenda@linux.ibm.com>
        <2e409ab1-1865-d59a-dc89-2d30f2657a38@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-05_07:2021-02-05,2021-02-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 spamscore=0 phishscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 impostorscore=0 mlxscore=0 lowpriorityscore=0 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102050080
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 4 Feb 2021 18:10:01 +0100
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 2/2/21 7:00 PM, Claudio Imbrenda wrote:
> > Correctly handle the MVPG instruction when issued by a VSIE guest.
> > 
> > Fixes: a3508fbe9dc6d ("KVM: s390: vsie: initial support for nested
> > virtualization") Cc: stable@vger.kernel.org
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>  
> 
> So far the patch looks ok to me and way better to understand than v1,
> good job
> 
> > ---
> >  arch/s390/kvm/vsie.c | 94
> > +++++++++++++++++++++++++++++++++++++++++--- 1 file changed, 89
> > insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
> > index 7db022141db3..2db49749e27b 100644
> > --- a/arch/s390/kvm/vsie.c
> > +++ b/arch/s390/kvm/vsie.c
> > @@ -416,11 +416,6 @@ static void unshadow_scb(struct kvm_vcpu
> > *vcpu, struct vsie_page *vsie_page) memcpy((void *)((u64)scb_o +
> > 0xc0), (void *)((u64)scb_s + 0xc0), 0xf0 - 0xc0);  
> 
> Magic offsets being magic
> Another item for my todo list.
> 
> >  		break;
> > -	case ICPT_PARTEXEC:
> > -		/* MVPG only */
> > -		memcpy((void *)((u64)scb_o + 0xc0),
> > -		       (void *)((u64)scb_s + 0xc0), 0xd0 - 0xc0);
> > -		break;
> >  	}
> >  
> >  	if (scb_s->ihcpu != 0xffffU)
> > @@ -982,6 +977,91 @@ static int handle_stfle(struct kvm_vcpu *vcpu,
> > struct vsie_page *vsie_page) return 0;
> >  }
> >  
> > +static u64 vsie_get_register(struct kvm_vcpu *vcpu, struct
> > vsie_page *vsie_page, u8 reg) +{
> > +	reg &= 0xf;
> > +	switch (reg) {
> > +	case 15:
> > +		return vsie_page->scb_s.gg15;
> > +	case 14:
> > +		return vsie_page->scb_s.gg14;
> > +	default:
> > +		return vcpu->run->s.regs.gprs[reg];
> > +	}
> > +}
> > +
> > +static int vsie_handle_mvpg(struct kvm_vcpu *vcpu, struct
> > vsie_page *vsie_page) +{
> > +	struct kvm_s390_sie_block *scb_s = &vsie_page->scb_s;
> > +	unsigned long pei1, pei2, src, dest, mask = PAGE_MASK;
> > +	u64 *pei_block = &vsie_page->scb_o->mcic;
> > +	int edat, rc1, rc2;  
> 
> Can use a src/dst prefix or suffix please?
> 1/2 is confusing.

will do

> > +	union ctlreg0 cr0;
> > +
> > +	cr0.val = vcpu->arch.sie_block->gcr[0];
> > +	edat = cr0.edat && test_kvm_facility(vcpu->kvm, 8);
> > +	if (psw_bits(scb_s->gpsw).eaba == PSW_BITS_AMODE_24BIT)
> > +		mask = 0xfff000;
> > +	else if (psw_bits(scb_s->gpsw).eaba ==
> > PSW_BITS_AMODE_31BIT)
> > +		mask = 0x7ffff000;
> > +
> > +	dest = vsie_get_register(vcpu, vsie_page, scb_s->ipb >>
> > 16) & mask;
> > +	src = vsie_get_register(vcpu, vsie_page, scb_s->ipb >> 20)
> > & mask; +
> > +	rc1 = kvm_s390_shadow_fault(vcpu, vsie_page->gmap, dest,
> > &pei1);
> > +	rc2 = kvm_s390_shadow_fault(vcpu, vsie_page->gmap, src,
> > &pei2);
> > +	/*
> > +	 * Either everything went well, or something non-critical
> > went wrong
> > +	 * e.g. beause of a race. In either case, simply retry.
> > +	 */
> > +	if (rc1 == -EAGAIN || rc2 == -EAGAIN || (!rc1 && !rc2)) {
> > +		retry_vsie_icpt(vsie_page);
> > +		return -EAGAIN;
> > +	}
> > +	/* Something more serious went wrong, propagate the error
> > */
> > +	if (rc1 < 0)
> > +		return rc1;
> > +	if (rc2 < 0)
> > +		return rc2;
> > +
> > +	/* The only possible suppressing exception: just deliver
> > it */
> > +	if (rc1 == PGM_TRANSLATION_SPEC || rc2 ==
> > PGM_TRANSLATION_SPEC) {
> > +		clear_vsie_icpt(vsie_page);
> > +		rc1 = kvm_s390_inject_program_int(vcpu,
> > PGM_TRANSLATION_SPEC);
> > +		WARN_ON_ONCE(rc1);
> > +		return 1;
> > +	}
> > +
> > +	/*
> > +	 * Forward the PEI intercept to the guest if it was a page
> > fault, or
> > +	 * also for segment and region table faults if EDAT
> > applies.
> > +	 */
> > +	if (edat) {
> > +		rc1 = rc1 == PGM_ASCE_TYPE ? rc1 : 0;
> > +		rc2 = rc2 == PGM_ASCE_TYPE ? rc2 : 0;
> > +	}
> > +	if ((!rc1 || rc1 == PGM_PAGE_TRANSLATION) && (!rc2 || rc2
> > == PGM_PAGE_TRANSLATION)) {
> > +		pei_block[0] = pei1;
> > +		pei_block[1] = pei2;
> > +		return 1;
> > +	}
> > +
> > +	retry_vsie_icpt(vsie_page);
> > +
> > +	/*
> > +	 * The host has edat, and the guest does not, or it was an
> > ASCE type
> > +	 * exception. The host needs to inject the appropriate DAT
> > interrupts
> > +	 * into the guest.
> > +	 */
> > +	if (rc1)
> > +		return inject_fault(vcpu, rc1, dest, 1);
> > +	if (rc2)> +		return inject_fault(vcpu, rc2,
> > src, 0); +
> > +	/* This should never be reached */  
> 
> BUG()?

look at the code, if it's reached, it's a bug in the compiler :)

maybe I should rewrite it so that there won't be any unreachable code at
all

> > +	return 0;
> > +}
> > +
> >  /*
> >   * Run the vsie on a shadow scb and a shadow gmap, without any
> > further
> >   * sanity checks, handling SIE faults.
> > @@ -1068,6 +1148,10 @@ static int do_vsie_run(struct kvm_vcpu
> > *vcpu, struct vsie_page *vsie_page) if ((scb_s->ipa & 0xf000) !=
> > 0xf000) scb_s->ipa += 0x1000;
> >  		break;
> > +	case ICPT_PARTEXEC:
> > +		if (scb_s->ipa == 0xb254)
> > +			rc = vsie_handle_mvpg(vcpu, vsie_page);
> > +		break;
> >  	}
> >  	return rc;
> >  }
> >   
> 

