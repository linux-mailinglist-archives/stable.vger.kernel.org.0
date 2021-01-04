Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E12C2E986E
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 16:26:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727477AbhADPZE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 10:25:04 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32966 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727373AbhADPZD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 10:25:03 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 104F3GTO143746;
        Mon, 4 Jan 2021 10:24:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=o/VxyGMzPKfmCs+Dy40ZZuGl2OdDMSIsW8Zp1WjedFM=;
 b=GMbIZZSjRVw5QdJpkvwqCZ9VEBuu0YbdGTNjpeGRCPwUEZwKnn30u3wL36qlS6leX28y
 5QTF4SduM6UAwKNmZgrR+jSEhP1TRmiFNHc/QPPsHcdwid/8uKW/KGuvNclZUIiVRZ2O
 hhsP4ABnkFpGCHGTURS8cNkMjI8NdWxMkwjjDz6owE61WsMkILF+1roAh/Cq0QQOOMFq
 t2UnJPTB7/dolx/PoXCwhCsu7luM90jsYUhtz4mlKWG5SsH7ucglExiH5OVNA8pnlfdx
 RLQFwcGW/y/qWW1iAt6JNRm2xGyvqpiqhmNxV3IixvKmiJGceyWfsXxP1tMWA5Omj+MN UA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35v59krmte-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jan 2021 10:24:21 -0500
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 104F3b67145258;
        Mon, 4 Jan 2021 10:24:21 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35v59krmsv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jan 2021 10:24:21 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 104FBaW3013449;
        Mon, 4 Jan 2021 15:24:19 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 35tg3ha0g7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jan 2021 15:24:19 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 104FODR125100738
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Jan 2021 15:24:13 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 821EFA405C;
        Mon,  4 Jan 2021 15:24:16 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1E05BA405F;
        Mon,  4 Jan 2021 15:24:16 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.0.177])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  4 Jan 2021 15:24:16 +0000 (GMT)
Date:   Mon, 4 Jan 2021 14:58:02 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v1 1/4] s390/kvm: VSIE: stop leaking host addresses
Message-ID: <20210104145802.7a2274a2@ibm-vm>
In-Reply-To: <b1a31982-a967-7439-1a7c-3c948deeb79d@redhat.com>
References: <20201218141811.310267-1-imbrenda@linux.ibm.com>
        <20201218141811.310267-2-imbrenda@linux.ibm.com>
        <b1a31982-a967-7439-1a7c-3c948deeb79d@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-04_10:2021-01-04,2021-01-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 phishscore=0 lowpriorityscore=0 malwarescore=0 bulkscore=0 impostorscore=0
 clxscore=1015 mlxlogscore=999 priorityscore=1501 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101040099
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 20 Dec 2020 10:44:56 +0100
David Hildenbrand <david@redhat.com> wrote:

> On 18.12.20 15:18, Claudio Imbrenda wrote:
> > The addresses in the SIE control block of the host should not be
> > forwarded to the guest. They are only meaningful to the host, and
> > moreover it would be a clear security issue.  
> 
> It's really almost impossible for someone without access to
> documentation to understand what we leak. I assume we're leaking the
> g1 address of a page table (entry), used for translation of g2->g3 to
> g1. Can you try making that clearer?

this is correct.

I guess I can improve the text of the commit
 
> In that case, it's pretty much a random number (of a random page used
> as a leave page table) and does not let g1 identify locations of
> symbols etc. If so, I don't think this is a "clear security issue"
> and suggest squashing this into the actual fix (#p4 I assume).

yeah __maybe__ I overstated the importance ;)

But I would still like to keep it as a separate patch, looks more
straightforward to me
 
> @Christian, @Janosch? Am I missing something?
> 
> > 
> > Subsequent patches will actually put the right values in the guest
> > SIE control block.
> > 
> > Fixes: a3508fbe9dc6d ("KVM: s390: vsie: initial support for nested
> > virtualization") Cc: stable@vger.kernel.org
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >  arch/s390/kvm/vsie.c | 5 -----
> >  1 file changed, 5 deletions(-)
> > 
> > diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
> > index 4f3cbf6003a9..ada49583e530 100644
> > --- a/arch/s390/kvm/vsie.c
> > +++ b/arch/s390/kvm/vsie.c
> > @@ -416,11 +416,6 @@ static void unshadow_scb(struct kvm_vcpu
> > *vcpu, struct vsie_page *vsie_page) memcpy((void *)((u64)scb_o +
> > 0xc0), (void *)((u64)scb_s + 0xc0), 0xf0 - 0xc0);
> >  		break;
> > -	case ICPT_PARTEXEC:
> > -		/* MVPG only */
> > -		memcpy((void *)((u64)scb_o + 0xc0),
> > -		       (void *)((u64)scb_s + 0xc0), 0xd0 - 0xc0);
> > -		break;
> >  	}
> >  
> >  	if (scb_s->ihcpu != 0xffffU)
> >   
> 
> 

