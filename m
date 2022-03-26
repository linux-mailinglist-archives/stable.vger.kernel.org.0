Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE414E80BF
	for <lists+stable@lfdr.de>; Sat, 26 Mar 2022 13:18:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbiCZMTw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Mar 2022 08:19:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232803AbiCZMTv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Mar 2022 08:19:51 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9986325845A;
        Sat, 26 Mar 2022 05:18:15 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id p8so8684704pfh.8;
        Sat, 26 Mar 2022 05:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Dv1PdlO/zHAijDx+J2HibW5hvJdNUZlfKrxeyfe2gKQ=;
        b=RJzawOJFMl1p6yeP0Y/k/J30/XL+ON8dSMX90hcCQfuc8RltUO3XALQmdWw5q77MLb
         9Xx2lSrl64Gggvy1HNHX+C7ZjLl66v0jOGHPJe5kroGghMARbmXzru4OKt/Quv7PLXPU
         GGVHj+31rK6xDPJNEGxqFyzjf5mOFwep7FmYEUwqqy5//T9FawkCyV1eqmgo7y5miIic
         AugournJu9jQGcBfoHPdyNYNPklZCEFSlN0WaNxwWURrR0CsoAjqMLv1HdwjDg6KLfh7
         z95PAbvFpyPauzX6x644bYn+YeQPp8bB27M21seG4/ojjyEbj/To7hBr3Zpq62TvJ7Dc
         7tqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Dv1PdlO/zHAijDx+J2HibW5hvJdNUZlfKrxeyfe2gKQ=;
        b=KOhKkkEvKvwCP0+9cTfTuq6ncU1n39FI3Q2DOLztmtG71visFN7FRBmD6jI2HyPtLs
         cslcTsPKtQBbqtOpJDBsi963L1gS/eT9ZX0Gt+bEi7/am/ZJIQHafYHUCHd6BvVyGb5w
         RAv9mZN8/MU8IrTz3kGOK29Rl+3hJA3i3wLVPeTODsBE345fq6e3MucpO6/jcWJdR9iX
         i4TFlPVWtkSSZeb6r7gjyyWPbcYA0GD3eBJC9doZzM/rtMkiVhtI0JZ1K+J59x2UEwkG
         sy4PywW0HNd4qw4OzrxabeV+o4VvHzcXv/bNxa9Nj1Mo6D15rZ4lJPeaeiYG82VPg175
         mEDQ==
X-Gm-Message-State: AOAM532mLxYnULXtoxA79d7tqtGrBJI6NE2ihGR45Wx5nJ+Vu01qujcO
        lTs0qdMeGG5+hKxdOPFDZwclYsNmojm2dA==
X-Google-Smtp-Source: ABdhPJwRkDR/TvDD2ZqtiZBgIGVqVk9kYYIt1oC6x8xMXpp6BqhQVj4joJxbwvy8ZI4/UgbhAbxn9w==
X-Received: by 2002:a05:6a00:134f:b0:4fb:1307:ceed with SMTP id k15-20020a056a00134f00b004fb1307ceedmr7556192pfu.23.1648297095023;
        Sat, 26 Mar 2022 05:18:15 -0700 (PDT)
Received: from [192.168.43.80] (subs03-180-214-233-24.three.co.id. [180.214.233.24])
        by smtp.gmail.com with ESMTPSA id il3-20020a17090b164300b001c6d5ed3cacsm9877094pjb.1.2022.03.26.05.18.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Mar 2022 05:18:14 -0700 (PDT)
Message-ID: <4628e365-2e61-f906-46aa-c132f3506363@gmail.com>
Date:   Sat, 26 Mar 2022 19:18:06 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 5.15 00/37] 5.15.32-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220325150419.931802116@linuxfoundation.org>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20220325150419.931802116@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 25/03/22 22.14, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.32 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, gcc 10.2.0)
and powerpc (ps3_defconfig, gcc 11.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
