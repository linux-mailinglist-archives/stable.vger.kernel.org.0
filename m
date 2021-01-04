Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD6A12E986A
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 16:26:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727275AbhADPZC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 10:25:02 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21854 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727225AbhADPZB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 10:25:01 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 104F2AeE054555;
        Mon, 4 Jan 2021 10:24:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=zxghkz7KN4TP63NXTpRrf4UWbVhYh7z0S3onnXQYjGQ=;
 b=JMVfCZiMOgOxDlCupGquPsR0SBAsQUEHN6Rxgqy9BGX0AFfmBhKS253usby50lHFEEQV
 TXtVVijovuON42LgLtIHZJvcowTVsSgRMvGHs25EUrC99UHAURAUGQ/oLNX7mxRPExaR
 LFn/CWHIEJ8/xs499WkQZHOyIYpFtLwx2NOxHvfftaURa/EkeLNThc7kWGDx14hDdUmA
 O7pTl1tkrjuZ37uHmK2z86LXWRzySO7xOEsId/XRmKhcwKEYuSc+pc/VVeKLCYzxF5V/
 oYdl+ZHW5BQEm+Iib03kX3sHfJdfw5LJMtdZBDPaNg+4Yv+Fs1dvtMEgsRvNjv/Gxmx0 4g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35v3183w3q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jan 2021 10:24:20 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 104F2U79055391;
        Mon, 4 Jan 2021 10:24:20 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35v3183w2y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jan 2021 10:24:19 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 104FBdcS003941;
        Mon, 4 Jan 2021 15:24:18 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 35tgf8h182-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jan 2021 15:24:18 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 104FOFiN42729806
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Jan 2021 15:24:15 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E4717A405F;
        Mon,  4 Jan 2021 15:24:14 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7F0A8A405C;
        Mon,  4 Jan 2021 15:24:14 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.0.177])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  4 Jan 2021 15:24:14 +0000 (GMT)
Date:   Mon, 4 Jan 2021 16:22:31 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v1 4/4] s390/kvm: VSIE: correctly handle MVPG when in
 VSIE
Message-ID: <20210104162231.4e56ab47@ibm-vm>
In-Reply-To: <6836573a-a49d-9d9f-49e0-96b5aa479c52@redhat.com>
References: <20201218141811.310267-1-imbrenda@linux.ibm.com>
        <20201218141811.310267-5-imbrenda@linux.ibm.com>
        <6836573a-a49d-9d9f-49e0-96b5aa479c52@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-04_08:2021-01-04,2021-01-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 spamscore=0 clxscore=1015 bulkscore=0 malwarescore=0
 impostorscore=0 mlxlogscore=999 phishscore=0 adultscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101040095
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 20 Dec 2020 11:13:57 +0100
David Hildenbrand <david@redhat.com> wrote:

> On 18.12.20 15:18, Claudio Imbrenda wrote:
> > Correctly handle the MVPG instruction when issued by a VSIE guest.
> >   
> 
> I remember that MVPG SIE documentation was completely crazy and full
> of corner cases. :)

you remember correctly

> Looking at arch/s390/kvm/intercept.c:handle_mvpg_pei(), I can spot
> that
> 
> 1. "This interception can only happen for guests with DAT disabled
> ..." 2. KVM does not make use of any mvpg state inside the SCB.
> 
> Can this be observed with Linux guests?

a Linux guest will typically not run with DAT disabled

> Can I get some information on what information is stored at [0xc0,
> 0xd) inside the SCB? I assume it's:
> 
> 0xc0: guest physical address of source PTE
> 0xc8: guest physical address of target PTE

yes (plus 3 flags in the lower bits of each)

> 
> Also, which conditions have to be met such that we get a
> ICPT_PARTEXEC:
> 
> a) State of guest DAT (I assume off?)
> b) State of PTEs: What happens if there is no PTE (I assume we need
> two PTEs, otherwise no such intercept)? I assume we get an intercept
> if one of both PTEs is not present or the destination PTE is
> protected. Correct?

we get the intercept if the guest has DAT off, and at least one of the
host PTEs is invalid (and I think if the destination is valid but
protected)

> So, when we (g1) get an intercept for g3, can we be sure 0xc0 and 0xc8
> in the scb are both valid g1 addresses pointing at our PTE, and what
> do we know about these PTEs (one not present or destination
> protected)?

we only know that at least one of the following holds true:
* source invalid
* destination invalid
* destination protected

there is a bit that tells us if the destination was protected (bit 62),
but that does not exclude an invalid source

> [...]
> >  /*
> >   * Run the vsie on a shadow scb and a shadow gmap, without any
> > further
> >   * sanity checks, handling SIE faults.
> > @@ -1063,6 +1132,10 @@ static int do_vsie_run(struct kvm_vcpu
> > *vcpu, struct vsie_page *vsie_page) if ((scb_s->ipa & 0xf000) !=
> > 0xf000) scb_s->ipa += 0x1000;
> >  		break;
> > +	case ICPT_PARTEXEC:
> > +		if (scb_s->ipa == 0xb254)  
> 
> Old code hat "/* MVPG only */" - why is this condition now necessary?

old code was wrong ;)

> > +			rc = vsie_handle_mvpg(vcpu, vsie_page);
> > +		break;
> >  	}
> >  	return rc;
> >  }
> >   
> 
> 

