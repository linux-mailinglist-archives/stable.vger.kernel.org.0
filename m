Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFADE26DFD3
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 17:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727966AbgIQPlL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 11:41:11 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60080 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728013AbgIQPX5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Sep 2020 11:23:57 -0400
X-Greylist: delayed 1309 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 11:23:56 EDT
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08HF0W8A159948
        for <stable@vger.kernel.org>; Thu, 17 Sep 2020 11:01:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=q0FgFp8xFHwNyM9AGWpcsO7DZ04d2ykFyZgRHcqZ7Kw=;
 b=TGTUw8h06BxyHFMUvmVj91r2nUe4SiVdAFW0WplRESzsAC7a34AlG2k+x2VxL5GanXNZ
 6FcL9saRQKgZTI2moxlExnhTvqr1NTp9/O7ibMrikJHlBE2dVIX1+BbcYc7azuer2gNv
 jkSgz9Ds+RHil/J8WPzCgjRz5M9xrw2z05VRFT3R9kH0sPipo4IvDYai5nqYNT+KVdxN
 WDAd3nSbNfkXvi6QCtx6Uqwmef5Qj/yZoQjTnyIP1yTVqXyA2XiG1PHMRL1E2uL2oeJu
 sXGm1PmXjfv4lrHgjbC4HM8lwLUrk88pPK9pGTQqbD1fhTTX63yVPL3tr8WIJzzAylK0 gg== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33m9nt8v59-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Thu, 17 Sep 2020 11:01:54 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08HF1ddO022058
        for <stable@vger.kernel.org>; Thu, 17 Sep 2020 15:01:51 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 33ku33s4n6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Thu, 17 Sep 2020 15:01:51 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08HF0EIW19857858
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Sep 2020 15:00:15 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3FB5E5204F;
        Thu, 17 Sep 2020 15:01:49 +0000 (GMT)
Received: from [9.211.43.110] (unknown [9.211.43.110])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 39AC752052;
        Thu, 17 Sep 2020 15:01:46 +0000 (GMT)
Subject: Re: [PATCH] s390/pkey: fix paes selftest failure with paes and pkey
 static build
To:     Harald Freudenberger <freude@linux.ibm.com>,
        linux390-list@tuxmaker.boeblingen.de.ibm.com
Cc:     Alexander.Egorenkov@ibm.com, Stable <stable@vger.kernel.org>
References: <20200915092153.5483-1-freude@linux.ibm.com>
From:   Ingo Franzki <ifranzki@linux.ibm.com>
Message-ID: <8337a2b6-42a8-ac82-5ce8-356f33a31b2e@linux.ibm.com>
Date:   Thu, 17 Sep 2020 17:01:44 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200915092153.5483-1-freude@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-17_10:2020-09-16,2020-09-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 bulkscore=0 adultscore=0 impostorscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 spamscore=0 mlxscore=0 clxscore=1011
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009170113
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 15.09.2020 11:21, Harald Freudenberger wrote:
> When both the paes and the pkey kernel module are statically build
> into the kernel, the paes cipher selftests run before the pkey
> kernel module is initialized. So a static variable set in the pkey
> init function and used in the pkey_clr2protkey function is not
> initialized when the paes cipher's selftests request to call pckmo for
> transforming a clear key value into a protected key.
> 
> This patch moves the initial setup of the static variable into
> the function pck_clr2protkey. So it's possible, to use the function
> for transforming a clear to a protected key even before the pkey
> init function has been called and the paes selftests may run
> successful.
> 
> Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
> Reported-by: Alexander Egorenkov <Alexander.Egorenkov@ibm.com>
> Cc: Stable <stable@vger.kernel.org>
> ---
>  drivers/s390/crypto/pkey_api.c | 30 ++++++++++++++++--------------
>  1 file changed, 16 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/s390/crypto/pkey_api.c b/drivers/s390/crypto/pkey_api.c
> index 490917cd44d0..5f75c9dfe071 100644
> --- a/drivers/s390/crypto/pkey_api.c
> +++ b/drivers/s390/crypto/pkey_api.c
> @@ -34,9 +34,6 @@ MODULE_DESCRIPTION("s390 protected key interface");
>  #define KEYBLOBBUFSIZE 8192  /* key buffer size used for internal processing */
>  #define MAXAPQNSINLIST 64    /* max 64 apqns within a apqn list */
>  
> -/* mask of available pckmo subfunctions, fetched once at module init */
> -static cpacf_mask_t pckmo_functions;
> -
>  /*
>   * debug feature data and functions
>   */
> @@ -90,6 +87,9 @@ static int pkey_clr2protkey(u32 keytype,
>  			    const struct pkey_clrkey *clrkey,
>  			    struct pkey_protkey *protkey)
>  {
> +	/* mask of available pckmo subfunctions */
> +	static cpacf_mask_t pckmo_functions;
> +
>  	long fc;
>  	int keysize;
>  	u8 paramblock[64];
> @@ -113,11 +113,13 @@ static int pkey_clr2protkey(u32 keytype,
>  		return -EINVAL;
>  	}
>  
> -	/*
> -	 * Check if the needed pckmo subfunction is available.
> -	 * These subfunctions can be enabled/disabled by customers
> -	 * in the LPAR profile or may even change on the fly.
> -	 */
> +	/* did we already check for PCKMO ? */
> +	if (!pckmo_functions.bytes[0]) {
> +		/* no, so check now */
> +		if (!cpacf_query(CPACF_PCKMO, &pckmo_functions))
> +			return -ENODEV;
> +	}
Does this need a lock here? What if 2 processes or threads call this concurrently? 
Certainly the cpacf_query will produce the same result, but updating static pckmo_functions concurrently might cause problems.
> +	/* check for the pckmo subfunction we need now */
>  	if (!cpacf_test_func(&pckmo_functions, fc)) {
>  		DEBUG_ERR("%s pckmo functions not available\n", __func__);
>  		return -ENODEV;
> @@ -1853,7 +1855,7 @@ static struct miscdevice pkey_dev = {
>   */
>  static int __init pkey_init(void)
>  {
> -	cpacf_mask_t kmc_functions;
> +	cpacf_mask_t func_mask;
>  
>  	/*
>  	 * The pckmo instruction should be available - even if we don't
> @@ -1861,15 +1863,15 @@ static int __init pkey_init(void)
>  	 * is also the minimum level for the kmc instructions which
>  	 * are able to work with protected keys.
>  	 */
> -	if (!cpacf_query(CPACF_PCKMO, &pckmo_functions))
> +	if (!cpacf_query(CPACF_PCKMO, &func_mask))
>  		return -ENODEV;
>  
>  	/* check for kmc instructions available */
> -	if (!cpacf_query(CPACF_KMC, &kmc_functions))
> +	if (!cpacf_query(CPACF_KMC, &func_mask))
>  		return -ENODEV;
> -	if (!cpacf_test_func(&kmc_functions, CPACF_KMC_PAES_128) ||
> -	    !cpacf_test_func(&kmc_functions, CPACF_KMC_PAES_192) ||
> -	    !cpacf_test_func(&kmc_functions, CPACF_KMC_PAES_256))
> +	if (!cpacf_test_func(&func_mask, CPACF_KMC_PAES_128) ||
> +	    !cpacf_test_func(&func_mask, CPACF_KMC_PAES_192) ||
> +	    !cpacf_test_func(&func_mask, CPACF_KMC_PAES_256))
>  		return -ENODEV;
>  
>  	pkey_debug_init();
> 


-- 
Ingo Franzki
eMail: ifranzki@linux.ibm.com  
Tel: ++49 (0)7031-16-4648
Fax: ++49 (0)7031-16-3456
Linux on IBM Z Development, Schoenaicher Str. 220, 71032 Boeblingen, Germany

IBM Deutschland Research & Development GmbH / Vorsitzender des Aufsichtsrats: Matthias Hartmann
Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: Amtsgericht Stuttgart, HRB 243294
IBM DATA Privacy Statement: https://www.ibm.com/privacy/us/en/
