Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 996333462C8
	for <lists+stable@lfdr.de>; Tue, 23 Mar 2021 16:27:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232804AbhCWP1X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Mar 2021 11:27:23 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:25062 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232808AbhCWP1A (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Mar 2021 11:27:00 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12NFIVaV185148;
        Tue, 23 Mar 2021 11:27:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=IhbKy3KEgFO5n9yoyV20uKz2csBLuks5l1dpHsBxZGk=;
 b=NLdpsebjh7WIR97zZUeDl9txZi/MZYMtf83xh94HHemDaHzg8Q5/gDx1jHSBtz5W506M
 hUpzX5ZX76Qy/X/l1R+EfNks//ror9TeiRnvqERdVovWNbXrw3SBGiA/Or6hMSfqwrNG
 LQSiXoRR07Dd3y3ltFfR0gA173w/hj7Fsdx/XUASBU19/5zsm4SLCfQZmqO7cCuE7geL
 jePbH7NA6GEI1RGlT4P11qLWfcqLIBM0HrZy4y0TiR90Dbgmqi2AVSUPF0nHGSXUP74H
 dxLiw81LEB6L3P0dY/6lCEpCN23HqWy9jR4Vp51urA5F6gXGpyeH6e18AN4bNqBg7jnJ Cw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37fjuw07gc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Mar 2021 11:26:59 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12NFJEOx186689;
        Tue, 23 Mar 2021 11:26:59 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37fjuw07fs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Mar 2021 11:26:59 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12NF7KLN030117;
        Tue, 23 Mar 2021 15:21:57 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 37d9by9tju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Mar 2021 15:21:57 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12NFLsc440698120
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Mar 2021 15:21:54 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 197BB4C040;
        Tue, 23 Mar 2021 15:21:54 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9F51B4C04E;
        Tue, 23 Mar 2021 15:21:53 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.2.56])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 23 Mar 2021 15:21:53 +0000 (GMT)
Date:   Tue, 23 Mar 2021 16:21:52 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
        frankja@linux.ibm.com, cohuck@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/2] s390/kvm: VSIE: fix MVPG handling for prefixing
 and MSO
Message-ID: <20210323162152.3356dc19@ibm-vm>
In-Reply-To: <9293b208-0f1d-fb58-290c-66a8ae30d60c@de.ibm.com>
References: <20210322140559.500716-1-imbrenda@linux.ibm.com>
        <20210322140559.500716-3-imbrenda@linux.ibm.com>
        <433933f5-1b6e-ea58-618d-3c844edc73a6@de.ibm.com>
        <830ca8c6-4d21-b1ed-ccaf-e0c12237849e@redhat.com>
        <9293b208-0f1d-fb58-290c-66a8ae30d60c@de.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-23_07:2021-03-22,2021-03-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 phishscore=0 malwarescore=0 spamscore=0 impostorscore=0
 clxscore=1015 suspectscore=0 adultscore=0 mlxlogscore=999 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103230112
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 23 Mar 2021 16:16:18 +0100
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> On 23.03.21 16:11, David Hildenbrand wrote:
> > On 23.03.21 16:07, Christian Borntraeger wrote: =20
> >>
> >>
> >> On 22.03.21 15:05, Claudio Imbrenda wrote: =20
> >>> Prefixing needs to be applied to the guest real address to
> >>> translate it into a guest absolute address.
> >>>
> >>> The value of MSO needs to be added to a guest-absolute address in
> >>> order to obtain the host-virtual.
> >>>
> >>> Fixes: 223ea46de9e79 ("s390/kvm: VSIE: correctly handle MVPG when
> >>> in VSIE") Cc: stable@vger.kernel.org
> >>> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> >>> Reported-by: Janosch Frank <frankja@linux.ibm.com>
> >>> ---
> >>> =C2=A0=C2=A0 arch/s390/kvm/vsie.c | 6 +++++-
> >>> =C2=A0=C2=A0 1 file changed, 5 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
> >>> index 48aab6290a77..ac86f11e46dc 100644
> >>> --- a/arch/s390/kvm/vsie.c
> >>> +++ b/arch/s390/kvm/vsie.c
> >>> @@ -1002,7 +1002,7 @@ static u64 vsie_get_register(struct
> >>> kvm_vcpu *vcpu, struct vsie_page *vsie_page, static int
> >>> vsie_handle_mvpg(struct kvm_vcpu *vcpu, struct vsie_page
> >>> *vsie_page) { struct kvm_s390_sie_block *scb_s =3D
> >>> &vsie_page->scb_s;
> >>> -=C2=A0=C2=A0=C2=A0 unsigned long pei_dest, pei_src, src, dest, mask;
> >>> +=C2=A0=C2=A0=C2=A0 unsigned long pei_dest, pei_src, dest, src, mask,=
 mso,
> >>> prefix; u64 *pei_block =3D &vsie_page->scb_o->mcic;
> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int edat, rc_dest, rc_src;
> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 union ctlreg0 cr0;
> >>> @@ -1010,9 +1010,13 @@ static int vsie_handle_mvpg(struct
> >>> kvm_vcpu *vcpu, struct vsie_page *vsie_page) cr0.val =3D
> >>> vcpu->arch.sie_block->gcr[0]; edat =3D cr0.edat &&
> >>> test_kvm_facility(vcpu->kvm, 8); mask =3D
> >>> _kvm_s390_logical_to_effective(&scb_s->gpsw, PAGE_MASK);
> >>> +=C2=A0=C2=A0=C2=A0 mso =3D scb_s->mso & ~(1UL << 20); =20
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sho=
uldnt that be ~((1UL << 20 ) -1)

oops

> >=20
> > Looking at shadow_scb(), we can simply take scb_s->mso unmodified. =20
>=20
> Right, I think I can fix this up (and get rid of the local mso

I think that's easier/simpler

> variable) when queueing. Or shall Claudio send a new version of the
> patch?

