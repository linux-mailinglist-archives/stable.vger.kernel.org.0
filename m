Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0FE59DE7D
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359271AbiHWMDa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 08:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359423AbiHWMBb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 08:01:31 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49927D9EA2;
        Tue, 23 Aug 2022 02:35:49 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27N9TmKA028318;
        Tue, 23 Aug 2022 09:34:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=Tf58FBj9C+gr8HRvmrfWvxzYRRXjuv6GKQMa42lNiwA=;
 b=mQoKDmnNc5Rb+SUlygyPSlS7T1lX3DJIiG+7V2knwrkXbA0eaCsWCA5dlf9QHWTwdEL3
 7mM37FY4J6aCnN18tOEhMLdFJJ9G5pg0CxYGakPbGRAHSCelp6T6OPvAnBMw69cZEs7G
 GglApbUboSAN6JmTDWi695xORxu+eeufnq86zpTHnTHAQ1fd3UAbDvOjWwFmcKdaedPp
 1nXEucQBTS589IAMZjLQ3Ccjt0qze6SiFbtMKyS+8f3PIT3xSPCOHO1n7Uu4y4Dcgc74
 55NgRlF2HXIqyKjuCbL3zsWJ1no15/2w4Ga4qAJTz0Xyaf/CQBF1d0wiWG67nWDNrj/r 3A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3j4vahr34c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 09:34:22 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27N9UXTX031257;
        Tue, 23 Aug 2022 09:34:21 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3j4vahr33u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 09:34:21 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27N9LJ2E022456;
        Tue, 23 Aug 2022 09:34:19 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 3j2q88tk74-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 09:34:19 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27N9YGZp31719908
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Aug 2022 09:34:17 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DD4E2A404D;
        Tue, 23 Aug 2022 09:34:16 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 682B4A4040;
        Tue, 23 Aug 2022 09:34:16 +0000 (GMT)
Received: from [9.101.4.33] (unknown [9.101.4.33])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 23 Aug 2022 09:34:16 +0000 (GMT)
Message-ID: <351ecdfe-0ec3-c9c3-0dd7-b35b31b3bdd0@linux.ibm.com>
Date:   Tue, 23 Aug 2022 11:34:15 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.1.2
Subject: Re: [PATCH AUTOSEL 5.15 14/28] watchdog: export
 lockup_detector_reconfigure
Content-Language: fr
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Michael Ellerman <mpe@ellerman.id.au>, pmladek@suse.com,
        akpm@linux-foundation.org, juri.lelli@redhat.com, pauld@redhat.com,
        nixiaoming@huawei.com, john.ogness@linutronix.de,
        frederic@kernel.org, linux@rasmusvillemoes.dk
References: <20220814162610.2397644-1-sashal@kernel.org>
 <20220814162610.2397644-14-sashal@kernel.org>
From:   Laurent Dufour <ldufour@linux.ibm.com>
In-Reply-To: <20220814162610.2397644-14-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: lEUbdWLuNKnd5cxXvimzBs2fUoqcb_OG
X-Proofpoint-GUID: xLS52vkRAzjWIARcXEiIFGlZMxJXNFLJ
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-23_04,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 spamscore=0 priorityscore=1501 bulkscore=0 mlxscore=0
 adultscore=0 impostorscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0
 clxscore=1031 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208230036
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Le 14/08/2022 à 18:25, Sasha Levin a écrit :
> From: Laurent Dufour <ldufour@linux.ibm.com>
> 
> [ Upstream commit 7c56a8733d0a2a4be2438a7512566e5ce552fccf ]

Hi Sasha,

Thanks for picking this patch.

Do you plan to pick the 2 others patches of this series in the older
kernels, as you did for 5.18 and 5.19 ?

The 2 other patches in this series are:
118b1366930c ("powerpc/pseries/mobility: set NMI watchdog factor during an
LPM")
f5e74e836097 ("powerpc/watchdog: introduce a NMI watchdog's factor")

I'm not sure how well they apply to these older kernels.

Thanks,
Laurent.

> 
> In some circumstances it may be interesting to reconfigure the watchdog
> from inside the kernel.
> 
> On PowerPC, this may helpful before and after a LPAR migration (LPM) is
> initiated, because it implies some latencies, watchdog, and especially NMI
> watchdog is expected to be triggered during this operation. Reconfiguring
> the watchdog with a factor, would prevent it to happen too frequently
> during LPM.
> 
> Rename lockup_detector_reconfigure() as __lockup_detector_reconfigure() and
> create a new function lockup_detector_reconfigure() calling
> __lockup_detector_reconfigure() under the protection of watchdog_mutex.
> 
> Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
> [mpe: Squash in build fix from Laurent, reported by Sachin]
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> Link: https://lore.kernel.org/r/20220713154729.80789-3-ldufour@linux.ibm.com
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  include/linux/nmi.h |  2 ++
>  kernel/watchdog.c   | 21 ++++++++++++++++-----
>  2 files changed, 18 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/nmi.h b/include/linux/nmi.h
> index 750c7f395ca9..f700ff2df074 100644
> --- a/include/linux/nmi.h
> +++ b/include/linux/nmi.h
> @@ -122,6 +122,8 @@ int watchdog_nmi_probe(void);
>  int watchdog_nmi_enable(unsigned int cpu);
>  void watchdog_nmi_disable(unsigned int cpu);
>  
> +void lockup_detector_reconfigure(void);
> +
>  /**
>   * touch_nmi_watchdog - restart NMI watchdog timeout.
>   *
> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> index ad912511a0c0..1cfa269bd448 100644
> --- a/kernel/watchdog.c
> +++ b/kernel/watchdog.c
> @@ -537,7 +537,7 @@ int lockup_detector_offline_cpu(unsigned int cpu)
>  	return 0;
>  }
>  
> -static void lockup_detector_reconfigure(void)
> +static void __lockup_detector_reconfigure(void)
>  {
>  	cpus_read_lock();
>  	watchdog_nmi_stop();
> @@ -557,6 +557,13 @@ static void lockup_detector_reconfigure(void)
>  	__lockup_detector_cleanup();
>  }
>  
> +void lockup_detector_reconfigure(void)
> +{
> +	mutex_lock(&watchdog_mutex);
> +	__lockup_detector_reconfigure();
> +	mutex_unlock(&watchdog_mutex);
> +}
> +
>  /*
>   * Create the watchdog infrastructure and configure the detector(s).
>   */
> @@ -573,13 +580,13 @@ static __init void lockup_detector_setup(void)
>  		return;
>  
>  	mutex_lock(&watchdog_mutex);
> -	lockup_detector_reconfigure();
> +	__lockup_detector_reconfigure();
>  	softlockup_initialized = true;
>  	mutex_unlock(&watchdog_mutex);
>  }
>  
>  #else /* CONFIG_SOFTLOCKUP_DETECTOR */
> -static void lockup_detector_reconfigure(void)
> +static void __lockup_detector_reconfigure(void)
>  {
>  	cpus_read_lock();
>  	watchdog_nmi_stop();
> @@ -587,9 +594,13 @@ static void lockup_detector_reconfigure(void)
>  	watchdog_nmi_start();
>  	cpus_read_unlock();
>  }
> +void lockup_detector_reconfigure(void)
> +{
> +	__lockup_detector_reconfigure();
> +}
>  static inline void lockup_detector_setup(void)
>  {
> -	lockup_detector_reconfigure();
> +	__lockup_detector_reconfigure();
>  }
>  #endif /* !CONFIG_SOFTLOCKUP_DETECTOR */
>  
> @@ -629,7 +640,7 @@ static void proc_watchdog_update(void)
>  {
>  	/* Remove impossible cpus to keep sysctl output clean. */
>  	cpumask_and(&watchdog_cpumask, &watchdog_cpumask, cpu_possible_mask);
> -	lockup_detector_reconfigure();
> +	__lockup_detector_reconfigure();
>  }
>  
>  /*

