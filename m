Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8095316A15
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 16:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbhBJPZa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 10:25:30 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:20826 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231643AbhBJPZV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Feb 2021 10:25:21 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11AFBvDQ073293;
        Wed, 10 Feb 2021 10:24:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=YE4yzdTFr4qAlMkTbvSKj+np/7g7u8F/lfs8feNmmnE=;
 b=hIzvP7nvmJ+7w/MoBp8ZsKjtcO/iq7oJdHgqXU4faXJFNsi4RDJniSsv/EsXAyl+VGVd
 AzOIa2qewpe2ie8JCgN3nxyFv4iZrNs9pQbTNVMX8ynu1V4xhf3Apc07nantfuzc0/b6
 LPodDBZlap6OY3BHH/SGFaqUv8jr51DEydLFS/A25GSqKHXYhGEMfTst3DQiM3DIsGTK
 nYTcaUZF7vd7acl/KTMZHWRtpWYoLvp/5d4Q0XL5c9EvDsGEc0wCJQuqdow9tfAyurpy
 +H0sgPdJoU2e9R4Hjz5xW+ZtKCahbHcgqsIh768EGYi6qjhKCKChV+jxTcbf8e4dfuCq Ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36mhww0g7m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 10:24:37 -0500
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11AFBuJE073250;
        Wed, 10 Feb 2021 10:24:36 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36mhww0g6q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 10:24:36 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11AFCbM6031432;
        Wed, 10 Feb 2021 15:24:34 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 36m1m2s302-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 15:24:34 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11AFOLjV36831712
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 15:24:21 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE6C04204D;
        Wed, 10 Feb 2021 15:24:31 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 471D242042;
        Wed, 10 Feb 2021 15:24:31 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.25.242])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Wed, 10 Feb 2021 15:24:31 +0000 (GMT)
Date:   Wed, 10 Feb 2021 16:24:29 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org, borntraeger@de.ibm.com,
        kwankhede@nvidia.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, pasic@linux.vnet.ibm.com
Subject: Re: [PATCH 1/1] s390/vfio-ap: fix circular lockdep when
 setting/clearing crypto masks
Message-ID: <20210210162429.261fc17c.pasic@linux.ibm.com>
In-Reply-To: <20210210115334.46635966.cohuck@redhat.com>
References: <20210209194830.20271-1-akrowiak@linux.ibm.com>
        <20210209194830.20271-2-akrowiak@linux.ibm.com>
        <20210210115334.46635966.cohuck@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-10_05:2021-02-10,2021-02-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 phishscore=0 priorityscore=1501
 clxscore=1015 malwarescore=0 lowpriorityscore=0 bulkscore=0 adultscore=0
 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102100140
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 10 Feb 2021 11:53:34 +0100
Cornelia Huck <cohuck@redhat.com> wrote:

> On Tue,  9 Feb 2021 14:48:30 -0500
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> 
> > This patch fixes a circular locking dependency in the CI introduced by
> > commit f21916ec4826 ("s390/vfio-ap: clean up vfio_ap resources when KVM
> > pointer invalidated"). The lockdep only occurs when starting a Secure
> > Execution guest. Crypto virtualization (vfio_ap) is not yet supported for
> > SE guests; however, in order to avoid CI errors, this fix is being
> > provided.
> > 
> > The circular lockdep was introduced when the masks in the guest's APCB
> > were taken under the matrix_dev->lock. While the lock is definitely
> > needed to protect the setting/unsetting of the KVM pointer, it is not
> > necessarily critical for setting the masks, so this will not be done under
> > protection of the matrix_dev->lock.
> > 
> > Fixes: f21916ec4826 ("s390/vfio-ap: clean up vfio_ap resources when KVM pointer invalidated")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> > ---
> >  drivers/s390/crypto/vfio_ap_ops.c | 75 ++++++++++++++++++-------------
> >  1 file changed, 45 insertions(+), 30 deletions(-)
> >   
> 
> >  static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev)
> >  {
> > -	kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
> > -	matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
> > -	vfio_ap_mdev_reset_queues(matrix_mdev->mdev);
> > -	kvm_put_kvm(matrix_mdev->kvm);
> > -	matrix_mdev->kvm = NULL;
> > +	if (matrix_mdev->kvm) {  
> 
> If you're doing setting/unsetting under matrix_dev->lock, is it
> possible that matrix_mdev->kvm gets unset between here and the next
> line, as you don't hold the lock?
> 
> Maybe you could
> - grab a reference to kvm while holding the lock
> - call the mask handling functions with that kvm reference
> - lock again, drop the reference, and do the rest of the processing?

I agree, matrix_mdev->kvm can go NULL any time and we are risking
a null pointer dereference here.

Another idea would be to do


static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev)           
{                                                                               
        struct kvm *kvm;
                                                        
        mutex_lock(&matrix_dev->lock);                                          
        if (matrix_mdev->kvm) {                                                 
                kvm = matrix_mdev->kvm;                                         
                matrix_mdev->kvm = NULL;                                        
                mutex_unlock(&matrix_dev->lock);                                
                kvm_arch_crypto_clear_masks(kvm);                               
                mutex_lock(&matrix_dev->lock);                                  
                matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;                 
                vfio_ap_mdev_reset_queues(matrix_mdev->mdev);                   
                kvm_put_kvm(kvm);                                               
        }                                                                       
        mutex_unlock(&matrix_dev->lock);                                         
}

That way only one unset would actually do the unset and cleanup
and every other invocation would bail out with only checking
matrix_mdev->kvm.

 
> > +		kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
> > +		mutex_lock(&matrix_dev->lock);
> > +		matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
> > +		vfio_ap_mdev_reset_queues(matrix_mdev->mdev);
> > +		kvm_put_kvm(matrix_mdev->kvm);
> > +		matrix_mdev->kvm = NULL;
> > +		mutex_unlock(&matrix_dev->lock);
> > +	}
> >  }  
> 

