Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FCAC3FA11F
	for <lists+stable@lfdr.de>; Fri, 27 Aug 2021 23:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbhH0VYo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Aug 2021 17:24:44 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46570 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231908AbhH0VYo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Aug 2021 17:24:44 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17RLE0gC130838;
        Fri, 27 Aug 2021 17:23:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=sCclVsG9zuQMWWDfdDhVlv7eQo2MGj647KbJjB0FvGE=;
 b=hkVIWSPLFnB26u8IfCDJ771Kt6FmU5P4x9xiZkHmQim7JtK+M5DSI+YgIapnK5MzFZtC
 6wlgLa2Wresdm2ErcCeRyYsIatQPus+REUQmnA88ncXcnudKseiN+ogCejT0y20XC7E4
 OEsr8neJc/IG327OMF94W1PS7U7uIjGsqo0MkD4Ydt02wSXIzLqTqqu8aQvcwq8PnGYB
 fJLxcm90iiiXwgNrXJckd/vfQMgKCVc17fKcZJLRVLlWniwWg4wOiN68JkX8E/nPNPSW
 4zult/UGt2QWipR50l9LEYXGS/f76i/8wKW18QEfnQcpSd3LrJ8rcvVdwJVxxdrFLJK2 9g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aq7sjr5ua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Aug 2021 17:23:54 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17RLFVgC139301;
        Fri, 27 Aug 2021 17:23:54 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aq7sjr5tk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Aug 2021 17:23:54 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17RLHgWH016088;
        Fri, 27 Aug 2021 21:23:51 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 3ajs48t8aa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Aug 2021 21:23:51 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17RLNlRF55378226
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Aug 2021 21:23:47 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BABA411C050;
        Fri, 27 Aug 2021 21:23:47 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C933A11C01F;
        Fri, 27 Aug 2021 21:23:46 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.80.46])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Fri, 27 Aug 2021 21:23:46 +0000 (GMT)
Date:   Fri, 27 Aug 2021 23:23:44 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Michael Mueller <mimu@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH 1/1] KVM: s390: index kvm->arch.idle_mask by vcpu_idx
Message-ID: <20210827232344.431e3114.pasic@linux.ibm.com>
In-Reply-To: <e9d2f79c-b784-bc6b-88dc-2d0f7cc08dbe@de.ibm.com>
References: <20210827125429.1912577-1-pasic@linux.ibm.com>
        <20210827160616.532d6699@p-imbrenda>
        <e9d2f79c-b784-bc6b-88dc-2d0f7cc08dbe@de.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: oj0mOj90HEjTriSPPOKCL0y1FS6AXabX
X-Proofpoint-GUID: e44dW4wEjmBWVeodvyoT24FHQg_SXFMh
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-27_06:2021-08-27,2021-08-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 malwarescore=0 priorityscore=1501 impostorscore=0 mlxscore=0
 suspectscore=0 clxscore=1015 adultscore=0 bulkscore=0 lowpriorityscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108270124
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 27 Aug 2021 18:36:48 +0200
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> On 27.08.21 16:06, Claudio Imbrenda wrote:
> > On Fri, 27 Aug 2021 14:54:29 +0200
> > Halil Pasic <pasic@linux.ibm.com> wrote:
> >   
> >> While in practice vcpu->vcpu_idx ==  vcpu->vcp_id is often true,

s/vcp_id/vcpu_id/

> >> it may not always be, and we must not rely on this.  
> > 
> > why?
> > 
> > maybe add a simple explanation of why vcpu_idx and vcpu_id can be
> > different, namely:
> > KVM decides the vcpu_idx, userspace decides the vcpu_id, thus the two
> > might not match
> >   
> >>
> >> Currently kvm->arch.idle_mask is indexed by vcpu_id, which implies
> >> that code like
> >> for_each_set_bit(vcpu_id, kvm->arch.idle_mask, online_vcpus) {
> >>                  vcpu = kvm_get_vcpu(kvm, vcpu_id);  
> > 
> > you can also add a sentence to clarify that kvm_get_vcpu expects an
> > vcpu_idx, not an vcpu_id.
> >   
> >> 		do_stuff(vcpu);  
> 
> I will modify the patch description accordingly before sending to Paolo.
> Thanks for noticing.

Can you also please fix the typo I pointed out above (in the first line
of the long description).

Thanks!
Halil
