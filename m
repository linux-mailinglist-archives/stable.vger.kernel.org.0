Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA20318B62
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 14:04:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231490AbhBKNBA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 08:01:00 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:17492 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231825AbhBKM6s (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Feb 2021 07:58:48 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11BCk7aW026707;
        Thu, 11 Feb 2021 07:58:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=QdQ7sXB56S7RetRm9u1Pk6q4tdb5or50B3OrRsZxoIE=;
 b=NL61gHzLyTPA2i0MJ88yQicYC37FU/zLMxYpjaEx2fooMdgObU+2zZpJuNS5pW4N+EzX
 VpEmQZhxMeYBHK9NP7323hHH/Vi94qK+9859EpmgaYA40fWS1zrUE9WacRUchOj8ViOZ
 vck4E1nnnlw34e1ZgaQqQXfKbe1sqZs3s80Dxvn2TD109h4m9YdIryuLaHlXZ6w2qRHX
 vFSPpt0U9gk6p1q/BG16JdjUISs/HO87+9j4yEeoUC9rpRD5sxg1MpDkj2T6NIOVdvVL
 S0NLFImO4YTqXA69oHSu5z1Fmms/YgtNA+i5BIG8rcvGvyi5X5fSCeJVr9+tGYNu7YEI eQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36n4tm0f2d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Feb 2021 07:58:05 -0500
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11BCw4m0088550;
        Thu, 11 Feb 2021 07:58:04 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36n4tm0f1t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Feb 2021 07:58:04 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11BCgvjM014332;
        Thu, 11 Feb 2021 12:58:03 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 36hskb2vup-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Feb 2021 12:58:03 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11BCw0tN14483794
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Feb 2021 12:58:00 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0ACBF52050;
        Thu, 11 Feb 2021 12:58:00 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.1.216])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id A02A852057;
        Thu, 11 Feb 2021 12:57:59 +0000 (GMT)
Date:   Thu, 11 Feb 2021 13:57:56 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, cohuck@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 1/2] s390/kvm: extend kvm_s390_shadow_fault to return
 entry pointer
Message-ID: <20210211135756.249b535b@ibm-vm>
In-Reply-To: <2a65f089-1728-7bc7-a2a8-a2c089a01cec@redhat.com>
References: <20210209154302.1033165-1-imbrenda@linux.ibm.com>
        <20210209154302.1033165-2-imbrenda@linux.ibm.com>
        <2a65f089-1728-7bc7-a2a8-a2c089a01cec@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-11_05:2021-02-10,2021-02-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 mlxscore=0 priorityscore=1501 suspectscore=0 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 adultscore=0 phishscore=0 impostorscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102110109
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 11 Feb 2021 10:18:56 +0100
David Hildenbrand <david@redhat.com> wrote:

> On 09.02.21 16:43, Claudio Imbrenda wrote:
> > Extend kvm_s390_shadow_fault to return the pointer to the valid leaf
> > DAT table entry, or to the invalid entry.
> > 
> > Also return some flags in the lower bits of the address:
> > DAT_PROT: indicates that DAT protection applies because of the
> >            protection bit in the segment (or, if EDAT, region)
> > tables NOT_PTE: indicates that the address of the DAT table entry
> > returned does not refer to a PTE, but to a segment or region table.
> >   
> 
> I've been thinking about one possible issue, but I think it's not 
> actually an issue. Just sharing so others can verify:
> 
> In case our guest uses huge pages / gigantic pages / ASCE R, we
> create fake page tables (GMAP_SHADOW_FAKE_TABLE).
> 
> So, it could be that kvm_s390_shadow_fault()->gmap_shadow_pgt_lookup()
> succeeds, however, we have a fake PTE in our hands. We lost the
> actual guest STE/RTE address. (I think it could be recovered somehow
> via page->index, thought)
> 
> But I guess, if there is a fake PTE, then there is not acutally
> something that could go wrong in gmap_shadow_page() anymore that could
> lead us in responding something wrong to the guest. We can only really
> fail with -EINVAL, -ENOMEM or -EFAULT.

this was also my reasoning

> So if the guest changed anything in the meantime (e.g., zap a
> segment), we would have unshadowed the whole fake page table
> hierarchy and would simply retry.
> 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > Cc: stable@vger.kernel.org
> > ---
> >   arch/s390/kvm/gaccess.c | 30 +++++++++++++++++++++++++-----
> >   arch/s390/kvm/gaccess.h |  5 ++++-
> >   arch/s390/kvm/vsie.c    |  8 ++++----
> >   3 files changed, 33 insertions(+), 10 deletions(-)
> > 
> > diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
> > index 6d6b57059493..e0ab83f051d2 100644
> > --- a/arch/s390/kvm/gaccess.c
> > +++ b/arch/s390/kvm/gaccess.c
> > @@ -976,7 +976,9 @@ int kvm_s390_check_low_addr_prot_real(struct
> > kvm_vcpu *vcpu, unsigned long gra)
> >    * kvm_s390_shadow_tables - walk the guest page table and create
> > shadow tables
> >    * @sg: pointer to the shadow guest address space structure
> >    * @saddr: faulting address in the shadow gmap
> > - * @pgt: pointer to the page table address result
> > + * @pgt: pointer to the beginning of the page table for the given
> > address if
> > + *       successful (return value 0), or to the first invalid DAT
> > entry in
> > + *       case of exceptions (return value > 0)
> >    * @fake: pgt references contiguous guest memory block, not a
> > pgtable */
> >   static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long
> > saddr, @@ -1034,6 +1036,7 @@ static int
> > kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
> > rfte.val = ptr; goto shadow_r2t;
> >   		}
> > +		*pgt = ptr + vaddr.rfx * 8;
> >   		rc = gmap_read_table(parent, ptr + vaddr.rfx * 8,
> > &rfte.val);  
> 
> Using
> 
> gmap_read_table(parent, *pgt, &rfte.val);
> 
> or similar with a local variable might then be even clearer. But no 
> strong opinion.

that's also something I had thought about, in the end this minimizes
the number of lines / variables while still being readable

> >   		if (rc)
> >   			return rc;
> > @@ -1060,6 +1063,7 @@ static int kvm_s390_shadow_tables(struct gmap
> > *sg, unsigned long saddr, rste.val = ptr;
> >   			goto shadow_r3t;
> >   		}
> > +		*pgt = ptr + vaddr.rsx * 8;
> >   		rc = gmap_read_table(parent, ptr + vaddr.rsx * 8,
> > &rste.val); if (rc)
> >   			return rc;
> > @@ -1087,6 +1091,7 @@ static int kvm_s390_shadow_tables(struct gmap
> > *sg, unsigned long saddr, rtte.val = ptr;
> >   			goto shadow_sgt;
> >   		}
> > +		*pgt = ptr + vaddr.rtx * 8;
> >   		rc = gmap_read_table(parent, ptr + vaddr.rtx * 8,
> > &rtte.val); if (rc)
> >   			return rc;
> > @@ -1123,6 +1128,7 @@ static int kvm_s390_shadow_tables(struct gmap
> > *sg, unsigned long saddr, ste.val = ptr;
> >   			goto shadow_pgt;
> >   		}
> > +		*pgt = ptr + vaddr.sx * 8;
> >   		rc = gmap_read_table(parent, ptr + vaddr.sx * 8,
> > &ste.val); if (rc)
> >   			return rc;
> > @@ -1157,6 +1163,8 @@ static int kvm_s390_shadow_tables(struct gmap
> > *sg, unsigned long saddr,
> >    * @vcpu: virtual cpu
> >    * @sg: pointer to the shadow guest address space structure
> >    * @saddr: faulting address in the shadow gmap
> > + * @datptr: will contain the address of the faulting DAT table
> > entry, or of
> > + *          the valid leaf, plus some flags
> >    *
> >    * Returns: - 0 if the shadow fault was successfully resolved
> >    *	    - > 0 (pgm exception code) on exceptions while
> > faulting @@ -1165,11 +1173,11 @@ static int
> > kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
> >    *	    - -ENOMEM if out of memory
> >    */
> >   int kvm_s390_shadow_fault(struct kvm_vcpu *vcpu, struct gmap *sg,
> > -			  unsigned long saddr)
> > +			  unsigned long saddr, unsigned long
> > *datptr) {
> >   	union vaddress vaddr;
> >   	union page_table_entry pte;
> > -	unsigned long pgt;
> > +	unsigned long pgt = 0;
> >   	int dat_protection, fake;
> >   	int rc;
> >   
> > @@ -1191,8 +1199,20 @@ int kvm_s390_shadow_fault(struct kvm_vcpu
> > *vcpu, struct gmap *sg, pte.val = pgt + vaddr.px * PAGE_SIZE;
> >   		goto shadow_page;
> >   	}
> > -	if (!rc)
> > -		rc = gmap_read_table(sg->parent, pgt + vaddr.px *
> > 8, &pte.val); +
> > +	switch (rc) {
> > +	case PGM_SEGMENT_TRANSLATION:
> > +	case PGM_REGION_THIRD_TRANS:
> > +	case PGM_REGION_SECOND_TRANS:
> > +	case PGM_REGION_FIRST_TRANS:
> > +		pgt |= NOT_PTE;
> > +		break;
> > +	case 0:
> > +		pgt += vaddr.px * 8;
> > +		rc = gmap_read_table(sg->parent, pgt, &pte.val);
> > +	}
> > +	if (*datptr)
> > +		*datptr = pgt | dat_protection * DAT_PROT;
> >   	if (!rc && pte.i)
> >   		rc = PGM_PAGE_TRANSLATION;
> >   	if (!rc && pte.z)
> > diff --git a/arch/s390/kvm/gaccess.h b/arch/s390/kvm/gaccess.h
> > index f4c51756c462..fec26bbb17ba 100644
> > --- a/arch/s390/kvm/gaccess.h
> > +++ b/arch/s390/kvm/gaccess.h
> > @@ -359,7 +359,10 @@ void ipte_unlock(struct kvm_vcpu *vcpu);
> >   int ipte_lock_held(struct kvm_vcpu *vcpu);
> >   int kvm_s390_check_low_addr_prot_real(struct kvm_vcpu *vcpu,
> > unsigned long gra); 
> > +#define DAT_PROT 2
> > +#define NOT_PTE 4  
> 
> What if our guest is using ASCE.R ?

then we don't care.

if the guest is using ASCE.R, then shadowing will always succeed, and
the VSIE MVPG handler will retry right away.

if you are worried about the the lowest order bit, it can only be set
if a specific feature is enabled in the host, and KVM doesn't use /
support it, so the guest can't use it for its guest.



