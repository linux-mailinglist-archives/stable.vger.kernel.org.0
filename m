Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38D084A46F2
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 13:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377044AbiAaMZR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 07:25:17 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39964 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S241079AbiAaMZQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 07:25:16 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20VBBRq8026075;
        Mon, 31 Jan 2022 12:25:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=O4wtQYp6ALZab4bMarZJKmfsVhNP5vqFbU9c7Z5Ke4U=;
 b=mo2hwcwIuNUqiChyjNqU4w+6B97xNkZU+bYVrkK/siSyYp8OmTAZEViOuYoyT7Ouz2sW
 t0UQWGK9/HfQHqUlnlFtO9/l7dcyRRI93i7zVPi/YnJyy5wS+I2GfUgZ1ehqcNnbZ7em
 5Iyq5SGWrJSos6wpcidsyyg+ZFMxBVfynh3Ubv8vDAdQVekv/zygaWRXgMMBwvpAmlnN
 YTr99Ac5gnvFCzPGQ1xz51SXlwji6aL84zTCVO8EgLQL2KjCfsZ9vhZ6QqJPbuSFhXSM
 1ttPZGf2sGE13mrMjy4rIJS/s7NtQG5jayDQNmnaRagbBhGGYcNcmSyyqPyu+LopXN9g ew== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dxbwa4s21-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Jan 2022 12:25:12 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20VBWXVC019044;
        Mon, 31 Jan 2022 12:25:12 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dxbwa4s1g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Jan 2022 12:25:12 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20VC8AlR024134;
        Mon, 31 Jan 2022 12:25:10 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 3dvw792gem-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Jan 2022 12:25:10 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20VCP4bE21496296
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Jan 2022 12:25:04 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 560E711C066;
        Mon, 31 Jan 2022 12:25:04 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6819E11C054;
        Mon, 31 Jan 2022 12:25:03 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.30.167])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Mon, 31 Jan 2022 12:25:03 +0000 (GMT)
Date:   Mon, 31 Jan 2022 13:24:59 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Petr =?UTF-8?B?VGVzYcWZw61r?= <ptesarik@suse.cz>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Michael Mueller <mimu@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH 1/1] KVM: s390: index kvm->arch.idle_mask by vcpu_idx
Message-ID: <20220131132459.125e560c.pasic@linux.ibm.com>
In-Reply-To: <76a1c7b0-a073-02bb-1612-a74ca97105ec@suse.cz>
References: <20210827125429.1912577-1-pasic@linux.ibm.com>
        <3ca4de98-8f4d-9937-923e-f8865c96f82c@suse.cz>
        <20220131125337.05f73251.pasic@linux.ibm.com>
        <76a1c7b0-a073-02bb-1612-a74ca97105ec@suse.cz>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: UigN8Km17PMrofHcejV2lTkNHQs6wt41
X-Proofpoint-ORIG-GUID: lvwfGf52pHtBj7sbVl-RSQSQmkiwO2wS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-31_04,2022-01-28_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 adultscore=0 impostorscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201310081
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 31 Jan 2022 13:09:26 +0100
Petr Tesařík <ptesarik@suse.cz> wrote:

> Hi Halil,
> 
> Dne 31. 01. 22 v 12:53 Halil Pasic napsal(a):
> > On Mon, 31 Jan 2022 11:13:18 +0100
> > Petr Tesařík <ptesarik@suse.cz> wrote:
> >   
> >> Hi Halil,
> >>
> >> Dne 27. 08. 21 v 14:54 Halil Pasic napsal(a):  
> >>> While in practice vcpu->vcpu_idx ==  vcpu->vcp_id is often true,
> >>> it may not always be, and we must not rely on this.
> >>>
> >>> Currently kvm->arch.idle_mask is indexed by vcpu_id, which implies
> >>> that code like
> >>> for_each_set_bit(vcpu_id, kvm->arch.idle_mask, online_vcpus) {
> >>>                   vcpu = kvm_get_vcpu(kvm, vcpu_id);
> >>> 		do_stuff(vcpu);
> >>> }
> >>> is not legit. The trouble is, we do actually use kvm->arch.idle_mask
> >>> like this. To fix this problem we have two options. Either use
> >>> kvm_get_vcpu_by_id(vcpu_id), which would loop to find the right vcpu_id,
> >>> or switch to indexing via vcpu_idx. The latter is preferable for obvious
> >>> reasons.  
> >>
> >> I'm just backporting this fix to SLES 12 SP5, and I've noticed that
> >> there is still this code in __floating_irq_kick():
> >>
> >> 	/* find idle VCPUs first, then round robin */
> >> 	sigcpu = find_first_bit(fi->idle_mask, online_vcpus);
> >> /* ... round robin loop removed ...
> >> 	dst_vcpu = kvm_get_vcpu(kvm, sigcpu);
> >>
> >> It seems to me that this does exactly the thing that is not legit, but
> >> I'm no expert. Did I miss something?
> >>  
> > 
> > We made that legit by making the N-th bit in idle_mask correspond to the
> > vcpu whose vcpu_idx == N. The second argument of kvm_get_vcpu() is the
> > vcpu_idx. IMHO that ain't super-intuitive because it ain't spelled out.
> > 
> > So before this was a mismatch (with a vcpu_id based bitmap we would have
> > to use kvm_get_vcpu_by_id()), and with this patch applied this code
> > becomes legit because both idle_mask and kvm_get_vcpu() operate with
> > vcpu_idx.
> > 
> > Does that make sense?  
> 
> Yes!
> 
> > I'm sorry the commit message did not convey this clearly enough...  
> 
> No, it's not your fault. I didn't pay enough attention to the change, 
> and with vcpu_id and vcpu_idx being so similar I got confused.

No problem at all!

> 
> In short, there's no bug now, indeed. Thanks for your patience.
> 

Thank you for being mindful when backporting!

Regards,
Halil

