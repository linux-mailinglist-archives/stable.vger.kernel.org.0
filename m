Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 400243173A4
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 23:47:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233577AbhBJWrA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 17:47:00 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:18636 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230229AbhBJWqz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Feb 2021 17:46:55 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11AMXjer098838;
        Wed, 10 Feb 2021 17:46:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=2au3AMlluLBKkZoOsIbltg1hE/3YCbFNe5zqqSQHIEw=;
 b=SoAL3mc5VEfpYOqe66662HPIN136MUF6VwvrxVFjYnHFGk8JoqH+JleCy/50x/cFJbJ1
 dfvlkt+LLIoKqmme7I1cc4DlW9CLVBVGAyLmkkPtSaVedqC6e7IuBtVha9l72R6eMmGi
 02WNTlZ4olvTN1m6VbyzO9BKnf23HvA/8O7h9Rlyepng36FQX8kWhDhExOOpAl6Z3PQo
 Wk7NtPOvjBUHTDW1D3R2PccqZ0s1VjRvBhFg2hDSOkYiSkT252QJ4bf4ZMvrDoVPm5tN
 4bWV4QuNcI3LahUXKFkgSq01CloED6qsSbXJDMMOX9y3IE1z0xlQRuwkyOA25I1K4vLZ zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36mqvm914a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 17:46:14 -0500
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11AMZ2qm106327;
        Wed, 10 Feb 2021 17:46:14 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36mqvm913s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 17:46:13 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11AMhfhJ011768;
        Wed, 10 Feb 2021 22:46:11 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 36j94wmf53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 22:46:11 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11AMk8AP41484686
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 22:46:08 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AA68E42066;
        Wed, 10 Feb 2021 22:46:08 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0936042067;
        Wed, 10 Feb 2021 22:46:08 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.25.242])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Wed, 10 Feb 2021 22:46:07 +0000 (GMT)
Date:   Wed, 10 Feb 2021 23:46:06 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org, borntraeger@de.ibm.com,
        kwankhede@nvidia.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, pasic@linux.vnet.ibm.com
Subject: Re: [PATCH 1/1] s390/vfio-ap: fix circular lockdep when
 setting/clearing crypto masks
Message-ID: <20210210234606.1d0dbdec.pasic@linux.ibm.com>
In-Reply-To: <59e8f084-c9ec-ce25-2326-b206e30d04d0@linux.ibm.com>
References: <20210209194830.20271-1-akrowiak@linux.ibm.com>
        <20210209194830.20271-2-akrowiak@linux.ibm.com>
        <20210210115334.46635966.cohuck@redhat.com>
        <20210210162429.261fc17c.pasic@linux.ibm.com>
        <20210210163237.315d9a68.pasic@linux.ibm.com>
        <59e8f084-c9ec-ce25-2326-b206e30d04d0@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-10_11:2021-02-10,2021-02-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 spamscore=0 adultscore=0 priorityscore=1501 mlxscore=0
 phishscore=0 suspectscore=0 impostorscore=0 mlxlogscore=999 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102100191
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 10 Feb 2021 17:05:48 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> On 2/10/21 10:32 AM, Halil Pasic wrote:
> > On Wed, 10 Feb 2021 16:24:29 +0100
> > Halil Pasic <pasic@linux.ibm.com> wrote:
> >  
> >>> Maybe you could
> >>> - grab a reference to kvm while holding the lock
> >>> - call the mask handling functions with that kvm reference
> >>> - lock again, drop the reference, and do the rest of the processing?  
> >> I agree, matrix_mdev->kvm can go NULL any time and we are risking
> >> a null pointer dereference here.
> >>
> >> Another idea would be to do
> >>
> >>
> >> static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev)
> >> {
> >>          struct kvm *kvm;
> >>                                                          
> >>          mutex_lock(&matrix_dev->lock);
> >>          if (matrix_mdev->kvm) {
> >>                  kvm = matrix_mdev->kvm;
> >>                  matrix_mdev->kvm = NULL;
> >>                  mutex_unlock(&matrix_dev->lock);
> >>                  kvm_arch_crypto_clear_masks(kvm);
> >>                  mutex_lock(&matrix_dev->lock);
> >>                  matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;  
> > s/matrix_mdev->kvm/kvm  
> >>                  vfio_ap_mdev_reset_queues(matrix_mdev->mdev);
> >>                  kvm_put_kvm(kvm);
> >>          }
> >>          mutex_unlock(&matrix_dev->lock);
> >> }
> >>
> >> That way only one unset would actually do the unset and cleanup
> >> and every other invocation would bail out with only checking
> >> matrix_mdev->kvm.  
> > But the problem with that is that we enable the the assign/unassign
> > prematurely, which could interfere wit reset_queues(). Forget about
> > it.  
> 
> Not sure what you mean by this.
> 
> 

I mean because above I first do
(1) matrix_mdev->kvm = NULL;
and then do 
(2) vfio_ap_mdev_reset_queues(matrix_mdev->mdev);
another thread could do 
static ssize_t unassign_adapter_store(struct device *dev,                       
                                      struct device_attribute *attr,            
                                      const char *buf, size_t count)            
{                                                                               
        int ret;                                                                
        unsigned long apid;                                                     
        struct mdev_device *mdev = mdev_from_dev(dev);                          
        struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);            
                                                                                
        /* If the guest is running, disallow un-assignment of adapter */        
        if (matrix_mdev->kvm)                                                   
                return -EBUSY;   
...
}
between (1) and (2), and we would not bail out with -EBUSY because !!kvm
because of (1). That means we would change matrix_mdev->matrix and we
would not reset the queues that correspond to the apid that was just
removed, because by the time we do the reset_queues, the queues are
not in the matrix_mdev->matrix any more.

Does that make sense?
