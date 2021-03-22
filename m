Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21C44343F58
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 12:13:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbhCVLMu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 07:12:50 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:3164 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230194AbhCVLMi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Mar 2021 07:12:38 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12MB3DtV054249;
        Mon, 22 Mar 2021 07:12:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=/RRkyit7Gs9XpK0bshkl5kLG0MSCrZYjso4ppZ1RYQ0=;
 b=kG83A9B3JQe33iIWgilhBR65bQ1+DR7ayzunOnt8BArdvbaOlehGZCf3XyRJ4fK3EQHh
 gytyab6qS/avoOr40CWCbzGqTPg3kKDfi8+uVOmKuUJT/3lZKPehkew0+0hIDDP0yoN4
 rbhapRUtPlWbh4MzOspIwzjuwcAofHDdostrLvv+4C7Ik2o/z+P5GqKUPJC+la61KI+5
 G1wEspdx1OwNaRkuiimjmM8g9AxXOTxf4NOnez2+ICnelG7QTLsbSFbpMT9EE7udUZIF
 DcHVDc+UjQlWhZ6YtkA/iPj7ZnZvX8gsEWuN/dqXloRIYEhh7jCmGn2Go+GIfU5BOn8D Hg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37e03eukmr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Mar 2021 07:12:37 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12MB3GDO054467;
        Mon, 22 Mar 2021 07:12:36 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37e03eukkd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Mar 2021 07:12:36 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12MBCLab004511;
        Mon, 22 Mar 2021 11:12:34 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 37d9by95h5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Mar 2021 11:12:33 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12MBCCqM36897176
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Mar 2021 11:12:12 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 80B2EA4053;
        Mon, 22 Mar 2021 11:12:30 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0CC63A4051;
        Mon, 22 Mar 2021 11:12:30 +0000 (GMT)
Received: from osiris (unknown [9.171.45.177])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 22 Mar 2021 11:12:29 +0000 (GMT)
Date:   Mon, 22 Mar 2021 12:12:28 +0100
From:   Heiko Carstens <hca@linux.ibm.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-kernel@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, cohuck@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v1 1/2] s390/kvm: split kvm_s390_real_to_abs
Message-ID: <YFh7nGfVZRD15Cbp@osiris>
References: <20210319193354.399587-1-imbrenda@linux.ibm.com>
 <20210319193354.399587-2-imbrenda@linux.ibm.com>
 <fa583ab0-36ac-47a7-7fa3-4ce88c518488@redhat.com>
 <f76f770c-908e-4f4f-f060-15f4d30652d8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f76f770c-908e-4f4f-f060-15f4d30652d8@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-22_04:2021-03-22,2021-03-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 adultscore=0 phishscore=0
 impostorscore=0 bulkscore=0 mlxscore=0 mlxlogscore=988 malwarescore=0
 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103220079
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 22, 2021 at 10:53:46AM +0100, David Hildenbrand wrote:
> > > diff --git a/arch/s390/kvm/gaccess.h b/arch/s390/kvm/gaccess.h
> > > index daba10f76936..7c72a5e3449f 100644
> > > --- a/arch/s390/kvm/gaccess.h
> > > +++ b/arch/s390/kvm/gaccess.h
> > > @@ -18,17 +18,14 @@
> > >    /**
> > >     * kvm_s390_real_to_abs - convert guest real address to guest absolute address
> > > - * @vcpu - guest virtual cpu
> > > + * @prefix - guest prefix
> > >     * @gra - guest real address
> > >     *
> > >     * Returns the guest absolute address that corresponds to the passed guest real
> > > - * address @gra of a virtual guest cpu by applying its prefix.
> > > + * address @gra of by applying the given prefix.
> > >     */
> > > -static inline unsigned long kvm_s390_real_to_abs(struct kvm_vcpu *vcpu,
> > > -						 unsigned long gra)
> > > +static inline unsigned long _kvm_s390_real_to_abs(u32 prefix, unsigned long gra)
> > 
> > <bikeshedding>
> > Just a matter of taste, but maybe this could be named differently?
> > kvm_s390_real2abs_prefix() ? kvm_s390_prefix_real_to_abs()?
> > </bikeshedding>
> 
> +1, I also dislike these "_.*" style functions here.

Yes, let's bikeshed then :)

Could you then please try to rename page_to* and everything that looks
similar to page2* please? I'm wondering what the response will be..
