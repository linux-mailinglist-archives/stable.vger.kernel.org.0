Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D43368E2E8
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 22:23:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbjBGVXY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 16:23:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjBGVXX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 16:23:23 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C61423C53
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:22:47 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id w2so2909485ilg.8
        for <stable@vger.kernel.org>; Tue, 07 Feb 2023 13:22:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4pWtMDHlChNZpBVUhtxKeU61bbziVZ1L3zQXJ9Q/ELQ=;
        b=iGG49ZGHPzcvfk5FpC/wPCPjp3eRBlDLnfbucFVpWLpsl2Z8RzUxLQhMjaoGLnVgBq
         xjeqRsYNHx/x1cXl5gl7p7O8mwLBteNJy4e4Jt0xmGTfls523cXFG6Zp+e76SIzupePC
         DseNoGGv79jE/4Z6vcZzHYWFK5W0bjBjcgF6w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4pWtMDHlChNZpBVUhtxKeU61bbziVZ1L3zQXJ9Q/ELQ=;
        b=tB6SEl5Wwbjk+t5GahfyUUrASizFyXF9L+IFp98ShH5g8lukZnDYNf/9RZpnJ/nGTG
         Uezpg5ripBaroQMpqzjapxgf1jHNXV/Rw875KffGPc1QLOZVb+YP7jA7va1zThYLNxnf
         /HIFoLKttDo2JjeWc7D/2pG3Hxbd/C80fFJTrE2y1o5MbPT2+Os+Y9qK2lW9y6vcQzKO
         SQ6lflDKBlCxuOwWQg8VDaqCuA+lk/i6UUmZZRukicj55nvjx5ThoPDsj+NZ/nmPF/vY
         LDSTMcFa5ZZdfuwQguVXLJTaSvRvFwJ31snkGCdkaVsSI3JjpXaEiyWR4KsJ7BfiC0Jf
         kLXA==
X-Gm-Message-State: AO0yUKUF5aNu/fvVkvgHjlzmWH+iS5NnDWakJTW1w37PmHFmJBh+X3HX
        awXiGuBGE1z8QD6Skqao6nYsUw==
X-Google-Smtp-Source: AK7set9iKHCEqTPRQ6Y+u1bMD/+Kbw88A5WZcUuyVysTNoY0Ai0/BDNKii8NCmibzYRgz4gqOf3llA==
X-Received: by 2002:a05:6e02:12a8:b0:313:d901:82e6 with SMTP id f8-20020a056e0212a800b00313d90182e6mr3726764ilr.2.1675804896995;
        Tue, 07 Feb 2023 13:21:36 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id i15-20020a92c94f000000b00304ae88ebebsm4375569ilq.88.2023.02.07.13.21.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Feb 2023 13:21:36 -0800 (PST)
Message-ID: <8ca9283f-36ff-8e79-c168-c59f8e84f7dc@linuxfoundation.org>
Date:   Tue, 7 Feb 2023 14:21:34 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 6.1 000/208] 6.1.11-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/7/23 05:54, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.11 release.
> There are 208 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Feb 2023 12:55:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
