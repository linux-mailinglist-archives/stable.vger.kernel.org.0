Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE0F54EF25
	for <lists+stable@lfdr.de>; Fri, 17 Jun 2022 04:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379582AbiFQCKk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 22:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378609AbiFQCKj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 22:10:39 -0400
Received: from progateway7-pub.mail.pro1.eigbox.com (gproxy5-pub.mail.unifiedlayer.com [67.222.38.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4901564BC9
        for <stable@vger.kernel.org>; Thu, 16 Jun 2022 19:10:39 -0700 (PDT)
Received: from cmgw15.mail.unifiedlayer.com (unknown [10.0.90.130])
        by progateway7.mail.pro1.eigbox.com (Postfix) with ESMTP id 6DC1C10048319
        for <stable@vger.kernel.org>; Fri, 17 Jun 2022 02:10:38 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
        by cmsmtp with ESMTP
        id 21RVoKbpcecv921RWoelQR; Fri, 17 Jun 2022 02:10:38 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=J/5vUCrS c=1 sm=1 tr=0 ts=62abe29e
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10:nop_charset_1
 a=JPEYwPQDsx4A:10:nop_rcvd_month_year
 a=-Ou01B_BuAIA:10:endurance_base64_authed_username_1 a=VwQbUJbxAAAA:8
 a=Ikd4Dj_1AAAA:8 a=HaFmDPmJAAAA:8 a=UGG5zPGqAAAA:8 a=Ya-HtxX5zRGB2Al-8G4A:9
 a=QEXdDO2ut3YA:10:nop_charset_2 a=AjGcO6oz07-iQ99wixmX:22
 a=nmWuMzfKamIsx3l42hEX:22 a=17ibUXfGiVyGqR_YBevW:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
        s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:In-Reply-To:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=OrqZ5LGlxlFOVquUDVyuhvmjfqRySOJhv2yBIb+Vw3w=; b=RerQUGOoYsLIzu+o696/2vOscO
        8jzMm6pZo1Z674db2WIWABm1Vfw+jQl0gRutz6YZd1So75wvZ4CKS3XHiIVFINe7ILM1ieuc8Y4e8
        OkihOUIB2G0xsqf7T0j5cslfZ33oDOMg4VaA8IDW2n4XKogMwcjYGDfwwA+tdqFvJ5a1F8vksH9E+
        ADidj1J4pbQWgPHPU2Tv8Mqja27I7O4Yu63nwhqNbIDGZk1/WnGzCCWLAI0A09Yl7bpyZhydwGNxD
        w99gcYDEd0lleENONoDlBW+kzbdzJzMUJ+IgP4ZCkPWVjeKItXR+5Sa3v99WNxRuIVci4lfVas9dG
        uYW7qePg==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:44666 helo=[10.0.1.48])
        by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <re@w6rz.net>)
        id 1o21RV-001fkm-81;
        Thu, 16 Jun 2022 20:10:37 -0600
Subject: Re: [PATCH] random: quiet urandom warning ratelimit suppression
 message
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Jon Hunter <jonathanh@nvidia.com>
References: <81bda7cc-fd95-8f54-4ad7-3fad9a81b831@nvidia.com>
 <20220616132029.443033-1-Jason@zx2c4.com>
From:   Ron Economos <re@w6rz.net>
In-Reply-To: <20220616132029.443033-1-Jason@zx2c4.com>
Message-ID: <f4dc15ff-10cf-bb73-5f72-874dd2b85f1a@w6rz.net>
Date:   Thu, 16 Jun 2022 19:10:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux armv7l; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.162.232.9
X-Source-L: No
X-Exim-ID: 1o21RV-001fkm-81
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.48]) [73.162.232.9]:44666
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/16/22 6:20 AM, Jason A. Donenfeld wrote:
> random.c ratelimits how much it warns about uninitialized urandom reads
> using __ratelimit. When the RNG is finally initialized, it prints the
> number of missed messages due to ratelimiting.
>
> It has been this way since that functionality was introduced back in
> 2018. Recently, cc1e127bfa95 ("random: remove ratelimiting for in-kernel
> unseeded randomness") put a bit more stress on the urandom ratelimiting,
> which teased out a bug in the implementation.
>
> Specifically, when under pressure, __ratelimit() will print its own
> message and reset the count back to 0, making the final message at the
> end less useful. Secondly, it does so as a pr_warn(), which apparently
> is undesirable for people's CI.
>
> Fortunately, __ratelimit() has the RATELIMIT_MSG_ON_RELEASE flag exactly
> for this purpose, so we set the flag.
>
> Fixes: 4e00b339e264 ("random: rate limit unseeded randomness warnings")
> Cc: stable@vger.kernel.org
> Reported-by: Jon Hunter <jonathanh@nvidia.com>
> Reported-by: Ron Economos <re@w6rz.net>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>   drivers/char/random.c           |  2 +-
>   include/linux/ratelimit_types.h | 12 ++++++++----
>   2 files changed, 9 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/char/random.c b/drivers/char/random.c
> index d0e4c89c4fcb..07a022e24057 100644
> --- a/drivers/char/random.c
> +++ b/drivers/char/random.c
> @@ -87,7 +87,7 @@ static struct fasync_struct *fasync;
>   
>   /* Control how we warn userspace. */
>   static struct ratelimit_state urandom_warning =
> -	RATELIMIT_STATE_INIT("warn_urandom_randomness", HZ, 3);
> +	RATELIMIT_STATE_INIT_FLAGS("urandom_warning", HZ, 3, RATELIMIT_MSG_ON_RELEASE);
>   static int ratelimit_disable __read_mostly =
>   	IS_ENABLED(CONFIG_WARN_ALL_UNSEEDED_RANDOM);
>   module_param_named(ratelimit_disable, ratelimit_disable, int, 0644);
> diff --git a/include/linux/ratelimit_types.h b/include/linux/ratelimit_types.h
> index c21c7f8103e2..002266693e50 100644
> --- a/include/linux/ratelimit_types.h
> +++ b/include/linux/ratelimit_types.h
> @@ -23,12 +23,16 @@ struct ratelimit_state {
>   	unsigned long	flags;
>   };
>   
> -#define RATELIMIT_STATE_INIT(name, interval_init, burst_init) {		\
> -		.lock		= __RAW_SPIN_LOCK_UNLOCKED(name.lock),	\
> -		.interval	= interval_init,			\
> -		.burst		= burst_init,				\
> +#define RATELIMIT_STATE_INIT_FLAGS(name, interval_init, burst_init, flags_init) { \
> +		.lock		= __RAW_SPIN_LOCK_UNLOCKED(name.lock),		  \
> +		.interval	= interval_init,				  \
> +		.burst		= burst_init,					  \
> +		.flags		= flags_init,					  \
>   	}
>   
> +#define RATELIMIT_STATE_INIT(name, interval_init, burst_init) \
> +	RATELIMIT_STATE_INIT_FLAGS(name, interval_init, burst_init, 0)
> +
>   #define RATELIMIT_STATE_INIT_DISABLED					\
>   	RATELIMIT_STATE_INIT(ratelimit_state, 0, DEFAULT_RATELIMIT_BURST)
>   

Tested on 5.15.48 kernel for RISC-V RV64. Works good, urandom_read_iter 
warnings are suppressed.

Tested-by: Ron Economos <re@w6rz.net>

