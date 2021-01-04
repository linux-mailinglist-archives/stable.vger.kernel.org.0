Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 498C22E9B25
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:38:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbhADQhd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:37:33 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46074 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726098AbhADQhd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 11:37:33 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 104GWbl1106944;
        Mon, 4 Jan 2021 11:36:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=ZYz2tLgpgNEouiJcCAzBQncY9TnARviMIMG0lWR3eIA=;
 b=VPYVto0jP8mZjfycR2YSnR8SVc/d7SFzfWSC1kzRwhIl2U98p//g8GmhHAKm5IwPodUK
 t4guIW6TNOI3hwHfv/Y+nIXdnnAoa2x67rMhISbGJJkZ2RNUlpm6r/KLZDA6NdSDnvmt
 X1+KRkWL53PaI7EOknmxIpBiJQedtIZbvAIOI2USw62XygH+KOPV3TzpHWse5jSmYQ8y
 cNwK87NG0HkHtUoXp1iZOmpCmzVMCQ+XMPUiHa1k8+37yWVUne/k0DZTInqW6RSs3M4M
 K0mDtAR93dwcfpJNyrYzz2lCwlxNDk8XGpD17sVvB/2ctZ5yjbd13VJAslskwaDlvmZn ng== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35v4a14nkh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jan 2021 11:36:52 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 104GXcfq110464;
        Mon, 4 Jan 2021 11:36:52 -0500
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35v4a14nk2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jan 2021 11:36:52 -0500
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 104GWDKZ032124;
        Mon, 4 Jan 2021 16:36:49 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 35tg3hh25c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jan 2021 16:36:49 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 104GakeI43975082
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Jan 2021 16:36:46 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8B249AE053;
        Mon,  4 Jan 2021 16:36:46 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 26B66AE04D;
        Mon,  4 Jan 2021 16:36:46 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.0.177])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  4 Jan 2021 16:36:46 +0000 (GMT)
Date:   Mon, 4 Jan 2021 17:36:44 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v1 4/4] s390/kvm: VSIE: correctly handle MVPG when in
 VSIE
Message-ID: <20210104173644.2e6c8df4@ibm-vm>
In-Reply-To: <3376268b-7fd7-9fbe-b483-fe7471038a18@redhat.com>
References: <20201218141811.310267-1-imbrenda@linux.ibm.com>
        <20201218141811.310267-5-imbrenda@linux.ibm.com>
        <6836573a-a49d-9d9f-49e0-96b5aa479c52@redhat.com>
        <20210104162231.4e56ab47@ibm-vm>
        <3376268b-7fd7-9fbe-b483-fe7471038a18@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-04_10:2021-01-04,2021-01-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 spamscore=0 mlxscore=0 mlxlogscore=737
 priorityscore=1501 adultscore=0 suspectscore=0 phishscore=0
 impostorscore=0 clxscore=1015 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101040107
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 4 Jan 2021 17:08:15 +0100
David Hildenbrand <david@redhat.com> wrote:

> On 04.01.21 16:22, Claudio Imbrenda wrote:
> > On Sun, 20 Dec 2020 11:13:57 +0100
> > David Hildenbrand <david@redhat.com> wrote:
> >   
> >> On 18.12.20 15:18, Claudio Imbrenda wrote:  
> >>> Correctly handle the MVPG instruction when issued by a VSIE guest.
> >>>     
> >>
> >> I remember that MVPG SIE documentation was completely crazy and
> >> full of corner cases. :)  
> > 
> > you remember correctly
> >   
> >> Looking at arch/s390/kvm/intercept.c:handle_mvpg_pei(), I can spot
> >> that
> >>
> >> 1. "This interception can only happen for guests with DAT disabled
> >> ..." 2. KVM does not make use of any mvpg state inside the SCB.
> >>
> >> Can this be observed with Linux guests?  
> > 
> > a Linux guest will typically not run with DAT disabled
> >   
> >> Can I get some information on what information is stored at [0xc0,
> >> 0xd) inside the SCB? I assume it's:
> >>
> >> 0xc0: guest physical address of source PTE
> >> 0xc8: guest physical address of target PTE  
> > 
> > yes (plus 3 flags in the lower bits of each)  
> 
> Thanks! Do the flags tell us what the deal with the PTE was? If yes,
> what's the meaning of the separate flags?
> 
> I assume something like "invalid, proteced, ??"

bit 61 indicates that the address is a region or segment table entry,
when EDAT applies
bit 62 is "protected" when the protected bit is set in the segment
table entry (or region, if EDAT applies) 
bit 63 is set when the operand was translated with a real-space ASCE

but you can check if the PTE is valid just by dereferencing the
pointers...

> I'm asking because I think we can handle this a little easier.

what is your idea?

> >   
> >> [...]  
> >>>  /*
> >>>   * Run the vsie on a shadow scb and a shadow gmap, without any
> >>> further
> >>>   * sanity checks, handling SIE faults.
> >>> @@ -1063,6 +1132,10 @@ static int do_vsie_run(struct kvm_vcpu
> >>> *vcpu, struct vsie_page *vsie_page) if ((scb_s->ipa & 0xf000) !=
> >>> 0xf000) scb_s->ipa += 0x1000;
> >>>  		break;
> >>> +	case ICPT_PARTEXEC:
> >>> +		if (scb_s->ipa == 0xb254)    
> >>
> >> Old code hat "/* MVPG only */" - why is this condition now
> >> necessary?  
> > 
> > old code was wrong ;)  
> 
> 
> arch/s390/kvm/intercept.c:handle_partial_execution() we only seem to
> handle
> 
> 1. MVPG
> 2. SIGP PEI
> 
> The latter is only relevant for external calls. IIRC, this is only
> active with sigp interpretation - which is never active under vsie
> (ECA_SIGPI).

I think putting an explicit check is better than just a jump in the
dark.

