Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B61C658699
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 21:04:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231879AbiL1UEE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 15:04:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232640AbiL1UEB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 15:04:01 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B9713F3F;
        Wed, 28 Dec 2022 12:04:00 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id o8-20020a17090a9f8800b00223de0364beso20939111pjp.4;
        Wed, 28 Dec 2022 12:04:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=D9hw1tyF2xNwFWyPmio8njtMOWA8uIyfYQ81GU7PQ4g=;
        b=l5hSqSw7DhDVM2wKiPZ9RYMs20w2cvUUZhLOO00+ql252Nm0olrX0Rv9xmU7vqHR9O
         LIRe6eWgrqlHrYUPH6OiRi4Q7e9fQ9fO0elhONz3PQ1X7oq0PuaMjwSnXeMV1nkJ5NCg
         1PGR683ce+XaMymj5D6i1neHgegICCGOO0Oh8W84QDxYUMX7SQqNCCMvv1OE529fve2s
         4deFw1HB8r23vK/YoMdKhIaOTVy566MgadmYlZpO0e5obxEmwuxIQnZ7cniERQBnRJhk
         GA2+0O68FtQz8I/lonnmxobdxon3TsFtre6KLTdcgGgZhlqv5mYIA7fdnlj+s609WLs2
         sD1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D9hw1tyF2xNwFWyPmio8njtMOWA8uIyfYQ81GU7PQ4g=;
        b=EusXyHkKgzoDy0pQ8cEk9eLbPTywwRAvLvV4J0zS0VDx74OpEOgw61LmDFN7xpycq4
         eGOML4qNvJioND7uZxhrkdbdZcLARJgojiyoH0+xh4AMuC35jDP8yRdNWvjjl1ZzZk6P
         03K94gB67dQYFa2SNXUeqgPS/UJE4HfOXZf41BEsfY81nrCHMhEJfKqYuJnq2CJRoW4c
         56LJpnCZ52kH1OziH1AwEa/hhAai1lCi8ri2P47kwQ/KSS28CC5QoDDuX85x3LVN62cy
         0Rb3qQOInoHIyRksT2cJ//PXRPIT51whququ6QPB8Tf7Ipgld7v7yJrPJl5369Qu+p+j
         MZGg==
X-Gm-Message-State: AFqh2kqXyGZTWbGXHP9f8j8vtYP1PVrnpqK8o+4FhrKo91vvUiswGJzn
        qKRF1XcqSexCMJnUJ7TQQdc=
X-Google-Smtp-Source: AMrXdXvaLyIZDB2S9vQZlF3OIaI/XmryotvyVvLG8GaQ4k7gCNGscNcXAEniNr9iPcBPOU3EdJJIzA==
X-Received: by 2002:a17:90a:780d:b0:219:ccbc:ed8e with SMTP id w13-20020a17090a780d00b00219ccbced8emr30058109pjk.20.1672257839728;
        Wed, 28 Dec 2022 12:03:59 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id q60-20020a17090a4fc200b00225d963fbc2sm7056781pjh.34.2022.12.28.12.03.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Dec 2022 12:03:59 -0800 (PST)
Message-ID: <6e00e703-f0ff-a739-75b5-bbca484ab74a@gmail.com>
Date:   Wed, 28 Dec 2022 12:03:57 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 6.1 0000/1146] 6.1.2-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221228144330.180012208@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12/28/2022 6:25 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.2 release.
> There are 1146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Dec 2022 14:41:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
