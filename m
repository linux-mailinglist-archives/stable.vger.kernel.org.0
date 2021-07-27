Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 684143D6FA9
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 08:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235510AbhG0GtZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 02:49:25 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:9736 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235205AbhG0GtZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 02:49:25 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R6YZZr031688;
        Tue, 27 Jul 2021 02:49:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=4gKl0q2cCG3K0uWmHofx3rjoSMwefxziUQ3VJpNnV4w=;
 b=du6MRDY0J1mBENbGmQ6B5qGjstjN5EpVK/im5p0EwHOo9F//VUIWoNubMWsbZ5aGfhxF
 Z7WLvZ0A5sBT/rvP1vurgPr442mLyrK5TSrRZf8CmbUTpNEUto+QuKN/sIZ+Jge78iEA
 eJkvcBbkrJEtzwKh4SsiaNzd2F+K+av+O539a8vNKcF6uL4APDa67jxeHitgwm1bGNce
 UWj8UeGZ3VUmBf8wgrl4J/K5VCX1iLcuchyvHDkuQFuLmTa5kC/RtJ8rE5QvF9gsgm9C
 jTLium8IKThP6vv7KadyvS7i7tPcyt5XykVWvyyffIuMl6Um16YBIYWoBCuITjLlMX7q KA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a2d080qa9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Jul 2021 02:49:14 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16R6Ynl7033625;
        Tue, 27 Jul 2021 02:49:13 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a2d080q92-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Jul 2021 02:49:13 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16R6CSpi027171;
        Tue, 27 Jul 2021 06:49:11 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3a235m07db-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Jul 2021 06:49:11 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16R6n8Zv28311894
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Jul 2021 06:49:08 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 932F0A4062;
        Tue, 27 Jul 2021 06:49:08 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA1CEA405B;
        Tue, 27 Jul 2021 06:49:05 +0000 (GMT)
Received: from [9.199.45.94] (unknown [9.199.45.94])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 27 Jul 2021 06:49:05 +0000 (GMT)
Subject: Re: [PATCH] cpufreq:powernv: Fix init_chip_info initialization in
 numa=off
To:     ego@linux.vnet.ibm.com
Cc:     mpe@ellerman.id.au, rjw@rjwysocki.net, linux-pm@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, pratik.r.sampat@gmail.com
References: <20210726170758.61041-1-psampat@linux.ibm.com>
 <20210727061656.GA10282@in.ibm.com>
From:   Pratik Sampat <psampat@linux.ibm.com>
Message-ID: <60aaa78a-ece1-73d2-ea4c-e3835a6e3ab8@linux.ibm.com>
Date:   Tue, 27 Jul 2021 12:19:04 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210727061656.GA10282@in.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 2wm48rhKY5L38nFjNAYG_fYMRPhOJ6TD
X-Proofpoint-GUID: rpSxo2XOqTUJmE7fJEZ_NqTsKBv5681R
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-27_04:2021-07-27,2021-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 clxscore=1015
 priorityscore=1501 suspectscore=0 mlxscore=0 bulkscore=0 adultscore=0
 impostorscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2107270038
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 27/07/21 11:46 am, Gautham R Shenoy wrote:
> On Mon, Jul 26, 2021 at 10:37:57PM +0530, Pratik R. Sampat wrote:
>> In the numa=off kernel command-line configuration init_chip_info() loops
>> around the number of chips and attempts to copy the cpumask of that node
>> which is NULL for all iterations after the first chip.
>>
>> Hence, store the cpu mask for each chip instead of derving cpumask from
>> node while populating the "chips" struct array and copy that to the
>> chips[i].mask
>>
>> Cc: stable@vger.kernel.org
>> Fixes: 053819e0bf84 ("cpufreq: powernv: Handle throttling due to Pmax capping at chip level")
>> Signed-off-by: Pratik R. Sampat <psampat@linux.ibm.com>
>> Reported-by: Shirisha Ganta <shirisha.ganta1@ibm.com>
>> ---
>>   drivers/cpufreq/powernv-cpufreq.c | 15 +++++++++++++--
>>   1 file changed, 13 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/cpufreq/powernv-cpufreq.c b/drivers/cpufreq/powernv-cpufreq.c
>> index 005600cef273..8ec10d9aed8f 100644
>> --- a/drivers/cpufreq/powernv-cpufreq.c
>> +++ b/drivers/cpufreq/powernv-cpufreq.c
>> @@ -1046,12 +1046,20 @@ static int init_chip_info(void)
>>   	unsigned int *chip;
>>   	unsigned int cpu, i;
>>   	unsigned int prev_chip_id = UINT_MAX;
>> +	cpumask_t *chip_cpu_mask;
>>   	int ret = 0;
>>
>>   	chip = kcalloc(num_possible_cpus(), sizeof(*chip), GFP_KERNEL);
>>   	if (!chip)
>>   		return -ENOMEM;
>>
>> +	/* Allocate a chip cpu mask large enough to fit mask for all chips */
>> +	chip_cpu_mask = kcalloc(32, sizeof(cpumask_t), GFP_KERNEL);
> I suppose by 32 you mean the maximum number of chips possible. You
> could use a #define for that.

ack, I could #define the constant.

> Otherwise, the patch looks good to me.
>
> Reviewed-by: Gautham R. Shenoy <ego@linux.vnet.ibm.com>
>
Thanks
Pratik

>
>> +	if (!chip_cpu_mask) {
>> +		ret = -ENOMEM;
>> +		goto free_and_return;
>> +	}
>> +
>>   	for_each_possible_cpu(cpu) {
>>   		unsigned int id = cpu_to_chip_id(cpu);
>>
>> @@ -1059,22 +1067,25 @@ static int init_chip_info(void)
>>   			prev_chip_id = id;
>>   			chip[nr_chips++] = id;
>>   		}
>> +		cpumask_set_cpu(cpu, &chip_cpu_mask[nr_chips-1]);
>>   	}
>>
>>   	chips = kcalloc(nr_chips, sizeof(struct chip), GFP_KERNEL);
>>   	if (!chips) {
>>   		ret = -ENOMEM;
>> -		goto free_and_return;
>> +		goto out_chip_cpu_mask;
>>   	}
>>
>>   	for (i = 0; i < nr_chips; i++) {
>>   		chips[i].id = chip[i];
>> -		cpumask_copy(&chips[i].mask, cpumask_of_node(chip[i]));
>> +		cpumask_copy(&chips[i].mask, &chip_cpu_mask[i]);
>>   		INIT_WORK(&chips[i].throttle, powernv_cpufreq_work_fn);
>>   		for_each_cpu(cpu, &chips[i].mask)
>>   			per_cpu(chip_info, cpu) =  &chips[i];
>>   	}
>>
>> +out_chip_cpu_mask:
>> +	kfree(chip_cpu_mask);
>>   free_and_return:
>>   	kfree(chip);
>>   	return ret;
>> -- 
>> 2.31.1
>>

