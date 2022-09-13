Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8256E5B76A5
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 18:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231921AbiIMQoq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 12:44:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230470AbiIMQoY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 12:44:24 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4593BC2B;
        Tue, 13 Sep 2022 08:39:00 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28DEBKHs007317;
        Tue, 13 Sep 2022 14:53:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Q97aEngNRdvGPLm2q/BFnsSsYf87cDWPq/dqfDKCPCg=;
 b=mT4I68SmOLgwI8qFT5NONdAOSb6ZJllMuv/LwsWtF4agEWC5NWkieD1HRdODy8i/YK8S
 EyuHh+ptravL1D27ZdlQg/MHZQF3JKzugnAY06BAWHH2ZQ6EnogNbSVFBfiavoUM2xTA
 82/9FiQvH3z29qxWqaJCMSPDsN+hJn6a7jkMPywmTgUGsYa/NeasKP6gMn6rArk0tkue
 nxhNAU/ikMFkInEHniPmXAWMi6hbhG9MWUPXTLiRS/b6GwPbXeHp28B2UDjgHsAAyLt5
 l9uF4b1NDEPPmotfLP6svfnFwNSakFzkevNdUZAkh8xQIvux2gM4l3Y+BrJrHPbhSE7q Ag== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3jjtfjv8ac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Sep 2022 14:53:53 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28DDAXXG016041;
        Tue, 13 Sep 2022 14:53:52 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3jjtfjv89x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Sep 2022 14:53:52 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28DEpsbA025296;
        Tue, 13 Sep 2022 14:53:52 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma01dal.us.ibm.com with ESMTP id 3jgj7a1tj7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Sep 2022 14:53:52 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28DErosY9896500
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Sep 2022 14:53:50 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ADF70124052;
        Tue, 13 Sep 2022 14:53:50 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 247DB124053;
        Tue, 13 Sep 2022 14:53:50 +0000 (GMT)
Received: from [9.160.74.225] (unknown [9.160.74.225])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 13 Sep 2022 14:53:50 +0000 (GMT)
Message-ID: <7c222f64-3f06-5184-31c3-be557051c6fa@linux.ibm.com>
Date:   Tue, 13 Sep 2022 10:53:49 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v3 2/2] s390/vfio-ap: fix unlinking of queues from the
 mdev
Content-Language: en-US
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, stable@vger.kernel.org
References: <20220823150643.427737-1-akrowiak@linux.ibm.com>
 <20220823150643.427737-3-akrowiak@linux.ibm.com>
 <20220913160708.50466335.pasic@linux.ibm.com>
From:   Anthony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <20220913160708.50466335.pasic@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3TVdiP9lvKgp6_vFTTZrHYdcdqxd8fvD
X-Proofpoint-ORIG-GUID: BELhWXQtiocM6owscKt1yentPVpm78O7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-13_06,2022-09-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 mlxscore=0 bulkscore=0 phishscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 spamscore=0 impostorscore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209130066
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 9/13/22 10:07 AM, Halil Pasic wrote:
> On Tue, 23 Aug 2022 11:06:43 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> The vfio_ap_mdev_unlink_adapter and vfio_ap_mdev_unlink_domain functions
>> add the associated vfio_ap_queue objects to the hashtable that links them
>> to the matrix mdev to which their APQN is assigned. In order to unlink
>> them, they must be deleted from the hashtable; if not, they will continue
>> to be reset whenever userspace closes the mdev fd or removes the mdev.
>> This patch fixes that issue.
> I'm not so sure about that!
>
>> Cc: stable@vger.kernel.org
>> Fixes: 70aeefe574cb ("s390/vfio-ap: reset queues after adapter/domain unassignment")
>> Reported-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> ---
>>   drivers/s390/crypto/vfio_ap_ops.c | 6 ++----
>>   1 file changed, 2 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
>> index ee82207b4e60..2493926b5dfb 100644
>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>> @@ -1049,8 +1049,7 @@ static void vfio_ap_mdev_unlink_adapter(struct ap_matrix_mdev *matrix_mdev,
>>   		if (q && qtable) {
>>   			if (test_bit_inv(apid, matrix_mdev->shadow_apcb.apm) &&
>>   			    test_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm))
>> -				hash_add(qtable->queues, &q->mdev_qnode,
>> -					 q->apqn);
> Careful qtable->queues is not supposed to be the same as
> matrix_mdev->qtable.queues it is rather a function local
> qtable that you use to know which queues were unlinked and
> need resetting.


You are correct. This patch is unnecessary.


>
> Have a look at vfio_ap_mdev_hot_unplug_adapter()
>
>> +				vfio_ap_unlink_queue_fr_mdev(q);
> IMHO this change is completely bogous. BTW
> vfio_ap_unlink_apqn_fr_mdev() a couple of lines above in the source
> (not seen in diff context) calls vfio_ap_unlink_queue_fr_mdev().


After further review, this patch is not only bogus, it is not necessary.


>
>>   		}
>>   	}
>>   }
>> @@ -1236,8 +1235,7 @@ static void vfio_ap_mdev_unlink_domain(struct ap_matrix_mdev *matrix_mdev,
>>   		if (q && qtable) {
>>   			if (test_bit_inv(apid, matrix_mdev->shadow_apcb.apm) &&
>>   			    test_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm))
>> -				hash_add(qtable->queues, &q->mdev_qnode,
>> -					 q->apqn);
>> +				vfio_ap_unlink_queue_fr_mdev(q);
> Same as above...
>
> Regards,
> Halil
>
>>   		}
>>   	}
>>   }
