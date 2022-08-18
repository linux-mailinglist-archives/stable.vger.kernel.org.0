Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF95598588
	for <lists+stable@lfdr.de>; Thu, 18 Aug 2022 16:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245674AbiHRONH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Aug 2022 10:13:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245133AbiHRONG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Aug 2022 10:13:06 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EC219F0D4;
        Thu, 18 Aug 2022 07:13:05 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27ID14CC016237;
        Thu, 18 Aug 2022 14:13:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=ocFXUaee3DFtT/I/MOOiB+O6mmtuhQXu7Wa1ZFJfjb4=;
 b=i/RSsSWj7Nrl/X+cZUafu55WsWEUCooWKDji3mXKrhXAHSRaSR/vsU0zU5gMBGQVnrHg
 x5K6oAoFR58SjUVP/HL3HlYmTMzQxrKR2jKVqyh7knW0K/StdKeU48y8nWxkTyeJ9nyy
 eL5fmOTQo7K8Iy0yaX8TpyGUG6lTnd23DtK2dXdgmnFzsYjhi+aH9rJ0m5sDgHvSRuq4
 zAMfJrV9LHQn7gjo6cuKyQSDx2ba+5ptIW+t7M+v3ZWyuXE45Lzm3miGtTjiukfJJA5f
 sEszsPE7Mo7otWh/dv+6HlCkSMJiTR6wKaDu80uJAif0NFP3mt+SW8fQAIsOoVYETdtC wA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3j1nxkjkcu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Aug 2022 14:13:03 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27ID1MlT018212;
        Thu, 18 Aug 2022 14:13:02 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3j1nxkjkbj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Aug 2022 14:13:02 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27IE5HVt019754;
        Thu, 18 Aug 2022 14:13:00 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 3hyp8sjywx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Aug 2022 14:13:00 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27IECv3K36045140
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Aug 2022 14:12:57 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8787452059;
        Thu, 18 Aug 2022 14:12:57 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.152.224.212])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 25A3352052;
        Thu, 18 Aug 2022 14:12:57 +0000 (GMT)
Date:   Thu, 18 Aug 2022 16:12:55 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, stable@vger.kernel.org,
        Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH v2 1/2] s390/vfio-ap: fix hang during removal of mdev
 after duplicate assignment
Message-ID: <20220818161255.2fe5a542.pasic@linux.ibm.com>
In-Reply-To: <20220818132606.13321-2-akrowiak@linux.ibm.com>
References: <20220818132606.13321-1-akrowiak@linux.ibm.com>
        <20220818132606.13321-2-akrowiak@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: yQGkJllg8VbH4YSAFG7H5vIqdf6p324-
X-Proofpoint-ORIG-GUID: AIaqSj65wGiNtqt3GIDHwqrWcuFSbVwd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-18_12,2022-08-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 impostorscore=0 bulkscore=0 suspectscore=0 adultscore=0
 phishscore=0 priorityscore=1501 clxscore=1011 malwarescore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208180050
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 18 Aug 2022 09:26:05 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

Subject: s390/vfio-ap: fix hang during removal of mdev after duplicate
assignment

It would have made sense to do it this way in the first place, even
if the link code were to take care of the duplicates. It did not really
make sense to do the whole filtering biz and everything else. Maybe we
should spin the short description and the rest of the commit message so
it reflects the code more. 

> When the same adapter or domain is assigned more than one time prior to
> removing the matrix mdev to which it is assigned, the remove operation
> will hang. The reason is because the same vfio_ap_queue objects with an
> APQN containing the APID of the adapter or APQI of the domain being
> assigned will get added to the hashtable that holds them multiple times.
> This results in the pprev and next pointers of the hlist_node (mdev_qnode
> field in the vfio_ap_queue object) pointing to the queue object itself.
> This causes an interminable loop when the mdev is removed and the queue
> table is iterated to reset the queues.
> 
> To fix this problem, the assignment operation is bypassed when assigning
> an adapter or domain if it is already assigned to the matrix mdev.
> 
> Since it is not necessary to assign a resource already assigned or to
> unassign a resource that has not been assigned, this patch will bypass
> all assignment/unassignment operations for an adapter, domain or
> control domain under these circumstances.
> 
> Cc: stable@vger.kernel.org
> Fixes: 771e387d5e79 ("s390/vfio-ap: manage link between queue struct and matrix mdev")

Not 11cb2419fafe ("s390/vfio-ap: manage link between queue struct and
matrix mdev")

Is my repo borked?


> Reported-by: Matthew Rosato <mjrosato@linux.ibm.com>
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>  drivers/s390/crypto/vfio_ap_ops.c | 30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index 6c8c41fac4e1..ee82207b4e60 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -984,6 +984,11 @@ static ssize_t assign_adapter_store(struct device *dev,
>  		goto done;
>  	}
>  
> +	if (test_bit_inv(apid, matrix_mdev->matrix.apm)) {
> +		ret = count;
> +		goto done;
> +	}
> +
>  	set_bit_inv(apid, matrix_mdev->matrix.apm);
>  
>  	ret = vfio_ap_mdev_validate_masks(matrix_mdev);
> @@ -1109,6 +1114,11 @@ static ssize_t unassign_adapter_store(struct device *dev,
>  		goto done;
>  	}
>  
> +	if (!test_bit_inv(apid, matrix_mdev->matrix.apm)) {
> +		ret = count;
> +		goto done;
> +	}
> +
>  	clear_bit_inv((unsigned long)apid, matrix_mdev->matrix.apm);
>  	vfio_ap_mdev_hot_unplug_adapter(matrix_mdev, apid);
>  	ret = count;
> @@ -1183,6 +1193,11 @@ static ssize_t assign_domain_store(struct device *dev,
>  		goto done;
>  	}
>  
> +	if (test_bit_inv(apqi, matrix_mdev->matrix.aqm)) {
> +		ret = count;
> +		goto done;
> +	}
> +
>  	set_bit_inv(apqi, matrix_mdev->matrix.aqm);
>  
>  	ret = vfio_ap_mdev_validate_masks(matrix_mdev);
> @@ -1286,6 +1301,11 @@ static ssize_t unassign_domain_store(struct device *dev,
>  		goto done;
>  	}
>  
> +	if (!test_bit_inv(apqi, matrix_mdev->matrix.aqm)) {
> +		ret = count;
> +		goto done;
> +	}
> +
>  	clear_bit_inv((unsigned long)apqi, matrix_mdev->matrix.aqm);
>  	vfio_ap_mdev_hot_unplug_domain(matrix_mdev, apqi);
>  	ret = count;
> @@ -1329,6 +1349,11 @@ static ssize_t assign_control_domain_store(struct device *dev,
>  		goto done;
>  	}
>  
> +	if (test_bit_inv(id, matrix_mdev->matrix.adm)) {
> +		ret = count;
> +		goto done;
> +	}
> +
>  	/* Set the bit in the ADM (bitmask) corresponding to the AP control
>  	 * domain number (id). The bits in the mask, from most significant to
>  	 * least significant, correspond to IDs 0 up to the one less than the
> @@ -1378,6 +1403,11 @@ static ssize_t unassign_control_domain_store(struct device *dev,
>  		goto done;
>  	}
>  
> +	if (!test_bit_inv(domid, matrix_mdev->matrix.adm)) {
> +		ret = count;
> +		goto done;
> +	}
> +
>  	clear_bit_inv(domid, matrix_mdev->matrix.adm);
>  
>  	if (test_bit_inv(domid, matrix_mdev->shadow_apcb.adm)) {

