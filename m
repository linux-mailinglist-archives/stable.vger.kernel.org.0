Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7A7531905C
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 17:54:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231682AbhBKQux (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 11:50:53 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:5388 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231947AbhBKQsu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Feb 2021 11:48:50 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11BGYB8V135888;
        Thu, 11 Feb 2021 11:47:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=Aqmz4aQl7nkrALMRdUdLq/F8auLEY5n8P94aY02T45c=;
 b=m+uxjRhrfNPbgNmBVlmIOGzIeLGl6izrtUDDcRgnBoCaOkBfpBvv+ahCuKZupIYakPUw
 xWeFInFbXEhG9e+Mkxg65JtRT1JuSHbi9+ExlV7/lmhPgKWT/DXTDlMULbDx8bALfJlY
 uJtX6DldxNc+uzPiHuI0Xj5ua4DlVrVjt9feLokhpj8q2VUhs9f3M8F8OevE9dWIFWsb
 0NUslzRTSlPMOzuoEj+UV4ozpAMe6P2BSPeXAzUBNRANEjgG9/kGYOXmFlkfGvyKURB8
 KJiL4+FH6+UnkfSaviP/EWghqj3ScczJApNnJ6x8uMz9Ay8uALQ6oC2lGagwAX9ol8l2 BA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36n7wm1h7t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Feb 2021 11:47:59 -0500
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11BGZNQU146157;
        Thu, 11 Feb 2021 11:47:58 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36n7wm1h71-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Feb 2021 11:47:58 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11BGhNlm008187;
        Thu, 11 Feb 2021 16:47:57 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 36hjr8dya2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Feb 2021 16:47:56 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11BGlsbr32440596
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Feb 2021 16:47:54 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0ED66A405F;
        Thu, 11 Feb 2021 16:47:54 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 73DE0A4068;
        Thu, 11 Feb 2021 16:47:53 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.0.79])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Thu, 11 Feb 2021 16:47:53 +0000 (GMT)
Date:   Thu, 11 Feb 2021 17:47:50 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org, borntraeger@de.ibm.com,
        kwankhede@nvidia.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, pasic@linux.vnet.ibm.com
Subject: Re: [PATCH 1/1] s390/vfio-ap: fix circular lockdep when
 setting/clearing crypto masks
Message-ID: <20210211174750.24d91a65.pasic@linux.ibm.com>
In-Reply-To: <8c461602-8c2c-4dd9-1d2b-5e424fc701f8@linux.ibm.com>
References: <20210209194830.20271-1-akrowiak@linux.ibm.com>
        <20210209194830.20271-2-akrowiak@linux.ibm.com>
        <20210210115334.46635966.cohuck@redhat.com>
        <20210210162429.261fc17c.pasic@linux.ibm.com>
        <20210210163237.315d9a68.pasic@linux.ibm.com>
        <59e8f084-c9ec-ce25-2326-b206e30d04d0@linux.ibm.com>
        <20210210234606.1d0dbdec.pasic@linux.ibm.com>
        <8c461602-8c2c-4dd9-1d2b-5e424fc701f8@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-11_07:2021-02-11,2021-02-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 impostorscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 spamscore=0 phishscore=0 priorityscore=1501 clxscore=1015 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102110135
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 11 Feb 2021 09:21:26 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> Yes, it makes sense. I guess I didn't look closely at your
> suggestion when I said it was exactly what I implemented
> after agreeing with Connie. I had a slight difference in
> my implementation:
> 
> static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev)
> {
>      struct kvm *kvm;
> 
>      mutex_lock(&matrix_dev->lock);
> 
>      if (matrix_mdev->kvm) {
>          kvm = matrix_mdev->kvm;
>          mutex_unlock(&matrix_dev->lock);

The problem with this one is that as soon as we drop
the lock here, another thread can in theory execute
the critical section below, which drops our reference
to kvm via kvm_put_kvm(kvm). Thus when we enter
kvm_arch_crypto_clear_mask(), even if we are guaranteed
to have a non-null pointer, the pointee is not guaranteed
to be around. So like Connie suggested, you better take
another reference to kvm in the first critical section.

Regards,
Halil

>          kvm_arch_crypto_clear_masks(kvm);
>          mutex_lock(&matrix_dev->lock);
>          kvm->arch.crypto.pqap_hook = NULL;
>          vfio_ap_mdev_reset_queues(matrix_mdev->mdev);
>          matrix_mdev->kvm = NULL;
>          kvm_put_kvm(kvm);
>      }
> 
>      mutex_unlock(&matrix_dev->lock);
> }
