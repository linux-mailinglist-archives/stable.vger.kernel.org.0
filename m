Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA6225FF7FB
	for <lists+stable@lfdr.de>; Sat, 15 Oct 2022 04:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbiJOCG7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 22:06:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiJOCG6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 22:06:58 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBFAE9AC22;
        Fri, 14 Oct 2022 19:06:56 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id o9-20020a17090a0a0900b0020ad4e758b3so6288919pjo.4;
        Fri, 14 Oct 2022 19:06:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rNklb0STZIX8NI4XxunDZJac08jSQZVvK8oerGbpjSU=;
        b=ZAPsEPW9ifAId8LrHMKs4xzG/ppkV8LBYkga94x6Y+zh+r/0cytqxKN07LqjB2ea0R
         KKhBouQsnvPbOUTxHmwycEOoXwK9X/IWc8pnHhXu0bKUrryRQGzCQVXWkaSckWj/YZnf
         KFd2DBGyW+h7+VNrbE53vqAgFoYociJhDSyBiKORopMjjIR10E8fInPNMfgKcTYHKhP6
         6U15C2wvX2ZPugtLBQpGhIlRjlRtv4vLWVwDVJHSLAddeaM7yPB7vp0qunciWXivmaOM
         b0tTMifJ8LkOxKjofsW5KPDWZOEpmrurEZHSrE0ozANeP40ujOVIkcfNaQasHQm1KmSE
         UIKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rNklb0STZIX8NI4XxunDZJac08jSQZVvK8oerGbpjSU=;
        b=4Tz1FpKDR/yaWm+36K4r59dEFkl1nYcw9VOQnvn9rix4jVisqJw30+r0GMkH9PWqaC
         GteHqGUEJer8tjQbPYfsDnnbVh52qDGuNfKoblwQDMkOuZlDXhVlLHRigolD0tSqr662
         jz0WnYNv2YtKNoFRGBqvfcrYa70IweO98+K6Vnk4az8+i1Oser2zwqLkNBGFR+OIzeGU
         GZkM9Ew8v/hhB0ZErNMkUd8MihldaGms+1j3z9mwcyYtJiZXtxHeH3R9lvWkvkPcRUyX
         ZmTx1ouFwW5ytGVxsF+lY4O/m1Xt9Dwj+GRLytY/tYCC7MMJ+I8uarZ7BrirGq9/MZYF
         y0sg==
X-Gm-Message-State: ACrzQf3XSWsUSsgPcaJ2xKWjeLn9z/sGLIVItsfvtKQuMmYD/wFOzpvR
        PSQy4VDBI2HVuBpcU7LgvBVymOhlTm0=
X-Google-Smtp-Source: AMsMyM7YWXFBkuZo1yLWoTLKV6tzQIosaGpz9hgtijnzZ7y65DuDh+Iyr4sTWVL5W77EvHNnNv/Ryg==
X-Received: by 2002:a17:902:e750:b0:17f:71fa:d695 with SMTP id p16-20020a170902e75000b0017f71fad695mr807513plf.105.1665799616402;
        Fri, 14 Oct 2022 19:06:56 -0700 (PDT)
Received: from [192.168.43.80] (subs32-116-206-28-41.three.co.id. [116.206.28.41])
        by smtp.gmail.com with ESMTPSA id m20-20020a62a214000000b005609d3d3008sm2444848pff.171.2022.10.14.19.06.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Oct 2022 19:06:55 -0700 (PDT)
Message-ID: <70a859bc-a33b-79f5-6f44-5cccfb394749@gmail.com>
Date:   Sat, 15 Oct 2022 09:06:51 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH v2] Documentation: process: replace outdated LTS table w/
 link
To:     Nick Desaulniers <ndesaulniers@google.com>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        Sasha Levin <sashal@kernel.org>, Tyler Hicks <code@tyhicks.com>
References: <Y0mSVQCQer7fEKgu@kroah.com>
 <20221014171040.849726-1-ndesaulniers@google.com>
Content-Language: en-US
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20221014171040.849726-1-ndesaulniers@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/15/22 00:10, Nick Desaulniers wrote:
> The existing table was a bit outdated.
> 
> 3.16 was EOL in 2020.
> 4.4 was EOL in 2022.
> 
> 5.10 is new in 2020.
> 5.15 is new in 2021.
> 
> We'll see if 6.1 becomes LTS in 2022.
> 
> Rather than keep this table updated, it does duplicate information from
> multiple kernel.org pages. Make one less duplication site that needs to
> be updated and simply refer to the kernel.org page on releases.
> 
> Suggested-by: Tyler Hicks <code@tyhicks.com>
> Suggested-by: Bagas Sanjaya <bagasdotme@gmail.com>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Should this patch be backported to all stable releases? I see Cc: stable
on message header, but not in the patch trailer.

>  Some kernels are designated "long term" kernels; they will receive support
> -for a longer period.  As of this writing, the current long term kernels
> -and their maintainers are:
> -
> -	======  ================================	=======================
> -	3.16	Ben Hutchings				(very long-term kernel)
> -	4.4	Greg Kroah-Hartman & Sasha Levin	(very long-term kernel)
> -	4.9	Greg Kroah-Hartman & Sasha Levin
> -	4.14	Greg Kroah-Hartman & Sasha Levin
> -	4.19	Greg Kroah-Hartman & Sasha Levin
> -	5.4	Greg Kroah-Hartman & Sasha Levin
> -	======  ================================	=======================
> +for a longer period.  Please refer to the following link for the list of active
> +long term kernel versions and their maintainers:
> +
> +	https://www.kernel.org/category/releases.html
>  

LGTM, thanks.

Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara

