Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9586A1258
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 22:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbjBWVyR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 16:54:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbjBWVyQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 16:54:16 -0500
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 167FA4741C;
        Thu, 23 Feb 2023 13:54:14 -0800 (PST)
Received: by mail-qv1-xf2d.google.com with SMTP id y12so12147211qvt.8;
        Thu, 23 Feb 2023 13:54:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mhDdt0fMRr1vot8arPkCNh+wXMPBtnxO+GXM3kSrfBE=;
        b=PISFKTE8TM6sQSy1pBwZQI3u/FYQ14vkOaC/RCP1BrAipVymVttA0bLTmJjirxfNrX
         5o8h95DpGXbCuVOFh5tziZ+NXPrX71dUMKRzGEkobDZBbA9JLfjoWXaNJJEO53RcxY7v
         fm6zQHfxKYLvHNA47/9eR4LRs89UcMrAGBfWZL1nqOAquJrumq3aL1Mg/glmVNG6zsJV
         kRNV+w2DSoJtKyUA6GTXqZ/HiAa2PMDNL1s5aKqF+1gfb/QOqKGXf2uoUttcXRYCgzEE
         LVglo9IJJFOWySdneEpSw6VWeLHI8zsZyC3ojV6mS4Jy5Ws827yvaxd4Wek9sJ+dZgKp
         Y6KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mhDdt0fMRr1vot8arPkCNh+wXMPBtnxO+GXM3kSrfBE=;
        b=LpMuNvb/emAfpTDdFajfbx1c0IaUCsPp/Ak2RMzG+1yNEK/r4kw3FS4FpW5G8ywRNm
         lNB7fTFeT5CQ8v+2YVct8lQsnuZMbsdyUFUKNlQ/zv6SOkGi7wvminfU1kawsG7v1zw2
         i01TH0DjvsygjU4eLRaZTPz3hd6A1rLeSdCV3rtyCwHQjNvw+47iCSrWmnkNvA+CPUXC
         GE4R0hplnVwULuxi4u9PZ8qizfQOg71n0E3ryZQgFWDjHED5C5bXX8JSu02woAlQZsZU
         8rOqmUDM/gd46V59cI3+KKp/pqZ9bXQz0k5GGS9BopYxcKBUSQJ5QmDKlXqcqbV69x7I
         ZQwA==
X-Gm-Message-State: AO0yUKXd46DNWJwdV19icrMMibGJ3EiN/W7boLvFgLpf7+1T+uzh0pOI
        FEksGd0bcHuPIfP7xjiEUCk=
X-Google-Smtp-Source: AK7set+8DThh2Mijo2u7YMM3UZhA44f0vpc4gUZlHdvfSjAp1w1r64513HiUfo8NsrWaPkl3D+3lQA==
X-Received: by 2002:a05:6214:528b:b0:56e:982c:30 with SMTP id kj11-20020a056214528b00b0056e982c0030mr27247064qvb.16.1677189253033;
        Thu, 23 Feb 2023 13:54:13 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d191-20020a3768c8000000b0073b4d8cb4a5sm5489949qkc.60.2023.02.23.13.54.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Feb 2023 13:54:12 -0800 (PST)
Message-ID: <ceea2630-7c1e-6fde-cf2f-d4e36e292e59@gmail.com>
Date:   Thu, 23 Feb 2023 13:54:09 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.15 00/37] 5.15.96-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230223141542.672463796@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230223141542.672463796@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/23/23 06:16, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.96 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.96-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>

with fixing the permissions of scripts/pahole-version.sh
-- 
Florian

