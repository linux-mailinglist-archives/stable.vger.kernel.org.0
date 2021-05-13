Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7350C37FCBB
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 19:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbhEMRrC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 13:47:02 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:19828 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230204AbhEMRrB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 May 2021 13:47:01 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14DHXZT8030752;
        Thu, 13 May 2021 13:45:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=sAOZwolAoy/drwR0caZU8MVPGvjvq28I4PUecHlZgbk=;
 b=YXBWS+zbh2EYRIK3c+qpRhk7qJkx5cZAVsX1L0/ixI4ma10G1wIeIsYzF6bqfcgd3uy+
 IwMXRU2gviW6qDNig6Fw6jbJE9arpXRovc3v4upju2NXdZ13LUUu6S59jTH+QFQ6U/6f
 c5YOYSuciwesjKjHhU1beMEaJRw6p2AuowIyLa0ELREKwiog8cULl1Qacw9p1dwspUqs
 0M58nolviNM9DRuw2yAnEgwFygPtpQ/oeDmQItzpMyppD+udNS1foD/k16liMNdc3TjB
 n7TT01xxzYHV2yPZW2y/JT7tFk9yLGvYOuYFhCBJXPoKKHwexJfIlDovzi32UeVvjOv9 sw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38h7kxt3cf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 May 2021 13:45:49 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14DHXjaW031694;
        Thu, 13 May 2021 13:45:49 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38h7kxt3bn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 May 2021 13:45:48 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14DHd6Sd019211;
        Thu, 13 May 2021 17:45:46 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 38dj98au5t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 May 2021 17:45:46 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14DHjhLR39518532
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 May 2021 17:45:43 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7BAE55204E;
        Thu, 13 May 2021 17:45:43 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.9.250])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with SMTP id A43025204F;
        Thu, 13 May 2021 17:45:42 +0000 (GMT)
Date:   Thu, 13 May 2021 19:45:41 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        pasic@linux.vnet.ibm.com, jjherne@linux.ibm.com, jgg@nvidia.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        stable@vger.kernel.org, Tony Krowiak <akrowiak@stny.rr.com>
Subject: Re: [PATCH v2] s390/vfio-ap: fix memory leak in mdev remove
 callback
Message-ID: <20210513194541.58d1628a.pasic@linux.ibm.com>
In-Reply-To: <4c156ab8-da49-4867-f29c-9712c2628d44@linux.ibm.com>
References: <20210510214837.359717-1-akrowiak@linux.ibm.com>
        <20210512203536.4209c29c.pasic@linux.ibm.com>
        <4c156ab8-da49-4867-f29c-9712c2628d44@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: j_0LaH2wvlKTfj4XQdZHKt381UN5yZzI
X-Proofpoint-ORIG-GUID: 1HhEbFaLPJXS6RgbGNzZM_nx8gTz-rif
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-13_10:2021-05-12,2021-05-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1015
 phishscore=0 mlxscore=0 suspectscore=0 impostorscore=0 priorityscore=1501
 spamscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105130122
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 13 May 2021 10:35:05 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> On 5/12/21 2:35 PM, Halil Pasic wrote:
> > On Mon, 10 May 2021 17:48:37 -0400
> > Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> >  
> >> The mdev remove callback for the vfio_ap device driver bails out with
> >> -EBUSY if the mdev is in use by a KVM guest. The intended purpose was
> >> to prevent the mdev from being removed while in use; however, returning a
> >> non-zero rc does not prevent removal. This could result in a memory leak
> >> of the resources allocated when the mdev was created. In addition, the
> >> KVM guest will still have access to the AP devices assigned to the mdev
> >> even though the mdev no longer exists.
> >>
> >> To prevent this scenario, cleanup will be done - including unplugging the
> >> AP adapters, domains and control domains - regardless of whether the mdev
> >> is in use by a KVM guest or not.
> >>
> >> Fixes: 258287c994de ("s390: vfio-ap: implement mediated device open callback")
> >> Cc: stable@vger.kernel.org
> >> Signed-off-by: Tony Krowiak <akrowiak@stny.rr.com>
> >> ---
> >>   drivers/s390/crypto/vfio_ap_ops.c | 13 ++-----------
> >>   1 file changed, 2 insertions(+), 11 deletions(-)
> >>
> >> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> >> index b2c7e10dfdcd..f90c9103dac2 100644
> >> --- a/drivers/s390/crypto/vfio_ap_ops.c
> >> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> >> @@ -26,6 +26,7 @@
> >>
> >>   static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev);
> >>   static struct vfio_ap_queue *vfio_ap_find_queue(int apqn);
> >> +static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev);
> >>
> >>   static int match_apqn(struct device *dev, const void *data)
> >>   {
> >> @@ -366,17 +367,7 @@ static int vfio_ap_mdev_remove(struct mdev_device *mdev)
> >>   	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
> >>
> >>   	mutex_lock(&matrix_dev->lock);
> >> -
> >> -	/*
> >> -	 * If the KVM pointer is in flux or the guest is running, disallow
> >> -	 * un-assignment of control domain.
> >> -	 */
> >> -	if (matrix_mdev->kvm_busy || matrix_mdev->kvm) {
> >> -		mutex_unlock(&matrix_dev->lock);
> >> -		return -EBUSY;
> >> -	}
> >> -
> >> -	vfio_ap_mdev_reset_queues(mdev);
> >> +	vfio_ap_mdev_unset_kvm(matrix_mdev);
> >>   	list_del(&matrix_mdev->node);
> >>   	kfree(matrix_mdev);  
> > Are we at risk of handle_pqap() in arch/s390/kvm/priv.c using an
> > already freed pqap_hook (which is a member of the matrix_mdev pointee
> > that is freed just above my comment).
> >
> > I'm aware of the fact that vfio_ap_mdev_unset_kvm() does a
> > matrix_mdev->kvm->arch.crypto.pqap_hook = NULL but that is
> > AFRICT not done under any lock relevant for handle_pqap(). I guess
> > the idea is, I guess, the check cited below
> >
> > static int handle_pqap(struct kvm_vcpu *vcpu)
> > [..]
> >          /*
> >           * Verify that the hook callback is registered, lock the owner
> >           * and call the hook.
> >           */
> >          if (vcpu->kvm->arch.crypto.pqap_hook) {
> >                  if (!try_module_get(vcpu->kvm->arch.crypto.pqap_hook->owner))
> >                          return -EOPNOTSUPP;
> >                  ret = vcpu->kvm->arch.crypto.pqap_hook->hook(vcpu);
> >                  module_put(vcpu->kvm->arch.crypto.pqap_hook->owner);
> >                  if (!ret && vcpu->run->s.regs.gprs[1] & 0x00ff0000)
> >                          kvm_s390_set_psw_cc(vcpu, 3);
> >                  return ret;
> >          }
> >
> > is going to catch it, but I'm not sure it is guaranteed to catch it.
> > Opinions?  
> 
> The hook itself - handle_pqap() function in vfio_ap_ops.c - also checks
> to see if the reference to the hook is set and terminates with an error 
> if it
> is not. If the hook is invoked subsequent to the remove callback above,
> all should be fine since the check is also done under the matrix_dev->lock.
> 

I don't quite understand your logic. Let us assume matrix_mdev was freed,
but vcpu->kvm->arch.crypto.pqap_hook still points to what used to be
(*matrix_mdev).pqap_hook. In that case the function pointer
vcpu->kvm->arch.crypto.pqap_hook->hook is used after it was freed, and
may not point to the handle_pqap() function in vfio_ap_ops.c, thus the
check you are referring to ain't necessarily relevant. Than is
if you mean the check in the  handle_pqap() function in vfio_ap_ops.c; if
you mean the check in handle_pqap() in arch/s390/kvm/priv.c, that one is
not done under the matrix_dev->lock. Or do I have a hole somewhere in my
reasoning?

Regards,
Halil

