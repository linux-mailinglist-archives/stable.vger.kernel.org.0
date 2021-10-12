Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A23A042A6D6
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 16:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237162AbhJLONR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 10:13:17 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59992 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236846AbhJLONO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Oct 2021 10:13:14 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19CDfQnS012661;
        Tue, 12 Oct 2021 10:11:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=71cdKd02qfmaBKvYdLQNGQCFpTXIHmjd5LJS3JMWfKg=;
 b=n3iVwMKkRaFmCFWLFooPzTD8TzbizbxDetmv27tQsoy8y4rcclzZ6JmB1m7WuGrDrSz3
 lYdhjxT7LF3OPCMK/dTHcrgyZzNv3ufkuAG+KasbIPhePRaNF1BMymTfk3Zpqz+ZmyLO
 Q4o3Su5/IDe49dSQbZexY3YKc9w5btCPCfj5+udthujzY2wL8EuE5TOjZEvf0ewI+ks0
 2AiV9mfB017zSDv+sBOtWl/CmMQMtvwdUJNMFGsuX6dBsQnmdwLgn5R6M+pcA4JuDwYm
 SWG5+vUHPffxABPu08wfGYC0HCcvjYdV0mM3FP5R83OG2gVExq+EyZlIVahzR3Q8tLfs SA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bnbfch0bv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 10:11:11 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19CDwb2v030702;
        Tue, 12 Oct 2021 10:11:11 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bnbfch09n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 10:11:11 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19CEA4if000955;
        Tue, 12 Oct 2021 14:11:08 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3bk2bj9p1p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 14:11:07 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19CEAtfj20906314
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 14:10:55 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0EA24A408A;
        Tue, 12 Oct 2021 14:10:55 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 551F4A408D;
        Tue, 12 Oct 2021 14:10:49 +0000 (GMT)
Received: from [9.152.222.57] (unknown [9.152.222.57])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 12 Oct 2021 14:10:48 +0000 (GMT)
Message-ID: <342e81ec-8c67-29ea-ae38-5911073ecdb0@linux.ibm.com>
Date:   Tue, 12 Oct 2021 16:10:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [RFC PATCH 1/1] s390/cio: make ccw_device_dma_* more robust
Content-Language: en-US
To:     Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, bfu@redhat.com
References: <20211011115955.2504529-1-pasic@linux.ibm.com>
 <466de207-e88d-ea93-beec-fbfe10e63a26@linux.ibm.com>
 <874k9ny6k6.fsf@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <874k9ny6k6.fsf@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: y6iWKooQBWVeiI1LfeRUQN1dbUzuWijV
X-Proofpoint-ORIG-GUID: xKrTCGWWtokDcIolwhDA-iIigP4CiYcz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-12_03,2021-10-12_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 spamscore=0
 adultscore=0 clxscore=1015 phishscore=0 suspectscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110120082
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 10/11/21 16:33, Cornelia Huck wrote:
> On Mon, Oct 11 2021, Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> On 10/11/21 1:59 PM, Halil Pasic wrote:
>>> diff --git a/drivers/s390/cio/device_ops.c b/drivers/s390/cio/device_ops.c
>>> index 0fe7b2f2e7f5..c533d1dadc6b 100644
>>> --- a/drivers/s390/cio/device_ops.c
>>> +++ b/drivers/s390/cio/device_ops.c
>>> @@ -825,13 +825,23 @@ EXPORT_SYMBOL_GPL(ccw_device_get_chid);
>>>     */
>>>    void *ccw_device_dma_zalloc(struct ccw_device *cdev, size_t size)
>>>    {
>>> -	return cio_gp_dma_zalloc(cdev->private->dma_pool, &cdev->dev, size);
>>> +	void *addr;
>>> +
>>> +	if (!get_device(&cdev->dev))
>>> +		return NULL;
>>> +	addr = cio_gp_dma_zalloc(cdev->private->dma_pool, &cdev->dev, size);
>>> +	if (IS_ERR_OR_NULL(addr))
>>
>> I can be wrong but it seems that only dma_alloc_coherent() used in
>> cio_gp_dma_zalloc() report an error but the error is ignored and used as
>> a valid pointer.
> 
> Hm, I thought dma_alloc_coherent() returned either NULL or a valid
> address?

hum, my bad, checked the wrong function, should have use my glasses or 
connect my brain.

> 
>>
>> So shouldn't we modify this function and just test for a NULL address here?
> 
> If I read cio_gp_dma_zalloc() correctly, we either get NULL or a valid
> address, so yes.
> 

-- 
Pierre Morel
IBM Lab Boeblingen
