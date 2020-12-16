Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C434D2DB862
	for <lists+stable@lfdr.de>; Wed, 16 Dec 2020 02:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726053AbgLPBWi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Dec 2020 20:22:38 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:8018 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725952AbgLPBWi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Dec 2020 20:22:38 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BG10x1x028450;
        Tue, 15 Dec 2020 20:21:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=0+BnuKA8p1Jrwe6PPrdqKhHIW1sVQdnh7AMkQ8h2wWA=;
 b=PUxN2HawcIcUXGlDLWk/G/PbfI4DzbDsJevw+pjpQgSAhet6dX4KQar6jHYFPsaVhrW9
 5I/MiCEeXMQDi5hxudlQ7QgptKQUT9cYAouWEycYjQjXTODYbAT1Yat7GGH+dI08AyVP
 MNtWC0FzIh/QX5PzoSwXTYJvKL5NYfv+2qr79FcfDk33OcbkhlcPHjljUSM6XX0XWEV6
 xXytFGWKxzNiiWzFcbk9Ey406fUiVMKKUNpgbfnuIJeX0d85U2ba9wMAu0DlNEdTn1dX
 c/tI9hdo8NNg6GIwXnZ8I9XggHcXtI/wrF0WuSU4Oal7NpmZP4wp3PM3MEtupoTB/tjE 4w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35f5qe42ve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Dec 2020 20:21:50 -0500
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BG1Ln4l094992;
        Tue, 15 Dec 2020 20:21:49 -0500
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35f5qe42v2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Dec 2020 20:21:49 -0500
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BG1D8sk027041;
        Wed, 16 Dec 2020 01:21:48 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma05fra.de.ibm.com with ESMTP id 35cng89y8e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Dec 2020 01:21:47 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BG1LjWR31457654
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Dec 2020 01:21:45 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E93EBAE045;
        Wed, 16 Dec 2020 01:21:44 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4931AAE053;
        Wed, 16 Dec 2020 01:21:44 +0000 (GMT)
Received: from oc2783563651 (unknown [9.171.86.205])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Wed, 16 Dec 2020 01:21:44 +0000 (GMT)
Date:   Wed, 16 Dec 2020 02:21:40 +0100
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
Message-ID: <20201216022140.02741788.pasic@linux.ibm.com>
In-Reply-To: <44ffb312-964a-95c3-d691-38221cee2c0a@de.ibm.com>
References: <20201214165617.28685-1-akrowiak@linux.ibm.com>
        <20201215115746.3552e873.pasic@linux.ibm.com>
        <44ffb312-964a-95c3-d691-38221cee2c0a@de.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-15_13:2020-12-15,2020-12-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 impostorscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1015 priorityscore=1501
 mlxscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012160001
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 15 Dec 2020 19:10:20 +0100
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> 
> 
> On 15.12.20 11:57, Halil Pasic wrote:
> > On Mon, 14 Dec 2020 11:56:17 -0500
> > Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> > 
> >> The vfio_ap device driver registers a group notifier with VFIO when the
> >> file descriptor for a VFIO mediated device for a KVM guest is opened to
> >> receive notification that the KVM pointer is set (VFIO_GROUP_NOTIFY_SET_KVM
> >> event). When the KVM pointer is set, the vfio_ap driver takes the
> >> following actions:
> >> 1. Stashes the KVM pointer in the vfio_ap_mdev struct that holds the state
> >>    of the mediated device.
> >> 2. Calls the kvm_get_kvm() function to increment its reference counter.
> >> 3. Sets the function pointer to the function that handles interception of
> >>    the instruction that enables/disables interrupt processing.
> >> 4. Sets the masks in the KVM guest's CRYCB to pass AP resources through to
> >>    the guest.
> >>
> >> In order to avoid memory leaks, when the notifier is called to receive
> >> notification that the KVM pointer has been set to NULL, the vfio_ap device
> >> driver should reverse the actions taken when the KVM pointer was set.
> >>
> >> Fixes: 258287c994de ("s390: vfio-ap: implement mediated device open callback")
> >> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> >> ---
> >>  drivers/s390/crypto/vfio_ap_ops.c | 29 ++++++++++++++++++++---------
> >>  1 file changed, 20 insertions(+), 9 deletions(-)
> >>
> >> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> >> index e0bde8518745..cd22e85588e1 100644
> >> --- a/drivers/s390/crypto/vfio_ap_ops.c
> >> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> >> @@ -1037,8 +1037,6 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
> >>  {
> >>  	struct ap_matrix_mdev *m;
> >>
> >> -	mutex_lock(&matrix_dev->lock);
> >> -
> >>  	list_for_each_entry(m, &matrix_dev->mdev_list, node) {
> >>  		if ((m != matrix_mdev) && (m->kvm == kvm)) {
> >>  			mutex_unlock(&matrix_dev->lock);
> >> @@ -1049,7 +1047,6 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
> >>  	matrix_mdev->kvm = kvm;
> >>  	kvm_get_kvm(kvm);
> >>  	kvm->arch.crypto.pqap_hook = &matrix_mdev->pqap_hook;
> >> -	mutex_unlock(&matrix_dev->lock);
> >>
> >>  	return 0;
> >>  }
> >> @@ -1083,35 +1080,49 @@ static int vfio_ap_mdev_iommu_notifier(struct notifier_block *nb,
> >>  	return NOTIFY_DONE;
> >>  }
> >>
> >> +static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev)
> >> +{
> >> +	kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
> >> +	matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
> > 
> > 
> > This patch LGTM. The only concern I have with it is whether a
> > different cpu is guaranteed to observe the above assignment as
> > an atomic operation. I think we didn't finish this discussion
> > at v1, or did we?
> 
> You mean just this assigment:
> >> +	matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
> should either have the old or the new value, but not halve zero halve old?
>

Yes that is the assignment I was referring to. Old value will work as well because
kvm holds a reference to this module while in the pqap_hook.
 
> Normally this should be ok (and I would consider this a compiler bug if
> this is split into 2 32 bit zeroes) But if you really want to be sure then we
> can use WRITE_ONCE.

Just my curiosity: what would make this a bug? Is it the s390 elf ABI,
or some gcc feature, or even the C standard? Also how exactly would
WRITE_ONCE, also access via volatile help in this particular situation?

I agree, if the member is properly aligned, (which it is),
normally/probably we are fine on s390x (which is also a given). 

> I think we take this via the s390 tree? I can add the WRITE_ONCE when applying?

Yes that works fine with me.

Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
