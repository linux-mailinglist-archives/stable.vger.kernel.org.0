Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB50318660
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 09:36:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbhBKIgh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 03:36:37 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43008 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229478AbhBKIgh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Feb 2021 03:36:37 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11B8WIJs150417;
        Thu, 11 Feb 2021 03:35:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=to : cc : references :
 from : subject : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Nlcr3nKBLvyoPjmf/rFztISMggdQUalsfPUdkRrSmHs=;
 b=BbkpthWdeiMX2KXdxgUDyIx/Rv0ubpKmTp2c+5OidS0+bqKxJZvUSLUJ5JAkWse6obr+
 7DLI30AKqZAFozFHNWoOjEAULQdX/RhVdkSs8Pr7YDkjvyNK7ZCNfPJrXuVhBVw9SIrb
 BbugEg0cKGjzIKxVjMYe2IcfN+EIVMCSZSHTLJrN8dgs5HGogURONrTMieAwIN3T6h3l
 ogcJaKrdWKP7thqQbV3chu2YZ7Usb8TeElrju5rcTSk+d45z2bbCNeSzpBrzI1pELIGs
 HLbm5WYKsp/yErs4OiISFqpS/tB4K9aUx3gtXx6MNgz5On0jc4okXamGO8rALFnTvfn5 TA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36n13y05nb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Feb 2021 03:35:20 -0500
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11B8Ws99152603;
        Thu, 11 Feb 2021 03:35:20 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36n13y05kq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Feb 2021 03:35:20 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11B8RBuH026928;
        Thu, 11 Feb 2021 08:35:18 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 36hjr8dk4x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Feb 2021 08:35:18 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11B8Z5b434931004
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Feb 2021 08:35:05 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7758CAE055;
        Thu, 11 Feb 2021 08:35:15 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0D26EAE04D;
        Thu, 11 Feb 2021 08:35:15 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.64.239])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 11 Feb 2021 08:35:14 +0000 (GMT)
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-kernel@vger.kernel.org
Cc:     borntraeger@de.ibm.com, david@redhat.com, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        stable@vger.kernel.org
References: <20210209154302.1033165-1-imbrenda@linux.ibm.com>
 <20210209154302.1033165-2-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH v3 1/2] s390/kvm: extend kvm_s390_shadow_fault to return
 entry pointer
Message-ID: <f7fabdb6-e53a-1c17-92a8-3240b0c03e47@linux.ibm.com>
Date:   Thu, 11 Feb 2021 09:35:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210209154302.1033165-2-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-11_05:2021-02-10,2021-02-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 clxscore=1015 impostorscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102110072
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/9/21 4:43 PM, Claudio Imbrenda wrote:
> Extend kvm_s390_shadow_fault to return the pointer to the valid leaf
> DAT table entry, or to the invalid entry.
> 
> Also return some flags in the lower bits of the address:
> DAT_PROT: indicates that DAT protection applies because of the
>           protection bit in the segment (or, if EDAT, region) tables
> NOT_PTE: indicates that the address of the DAT table entry returned
>          does not refer to a PTE, but to a segment or region table.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Cc: stable@vger.kernel.org

Reviewed-by: Janosch Frank <frankja@de.ibm.com>

Small nit below.

> ---
>  arch/s390/kvm/gaccess.c | 30 +++++++++++++++++++++++++-----
>  arch/s390/kvm/gaccess.h |  5 ++++-
>  arch/s390/kvm/vsie.c    |  8 ++++----
>  3 files changed, 33 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
> index 6d6b57059493..e0ab83f051d2 100644
> --- a/arch/s390/kvm/gaccess.c
> +++ b/arch/s390/kvm/gaccess.c
> @@ -976,7 +976,9 @@ int kvm_s390_check_low_addr_prot_real(struct kvm_vcpu *vcpu, unsigned long gra)
>   * kvm_s390_shadow_tables - walk the guest page table and create shadow tables
>   * @sg: pointer to the shadow guest address space structure
>   * @saddr: faulting address in the shadow gmap
> - * @pgt: pointer to the page table address result
> + * @pgt: pointer to the beginning of the page table for the given address if
> + *       successful (return value 0), or to the first invalid DAT entry in
> + *       case of exceptions (return value > 0)
>   * @fake: pgt references contiguous guest memory block, not a pgtable
>   */
>  static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
> @@ -1034,6 +1036,7 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
>  			rfte.val = ptr;
>  			goto shadow_r2t;
>  		}
> +		*pgt = ptr + vaddr.rfx * 8;
>  		rc = gmap_read_table(parent, ptr + vaddr.rfx * 8, &rfte.val);
>  		if (rc)
>  			return rc;
> @@ -1060,6 +1063,7 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
>  			rste.val = ptr;
>  			goto shadow_r3t;
>  		}
> +		*pgt = ptr + vaddr.rsx * 8;
>  		rc = gmap_read_table(parent, ptr + vaddr.rsx * 8, &rste.val);
>  		if (rc)
>  			return rc;
> @@ -1087,6 +1091,7 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
>  			rtte.val = ptr;
>  			goto shadow_sgt;
>  		}
> +		*pgt = ptr + vaddr.rtx * 8;
>  		rc = gmap_read_table(parent, ptr + vaddr.rtx * 8, &rtte.val);
>  		if (rc)
>  			return rc;
> @@ -1123,6 +1128,7 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
>  			ste.val = ptr;
>  			goto shadow_pgt;
>  		}
> +		*pgt = ptr + vaddr.sx * 8;
>  		rc = gmap_read_table(parent, ptr + vaddr.sx * 8, &ste.val);
>  		if (rc)
>  			return rc;
> @@ -1157,6 +1163,8 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
>   * @vcpu: virtual cpu
>   * @sg: pointer to the shadow guest address space structure
>   * @saddr: faulting address in the shadow gmap
> + * @datptr: will contain the address of the faulting DAT table entry, or of
> + *          the valid leaf, plus some flags
>   *
>   * Returns: - 0 if the shadow fault was successfully resolved
>   *	    - > 0 (pgm exception code) on exceptions while faulting
> @@ -1165,11 +1173,11 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
>   *	    - -ENOMEM if out of memory
>   */
>  int kvm_s390_shadow_fault(struct kvm_vcpu *vcpu, struct gmap *sg,
> -			  unsigned long saddr)
> +			  unsigned long saddr, unsigned long *datptr)
>  {
>  	union vaddress vaddr;
>  	union page_table_entry pte;
> -	unsigned long pgt;
> +	unsigned long pgt = 0;
>  	int dat_protection, fake;
>  	int rc;
>  
> @@ -1191,8 +1199,20 @@ int kvm_s390_shadow_fault(struct kvm_vcpu *vcpu, struct gmap *sg,
>  		pte.val = pgt + vaddr.px * PAGE_SIZE;
>  		goto shadow_page;
>  	}
> -	if (!rc)
> -		rc = gmap_read_table(sg->parent, pgt + vaddr.px * 8, &pte.val);
> +
> +	switch (rc) {
> +	case PGM_SEGMENT_TRANSLATION:
> +	case PGM_REGION_THIRD_TRANS:
> +	case PGM_REGION_SECOND_TRANS:
> +	case PGM_REGION_FIRST_TRANS:
> +		pgt |= NOT_PTE;
> +		break;
> +	case 0:
> +		pgt += vaddr.px * 8;
> +		rc = gmap_read_table(sg->parent, pgt, &pte.val);
> +	}
> +	if (*datptr)
> +		*datptr = pgt | dat_protection * DAT_PROT;
>  	if (!rc && pte.i)
>  		rc = PGM_PAGE_TRANSLATION;
>  	if (!rc && pte.z)
> diff --git a/arch/s390/kvm/gaccess.h b/arch/s390/kvm/gaccess.h
> index f4c51756c462..fec26bbb17ba 100644
> --- a/arch/s390/kvm/gaccess.h
> +++ b/arch/s390/kvm/gaccess.h
> @@ -359,7 +359,10 @@ void ipte_unlock(struct kvm_vcpu *vcpu);
>  int ipte_lock_held(struct kvm_vcpu *vcpu);
>  int kvm_s390_check_low_addr_prot_real(struct kvm_vcpu *vcpu, unsigned long gra);
>  
> +#define DAT_PROT 2
> +#define NOT_PTE 4

I'd like to have a PEI prefix and a short comment where this comes from,
something like:
"MVPG PEI indication bits"

> +
>  int kvm_s390_shadow_fault(struct kvm_vcpu *vcpu, struct gmap *shadow,
> -			  unsigned long saddr);
> +			  unsigned long saddr, unsigned long *datptr);
>  
>  #endif /* __KVM_S390_GACCESS_H */
> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
> index c5d0a58b2c29..7db022141db3 100644
> --- a/arch/s390/kvm/vsie.c
> +++ b/arch/s390/kvm/vsie.c
> @@ -619,10 +619,10 @@ static int map_prefix(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
>  	/* with mso/msl, the prefix lies at offset *mso* */
>  	prefix += scb_s->mso;
>  
> -	rc = kvm_s390_shadow_fault(vcpu, vsie_page->gmap, prefix);
> +	rc = kvm_s390_shadow_fault(vcpu, vsie_page->gmap, prefix, NULL);
>  	if (!rc && (scb_s->ecb & ECB_TE))
>  		rc = kvm_s390_shadow_fault(vcpu, vsie_page->gmap,
> -					   prefix + PAGE_SIZE);
> +					   prefix + PAGE_SIZE, NULL);
>  	/*
>  	 * We don't have to mprotect, we will be called for all unshadows.
>  	 * SIE will detect if protection applies and trigger a validity.
> @@ -913,7 +913,7 @@ static int handle_fault(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
>  				    current->thread.gmap_addr, 1);
>  
>  	rc = kvm_s390_shadow_fault(vcpu, vsie_page->gmap,
> -				   current->thread.gmap_addr);
> +				   current->thread.gmap_addr, NULL);
>  	if (rc > 0) {
>  		rc = inject_fault(vcpu, rc,
>  				  current->thread.gmap_addr,
> @@ -935,7 +935,7 @@ static void handle_last_fault(struct kvm_vcpu *vcpu,
>  {
>  	if (vsie_page->fault_addr)
>  		kvm_s390_shadow_fault(vcpu, vsie_page->gmap,
> -				      vsie_page->fault_addr);
> +				      vsie_page->fault_addr, NULL);
>  	vsie_page->fault_addr = 0;
>  }
>  
> 

