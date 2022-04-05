Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 857B64F47E5
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 01:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346932AbiDEVWm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 17:22:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1573499AbiDETNH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 15:13:07 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97E3EE885A;
        Tue,  5 Apr 2022 12:11:08 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id u14so432180pjj.0;
        Tue, 05 Apr 2022 12:11:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=nm9jptV3WzpDy4GnIltCgi8NKxkU/H5D+wxVFeqH508=;
        b=W1DTLDIV2ru+DUhUkWNcBevZsjAmQlciF2Ojz9VRCB1J8LZJBSqXvJCEgi+lQXStoT
         2e+BTYZi6ECv6oyu6x4fWHCCp3GVhbSzY8M0365tvfg2WWBSSIU/wYi/SEuLbS4fXewq
         heKLhNJ7d4xXLA52PGaFLKrnyTZIonnsDST+fGNIUxrIfML4B3Ya2gFtU+YQcBt5VNBB
         L3UDmMYyIZ7+RXy3eJ+2iXMPdKZ0w8X4VabdIOGCVNIv9zEyeN040vzh8piTt1JhON4D
         dXOkrPzvndu21x4UhE2MK0ju96OE3cGlAxrNuhvkKvP4rljA7LQZ258UgHTGcPE0YAtF
         KoCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=nm9jptV3WzpDy4GnIltCgi8NKxkU/H5D+wxVFeqH508=;
        b=F4wabNnxseVAaRTuEbtA3YLheKLwnslVnioyxmL0lrwMX5nB9kYDEKT9W6OyJo8Vod
         pBEGwmdADaurHPQsV4OcLHAzQTxAxMpscC1Na86Dvhx1GnT6FwYvxOicwxSR5KIAiR4k
         40aj78Eh1dKBtRv7KSQTM7ndDVpqnAw8dBWaqPwTePdAtgwKQ94QFuC01D5B+3G31sGZ
         IHGQM6XTRIzBCjlhXh4WAAMO7/KbllE49xLxEZaewMlr8PhCFOZE09o7lpy2cadmPmL8
         w65awfsxXqzB0vLQyI0U44GrdX5oNo4RLJGg7t7yD2lmkKbUlAKH7NDGUwbj3mfb3tOk
         S2AQ==
X-Gm-Message-State: AOAM5319/FAD56D5OJsBdj1fWfs3EZ/sWVtls/rmLNOr7hEzwtNlslCf
        h3nUFwV8xMbemVj4Z+FLExI=
X-Google-Smtp-Source: ABdhPJzpwCZtruVdAqWgIZpc+SFgn5A5HZe0HSZhnpA3P6/0Nk5mvpUf5WMxNPuZIi5ENOo5CUziDQ==
X-Received: by 2002:a17:90b:4b89:b0:1c8:105a:2262 with SMTP id lr9-20020a17090b4b8900b001c8105a2262mr5740653pjb.225.1649185868049;
        Tue, 05 Apr 2022 12:11:08 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id q28-20020a656a9c000000b00372f7ecfcecsm14616686pgu.37.2022.04.05.12.11.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 12:11:07 -0700 (PDT)
Message-ID: <b44fd7cb-018d-3258-7367-f92f7a46427a@gmail.com>
Date:   Tue, 5 Apr 2022 12:11:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.16 0000/1017] 5.16.19-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220405070354.155796697@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/5/22 00:15, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.19 release.
> There are 1017 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Apr 2022 07:01:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.19-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
