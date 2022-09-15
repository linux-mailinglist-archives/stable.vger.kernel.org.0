Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BEB75B92D5
	for <lists+stable@lfdr.de>; Thu, 15 Sep 2022 05:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbiIODAc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 23:00:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiIODAa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 23:00:30 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6E887E006;
        Wed, 14 Sep 2022 20:00:27 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28F2UAaA031229;
        Thu, 15 Sep 2022 03:00:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=8FxWTYvr9dyzYd240WhgjgTB7nYf9NQFy9fUf5lu17Y=;
 b=WKnFXzCfpMI0yg0rLpz69kw2byi+vTLNqK8vCo7DRiJjFuR8fblpjrflrImdjnmzDb5x
 s/GHPuo81qLreS3xtmukj5P6fOm4861C7D8xO0PXLznnXkEG5fVTQ5fVYVUa/w/6qbRq
 wvYThwHdy5wQ4gpmvFzBXFYTgK7oPkgWU7jMPZWaf+88Y0YCbAn/d7b1eCOw2KN0YD8f
 a3cnNTdapu6pUA02wTZSurO6GQIh4FUUEodXPkTfsBvt+skmrz1RDtowCp/EZ3vCsJY3
 z4HwmG4oYqGpuXAGY1wy1YgiUQQ6h98cUJ7jGzgd5dEOPY9ES1znIBX9wpfEEudWLFJz Pw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jkuakgkt3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Sep 2022 03:00:27 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28F2lnkr032462;
        Thu, 15 Sep 2022 03:00:26 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jkuakgks2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Sep 2022 03:00:26 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28F2pB0p029995;
        Thu, 15 Sep 2022 03:00:24 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3jjy95srec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Sep 2022 03:00:24 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28F30LjU27984342
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Sep 2022 03:00:21 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 27733AE04D;
        Thu, 15 Sep 2022 03:00:21 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 96266AE05A;
        Thu, 15 Sep 2022 03:00:20 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.145.64.223])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 15 Sep 2022 03:00:20 +0000 (GMT)
Date:   Thu, 15 Sep 2022 05:00:18 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, stable@vger.kernel.org,
        Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH v3 1/2] s390/vfio-ap: bypass unnecessary processing of
 AP resources
Message-ID: <20220915050018.37d21083.pasic@linux.ibm.com>
In-Reply-To: <20220823150643.427737-2-akrowiak@linux.ibm.com>
References: <20220823150643.427737-1-akrowiak@linux.ibm.com>
        <20220823150643.427737-2-akrowiak@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: s22ckWZDcNMmMJgBhKcfY7XFzDJzkSXQ
X-Proofpoint-GUID: 5gq95nZ4QaBYc3_mmCBpqDKZltwu4BnK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-14_11,2022-09-14_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 bulkscore=0 adultscore=0 mlxlogscore=999 impostorscore=0 suspectscore=0
 priorityscore=1501 phishscore=0 malwarescore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2208220000 definitions=main-2209150011
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 23 Aug 2022 11:06:42 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> It is not necessary to go through the process of validation, linking of
> queues to mdev and vice versa and filtering the APQNs assigned to the
> matrix mdev to build an AP configuration for a guest if an adapter or
> domain being assigned is already assigned to the matrix mdev. Likewise, it
> is not necessary to proceed through the process the unassignment of an
> adapter, domain or control domain if it is not assigned to the matrix mdev.
> 
> Since it is not necessary to process assignment of a resource resource
> already assigned or process unassignment of a resource that is been assigned,
> this patch will bypass all assignment/unassignment operations for an adapter,
> domain or control domain under these circumstances.
> 
> Not only is assignment of a duplicate adapter or domain unnecessary, it
> will also cause a hang situation when removing the matrix mdev to which it is
> assigned. The reason is because the same vfio_ap_queue objects with an
> APQN containing the APID of the adapter or APQI of the domain being
> assigned will get added multiple times to the hashtable that holds them.
> This results in the pprev and next pointers of the hlist_node (mdev_qnode
> field in the vfio_ap_queue object) pointing to the queue object itself
> resulting in an interminable loop when the mdev is removed and the queue
> table is iterated to reset the queues.
> 
> Cc: stable@vger.kernel.org
> Fixes: 11cb2419fafe ("s390/vfio-ap: manage link between queue struct and matrix mdev")
> Reported-by: Matthew Rosato <mjrosato@linux.ibm.com>
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>

Reviewed-by: Halil Pasic <pasic@linux.ibm.com>

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

