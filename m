Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 069CF3D6F12
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 08:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234226AbhG0GRQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 02:17:16 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54172 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234928AbhG0GRO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 02:17:14 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R6DtCQ020751;
        Tue, 27 Jul 2021 02:17:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : reply-to : references : mime-version : content-type
 : in-reply-to; s=pp1; bh=8XeYG3yg7Vf01LhGV5Z7bYY22GMqXf1CPu6wzVsB1Bw=;
 b=AZfa2557qPr1YpYZlnyMIx50kjsTSzuPoOe2XJBJqPGvM1QBQihdzbyH9JY7CiDidF96
 2cH1GmSTibYpOyrZ/c9/Gl8QASw8E9gt4AKNffMlmXZC0+9fTN6zUklsKNUvPrX6Xlmp
 5vxNQuQgKBKxIibXhmhlUIMd9XANIZC2HkOymFZ6bBEzLJz+mWiHtLxfyTd2CF179m0O
 JQgIKRTQmWLCeJClEJuoqknSsJ6M8q4gYlOz+Q2PZcPK/eYD0dwOogv1d0Zdy+FYN/dB
 qa6uIi/CXatupy05awUrmBincG7YjEEh1JEgCd6mrCwtVaLXJ1gn9knvAMavhuWPmGv8 cg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3a2cph02pj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Jul 2021 02:17:02 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16R6E1g9020876;
        Tue, 27 Jul 2021 02:17:01 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3a2cph02p9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Jul 2021 02:17:01 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16R62PBG004810;
        Tue, 27 Jul 2021 06:17:01 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma03dal.us.ibm.com with ESMTP id 3a235nhbx3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Jul 2021 06:17:01 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16R6H0oJ31457626
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Jul 2021 06:17:00 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5F58FAC05E;
        Tue, 27 Jul 2021 06:17:00 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EEFA3AC066;
        Tue, 27 Jul 2021 06:16:59 +0000 (GMT)
Received: from sofia.ibm.com (unknown [9.85.71.190])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 27 Jul 2021 06:16:59 +0000 (GMT)
Received: by sofia.ibm.com (Postfix, from userid 1000)
        id 4A24D2E4A4C; Tue, 27 Jul 2021 11:46:56 +0530 (IST)
Date:   Tue, 27 Jul 2021 11:46:56 +0530
From:   Gautham R Shenoy <ego@linux.vnet.ibm.com>
To:     "Pratik R. Sampat" <psampat@linux.ibm.com>
Cc:     mpe@ellerman.id.au, rjw@rjwysocki.net, linux-pm@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, pratik.r.sampat@gmail.com
Subject: Re: [PATCH] cpufreq:powernv: Fix init_chip_info initialization in
 numa=off
Message-ID: <20210727061656.GA10282@in.ibm.com>
Reply-To: ego@linux.vnet.ibm.com
References: <20210726170758.61041-1-psampat@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726170758.61041-1-psampat@linux.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: TBFUlIHCqR60qHwztg6isWZ6lxfaWg_M
X-Proofpoint-GUID: JOA9zxu-8QY3hhlblipMVVHkB5WwXOxu
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-27_04:2021-07-27,2021-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 mlxlogscore=999 mlxscore=0 lowpriorityscore=0 malwarescore=0
 spamscore=0 adultscore=0 suspectscore=0 impostorscore=0 clxscore=1011
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107270035
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 26, 2021 at 10:37:57PM +0530, Pratik R. Sampat wrote:
> In the numa=off kernel command-line configuration init_chip_info() loops
> around the number of chips and attempts to copy the cpumask of that node
> which is NULL for all iterations after the first chip.
> 
> Hence, store the cpu mask for each chip instead of derving cpumask from
> node while populating the "chips" struct array and copy that to the
> chips[i].mask
> 
> Cc: stable@vger.kernel.org
> Fixes: 053819e0bf84 ("cpufreq: powernv: Handle throttling due to Pmax capping at chip level")
> Signed-off-by: Pratik R. Sampat <psampat@linux.ibm.com>
> Reported-by: Shirisha Ganta <shirisha.ganta1@ibm.com>
> ---
>  drivers/cpufreq/powernv-cpufreq.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/cpufreq/powernv-cpufreq.c b/drivers/cpufreq/powernv-cpufreq.c
> index 005600cef273..8ec10d9aed8f 100644
> --- a/drivers/cpufreq/powernv-cpufreq.c
> +++ b/drivers/cpufreq/powernv-cpufreq.c
> @@ -1046,12 +1046,20 @@ static int init_chip_info(void)
>  	unsigned int *chip;
>  	unsigned int cpu, i;
>  	unsigned int prev_chip_id = UINT_MAX;
> +	cpumask_t *chip_cpu_mask;
>  	int ret = 0;
> 
>  	chip = kcalloc(num_possible_cpus(), sizeof(*chip), GFP_KERNEL);
>  	if (!chip)
>  		return -ENOMEM;
> 
> +	/* Allocate a chip cpu mask large enough to fit mask for all chips */
> +	chip_cpu_mask = kcalloc(32, sizeof(cpumask_t), GFP_KERNEL);

I suppose by 32 you mean the maximum number of chips possible. You
could use a #define for that.

Otherwise, the patch looks good to me.

Reviewed-by: Gautham R. Shenoy <ego@linux.vnet.ibm.com>



> +	if (!chip_cpu_mask) {
> +		ret = -ENOMEM;
> +		goto free_and_return;
> +	}
> +
>  	for_each_possible_cpu(cpu) {
>  		unsigned int id = cpu_to_chip_id(cpu);
> 
> @@ -1059,22 +1067,25 @@ static int init_chip_info(void)
>  			prev_chip_id = id;
>  			chip[nr_chips++] = id;
>  		}
> +		cpumask_set_cpu(cpu, &chip_cpu_mask[nr_chips-1]);
>  	}
> 
>  	chips = kcalloc(nr_chips, sizeof(struct chip), GFP_KERNEL);
>  	if (!chips) {
>  		ret = -ENOMEM;
> -		goto free_and_return;
> +		goto out_chip_cpu_mask;
>  	}
> 
>  	for (i = 0; i < nr_chips; i++) {
>  		chips[i].id = chip[i];
> -		cpumask_copy(&chips[i].mask, cpumask_of_node(chip[i]));
> +		cpumask_copy(&chips[i].mask, &chip_cpu_mask[i]);
>  		INIT_WORK(&chips[i].throttle, powernv_cpufreq_work_fn);
>  		for_each_cpu(cpu, &chips[i].mask)
>  			per_cpu(chip_info, cpu) =  &chips[i];
>  	}
> 
> +out_chip_cpu_mask:
> +	kfree(chip_cpu_mask);
>  free_and_return:
>  	kfree(chip);
>  	return ret;
> -- 
> 2.31.1
> 
