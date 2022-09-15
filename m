Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFF985B9DC5
	for <lists+stable@lfdr.de>; Thu, 15 Sep 2022 16:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbiIOOyB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Sep 2022 10:54:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbiIOOyA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Sep 2022 10:54:00 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17A8773904;
        Thu, 15 Sep 2022 07:53:58 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28FDhtpO017030;
        Thu, 15 Sep 2022 14:53:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=NQb4TxGnuZvveErzd7UCvTG1rRRd+QPk4e9P65fAVH8=;
 b=OzKuOWO9bbRjYRZ5fdWS0jdoRbNabjWt2U57qfuFLKYj9I6nryotkQE9vEh+lCsWRtTQ
 bzEEWvGjMqzmXk2TxgBp5XQm1OMeMZCtlaVwICYe8Dv+2M/LHABxmZF4Z6lbUU+kKH/D
 bSzOi5ZIRubMZum+C3V3zxh7QbizVb+s/hM1385NRBic0I/1ue5YYZK94eEH2oMQC427
 AbpRhAZWSMkRiyxPn2UaXs8ntkPflTNlbgZU5XcvlP0Se2jMnY8acupp3yHGeyXHR859
 8dOcrAKs+FI2NFkj6T6WjFRQfWJ+SngCY1TGmB3ct/N0P45qL7cBzV5jIM/eV4SINwYT uA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3jm56d2gdc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Sep 2022 14:53:57 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28FDiWwX019282;
        Thu, 15 Sep 2022 14:53:57 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3jm56d2gcn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Sep 2022 14:53:57 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28FEpOIc020267;
        Thu, 15 Sep 2022 14:53:55 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 3jjy2n1x8h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Sep 2022 14:53:55 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28FErqv338535482
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Sep 2022 14:53:52 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 55CBAA4040;
        Thu, 15 Sep 2022 14:53:52 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C0596A4051;
        Thu, 15 Sep 2022 14:53:51 +0000 (GMT)
Received: from [9.171.87.36] (unknown [9.171.87.36])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 15 Sep 2022 14:53:51 +0000 (GMT)
Message-ID: <4e89ff00-aac2-7c8e-14cf-add426853e9d@de.ibm.com>
Date:   Thu, 15 Sep 2022 16:53:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v3 1/2] s390/vfio-ap: bypass unnecessary processing of AP
 resources
Content-Language: en-US
To:     Halil Pasic <pasic@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, alex.williamson@redhat.com,
        stable@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
References: <20220823150643.427737-1-akrowiak@linux.ibm.com>
 <20220823150643.427737-2-akrowiak@linux.ibm.com>
 <20220915050018.37d21083.pasic@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
In-Reply-To: <20220915050018.37d21083.pasic@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: XIS-DtLMUyRIA_r36Zt6XofzVQHUVXTU
X-Proofpoint-GUID: ny8pIXFL1w_-ZtfSC5yS2z3c-hpDJBrC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-15_08,2022-09-14_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 lowpriorityscore=0 suspectscore=0 spamscore=0 mlxlogscore=999
 impostorscore=0 mlxscore=0 adultscore=0 priorityscore=1501 phishscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2208220000 definitions=main-2209150085
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Am 15.09.22 um 05:00 schrieb Halil Pasic:
> On Tue, 23 Aug 2022 11:06:42 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> 
>> It is not necessary to go through the process of validation, linking of
>> queues to mdev and vice versa and filtering the APQNs assigned to the
>> matrix mdev to build an AP configuration for a guest if an adapter or
>> domain being assigned is already assigned to the matrix mdev. Likewise, it
>> is not necessary to proceed through the process the unassignment of an
>> adapter, domain or control domain if it is not assigned to the matrix mdev.
>>
>> Since it is not necessary to process assignment of a resource resource
>> already assigned or process unassignment of a resource that is been assigned,
>> this patch will bypass all assignment/unassignment operations for an adapter,
>> domain or control domain under these circumstances.
>>
>> Not only is assignment of a duplicate adapter or domain unnecessary, it
>> will also cause a hang situation when removing the matrix mdev to which it is
>> assigned. The reason is because the same vfio_ap_queue objects with an
>> APQN containing the APID of the adapter or APQI of the domain being
>> assigned will get added multiple times to the hashtable that holds them.
>> This results in the pprev and next pointers of the hlist_node (mdev_qnode
>> field in the vfio_ap_queue object) pointing to the queue object itself
>> resulting in an interminable loop when the mdev is removed and the queue
>> table is iterated to reset the queues.
>>
>> Cc: stable@vger.kernel.org
>> Fixes: 11cb2419fafe ("s390/vfio-ap: manage link between queue struct and matrix mdev")
>> Reported-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> 
> Reviewed-by: Halil Pasic <pasic@linux.ibm.com>

Shall the patch go via the s390 tree (still into 6.0 I guess)?

> 
>> ---
>>   drivers/s390/crypto/vfio_ap_ops.c | 30 ++++++++++++++++++++++++++++++
>>   1 file changed, 30 insertions(+)
>>
>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
>> index 6c8c41fac4e1..ee82207b4e60 100644
>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>> @@ -984,6 +984,11 @@ static ssize_t assign_adapter_store(struct device *dev,
>>   		goto done;
>>   	}
>>   
>> +	if (test_bit_inv(apid, matrix_mdev->matrix.apm)) {
>> +		ret = count;
>> +		goto done;
>> +	}
>> +
>>   	set_bit_inv(apid, matrix_mdev->matrix.apm);
>>   
>>   	ret = vfio_ap_mdev_validate_masks(matrix_mdev);
>> @@ -1109,6 +1114,11 @@ static ssize_t unassign_adapter_store(struct device *dev,
>>   		goto done;
>>   	}
>>   
>> +	if (!test_bit_inv(apid, matrix_mdev->matrix.apm)) {
>> +		ret = count;
>> +		goto done;
>> +	}
>> +
>>   	clear_bit_inv((unsigned long)apid, matrix_mdev->matrix.apm);
>>   	vfio_ap_mdev_hot_unplug_adapter(matrix_mdev, apid);
>>   	ret = count;
>> @@ -1183,6 +1193,11 @@ static ssize_t assign_domain_store(struct device *dev,
>>   		goto done;
>>   	}
>>   
>> +	if (test_bit_inv(apqi, matrix_mdev->matrix.aqm)) {
>> +		ret = count;
>> +		goto done;
>> +	}
>> +
>>   	set_bit_inv(apqi, matrix_mdev->matrix.aqm);
>>   
>>   	ret = vfio_ap_mdev_validate_masks(matrix_mdev);
>> @@ -1286,6 +1301,11 @@ static ssize_t unassign_domain_store(struct device *dev,
>>   		goto done;
>>   	}
>>   
>> +	if (!test_bit_inv(apqi, matrix_mdev->matrix.aqm)) {
>> +		ret = count;
>> +		goto done;
>> +	}
>> +
>>   	clear_bit_inv((unsigned long)apqi, matrix_mdev->matrix.aqm);
>>   	vfio_ap_mdev_hot_unplug_domain(matrix_mdev, apqi);
>>   	ret = count;
>> @@ -1329,6 +1349,11 @@ static ssize_t assign_control_domain_store(struct device *dev,
>>   		goto done;
>>   	}
>>   
>> +	if (test_bit_inv(id, matrix_mdev->matrix.adm)) {
>> +		ret = count;
>> +		goto done;
>> +	}
>> +
>>   	/* Set the bit in the ADM (bitmask) corresponding to the AP control
>>   	 * domain number (id). The bits in the mask, from most significant to
>>   	 * least significant, correspond to IDs 0 up to the one less than the
>> @@ -1378,6 +1403,11 @@ static ssize_t unassign_control_domain_store(struct device *dev,
>>   		goto done;
>>   	}
>>   
>> +	if (!test_bit_inv(domid, matrix_mdev->matrix.adm)) {
>> +		ret = count;
>> +		goto done;
>> +	}
>> +
>>   	clear_bit_inv(domid, matrix_mdev->matrix.adm);
>>   
>>   	if (test_bit_inv(domid, matrix_mdev->shadow_apcb.adm)) {
> 
