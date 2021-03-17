Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D80C33FBBF
	for <lists+stable@lfdr.de>; Thu, 18 Mar 2021 00:18:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbhCQXRm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 19:17:42 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:15154 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229494AbhCQXRl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Mar 2021 19:17:41 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12HN40hK113226;
        Wed, 17 Mar 2021 19:17:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=HwTFj9YWtjFoFZ5fUL/TzRKtrvD01QdclZb5heatb5E=;
 b=DGiOz2pytOubrRitLQ75yfB0/tSjs0bmwTqkY93t201E+cL/Y9PYqx3B/fdwoCowv2dX
 zIaTyQosFjzsgt/GyNPqqfttFBBchUNP+8x8HEqeglHbXFitUrui0V6I9pQK6iYixlZb
 4U5YryPLUo6OfTu1LoDqxt42uVtBu3TjxEmITg52YN9pi3Xws+cIkrhPNp2JQzL8avD1
 zK/7LmQwRXW4hOX312uo6NSj05zy/HsKqXIf6fQfjSEgJiM3UUWONiVM5oM50LlyYF0u
 tq1LZrPPxQ0cHiywrPg12Kid2CJTHw2J6zULOzC1dAsmiKe7KAOuQZOug0YEG5+uX6oQ hg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37bnrehtma-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Mar 2021 19:17:38 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12HN5Hii120950;
        Wed, 17 Mar 2021 19:17:38 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37bnrehtkj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Mar 2021 19:17:37 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12HNDI53001296;
        Wed, 17 Mar 2021 23:17:35 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma05fra.de.ibm.com with ESMTP id 378n18a7rb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Mar 2021 23:17:35 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12HNHWpF39846396
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Mar 2021 23:17:32 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A7B52A4051;
        Wed, 17 Mar 2021 23:17:32 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C26CBA4040;
        Wed, 17 Mar 2021 23:17:31 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.80.101])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Wed, 17 Mar 2021 23:17:31 +0000 (GMT)
Date:   Thu, 18 Mar 2021 00:17:29 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, stable@vger.kernel.org,
        borntraeger@de.ibm.com, cohuck@redhat.com, kwankhede@nvidia.com,
        pbonzini@redhat.com, alex.williamson@redhat.com,
        pasic@linux.vnet.ibm.com
Subject: Re: [PATCH v4 1/1] s390/vfio-ap: fix circular lockdep when
 setting/clearing crypto masks
Message-ID: <20210318001729.06cdb8d6.pasic@linux.ibm.com>
In-Reply-To: <20210310150559.8956-2-akrowiak@linux.ibm.com>
References: <20210310150559.8956-1-akrowiak@linux.ibm.com>
        <20210310150559.8956-2-akrowiak@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-17_13:2021-03-17,2021-03-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 adultscore=0 bulkscore=0 suspectscore=0 phishscore=0
 mlxlogscore=910 clxscore=1015 spamscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103170163
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 10 Mar 2021 10:05:59 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> -		ret = vfio_ap_mdev_reset_queues(mdev);
> +		matrix_mdev = mdev_get_drvdata(mdev);

Is it guaranteed that matrix_mdev can't be NULL here? If yes, please
remind me of the mechanism that ensures this.

> +
> +		/*
> +		 * If the KVM pointer is in the process of being set, wait until
> +		 * the process has completed.
> +		 */
> +		wait_event_cmd(matrix_mdev->wait_for_kvm,
> +			       matrix_mdev->kvm_busy == false,
> +			       mutex_unlock(&matrix_dev->lock),
> +			       mutex_lock(&matrix_dev->lock));
> +
> +		if (matrix_mdev->kvm)
> +			ret = vfio_ap_mdev_reset_queues(mdev);
> +		else
> +			ret = -ENODEV;

Didn't we agree to make the call to vfio_ap_mdev_reset_queues()
unconditional again (for reference please take look at 
Message-ID: <64afa72c-2d6a-2ca1-e576-34e15fa579ed@linux.ibm.com>)?

Regards,
Halil
