Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE408324F38
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 12:31:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235784AbhBYL3r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 06:29:47 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34936 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235785AbhBYL3T (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Feb 2021 06:29:19 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11PB3I0g032389;
        Thu, 25 Feb 2021 06:28:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=qBoyYnHcCJqYWt10koSEmKWz4/PiSuY2+a7Z/gaa+lc=;
 b=MmdHCTuGrv6/gNTQceCmdAti2TfQp7HvWaBaus51e0yL0l3p1kL2HQAtyP5o9Xdgv8I3
 BblM7nc6ymPePZ8tOMheMSAW6+DgM/O7kKCO+E6cf48mmbD4n+zmlS+R0taCCD+rTcQ2
 nogzVNsWcvHv8Gw/mEbkpgIHpm7eUjDHQpACDP2mQ0GIS3E2o7eQbmlZUnoWDiBoVvEd
 J9LuuS2s9kXPUcjxrjE/ozFmyX/J5TZh2NbT3EKUmBI+SvgIDk3P0ZU5YqkeIDaDWKON
 TzlkgPN0bJm2PFM/VC6sUDWNsbr7M94hCGAWFXjEC/14oJDV1fu+Nhiw5cq33a0QuRYX XA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36x0qrrmu5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Feb 2021 06:28:33 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 11PB46OM036238;
        Thu, 25 Feb 2021 06:28:33 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36x0qrrmtc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Feb 2021 06:28:32 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11PBMZTi019320;
        Thu, 25 Feb 2021 11:28:30 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 36tsph4ctb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Feb 2021 11:28:30 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11PBSRV338994306
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Feb 2021 11:28:27 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 883EC42042;
        Thu, 25 Feb 2021 11:28:27 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C49004203F;
        Thu, 25 Feb 2021 11:28:26 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.33.39])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Thu, 25 Feb 2021 11:28:26 +0000 (GMT)
Date:   Thu, 25 Feb 2021 12:28:24 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, stable@vger.kernel.org,
        borntraeger@de.ibm.com, cohuck@redhat.com, kwankhede@nvidia.com,
        pbonzini@redhat.com, alex.williamson@redhat.com,
        pasic@linux.vnet.ibm.com
Subject: Re: [PATCH v2 1/1] s390/vfio-ap: fix circular lockdep when
 setting/clearing crypto masks
Message-ID: <20210225122824.467b8ed9.pasic@linux.ibm.com>
In-Reply-To: <63bb0d61-efcd-315b-5a1a-0ef4d99600f4@linux.ibm.com>
References: <20210216011547.22277-1-akrowiak@linux.ibm.com>
        <20210216011547.22277-2-akrowiak@linux.ibm.com>
        <20210223104805.6a8d1872.pasic@linux.ibm.com>
        <63bb0d61-efcd-315b-5a1a-0ef4d99600f4@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-25_06:2021-02-24,2021-02-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 malwarescore=0 priorityscore=1501 spamscore=0 clxscore=1015 phishscore=0
 suspectscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102250087
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 24 Feb 2021 22:28:50 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> >>   static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev)
> >>   {
> >> -	kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
> >> -	matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
> >> -	vfio_ap_mdev_reset_queues(matrix_mdev->mdev);
> >> -	kvm_put_kvm(matrix_mdev->kvm);
> >> -	matrix_mdev->kvm = NULL;
> >> +	struct kvm *kvm;
> >> +
> >> +	if (matrix_mdev->kvm) {
> >> +		kvm = matrix_mdev->kvm;
> >> +		kvm_get_kvm(kvm);
> >> +		matrix_mdev->kvm = NULL;  
> > I think if there were two threads dong the unset in parallel, one
> > of them could bail out and carry on before the cleanup is done. But
> > since nothing much happens in release after that, I don't see an
> > immediate problem.
> >
> > Another thing to consider is, that setting ->kvm to NULL arms
> > vfio_ap_mdev_remove()...  
> 
> I'm not entirely sure what you mean by this, but my
> assumption is that you are talking about the check
> for matrix_mdev->kvm != NULL at the start of
> that function. 

Yes I was talking about the check

static int vfio_ap_mdev_remove(struct mdev_device *mdev)                        
{                                                                               
        struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);            
                                                                                
        if (matrix_mdev->kvm)                                                   
                return -EBUSY;
...
        kfree(matrix_mdev);                                                     
...                                                               
} 

As you see, we bail out if kvm is still set, otherwise we clean up the
matrix_mdev which includes kfree-ing it. And vfio_ap_mdev_remove() is
initiated via the sysfs, i.e. can be initiated at any time. If we were
to free matrix_mdev in mdev_remove() and then carry on with kvm_unset()
with mutex_lock(&matrix_dev->lock); that would be bad.



> The reason
> matrix_mdev->kvm is set to NULL before giving up
> the matrix_dev->lock is so that functions that check
> for the presence of the matrix_mdev->kvm pointer,
> such as assign_adapter_store() - will exit if they get
> control while the masks are being cleared. 

I disagree!

static ssize_t assign_adapter_store(struct device *dev,                         
                                    struct device_attribute *attr,              
                                    const char *buf, size_t count)              
{                                                                               
        int ret;                                                                
        unsigned long apid;                                                     
        struct mdev_device *mdev = mdev_from_dev(dev);                          
        struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);            
                                                                                
        /* If the guest is running, disallow assignment of adapter */           
        if (matrix_mdev->kvm)                                                   
                return -EBUSY;

We bail out when kvm != NULL, so having it set to NULL while the
mask are being cleared will make these not bail out.

> So what we have
> here is a catch-22; in other words, we have the case
> you pointed out above and the cases related to
> assigning/unassigning adapters, domains and
> control domains which should exit when a guest
> is running.


See above.

> 
> I may have an idea to resolve this. Suppose we add:
> 
> struct ap_matrix_mdev {
>      ...
>      bool kvm_busy;
>      ...
> }
> 
> This flag will be set to true at the start of both the
> vfio_ap_mdev_set_kvm() and vfio_ap_mdev_unset_kvm()
> and set to false at the end. The assignment/unassignment
> and remove callback functions can test this flag and
> return -EBUSY if the flag is true. That will preclude assigning
> or unassigning adapters, domains and control domains when
> the KVM pointer is being set/unset. Likewise, removal of the
> mediated device will also be prevented while the KVM pointer
> is being set/unset.
> 
> In the case of the PQAP handler function, it can wait for the
> set/unset of the KVM pointer as follows:
> 
> /while (matrix_mdev->kvm_busy) {//
> //        mutex_unlock(&matrix_dev->lock);//
> //        msleep(100);//
> //        mutex_lock(&matrix_dev->lock);//
> //}//
> //
> //if (!matrix_mdev->kvm)//
> //        goto out_unlock;
> 
> /What say you?
> //

I'm not sure. Since I disagree with your analysis above it is difficult
to deal with the conclusion. I'm not against decoupling the tracking of
the state of the mdev_matrix device from the value of the kvm pointer. I
think we should first get a common understanding of the problem, before
we proceed to the solution.

Regards,
Halil
