Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5974B598C4B
	for <lists+stable@lfdr.de>; Thu, 18 Aug 2022 21:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242650AbiHRTDB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Aug 2022 15:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233465AbiHRTDA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Aug 2022 15:03:00 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 472FAC00EE;
        Thu, 18 Aug 2022 12:02:59 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27IIxZot013238;
        Thu, 18 Aug 2022 19:02:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=tKMju3sjzSo3xIdBg1oTDtDo+ZlGlwx9HD+6llrIQ/o=;
 b=TvtzL7V2+td6MH5PmXRHo0LgZYSpez4ZH+VgnVV7AAGfGONfbNwYw5WARUdF0PqSq8b4
 rCiTQNyN+raRb7+FfrdZ7Cy5ZlIfxoOqR1W6KoQi/ecbKclEVu1ZwuOs+eYSBEppeeb8
 ZfGY4BA14zzXPN0O06QX+sL3X9k94tqjzucGoIiccdkE8g41CL0gjTI5Ri1MMRZYTpX6
 Nj/BQ+L0fyqDnyVHl8FOVEDOYTQWsnkqc9uqDy5LceSfFlxPV9l1yctH9RDqu6upTuu4
 JlNWbhAESPfcV9duPiVJLfC7aebOOsZKniB+KH03N7hR6OLixswwsx1Mhn+DNa6NuMS1 Tg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j1u6ng27n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Aug 2022 19:02:56 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27IJ0wm3021328;
        Thu, 18 Aug 2022 19:02:56 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j1u6ng27d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Aug 2022 19:02:56 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27IIor0l007012;
        Thu, 18 Aug 2022 19:02:55 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma04wdc.us.ibm.com with ESMTP id 3hx3ka0ka5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Aug 2022 19:02:55 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27IJ2sME35324620
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Aug 2022 19:02:54 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 34774BE054;
        Thu, 18 Aug 2022 19:02:54 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3CE94BE04F;
        Thu, 18 Aug 2022 19:02:53 +0000 (GMT)
Received: from [9.160.64.167] (unknown [9.160.64.167])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 18 Aug 2022 19:02:52 +0000 (GMT)
Message-ID: <1ff0ff82-f0e6-96d7-7e9a-f46a4957813c@linux.ibm.com>
Date:   Thu, 18 Aug 2022 15:02:52 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2 1/2] s390/vfio-ap: fix hang during removal of mdev
 after duplicate assignment
Content-Language: en-US
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, stable@vger.kernel.org
References: <20220818132606.13321-1-akrowiak@linux.ibm.com>
 <20220818132606.13321-2-akrowiak@linux.ibm.com>
 <20220818161255.2fe5a542.pasic@linux.ibm.com>
From:   Anthony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <20220818161255.2fe5a542.pasic@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: PSZdRyd5im51UYa6Rc2cUOEsr88_M5g7
X-Proofpoint-GUID: 8RPhnrfQ4IwVpbRYDqKJQdkY6Xz2IRoY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-18_14,2022-08-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 bulkscore=0
 impostorscore=0 mlxlogscore=999 clxscore=1015 adultscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208180069
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 8/18/22 10:12 AM, Halil Pasic wrote:
> On Thu, 18 Aug 2022 09:26:05 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
> Subject: s390/vfio-ap: fix hang during removal of mdev after duplicate
> assignment
>
> It would have made sense to do it this way in the first place, even
> if the link code were to take care of the duplicates. It did not really
> make sense to do the whole filtering biz and everything else.


No, it did not; however, nobody caught it in review either. In fact, 
this probably should have been done prior to hot plug.


>   Maybe we
> should spin the short description and the rest of the commit message so
> it reflects the code more.


I'm not sure what you mean here, are you suggesting the first two 
paragraphs should be eliminated?


>   
>
>> When the same adapter or domain is assigned more than one time prior to
>> removing the matrix mdev to which it is assigned, the remove operation
>> will hang. The reason is because the same vfio_ap_queue objects with an
>> APQN containing the APID of the adapter or APQI of the domain being
>> assigned will get added to the hashtable that holds them multiple times.
>> This results in the pprev and next pointers of the hlist_node (mdev_qnode
>> field in the vfio_ap_queue object) pointing to the queue object itself.
>> This causes an interminable loop when the mdev is removed and the queue
>> table is iterated to reset the queues.
>>
>> To fix this problem, the assignment operation is bypassed when assigning
>> an adapter or domain if it is already assigned to the matrix mdev.
>>
>> Since it is not necessary to assign a resource already assigned or to
>> unassign a resource that has not been assigned, this patch will bypass
>> all assignment/unassignment operations for an adapter, domain or
>> control domain under these circumstances.
>>
>> Cc: stable@vger.kernel.org
>> Fixes: 771e387d5e79 ("s390/vfio-ap: manage link between queue struct and matrix mdev")
> Not 11cb2419fafe ("s390/vfio-ap: manage link between queue struct and
> matrix mdev")
>
> Is my repo borked?
>
>
>> Reported-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
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
