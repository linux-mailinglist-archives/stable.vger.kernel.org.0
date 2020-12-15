Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 153E52DAB8C
	for <lists+stable@lfdr.de>; Tue, 15 Dec 2020 11:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727167AbgLOK6r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Dec 2020 05:58:47 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31078 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726176AbgLOK6i (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Dec 2020 05:58:38 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BFAhbM7141092;
        Tue, 15 Dec 2020 05:57:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=aa9bPLEEN9oj8LamcU1uG5Yg95iXunxd/TiiwWqS86o=;
 b=AwexOlol+P0GRP4hldGfwRBpovsKZbsORfIfqAUMlSFanQcdkS9cYZnKR8I1B8JBcPAA
 DUnhZat543Ci/BWrm8IrwS83MPPtSUVSUzxMQAtJscnhGu05qkBgcm1HoHK7aF7GNVKu
 PSVmfByteDweok1+wiwRzwh5Mr5z3jmmo/3v4qGEdXQxVGhLFQ3czRAnxXX941nv6wZQ
 tVH3v15V8nKoHkzR6cWoG15z2vk82QvtNLH4sncSg4qFbOQILD1K2N1b/ve2prTdb6F4
 GhoFdfiww93tdzPu6f5MV8TlJOw3G9y3tUyFRdQnSNbuwWjv0zRuEY1FP9SqvDUllA6h 0g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35eumx0bf1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Dec 2020 05:57:54 -0500
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BFAsmpo182207;
        Tue, 15 Dec 2020 05:57:53 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35eumx0beg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Dec 2020 05:57:53 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BFAvq2d025171;
        Tue, 15 Dec 2020 10:57:52 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 35cng8b4sv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Dec 2020 10:57:52 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BFAvniw61342140
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Dec 2020 10:57:49 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EF9BF11C04C;
        Tue, 15 Dec 2020 10:57:48 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3270311C052;
        Tue, 15 Dec 2020 10:57:48 +0000 (GMT)
Received: from oc2783563651 (unknown [9.171.86.205])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Tue, 15 Dec 2020 10:57:48 +0000 (GMT)
Date:   Tue, 15 Dec 2020 11:57:46 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, stable@vger.kernel.org,
        gregkh@linuxfoundation.org, sashal@kernel.org,
        borntraeger@de.ibm.com, cohuck@redhat.com, kwankhede@nvidia.com,
        pbonzini@redhat.com, alex.williamson@redhat.com,
        pasic@linux.vnet.ibm.com
Subject: Re: [PATCH v3] s390/vfio-ap: clean up vfio_ap resources when KVM
 pointer invalidated
Message-ID: <20201215115746.3552e873.pasic@linux.ibm.com>
In-Reply-To: <20201214165617.28685-1-akrowiak@linux.ibm.com>
References: <20201214165617.28685-1-akrowiak@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-15_08:2020-12-14,2020-12-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 malwarescore=0 priorityscore=1501 suspectscore=0
 mlxscore=0 spamscore=0 impostorscore=0 clxscore=1011 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012150070
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 14 Dec 2020 11:56:17 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> The vfio_ap device driver registers a group notifier with VFIO when the
> file descriptor for a VFIO mediated device for a KVM guest is opened to
> receive notification that the KVM pointer is set (VFIO_GROUP_NOTIFY_SET_KVM
> event). When the KVM pointer is set, the vfio_ap driver takes the
> following actions:
> 1. Stashes the KVM pointer in the vfio_ap_mdev struct that holds the state
>    of the mediated device.
> 2. Calls the kvm_get_kvm() function to increment its reference counter.
> 3. Sets the function pointer to the function that handles interception of
>    the instruction that enables/disables interrupt processing.
> 4. Sets the masks in the KVM guest's CRYCB to pass AP resources through to
>    the guest.
> 
> In order to avoid memory leaks, when the notifier is called to receive
> notification that the KVM pointer has been set to NULL, the vfio_ap device
> driver should reverse the actions taken when the KVM pointer was set.
> 
> Fixes: 258287c994de ("s390: vfio-ap: implement mediated device open callback")
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>  drivers/s390/crypto/vfio_ap_ops.c | 29 ++++++++++++++++++++---------
>  1 file changed, 20 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index e0bde8518745..cd22e85588e1 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -1037,8 +1037,6 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
>  {
>  	struct ap_matrix_mdev *m;
> 
> -	mutex_lock(&matrix_dev->lock);
> -
>  	list_for_each_entry(m, &matrix_dev->mdev_list, node) {
>  		if ((m != matrix_mdev) && (m->kvm == kvm)) {
>  			mutex_unlock(&matrix_dev->lock);
> @@ -1049,7 +1047,6 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
>  	matrix_mdev->kvm = kvm;
>  	kvm_get_kvm(kvm);
>  	kvm->arch.crypto.pqap_hook = &matrix_mdev->pqap_hook;
> -	mutex_unlock(&matrix_dev->lock);
> 
>  	return 0;
>  }
> @@ -1083,35 +1080,49 @@ static int vfio_ap_mdev_iommu_notifier(struct notifier_block *nb,
>  	return NOTIFY_DONE;
>  }
> 
> +static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev)
> +{
> +	kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
> +	matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;


This patch LGTM. The only concern I have with it is whether a
different cpu is guaranteed to observe the above assignment as
an atomic operation. I think we didn't finish this discussion
at v1, or did we?

Regards,
Halil

> +	vfio_ap_mdev_reset_queues(matrix_mdev->mdev);
> +	kvm_put_kvm(matrix_mdev->kvm);
> +	matrix_mdev->kvm = NULL;
> +}
> +
>  static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
>  				       unsigned long action, void *data)
>  {
> -	int ret;
> +	int ret, notify_rc = NOTIFY_DONE;
>  	struct ap_matrix_mdev *matrix_mdev;
> 
>  	if (action != VFIO_GROUP_NOTIFY_SET_KVM)
>  		return NOTIFY_OK;
> 
>  	matrix_mdev = container_of(nb, struct ap_matrix_mdev, group_notifier);
> +	mutex_lock(&matrix_dev->lock);
> 
>  	if (!data) {
> -		matrix_mdev->kvm = NULL;
> -		return NOTIFY_OK;
> +		if (matrix_mdev->kvm)
> +			vfio_ap_mdev_unset_kvm(matrix_mdev);
> +		notify_rc = NOTIFY_OK;
> +		goto notify_done;
>  	}
> 
>  	ret = vfio_ap_mdev_set_kvm(matrix_mdev, data);
>  	if (ret)
> -		return NOTIFY_DONE;
> +		goto notify_done;
> 
>  	/* If there is no CRYCB pointer, then we can't copy the masks */
>  	if (!matrix_mdev->kvm->arch.crypto.crycbd)
> -		return NOTIFY_DONE;
> +		goto notify_done;
> 
>  	kvm_arch_crypto_set_masks(matrix_mdev->kvm, matrix_mdev->matrix.apm,
>  				  matrix_mdev->matrix.aqm,
>  				  matrix_mdev->matrix.adm);
> 
> -	return NOTIFY_OK;
> +notify_done:
> +	mutex_unlock(&matrix_dev->lock);
> +	return notify_rc;
>  }
> 
>  static void vfio_ap_irq_disable_apqn(int apqn)

