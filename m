Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE6F8322813
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 10:54:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232113AbhBWJvT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 04:51:19 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:61624 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231944AbhBWJtN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Feb 2021 04:49:13 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11N9Y7rJ066210;
        Tue, 23 Feb 2021 04:48:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=CNh+Qi5+6FfU2MT5IAkTZy4w15teQtMhWGVk4aN2qRI=;
 b=WrMOSBI908SocpUJ35XR8aR7UplRTp+dlvEXtRl0kjqrliPPfEVF2mjpryIV4kkjhktI
 qnx+4e3Xq6qKyIYyjGRk5w9Cd81WFCDkA8cVnvtuFzDKNTdzybGdqYxd3b9gNRkP1jEm
 K7mz4il8WiAVPKQhjQy5euOWWZ/q6LLYyBhZRr4srpEuZGd9ZfmGQUQWCz1obm+lfRzn
 j2S3oWoMwz/U6pKp9XsmIQDkF5E1PFaFb2ngTHp4pTjfc8sRJEr13+BmX2rFccWqj9Xp
 tytmP4tFWsDEWOu62KKaM7QUKozTKOajziGPqUdZ6qTsEJhtmLpEgoE3NV2DBPvE/Po0 xQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36vkmy92ja-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Feb 2021 04:48:24 -0500
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 11N9aS9s072130;
        Tue, 23 Feb 2021 04:48:24 -0500
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36vkmy92hn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Feb 2021 04:48:24 -0500
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11N9gWgm006346;
        Tue, 23 Feb 2021 09:48:22 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 36tt2899mg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Feb 2021 09:48:22 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11N9m68534275590
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 09:48:06 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 325BDA405B;
        Tue, 23 Feb 2021 09:48:19 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E99BA405C;
        Tue, 23 Feb 2021 09:48:18 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.41.180])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Tue, 23 Feb 2021 09:48:18 +0000 (GMT)
Date:   Tue, 23 Feb 2021 10:48:05 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, stable@vger.kernel.org,
        borntraeger@de.ibm.com, cohuck@redhat.com, kwankhede@nvidia.com,
        pbonzini@redhat.com, alex.williamson@redhat.com,
        pasic@linux.vnet.ibm.com
Subject: Re: [PATCH v2 1/1] s390/vfio-ap: fix circular lockdep when
 setting/clearing crypto masks
Message-ID: <20210223104805.6a8d1872.pasic@linux.ibm.com>
In-Reply-To: <20210216011547.22277-2-akrowiak@linux.ibm.com>
References: <20210216011547.22277-1-akrowiak@linux.ibm.com>
        <20210216011547.22277-2-akrowiak@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-23_04:2021-02-22,2021-02-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 impostorscore=0
 mlxscore=0 phishscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2102230077
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 15 Feb 2021 20:15:47 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> This patch fixes a circular locking dependency in the CI introduced by
> commit f21916ec4826 ("s390/vfio-ap: clean up vfio_ap resources when KVM
> pointer invalidated"). The lockdep only occurs when starting a Secure
> Execution guest. Crypto virtualization (vfio_ap) is not yet supported for
> SE guests; however, in order to avoid CI errors, this fix is being
> provided.
> 
> The circular lockdep was introduced when the masks in the guest's APCB
> were taken under the matrix_dev->lock. While the lock is definitely
> needed to protect the setting/unsetting of the KVM pointer, it is not
> necessarily critical for setting the masks, so this will not be done under
> protection of the matrix_dev->lock.



With the one little thing I commented on below addressed: 
Acked-by: Halil Pasic <pasic@linux.ibm.com>  

This solution probably ain't a perfect one, but can't say I see a simple
way to get around this problem. For instance I played with the thought of
taking locks in a different order and keeping the critical sections
intact, but that has problems of its own. Tony should have the best
understanding of vfio_ap anyway.

In theory the execution of vfio_ap_mdev_group_notifier() and
vfio_ap_mdev_release() could interleave, and we could loose a clear because
in theory some permutations of the critical sections need to be
considered. In practice I hope that won't happen with QEMU.

Tony, you gave this a decent amount of testing or? 

I think we should move forward with this. Any objections? 
> 
> Fixes: f21916ec4826 ("s390/vfio-ap: clean up vfio_ap resources when KVM pointer invalidated")
> Cc: stable@vger.kernel.org
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>  drivers/s390/crypto/vfio_ap_ops.c | 119 +++++++++++++++++++++---------
>  1 file changed, 84 insertions(+), 35 deletions(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index 41fc2e4135fe..8574b6ecc9c5 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -1027,8 +1027,21 @@ static const struct attribute_group *vfio_ap_mdev_attr_groups[] = {
>   * @matrix_mdev: a mediated matrix device
>   * @kvm: reference to KVM instance
>   *
> - * Verifies no other mediated matrix device has @kvm and sets a reference to
> - * it in @matrix_mdev->kvm.
> + * Sets all data for @matrix_mdev that are needed to manage AP resources
> + * for the guest whose state is represented by @kvm:
> + * 1. Verifies no other mediated device has a reference to @kvm.
> + * 2. Increments the ref count for @kvm so it doesn't disappear until the
> + *    vfio_ap driver is notified the pointer is being nullified.
> + * 3. Sets a reference to the PQAP hook (i.e., handle_pqap() function) into
> + *    @kvm to handle interception of the PQAP(AQIC) instruction.
> + * 4. Sets the masks supplying the AP configuration to the KVM guest.
> + * 5. Sets the KVM pointer into @kvm so the vfio_ap driver can access it.
> + *

Could for example a PQAP AQIC run across an unset matrix_mdev->kvm like
this, in theory? I don't think it's likely to happen in the wild though.
Why not set it up before setting the mask?

> + * Note: The matrix_dev->lock must be taken prior to calling
> + * this function; however, the lock will be temporarily released to avoid a
> + * potential circular lock dependency with other asynchronous processes that
> + * lock the kvm->lock mutex which is also needed to supply the guest's AP
> + * configuration.
>   *
>   * Return 0 if no other mediated matrix device has a reference to @kvm;
>   * otherwise, returns an -EPERM.
> @@ -1043,9 +1056,17 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
>  			return -EPERM;
>  	}
>  
> -	matrix_mdev->kvm = kvm;
> -	kvm_get_kvm(kvm);
> -	kvm->arch.crypto.pqap_hook = &matrix_mdev->pqap_hook;
> +	if (kvm->arch.crypto.crycbd) {
> +		kvm_get_kvm(kvm);
> +		kvm->arch.crypto.pqap_hook = &matrix_mdev->pqap_hook;
> +		mutex_unlock(&matrix_dev->lock);
> +		kvm_arch_crypto_set_masks(kvm,
> +					  matrix_mdev->matrix.apm,
> +					  matrix_mdev->matrix.aqm,
> +					  matrix_mdev->matrix.adm);
> +		mutex_lock(&matrix_dev->lock);
> +		matrix_mdev->kvm = kvm;
> +	}
>  
>  	return 0;
>  }
> @@ -1079,51 +1100,80 @@ static int vfio_ap_mdev_iommu_notifier(struct notifier_block *nb,
>  	return NOTIFY_DONE;
>  }
>  
> +/**
> + * vfio_ap_mdev_unset_kvm
> + *
> + * @matrix_mdev: a matrix mediated device
> + *
> + * Performs clean-up of resources no longer needed by @matrix_mdev.
> + *
> + * Note: The matrix_dev->lock must be taken prior to calling this
> + * function; however,  the lock will be temporarily released to avoid a
> + * potential circular lock dependency with other asynchronous processes that
> + * lock the kvm->lock mutex which is also needed to update the guest's AP
> + * configuration as follows:
> + *	1.  Grab a reference to the KVM pointer stored in @matrix_mdev.
> + *	2.  Set the KVM pointer in @matrix_mdev to NULL so no other asynchronous
> + *	    process uses it (e.g., assign_adapter store function) after
> + *	    unlocking the matrix_dev->lock mutex.
> + *	3.  Set the PQAP hook to NULL so it will not be invoked after unlocking
> + *	    the matrix_dev->lock mutex.
> + *	4.  Unlock the matrix_dev->lock mutex to avoid circular lock
> + *	    dependencies.
> + *	5.  Clear the masks in the guest's APCB to remove guest access to AP
> + *	    resources assigned to @matrix_mdev.
> + *	6.  Lock the matrix_dev->lock mutex to prevent access to resources
> + *	    assigned to @matrix_mdev while the remainder of the cleanup
> + *	    operations take place.
> + *	7.  Decrement the reference counter incremented in #1.
> + *	8.  Set the reference to the KVM pointer grabbed in #1 into @matrix_mdev
> + *	    (set to NULL in #2) because it will be needed when the queues are
> + *	    reset to clean up any IRQ resources being held.
> + *	9.  Decrement the reference count that was incremented when the KVM
> + *	    pointer was originally set by the group notifier.
> + *	10. Set the KVM pointer @matrix_mdev to NULL to prevent its usage from
> + *	    here on out.
> + *
> + */
>  static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev)
>  {
> -	kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
> -	matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
> -	vfio_ap_mdev_reset_queues(matrix_mdev->mdev);
> -	kvm_put_kvm(matrix_mdev->kvm);
> -	matrix_mdev->kvm = NULL;
> +	struct kvm *kvm;
> +
> +	if (matrix_mdev->kvm) {
> +		kvm = matrix_mdev->kvm;
> +		kvm_get_kvm(kvm);
> +		matrix_mdev->kvm = NULL;

I think if there were two threads dong the unset in parallel, one
of them could bail out and carry on before the cleanup is done. But
since nothing much happens in release after that, I don't see an
immediate problem.

Another thing to consider is, that setting ->kvm to NULL arms
vfio_ap_mdev_remove()...

> +		kvm->arch.crypto.pqap_hook = NULL;
> +		mutex_unlock(&matrix_dev->lock);
> +		kvm_arch_crypto_clear_masks(kvm);
> +		mutex_lock(&matrix_dev->lock);
> +		kvm_put_kvm(kvm);
> +		matrix_mdev->kvm = kvm;
> +		vfio_ap_mdev_reset_queues(matrix_mdev->mdev);
> +		kvm_put_kvm(matrix_mdev->kvm);
> +		matrix_mdev->kvm = NULL;
> +	}
>  }
>  
>  static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
>  				       unsigned long action, void *data)
>  {
> -	int ret, notify_rc = NOTIFY_OK;
> +	int notify_rc = NOTIFY_OK;
>  	struct ap_matrix_mdev *matrix_mdev;
>  
>  	if (action != VFIO_GROUP_NOTIFY_SET_KVM)
>  		return NOTIFY_OK;
>  
> -	matrix_mdev = container_of(nb, struct ap_matrix_mdev, group_notifier);
>  	mutex_lock(&matrix_dev->lock);
> +	matrix_mdev = container_of(nb, struct ap_matrix_mdev, group_notifier);
>  
> -	if (!data) {
> -		if (matrix_mdev->kvm)
> -			vfio_ap_mdev_unset_kvm(matrix_mdev);
> -		goto notify_done;
> -	}
> -
> -	ret = vfio_ap_mdev_set_kvm(matrix_mdev, data);
> -	if (ret) {
> -		notify_rc = NOTIFY_DONE;
> -		goto notify_done;
> -	}
> -
> -	/* If there is no CRYCB pointer, then we can't copy the masks */
> -	if (!matrix_mdev->kvm->arch.crypto.crycbd) {
> +	if (!data)
> +		vfio_ap_mdev_unset_kvm(matrix_mdev);
> +	else if (vfio_ap_mdev_set_kvm(matrix_mdev, data))
>  		notify_rc = NOTIFY_DONE;
> -		goto notify_done;
> -	}
> -
> -	kvm_arch_crypto_set_masks(matrix_mdev->kvm, matrix_mdev->matrix.apm,
> -				  matrix_mdev->matrix.aqm,
> -				  matrix_mdev->matrix.adm);
>  
> -notify_done:
>  	mutex_unlock(&matrix_dev->lock);
> +
>  	return notify_rc;
>  }
>  
> @@ -1258,8 +1308,7 @@ static void vfio_ap_mdev_release(struct mdev_device *mdev)
>  	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
>  
>  	mutex_lock(&matrix_dev->lock);
> -	if (matrix_mdev->kvm)
> -		vfio_ap_mdev_unset_kvm(matrix_mdev);
> +	vfio_ap_mdev_unset_kvm(matrix_mdev);
>  	mutex_unlock(&matrix_dev->lock);
>  
>  	vfio_unregister_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,

