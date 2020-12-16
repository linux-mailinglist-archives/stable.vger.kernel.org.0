Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 961E62DC93C
	for <lists+stable@lfdr.de>; Wed, 16 Dec 2020 23:51:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbgLPWvr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Dec 2020 17:51:47 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:16616 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727823AbgLPWvq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Dec 2020 17:51:46 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BGMY7JS005096;
        Wed, 16 Dec 2020 17:51:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=YGsmZvHBeeJBs2Dxbze8UDgDl3r3Trz1b7AFnaesP3U=;
 b=AWWjgHFNEOz1mMfwmoJ1nlslVqWNXo3mKBlSBjOCDmxYuNXeWpeY2bL2n93tEWDtNIuz
 R/i/1ktkyfxpMAKlkivUYW3vG5MRRiz22e2hs+/KZ4d4G6m6So4fxE0NV8ohLfn94X4/
 qSadu4XH9AaWWghIbvmSUNKSursUEYAdZo8eUiFQKF0PjDEuUDRv1xj4H/4uIi99CKxI
 EQU0T3AFCORojkvSuySYTt8pglV0rjsESXtIi6baVnn8KyYEbsrirqmwT01UN+wq2iwR
 XLkr1OpdG3QhH2Tpk/WjWUrrOQyvROMXeTMrlKmaZYfFLgmzT3uOiNlirPyx5nfh7ubz 4w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35fshhtk9y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Dec 2020 17:51:02 -0500
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BGMYbEu007156;
        Wed, 16 Dec 2020 17:51:01 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35fshhtk9f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Dec 2020 17:51:01 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BGMhDDt005222;
        Wed, 16 Dec 2020 22:50:59 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 35cng8f174-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Dec 2020 22:50:59 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BGMnfnR23921086
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Dec 2020 22:49:41 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3D172AE04D;
        Wed, 16 Dec 2020 22:49:41 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 499A3AE045;
        Wed, 16 Dec 2020 22:49:40 +0000 (GMT)
Received: from oc2783563651 (unknown [9.171.26.143])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Wed, 16 Dec 2020 22:49:40 +0000 (GMT)
Date:   Wed, 16 Dec 2020 23:49:38 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org, gregkh@linuxfoundation.org,
        sashal@kernel.org, cohuck@redhat.com, kwankhede@nvidia.com,
        pbonzini@redhat.com, alex.williamson@redhat.com,
        pasic@linux.vnet.ibm.com
Subject: Re: [PATCH v3] s390/vfio-ap: clean up vfio_ap resources when KVM
 pointer invalidated
Message-ID: <20201216234938.6656399c.pasic@linux.ibm.com>
In-Reply-To: <ae6e5c7a-0159-035e-2bd3-0a749f81a7c0@de.ibm.com>
References: <20201214165617.28685-1-akrowiak@linux.ibm.com>
        <20201215115746.3552e873.pasic@linux.ibm.com>
        <44ffb312-964a-95c3-d691-38221cee2c0a@de.ibm.com>
        <20201216022140.02741788.pasic@linux.ibm.com>
        <ae6e5c7a-0159-035e-2bd3-0a749f81a7c0@de.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-16_10:2020-12-15,2020-12-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 priorityscore=1501 clxscore=1015 mlxscore=0 lowpriorityscore=0
 phishscore=0 impostorscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012160140
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 16 Dec 2020 10:58:48 +0100
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> On 16.12.20 02:21, Halil Pasic wrote:
> > On Tue, 15 Dec 2020 19:10:20 +0100
> > Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> > 
> >>
> >>
> >> On 15.12.20 11:57, Halil Pasic wrote:
> >>> On Mon, 14 Dec 2020 11:56:17 -0500
> >>> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> >>>
> >>>> The vfio_ap device driver registers a group notifier with VFIO when the
> >>>> file descriptor for a VFIO mediated device for a KVM guest is opened to
> >>>> receive notification that the KVM pointer is set (VFIO_GROUP_NOTIFY_SET_KVM
> >>>> event). When the KVM pointer is set, the vfio_ap driver takes the
> >>>> following actions:
> >>>> 1. Stashes the KVM pointer in the vfio_ap_mdev struct that holds the state
> >>>>    of the mediated device.
> >>>> 2. Calls the kvm_get_kvm() function to increment its reference counter.
> >>>> 3. Sets the function pointer to the function that handles interception of
> >>>>    the instruction that enables/disables interrupt processing.
> >>>> 4. Sets the masks in the KVM guest's CRYCB to pass AP resources through to
> >>>>    the guest.
> >>>>
> >>>> In order to avoid memory leaks, when the notifier is called to receive
> >>>> notification that the KVM pointer has been set to NULL, the vfio_ap device
> >>>> driver should reverse the actions taken when the KVM pointer was set.
> >>>>
> >>>> Fixes: 258287c994de ("s390: vfio-ap: implement mediated device open callback")
> >>>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> >>>> ---
> >>>>  drivers/s390/crypto/vfio_ap_ops.c | 29 ++++++++++++++++++++---------
> >>>>  1 file changed, 20 insertions(+), 9 deletions(-)
> >>>>
> >>>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> >>>> index e0bde8518745..cd22e85588e1 100644
> >>>> --- a/drivers/s390/crypto/vfio_ap_ops.c
> >>>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> >>>> @@ -1037,8 +1037,6 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
> >>>>  {
> >>>>  	struct ap_matrix_mdev *m;
> >>>>
> >>>> -	mutex_lock(&matrix_dev->lock);
> >>>> -
> >>>>  	list_for_each_entry(m, &matrix_dev->mdev_list, node) {
> >>>>  		if ((m != matrix_mdev) && (m->kvm == kvm)) {
> >>>>  			mutex_unlock(&matrix_dev->lock);
> >>>> @@ -1049,7 +1047,6 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
> >>>>  	matrix_mdev->kvm = kvm;
> >>>>  	kvm_get_kvm(kvm);
> >>>>  	kvm->arch.crypto.pqap_hook = &matrix_mdev->pqap_hook;
> >>>> -	mutex_unlock(&matrix_dev->lock);
> >>>>
> >>>>  	return 0;
> >>>>  }
> >>>> @@ -1083,35 +1080,49 @@ static int vfio_ap_mdev_iommu_notifier(struct notifier_block *nb,
> >>>>  	return NOTIFY_DONE;
> >>>>  }
> >>>>
> >>>> +static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev)
> >>>> +{
> >>>> +	kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
> >>>> +	matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
> >>>
> >>>
> >>> This patch LGTM. The only concern I have with it is whether a
> >>> different cpu is guaranteed to observe the above assignment as
> >>> an atomic operation. I think we didn't finish this discussion
> >>> at v1, or did we?
> >>
> >> You mean just this assigment:
> >>>> +	matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
> >> should either have the old or the new value, but not halve zero halve old?
> >>
> > 
> > Yes that is the assignment I was referring to. Old value will work as well because
> > kvm holds a reference to this module while in the pqap_hook.
> >  
> >> Normally this should be ok (and I would consider this a compiler bug if
> >> this is split into 2 32 bit zeroes) But if you really want to be sure then we
> >> can use WRITE_ONCE.
> > 
> > Just my curiosity: what would make this a bug? Is it the s390 elf ABI,
> > or some gcc feature, or even the C standard? Also how exactly would
> > WRITE_ONCE, also access via volatile help in this particular situation?
> 
> I think its a tricky things and not strictly guaranteed, but there is a lot
> of code that relies on the atomicity of word sizes. see for example the discussion
> here
> https://lore.kernel.org/lkml/CAHk-=wgC4+kV9AiLokw7cPP429rKCU+vjA8cWAfyOjC3MtqC4A@mail.gmail.com/
> 
> WRITE_ONCE will not change the guarantees a lot, but it is mostly a documentation
> that we assume atomic access here.

Thanks a lot! I've read it, and IMHO it seems to contradict the section
https://lwn.net/Articles/793253/#Store%20Tearing a little. From there, I also learned
that WRITE_ONCE (i.e. volatile access) can help, although I don't really
understand why. Of course, we don't need to be portable here, as this
is s390 only code. So we might be safe without anything -- I don't know.
I believe, if volatile were enough (under any circumstances), the C
standard wouldn't have introduced atomic types.

Regards,
Halil
