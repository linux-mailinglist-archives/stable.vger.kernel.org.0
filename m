Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6D6340E26
	for <lists+stable@lfdr.de>; Thu, 18 Mar 2021 20:25:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232674AbhCRTYg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Mar 2021 15:24:36 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:8986 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232479AbhCRTY0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Mar 2021 15:24:26 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12IJ4QQu010615;
        Thu, 18 Mar 2021 15:24:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=Zuf1kKKkAwwOU6IO1L4Z2Ge+i5zj86VHl5I8TZpPZlw=;
 b=A+YL7cxMQ07QD44OFEWsELEBW72UmN/ouupKsZebTbzWW58iTsPm0ZLUdSHzox54/Mqm
 iSsRCvfmPWzxgKy7NdzLLkelnfNJa2DYvMJQHmo1IVSQKILWkn/9HbHJ45YD4uj7PwZM
 egiEdRF+md3vxlCcF4vZlGUPxLWmCDsBpRbVXJwfrnKqP5wYyv/8jhC3mawWGXbJn63v
 nQ8C6NB64hlwlD9AQm2oQHzSA1xMDdbusAzL49+TXZTqZpGFAgLD0glcRkTIG3UxCHtl
 zf8nh/vaxhnl01hwPgoG5WTKnbsMjlaN144UAjJCfBifPforvCthGwveMEGnlm8UZWS+ gg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37c6tfd4fm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 15:24:22 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12IJ4fFi011213;
        Thu, 18 Mar 2021 15:24:22 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37c6tfd4ew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 15:24:21 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12IJMMkq027092;
        Thu, 18 Mar 2021 19:24:20 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 378n18anwd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 19:24:20 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12IJOH1a36962566
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Mar 2021 19:24:17 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 52C30A4040;
        Thu, 18 Mar 2021 19:24:17 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8D3B8A404D;
        Thu, 18 Mar 2021 19:24:16 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.84.212])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Thu, 18 Mar 2021 19:24:16 +0000 (GMT)
Date:   Thu, 18 Mar 2021 20:24:14 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, stable@vger.kernel.org,
        borntraeger@de.ibm.com, cohuck@redhat.com, kwankhede@nvidia.com,
        pbonzini@redhat.com, alex.williamson@redhat.com,
        pasic@linux.vnet.ibm.com
Subject: Re: [PATCH v4 1/1] s390/vfio-ap: fix circular lockdep when
 setting/clearing crypto masks
Message-ID: <20210318202414.16f3350d.pasic@linux.ibm.com>
In-Reply-To: <d98ab0e1-dca3-0ea7-2478-387e3698900e@linux.ibm.com>
References: <20210310150559.8956-1-akrowiak@linux.ibm.com>
        <20210310150559.8956-2-akrowiak@linux.ibm.com>
        <20210318001729.06cdb8d6.pasic@linux.ibm.com>
        <d98ab0e1-dca3-0ea7-2478-387e3698900e@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-18_12:2021-03-17,2021-03-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 phishscore=0 priorityscore=1501 mlxscore=0
 suspectscore=0 bulkscore=0 clxscore=1015 adultscore=0 impostorscore=0
 malwarescore=0 mlxlogscore=758 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2103180135
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 18 Mar 2021 13:54:06 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> > Is it guaranteed that matrix_mdev can't be NULL here? If yes, please
> > remind me of the mechanism that ensures this.  
> 
> The matrix_mdev is set as drvdata when the mdev is created and
> is only cleared when the mdev is removed. Likewise, this function
> is a callback defined by by vfio in the vfio_ap_matrix_ops structure
> when the matrix_dev is registered and is intended to handle ioctl
> calls from userspace during the lifetime of the mdev. 

Yes, I've checked that these are all callbacks in the same struct, so
the callbacks are all registered simultaneously, i.e. the ioctl callback
gettin gregistered only when drv_data is already set is not the case.
If there isn't a mechanism in core mdev, then I think we better be
careful.  I don't see what would guarantee the pointer is always in the
vfio_ap code. 

> While I can't
> speak definitively to the guarantee, I think it is extremely unlikely
> that matrix_mdev would be NULL at this point. On the other hand,
> it wouldn't hurt to check for NULL and log an error or warning
> message (I prefer an error here) if NULL.

If we aren't absolutely sure this pointer is going to be always a valid
one, let's check it!

Regards,
Halil
