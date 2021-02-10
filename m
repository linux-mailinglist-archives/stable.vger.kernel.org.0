Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECDB7316A45
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 16:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231987AbhBJPdj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 10:33:39 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:6308 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231956AbhBJPd3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Feb 2021 10:33:29 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11AFWUtr072292;
        Wed, 10 Feb 2021 10:32:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=SqdGVyl7AjCXGqLpQSkaMN00EiHDHpxxixI6SbJVxeI=;
 b=iJMGCju83X9cNXuVtwzBg3PWUAKx2HDd+3vx2t2Nd3OVZ9yTMPVBWawphxTs/beD103g
 58TK5cFHFAQGSxwwGQ6nuQN3GyY/wA12PY8YpIAx6kslVeRaTW1js4t1F518Pl3Fd8Vh
 ioO7QT+BTJ85J6LMauE4W89x0xxWSYWEmIDFFzW0EANjS09Ml5pCYyqk24tkdzBZP5F7
 557LycAJGyaXv0sg4hTvkhKuwOO/818/eEcPmsP/fG+UEYsjbpckHJcmVrhD5G7cCEb/
 osrLMysMyRzyuVfhHLRLrKHG4iiYy2scdxnydYqx5AbTdpOW1jDoRPWjQaP8qXpU4nrT Dw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36mj3xg8u0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 10:32:46 -0500
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11AFWjUC074637;
        Wed, 10 Feb 2021 10:32:45 -0500
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36mj3xg8rn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 10:32:45 -0500
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11AFSH4S007765;
        Wed, 10 Feb 2021 15:32:43 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 36hjr82jfg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 15:32:43 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11AFWUoO36634956
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 15:32:30 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7062AAE045;
        Wed, 10 Feb 2021 15:32:40 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BAD19AE051;
        Wed, 10 Feb 2021 15:32:39 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.25.242])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Wed, 10 Feb 2021 15:32:39 +0000 (GMT)
Date:   Wed, 10 Feb 2021 16:32:37 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org, borntraeger@de.ibm.com,
        kwankhede@nvidia.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, pasic@linux.vnet.ibm.com
Subject: Re: [PATCH 1/1] s390/vfio-ap: fix circular lockdep when
 setting/clearing crypto masks
Message-ID: <20210210163237.315d9a68.pasic@linux.ibm.com>
In-Reply-To: <20210210162429.261fc17c.pasic@linux.ibm.com>
References: <20210209194830.20271-1-akrowiak@linux.ibm.com>
        <20210209194830.20271-2-akrowiak@linux.ibm.com>
        <20210210115334.46635966.cohuck@redhat.com>
        <20210210162429.261fc17c.pasic@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-10_06:2021-02-10,2021-02-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 bulkscore=0
 phishscore=0 suspectscore=0 lowpriorityscore=0 mlxscore=0 impostorscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102100145
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 10 Feb 2021 16:24:29 +0100
Halil Pasic <pasic@linux.ibm.com> wrote:

> > Maybe you could
> > - grab a reference to kvm while holding the lock
> > - call the mask handling functions with that kvm reference
> > - lock again, drop the reference, and do the rest of the processing?  
> 
> I agree, matrix_mdev->kvm can go NULL any time and we are risking
> a null pointer dereference here.
> 
> Another idea would be to do
> 
> 
> static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev)           
> {                                                                               
>         struct kvm *kvm;
>                                                         
>         mutex_lock(&matrix_dev->lock);                                          
>         if (matrix_mdev->kvm) {                                                 
>                 kvm = matrix_mdev->kvm;                                         
>                 matrix_mdev->kvm = NULL;                                        
>                 mutex_unlock(&matrix_dev->lock);                                
>                 kvm_arch_crypto_clear_masks(kvm);                               
>                 mutex_lock(&matrix_dev->lock);                                  
>                 matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
s/matrix_mdev->kvm/kvm
>                 vfio_ap_mdev_reset_queues(matrix_mdev->mdev);                   
>                 kvm_put_kvm(kvm);                                               
>         }                                                                       
>         mutex_unlock(&matrix_dev->lock);                                         
> }
> 
> That way only one unset would actually do the unset and cleanup
> and every other invocation would bail out with only checking
> matrix_mdev->kvm.

But the problem with that is that we enable the the assign/unassign
prematurely, which could interfere wit reset_queues(). Forget about
it.
