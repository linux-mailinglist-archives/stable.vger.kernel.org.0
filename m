Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE2B3FA113
	for <lists+stable@lfdr.de>; Fri, 27 Aug 2021 23:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231906AbhH0VUW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Aug 2021 17:20:22 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39330 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231883AbhH0VUV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Aug 2021 17:20:21 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17RLAZm2158605;
        Fri, 27 Aug 2021 17:19:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=u7sQHkmMVCWEQ+xt8UpkVUhX3C0XhIyAKQkPPvYoi1Q=;
 b=E7xY5XIzDc53Kzg9lY8jkTRcinj8LX6qCpKAefRm+SHfNfqdROElMbqtwNnjf1oBHydP
 YerYDRy+474agy3GgY2t7CMHX6Gu3HPWpWwRIY7ksA6iSt2vRTpfV23QGCTdZd6ePEgQ
 9p748MYkKLXrX9mtOLs3iHbRob7q3f8wc0ZrnWH9g7giA7Qv3bL2J4UJNp/edXPpwVeU
 DtnYo+q18TVMg7vPvhdmFqSsyXbn9RyM+C7cIopPXXoBYZUWZ0AVM+DOUNZxl3Yrv52/
 of9jMmd38l8RbJEx2C20AC3OH1LvmmMrvuX2V6HjPB/hi+DTHTNhARZjUTsAO9dwARYI 7A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aq75j8qq1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Aug 2021 17:19:31 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17RLBOMN163530;
        Fri, 27 Aug 2021 17:19:30 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aq75j8qpb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Aug 2021 17:19:30 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17RLHdBd026989;
        Fri, 27 Aug 2021 21:19:29 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma05fra.de.ibm.com with ESMTP id 3ajs48j84t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Aug 2021 21:19:29 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17RLJPPm35848604
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Aug 2021 21:19:25 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8F4FC42041;
        Fri, 27 Aug 2021 21:19:25 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B657942049;
        Fri, 27 Aug 2021 21:19:24 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.80.46])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Fri, 27 Aug 2021 21:19:24 +0000 (GMT)
Date:   Fri, 27 Aug 2021 23:19:21 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Michael Mueller <mimu@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH 1/1] KVM: s390: index kvm->arch.idle_mask by vcpu_idx
Message-ID: <20210827231921.267ad3df.pasic@linux.ibm.com>
In-Reply-To: <20210827160616.532d6699@p-imbrenda>
References: <20210827125429.1912577-1-pasic@linux.ibm.com>
        <20210827160616.532d6699@p-imbrenda>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: flYt4X4CxFJtdIKA-hZi8DCd9QyZXomU
X-Proofpoint-ORIG-GUID: rDOrGoWkUmPCfTxYp7kRBUf49-RAlFkF
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-27_06:2021-08-27,2021-08-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 priorityscore=1501 mlxlogscore=999 spamscore=0 suspectscore=0 mlxscore=0
 adultscore=0 phishscore=0 bulkscore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108270124
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 27 Aug 2021 16:06:16 +0200
Claudio Imbrenda <imbrenda@linux.ibm.com> wrote:

> On Fri, 27 Aug 2021 14:54:29 +0200
> Halil Pasic <pasic@linux.ibm.com> wrote:
> 
> > While in practice vcpu->vcpu_idx ==  vcpu->vcp_id is often true,

s/vcp_id/vcpu_id/

> > it may not always be, and we must not rely on this.  
> 
> why?
> 
> maybe add a simple explanation of why vcpu_idx and vcpu_id can be
> different, namely:
> KVM decides the vcpu_idx, userspace decides the vcpu_id, thus the two
> might not match 

Not sure that is a good explanation. A quote from
Documentation/virt/kvm/api.rst:

"""
4.7 KVM_CREATE_VCPU
-------------------

:Capability: basic
:Architectures: all
:Type: vm ioctl
:Parameters: vcpu id (apic id on x86)
:Returns: vcpu fd on success, -1 on error
                
This API adds a vcpu to a virtual machine. No more than max_vcpus may be added.
The vcpu id is an integer in the range [0, max_vcpu_id).
        
The recommended max_vcpus value can be retrieved using the KVM_CAP_NR_VCPUS of
the KVM_CHECK_EXTENSION ioctl() at run-time.
The maximum possible value for max_vcpus can be retrieved using the
KVM_CAP_MAX_VCPUS of the KVM_CHECK_EXTENSION ioctl() at run-time.
"""

Based on that and a quick look at the code, it looks to me like the
set of valid vcpu_id values are a subset of the range of vcpu_idx-es,
i.e. that kvm could decide to choose vcpu_id for the value of vcpu_idx.
I don't think it should, but it could. Were the set of valid vcpu_id
values not a subset of the set of supported vcpu_idx values, then one
could argue that this is why.

I didn't want to get into explaining the why, I just wanted to state the
fact.

> 
> > 
> > Currently kvm->arch.idle_mask is indexed by vcpu_id, which implies
> > that code like
> > for_each_set_bit(vcpu_id, kvm->arch.idle_mask, online_vcpus) {
> >                 vcpu = kvm_get_vcpu(kvm, vcpu_id);  
> 
> you can also add a sentence to clarify that kvm_get_vcpu expects an
> vcpu_idx, not an vcpu_id.

maybe ...

> 
> > 		do_stuff(vcpu);
> > }
> > is not legit. The trouble is, we do actually use kvm->arch.idle_mask

... s/legit\./legit, because kvm_get_vcpu() expects a vcpu_idx and not a
vcpu_id.

But I agree kvm_get_vcpu(kvm, vcpu_id); does not scream BUG at me while
kvm_get_vcpu_by_idx(kvm, vcpu_id) would look much more suspicious.

[..]
> 
> otherwise looks good to me.
> 
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Thanks for your reveiew!

Halil

[..]
