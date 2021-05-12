Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E804437ED81
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 00:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345937AbhELUhY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 16:37:24 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36960 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1356720AbhELSg4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 14:36:56 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14CIYWnH125672;
        Wed, 12 May 2021 14:35:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=qiIPM4jFYVlQa2wBPzrk+yQsKPL4bBQC7RNPW3MJnVg=;
 b=Ccn2Q+R+Eo5Hiuilhdbg1De7n0YWCZfEJUOhfXXjKUBmMR4u950309IU6B3b0iS5uLlO
 kS7cIhB9Fa42PdnYR0kpsWenMCVtDhXzXOWgR2Rcl2KcjGTiAsfJaNKdwGWx99u8WdIm
 6uuJgffhgJN3bbhgvOvZ4qexfDFcATKkIAg1ORsd55z49E1GRrfvC3ronkJz7+/0IW+O
 gNEhskMA1hUF17zYNpbgpuWOujptFLwk5/1II9cAHQd80LW8IruJtjz+Li/CoEdlkW4S
 BmoFBacCFoFnndLLXHVyKnrK+BPbmwr+u/Ajv/vi7PB490R8M57OBUI3DIMWsU9udOst iA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38gkcn1scb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 May 2021 14:35:45 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14CIYXfr125804;
        Wed, 12 May 2021 14:35:44 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38gkcn1sbr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 May 2021 14:35:44 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14CIT6GN027359;
        Wed, 12 May 2021 18:35:42 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 38ef37h33p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 May 2021 18:35:42 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14CIZdOi2753178
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 May 2021 18:35:39 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 64C37A4040;
        Wed, 12 May 2021 18:35:39 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 89752A4051;
        Wed, 12 May 2021 18:35:38 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.63.111])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Wed, 12 May 2021 18:35:38 +0000 (GMT)
Date:   Wed, 12 May 2021 20:35:36 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        pasic@linux.vnet.ibm.com, jjherne@linux.ibm.com, jgg@nvidia.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        stable@vger.kernel.org, Tony Krowiak <akrowiak@stny.rr.com>
Subject: Re: [PATCH v2] s390/vfio-ap: fix memory leak in mdev remove
 callback
Message-ID: <20210512203536.4209c29c.pasic@linux.ibm.com>
In-Reply-To: <20210510214837.359717-1-akrowiak@linux.ibm.com>
References: <20210510214837.359717-1-akrowiak@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: aoiz9GkGwDh40YfM0LFgbl2fYmQg0rU4
X-Proofpoint-ORIG-GUID: 4B3MDJ4aV-8tuyS6Gt7ZsQGH332RzLe_
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-12_09:2021-05-12,2021-05-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 mlxscore=0
 malwarescore=0 impostorscore=0 priorityscore=1501 adultscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 spamscore=0 lowpriorityscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105120120
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 10 May 2021 17:48:37 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> The mdev remove callback for the vfio_ap device driver bails out with
> -EBUSY if the mdev is in use by a KVM guest. The intended purpose was
> to prevent the mdev from being removed while in use; however, returning a
> non-zero rc does not prevent removal. This could result in a memory leak
> of the resources allocated when the mdev was created. In addition, the
> KVM guest will still have access to the AP devices assigned to the mdev
> even though the mdev no longer exists.
> 
> To prevent this scenario, cleanup will be done - including unplugging the
> AP adapters, domains and control domains - regardless of whether the mdev
> is in use by a KVM guest or not.
> 
> Fixes: 258287c994de ("s390: vfio-ap: implement mediated device open callback")
> Cc: stable@vger.kernel.org
> Signed-off-by: Tony Krowiak <akrowiak@stny.rr.com>
> ---
>  drivers/s390/crypto/vfio_ap_ops.c | 13 ++-----------
>  1 file changed, 2 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index b2c7e10dfdcd..f90c9103dac2 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -26,6 +26,7 @@
> 
>  static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev);
>  static struct vfio_ap_queue *vfio_ap_find_queue(int apqn);
> +static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev);
> 
>  static int match_apqn(struct device *dev, const void *data)
>  {
> @@ -366,17 +367,7 @@ static int vfio_ap_mdev_remove(struct mdev_device *mdev)
>  	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
> 
>  	mutex_lock(&matrix_dev->lock);
> -
> -	/*
> -	 * If the KVM pointer is in flux or the guest is running, disallow
> -	 * un-assignment of control domain.
> -	 */
> -	if (matrix_mdev->kvm_busy || matrix_mdev->kvm) {
> -		mutex_unlock(&matrix_dev->lock);
> -		return -EBUSY;
> -	}
> -
> -	vfio_ap_mdev_reset_queues(mdev);
> +	vfio_ap_mdev_unset_kvm(matrix_mdev);

>  	list_del(&matrix_mdev->node);
>  	kfree(matrix_mdev);

Are we at risk of handle_pqap() in arch/s390/kvm/priv.c using an
already freed pqap_hook (which is a member of the matrix_mdev pointee
that is freed just above my comment).

I'm aware of the fact that vfio_ap_mdev_unset_kvm() does a
matrix_mdev->kvm->arch.crypto.pqap_hook = NULL but that is
AFRICT not done under any lock relevant for handle_pqap(). I guess
the idea is, I guess, the check cited below 

static int handle_pqap(struct kvm_vcpu *vcpu)
[..]
        /*                                                                      
         * Verify that the hook callback is registered, lock the owner          
         * and call the hook.                                                   
         */                                                                     
        if (vcpu->kvm->arch.crypto.pqap_hook) {                                 
                if (!try_module_get(vcpu->kvm->arch.crypto.pqap_hook->owner))   
                        return -EOPNOTSUPP;                                     
                ret = vcpu->kvm->arch.crypto.pqap_hook->hook(vcpu);             
                module_put(vcpu->kvm->arch.crypto.pqap_hook->owner);            
                if (!ret && vcpu->run->s.regs.gprs[1] & 0x00ff0000)             
                        kvm_s390_set_psw_cc(vcpu, 3);                           
                return ret;                                                     
        }

is going to catch it, but I'm not sure it is guaranteed to catch it.
Opinions?

Regards,
Halil


>  	mdev_set_drvdata(mdev, NULL);

