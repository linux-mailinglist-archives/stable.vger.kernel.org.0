Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C41426E0CC
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 18:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728574AbgIQQdq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 12:33:46 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:24578 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728561AbgIQQdW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Sep 2020 12:33:22 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08HF37dK108155
        for <stable@vger.kernel.org>; Thu, 17 Sep 2020 11:29:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=A5izNRBOze6/szt8TVpj+DKqxxWPyzPDxXmtkxrCGUA=;
 b=U4ZQXgBky3RQ3X+1nchsd3jdcP/w48QeaG3YtaVAYxPftEnGe8oso6dxDGkaBrfYDj6n
 ysmfI2fWSANPHB9y/HOAo8rsjZuGXkDHaBROghBwSSbXRjx5A2BqDkClr5st7mkE6LZE
 w9I0uIj6T3yDya8AYK3ObUxbkCusmERat0wpP/wsGp/wy9+b0bz4SM8hVaCLeSnrDOcL
 0RkYcrgbHeep848DZ7PCWWujibB2QaE+2YoNrIMVv/HnblmF+b+5LhFGedY+BvkFq4/O
 QC1ESuRcEbZh+LGbqquZRoCSEMPzunLi6lqHtHwAFJAbB9GDcuqTSe25XTsAYYmmKXVZ 6g== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33m9fmt9er-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Thu, 17 Sep 2020 11:29:36 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08HFLkIA024291
        for <stable@vger.kernel.org>; Thu, 17 Sep 2020 15:29:34 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 33ku33s5e2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Thu, 17 Sep 2020 15:29:34 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08HFTVFQ30081280
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Sep 2020 15:29:32 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D240842047;
        Thu, 17 Sep 2020 15:29:31 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 194794203F;
        Thu, 17 Sep 2020 15:29:31 +0000 (GMT)
Received: from funtu.home (unknown [9.171.41.79])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 17 Sep 2020 15:29:31 +0000 (GMT)
Subject: Re: [PATCH] s390/pkey: fix paes selftest failure with paes and pkey
 static build
To:     Ingo Franzki <ifranzki@linux.ibm.com>,
        linux390-list@tuxmaker.boeblingen.de.ibm.com
Cc:     Alexander.Egorenkov@ibm.com, Stable <stable@vger.kernel.org>
References: <20200915092153.5483-1-freude@linux.ibm.com>
 <8337a2b6-42a8-ac82-5ce8-356f33a31b2e@linux.ibm.com>
From:   Harald Freudenberger <freude@linux.ibm.com>
Message-ID: <580ae7f9-293b-49a7-1851-7137c6dae917@linux.ibm.com>
Date:   Thu, 17 Sep 2020 17:29:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <8337a2b6-42a8-ac82-5ce8-356f33a31b2e@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-17_10:2020-09-16,2020-09-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 priorityscore=1501 clxscore=1015
 impostorscore=0 lowpriorityscore=0 adultscore=0 mlxlogscore=999
 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009170113
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 17.09.20 17:01, Ingo Franzki wrote:
> On 15.09.2020 11:21, Harald Freudenberger wrote:
>> When both the paes and the pkey kernel module are statically build
>> into the kernel, the paes cipher selftests run before the pkey
>> kernel module is initialized. So a static variable set in the pkey
>> init function and used in the pkey_clr2protkey function is not
>> initialized when the paes cipher's selftests request to call pckmo for
>> transforming a clear key value into a protected key.
>>
>> This patch moves the initial setup of the static variable into
>> the function pck_clr2protkey. So it's possible, to use the function
>> for transforming a clear to a protected key even before the pkey
>> init function has been called and the paes selftests may run
>> successful.
>>
>> Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
>> Reported-by: Alexander Egorenkov <Alexander.Egorenkov@ibm.com>
>> Cc: Stable <stable@vger.kernel.org>
>> ---
>>  drivers/s390/crypto/pkey_api.c | 30 ++++++++++++++++--------------
>>  1 file changed, 16 insertions(+), 14 deletions(-)
>>
>> diff --git a/drivers/s390/crypto/pkey_api.c b/drivers/s390/crypto/pkey_api.c
>> index 490917cd44d0..5f75c9dfe071 100644
>> --- a/drivers/s390/crypto/pkey_api.c
>> +++ b/drivers/s390/crypto/pkey_api.c
>> @@ -34,9 +34,6 @@ MODULE_DESCRIPTION("s390 protected key interface");
>>  #define KEYBLOBBUFSIZE 8192  /* key buffer size used for internal processing */
>>  #define MAXAPQNSINLIST 64    /* max 64 apqns within a apqn list */
>>  
>> -/* mask of available pckmo subfunctions, fetched once at module init */
>> -static cpacf_mask_t pckmo_functions;
>> -
>>  /*
>>   * debug feature data and functions
>>   */
>> @@ -90,6 +87,9 @@ static int pkey_clr2protkey(u32 keytype,
>>  			    const struct pkey_clrkey *clrkey,
>>  			    struct pkey_protkey *protkey)
>>  {
>> +	/* mask of available pckmo subfunctions */
>> +	static cpacf_mask_t pckmo_functions;
>> +
>>  	long fc;
>>  	int keysize;
>>  	u8 paramblock[64];
>> @@ -113,11 +113,13 @@ static int pkey_clr2protkey(u32 keytype,
>>  		return -EINVAL;
>>  	}
>>  
>> -	/*
>> -	 * Check if the needed pckmo subfunction is available.
>> -	 * These subfunctions can be enabled/disabled by customers
>> -	 * in the LPAR profile or may even change on the fly.
>> -	 */
>> +	/* did we already check for PCKMO ? */
>> +	if (!pckmo_functions.bytes[0]) {
>> +		/* no, so check now */
>> +		if (!cpacf_query(CPACF_PCKMO, &pckmo_functions))
>> +			return -ENODEV;
>> +	}
> Does this need a lock here? What if 2 processes or threads call this concurrently? 
> Certainly the cpacf_query will produce the same result, but updating static pckmo_functions concurrently might cause problems.
I'd say as long as both concurrent threads will fetch the very same value - No, even if the update is not done atomically.
For example:
  u64 blubber[2] = { 0, 0 };
  // thread 1 updates blubber but unfortunately not in an atomic way:
  blubber[0] = 0x1122334455667788;
  // now interrupted by thread 2 which updates blubber now:
  blubber[1] = 0x8877665544332211;
  blubber[0] = 0x1122334455667788;
  // and finally thread1 comes again and does the 2. half of the update:
  blubber[1] = 0x8877665544332211;
even if you reshuffle this the result is the very same as long as both threads
update blubber WITH THE SAME VALUE.
For a different value, I do agree some kind of locking is needed.
At least this is my understanding...
>> +	/* check for the pckmo subfunction we need now */
>>  	if (!cpacf_test_func(&pckmo_functions, fc)) {
>>  		DEBUG_ERR("%s pckmo functions not available\n", __func__);
>>  		return -ENODEV;
>> @@ -1853,7 +1855,7 @@ static struct miscdevice pkey_dev = {
>>   */
>>  static int __init pkey_init(void)
>>  {
>> -	cpacf_mask_t kmc_functions;
>> +	cpacf_mask_t func_mask;
>>  
>>  	/*
>>  	 * The pckmo instruction should be available - even if we don't
>> @@ -1861,15 +1863,15 @@ static int __init pkey_init(void)
>>  	 * is also the minimum level for the kmc instructions which
>>  	 * are able to work with protected keys.
>>  	 */
>> -	if (!cpacf_query(CPACF_PCKMO, &pckmo_functions))
>> +	if (!cpacf_query(CPACF_PCKMO, &func_mask))
>>  		return -ENODEV;
>>  
>>  	/* check for kmc instructions available */
>> -	if (!cpacf_query(CPACF_KMC, &kmc_functions))
>> +	if (!cpacf_query(CPACF_KMC, &func_mask))
>>  		return -ENODEV;
>> -	if (!cpacf_test_func(&kmc_functions, CPACF_KMC_PAES_128) ||
>> -	    !cpacf_test_func(&kmc_functions, CPACF_KMC_PAES_192) ||
>> -	    !cpacf_test_func(&kmc_functions, CPACF_KMC_PAES_256))
>> +	if (!cpacf_test_func(&func_mask, CPACF_KMC_PAES_128) ||
>> +	    !cpacf_test_func(&func_mask, CPACF_KMC_PAES_192) ||
>> +	    !cpacf_test_func(&func_mask, CPACF_KMC_PAES_256))
>>  		return -ENODEV;
>>  
>>  	pkey_debug_init();
>>
>
