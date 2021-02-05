Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5D02310B06
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 13:27:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231961AbhBEMYN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 07:24:13 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:62340 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231612AbhBEMV3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Feb 2021 07:21:29 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 115C40C7141347;
        Fri, 5 Feb 2021 07:20:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=p03fBIwsmtm08bndsOqGb6qzwrkYuWIszqPfx5LE3L0=;
 b=HX++ws0H6Ng/4duVpGm7NGVj1tEWAfmt1k2VQ2yD6EDMtT2WmZvjav6bZq6SVZwKtZpW
 LMJ8VBydVSYGaEkpmyyvYeaSZdbP6L4B9sTp9uPRv30nuqtca+rkf71VBRTXl2JHp7o7
 WJVmof55QiBj8sJSqWbfcrWK2i5EmIMZYRdp1QHrca20i1Z76c8r0SzmbBrcMv0nuAm0
 JGEIaDSHzfOVeyba97XCxv0sKBOxyrZFiApkaHCji06hFhJhdVt8xhSs4BeODtZ2hLT0
 MbQQtTHMW6zLXj/Wv8PU4kk23MoGl0P1htbmXhewRbCvQdWIasqZ++385+DTzHklJhsW ew== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36h51bspvr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Feb 2021 07:20:39 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 115C4I2Y142289;
        Fri, 5 Feb 2021 07:20:38 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36h51bspu7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Feb 2021 07:20:38 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 115CCqEI025777;
        Fri, 5 Feb 2021 12:20:35 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 36fwcw1x80-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Feb 2021 12:20:35 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 115CKNwr33685956
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 5 Feb 2021 12:20:24 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0FCFDA405F;
        Fri,  5 Feb 2021 12:20:33 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E83EA4054;
        Fri,  5 Feb 2021 12:20:32 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.1.216])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  5 Feb 2021 12:20:32 +0000 (GMT)
Date:   Fri, 5 Feb 2021 13:18:00 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, borntraeger@de.ibm.com,
        david@redhat.com, kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] s390/kvm: extend kvm_s390_shadow_fault to return
 entry pointer
Message-ID: <20210205131800.7d82b1b9@ibm-vm>
In-Reply-To: <264deb2a-a86e-79e3-9db1-ecfe265a6a10@linux.ibm.com>
References: <20210202180028.876888-1-imbrenda@linux.ibm.com>
        <20210202180028.876888-2-imbrenda@linux.ibm.com>
        <16522b25-a590-fbc4-0eb6-3537d8032577@linux.ibm.com>
        <264deb2a-a86e-79e3-9db1-ecfe265a6a10@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-05_07:2021-02-05,2021-02-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 mlxscore=0 adultscore=0 suspectscore=0 malwarescore=0 priorityscore=1501
 lowpriorityscore=0 spamscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102050080
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 4 Feb 2021 18:05:15 +0100
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 2/4/21 5:34 PM, Janosch Frank wrote:
> > On 2/2/21 7:00 PM, Claudio Imbrenda wrote:  
> >> Extend kvm_s390_shadow_fault to return the pointer to the valid
> >> leaf DAT table entry, or to the invalid entry.
> >>
> >> Also return some flags in the lower bits of the address:
> >> DAT_PROT: indicates that DAT protection applies because of the
> >>           protection bit in the segment (or, if EDAT, region)
> >> tables NOT_PTE: indicates that the address of the DAT table entry
> >> returned does not refer to a PTE, but to a segment or region table.
> >>
> >> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> >> Cc: stable@vger.kernel.org
> >> ---
> >>  arch/s390/kvm/gaccess.c | 26 ++++++++++++++++++++++----
> >>  arch/s390/kvm/gaccess.h |  5 ++++-
> >>  arch/s390/kvm/vsie.c    |  8 ++++----
> >>  3 files changed, 30 insertions(+), 9 deletions(-)
> >>
> >> diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
> >> index 6d6b57059493..2d7bcbfb185e 100644
> >> --- a/arch/s390/kvm/gaccess.c
> >> +++ b/arch/s390/kvm/gaccess.c
> >> @@ -1034,6 +1034,7 @@ static int kvm_s390_shadow_tables(struct
> >> gmap *sg, unsigned long saddr, rfte.val = ptr;
> >>  			goto shadow_r2t;
> >>  		}
> >> +		*pgt = ptr + vaddr.rfx * 8;  
> > 
> > So pgt either is a table entry if rc > 0 or a pointer to the first
> > pte on rc == 0 after this change?
> > 
> > Hrm, if it is really based on RCs than I might be able to come to
> > terms with having two things in a ptr with the name pgt. But it
> > needs a comment change.
> >   
> >>  		rc = gmap_read_table(parent, ptr + vaddr.rfx * 8,
> >> &rfte.val); if (rc)
> >>  			return rc;
> >> @@ -1060,6 +1061,7 @@ static int kvm_s390_shadow_tables(struct
> >> gmap *sg, unsigned long saddr, rste.val = ptr;
> >>  			goto shadow_r3t;
> >>  		}
> >> +		*pgt = ptr + vaddr.rsx * 8;
> >>  		rc = gmap_read_table(parent, ptr + vaddr.rsx * 8,
> >> &rste.val); if (rc)
> >>  			return rc;
> >> @@ -1087,6 +1089,7 @@ static int kvm_s390_shadow_tables(struct
> >> gmap *sg, unsigned long saddr, rtte.val = ptr;
> >>  			goto shadow_sgt;
> >>  		}
> >> +		*pgt = ptr + vaddr.rtx * 8;
> >>  		rc = gmap_read_table(parent, ptr + vaddr.rtx * 8,
> >> &rtte.val); if (rc)
> >>  			return rc;
> >> @@ -1123,6 +1126,7 @@ static int kvm_s390_shadow_tables(struct
> >> gmap *sg, unsigned long saddr, ste.val = ptr;
> >>  			goto shadow_pgt;
> >>  		}
> >> +		*pgt = ptr + vaddr.sx * 8;
> >>  		rc = gmap_read_table(parent, ptr + vaddr.sx * 8,
> >> &ste.val); if (rc)
> >>  			return rc;
> >> @@ -1157,6 +1161,8 @@ static int kvm_s390_shadow_tables(struct
> >> gmap *sg, unsigned long saddr,
> >>   * @vcpu: virtual cpu
> >>   * @sg: pointer to the shadow guest address space structure
> >>   * @saddr: faulting address in the shadow gmap
> >> + * @pteptr: will contain the address of the faulting DAT table
> >> entry, or of
> >> + *          the valid leaf, plus some flags  
> > 
> > pteptr is not the right name if it can be two things  
> 
> You use it for pei only, right?

yes

> >   
> >>   *
> >>   * Returns: - 0 if the shadow fault was successfully resolved
> >>   *	    - > 0 (pgm exception code) on exceptions while
> >> faulting @@ -1165,11 +1171,11 @@ static int
> >> kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
> >>   *	    - -ENOMEM if out of memory
> >>   */
> >>  int kvm_s390_shadow_fault(struct kvm_vcpu *vcpu, struct gmap *sg,
> >> -			  unsigned long saddr)
> >> +			  unsigned long saddr, unsigned long
> >> *pteptr) {
> >>  	union vaddress vaddr;
> >>  	union page_table_entry pte;
> >> -	unsigned long pgt;
> >> +	unsigned long pgt = 0;
> >>  	int dat_protection, fake;
> >>  	int rc;
> >>  
> >> @@ -1191,8 +1197,20 @@ int kvm_s390_shadow_fault(struct kvm_vcpu
> >> *vcpu, struct gmap *sg, pte.val = pgt + vaddr.px * PAGE_SIZE;
> >>  		goto shadow_page;
> >>  	}
> >> -	if (!rc)
> >> -		rc = gmap_read_table(sg->parent, pgt + vaddr.px *
> >> 8, &pte.val); +
> >> +	switch (rc) {
> >> +	case PGM_SEGMENT_TRANSLATION:
> >> +	case PGM_REGION_THIRD_TRANS:
> >> +	case PGM_REGION_SECOND_TRANS:
> >> +	case PGM_REGION_FIRST_TRANS:
> >> +		pgt |= NOT_PTE;  
> > 
> > GACC_TRANSL_ENTRY_INV ?
> >   
> >> +		break;
> >> +	case 0:
> >> +		pgt += vaddr.px * 8;
> >> +		rc = gmap_read_table(sg->parent, pgt, &pte.val);
> >> +	}
> >> +	if (*pteptr)
> >> +		*pteptr = pgt | dat_protection * DAT_PROT;
> >>  	if (!rc && pte.i)
> >>  		rc = PGM_PAGE_TRANSLATION;
> >>  	if (!rc && pte.z)
> >> diff --git a/arch/s390/kvm/gaccess.h b/arch/s390/kvm/gaccess.h
> >> index f4c51756c462..66a6e2cec97a 100644
> >> --- a/arch/s390/kvm/gaccess.h
> >> +++ b/arch/s390/kvm/gaccess.h
> >> @@ -359,7 +359,10 @@ void ipte_unlock(struct kvm_vcpu *vcpu);
> >>  int ipte_lock_held(struct kvm_vcpu *vcpu);
> >>  int kvm_s390_check_low_addr_prot_real(struct kvm_vcpu *vcpu,
> >> unsigned long gra); 
> >> +#define DAT_PROT 2  
> > 
> > GACC_TRANSL_ENTRY_PROT  
> 
> Ok after a second pass that's not what's going on here.
> Those basically directly correspond to the MVPG PEI indication bits,
> right?

yes :)

> Do we also need to consider bit 63?

no, that can only happen if a specific SIE feature is used, which KVM
neither uses nor supports for VSIE, so it cannot happen

> >   
> >> +#define NOT_PTE 4
> >> +
> >>  int kvm_s390_shadow_fault(struct kvm_vcpu *vcpu, struct gmap
> >> *shadow,
> >> -			  unsigned long saddr);
> >> +			  unsigned long saddr, unsigned long
> >> *pteptr); 
> >>  #endif /* __KVM_S390_GACCESS_H */
> >> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
> >> index c5d0a58b2c29..7db022141db3 100644
> >> --- a/arch/s390/kvm/vsie.c
> >> +++ b/arch/s390/kvm/vsie.c
> >> @@ -619,10 +619,10 @@ static int map_prefix(struct kvm_vcpu *vcpu,
> >> struct vsie_page *vsie_page) /* with mso/msl, the prefix lies at
> >> offset *mso* */ prefix += scb_s->mso;
> >>  
> >> -	rc = kvm_s390_shadow_fault(vcpu, vsie_page->gmap, prefix);
> >> +	rc = kvm_s390_shadow_fault(vcpu, vsie_page->gmap, prefix,
> >> NULL); if (!rc && (scb_s->ecb & ECB_TE))
> >>  		rc = kvm_s390_shadow_fault(vcpu, vsie_page->gmap,
> >> -					   prefix + PAGE_SIZE);
> >> +					   prefix + PAGE_SIZE,
> >> NULL); /*
> >>  	 * We don't have to mprotect, we will be called for all
> >> unshadows.
> >>  	 * SIE will detect if protection applies and trigger a
> >> validity. @@ -913,7 +913,7 @@ static int handle_fault(struct
> >> kvm_vcpu *vcpu, struct vsie_page *vsie_page)
> >> current->thread.gmap_addr, 1); 
> >>  	rc = kvm_s390_shadow_fault(vcpu, vsie_page->gmap,
> >> -				   current->thread.gmap_addr);
> >> +				   current->thread.gmap_addr,
> >> NULL); if (rc > 0) {
> >>  		rc = inject_fault(vcpu, rc,
> >>  				  current->thread.gmap_addr,
> >> @@ -935,7 +935,7 @@ static void handle_last_fault(struct kvm_vcpu
> >> *vcpu, {
> >>  	if (vsie_page->fault_addr)
> >>  		kvm_s390_shadow_fault(vcpu, vsie_page->gmap,
> >> -				      vsie_page->fault_addr);
> >> +				      vsie_page->fault_addr,
> >> NULL);  
> > 
> > Ok
> >   
> >>  	vsie_page->fault_addr = 0;
> >>  }
> >>  
> >>  
> >   
> 

