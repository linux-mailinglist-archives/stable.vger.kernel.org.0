Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D347D34114E
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 01:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbhCSAAL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Mar 2021 20:00:11 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45968 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230316AbhCSAAC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Mar 2021 20:00:02 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12INY35d094321;
        Thu, 18 Mar 2021 20:00:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=ivTiJWbGDsEtE3GvdJeKaLJ5TjbJ9stwGEwR143CR7w=;
 b=RKiQrzy448vuACAHjwq4aeriwig8JXHgtaYGwc67qD+TIE22Ks2tG/F5pNM3otFCKxN2
 InzPo6mWJICPay498RXM24kqaRsCu3eJW40IPY92k6Jlu1hyINzQ1v3yahRtBx5es74+
 F8GxAnzZikBPRk/Ic/VCdjjJBUqtgDPFv4HyPb70+eADGDRSbTVzi/FA1DUM/MBqHPeR
 74TrH9dwR8Smo2Tff54GN1egM02nsCeeL7oEGvjAXUFExTfzbDw77S61tjjyl7b9uxk5
 dbPTtFuvTwq70hLZjUdgk9caGCnEPqSu/XbCsKuXAv9bU04yiLn75HzTz9H2NWyMnHC4 rg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37c302j5p6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 20:00:01 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12INZKDh096838;
        Thu, 18 Mar 2021 20:00:01 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37c302j5my-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 20:00:01 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12INujVx028122;
        Thu, 18 Mar 2021 23:59:59 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 37b30p22nr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 23:59:59 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12INxcNO36831642
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Mar 2021 23:59:39 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EBC76AE059;
        Thu, 18 Mar 2021 23:59:55 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2DE48AE057;
        Thu, 18 Mar 2021 23:59:55 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.84.212])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Thu, 18 Mar 2021 23:59:55 +0000 (GMT)
Date:   Fri, 19 Mar 2021 00:59:53 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, stable@vger.kernel.org,
        borntraeger@de.ibm.com, cohuck@redhat.com, kwankhede@nvidia.com,
        pbonzini@redhat.com, alex.williamson@redhat.com,
        pasic@linux.vnet.ibm.com
Subject: Re: [PATCH v4 1/1] s390/vfio-ap: fix circular lockdep when
 setting/clearing crypto masks
Message-ID: <20210319005953.7e6425bd.pasic@linux.ibm.com>
In-Reply-To: <ab9d54a1-afe7-caca-4e5e-99fca9ea2972@linux.ibm.com>
References: <20210310150559.8956-1-akrowiak@linux.ibm.com>
        <20210310150559.8956-2-akrowiak@linux.ibm.com>
        <20210318001729.06cdb8d6.pasic@linux.ibm.com>
        <ab9d54a1-afe7-caca-4e5e-99fca9ea2972@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-18_18:2021-03-17,2021-03-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 clxscore=1015 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103180169
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 18 Mar 2021 14:38:53 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> On 3/17/21 7:17 PM, Halil Pasic wrote:
> > On Wed, 10 Mar 2021 10:05:59 -0500
> > Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> >  
> >> -		ret = vfio_ap_mdev_reset_queues(mdev);
> >> +		matrix_mdev = mdev_get_drvdata(mdev);  
> > Is it guaranteed that matrix_mdev can't be NULL here? If yes, please
> > remind me of the mechanism that ensures this.
> >  
> >> +
> >> +		/*
> >> +		 * If the KVM pointer is in the process of being set, wait until
> >> +		 * the process has completed.
> >> +		 */
> >> +		wait_event_cmd(matrix_mdev->wait_for_kvm,
> >> +			       matrix_mdev->kvm_busy == false,
> >> +			       mutex_unlock(&matrix_dev->lock),
> >> +			       mutex_lock(&matrix_dev->lock));
> >> +
> >> +		if (matrix_mdev->kvm)
> >> +			ret = vfio_ap_mdev_reset_queues(mdev);
> >> +		else
> >> +			ret = -ENODEV;  
> > Didn't we agree to make the call to vfio_ap_mdev_reset_queues()
> > unconditional again (for reference please take look at
> > Message-ID: <64afa72c-2d6a-2ca1-e576-34e15fa579ed@linux.ibm.com>)?  
> 
> How about this:

Looks good. I will check the mdev code if the checkeck is really
needed. I'm curious when the sysfs files associated with a new mdev are
created. My guess is that this one comes in via a device specific file
(not the parent like in case of the create), and that those may be
created after the create. But we can get rid of the check any time so I
really don't see it as something that would preclude merging this.

Regards,
Halil

> 
> static ssize_t vfio_ap_mdev_ioctl(struct mdev_device *mdev,
>                      unsigned int cmd, unsigned long arg)
> {
>      int ret = 0;
>      struct ap_matrix_mdev *matrix_mdev;
> 
>      ...
>      case VFIO_DEVICE_RESET:
>          matrix_mdev = mdev_get_drvdata(mdev);
>          WARN(!matrix_mdev, "Driver data missing from mdev!!");
> 
>          if (matrix_mdev) {
>              /*
>               * If the KVM pointer is in the process of being set, wait 
> until
>               * the process has completed.
>               */
>              wait_event_cmd(matrix_mdev->wait_for_kvm,
>                         matrix_mdev->kvm_busy == false,
> mutex_unlock(&matrix_dev->lock),
> mutex_lock(&matrix_dev->lock));
> 
>              ret = vfio_ap_mdev_reset_queues(mdev);
>          }
>          break;
>      ...
> 
>      return ret;
> }
> 
> >
> > Regards,
> > Halil  
> 

