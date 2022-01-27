Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13CD249EA69
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 19:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236267AbiA0Sfi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 13:35:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232362AbiA0Sfi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 13:35:38 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE0E1C061714;
        Thu, 27 Jan 2022 10:35:37 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id l24-20020a17090aec1800b001b55738f633so5632199pjy.1;
        Thu, 27 Jan 2022 10:35:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=fgOhbXSzqZrLmnPim35W6RVlyrAMx/XV1EOzaIZSXBw=;
        b=l9PTl3I288EdMuv81GloKU87+DMGtr83fAQp9zN26zYBzjr1wVmgmBET8rfZ/kyfwv
         twK3ANNjwi6teP5il6mlCzFha/h7r/nBVtJQCB59ODK1Q12c6pyFgmdMbbsBR74823fB
         /ssoNu1hJW+RWqds03NXV5Pa14Ko9KVf4QdjmaI7aofVlG+3ZgHgMWpXm8zY7ULHN0PJ
         /DniJ2LXWSjTtCYBndzJiCk0Wj8l80Kyi3r5PqBwBI1FcRsoAIGT/VvG4JbEVp5Z1yTi
         BpChlrT15pJBDzRMKxw9nlxfons28bq+dQ7dixuAk5R9lE5mwanwFnbBwIb5PLaBGbUs
         krCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fgOhbXSzqZrLmnPim35W6RVlyrAMx/XV1EOzaIZSXBw=;
        b=BgvoVZU9YmR2tbtd6kkI50YHwKWDd51k/FLYpVZUT9exYjr9ne4K+1cMR2RBzsIySy
         S96SOtbfiWzTmAvazk1+ylwynldu2p5Pz4K5NJ50jgSyrm/IxoRvfGRC0y3baXyOkbIS
         2f6EG2K4BxA1KnWh4P5dFqsGe3a6ZjukkFSPky+JMFCF63cUVrF+U9HtDBU0kYfEYv82
         w1n7wrq8YIUAWSdV8IHYllsG+JIACmgMdaGbriWaok43OqErYRJlMZFSTqrfY3qUpYOt
         x7EMN4I0j2V+RDK66rkh9vgSppKyPvUt4WA41DMyNKmCkUIYyn2JzJtkSzvkC5L/NSGw
         SMPA==
X-Gm-Message-State: AOAM5322ua4WyyvUZ596ol65BLKMuehBnFAP4Q1mYeXB9Fhlr0Q/IAza
        gfrSjGK46OsXbX6gbvAdNpGiFnI3M8U=
X-Google-Smtp-Source: ABdhPJwYxJh7z/q1s1ne5sfzm1UTejGbXuZU3RuSYHoR8zmJo7TMNep4Aos9gj6zC9Zq/bjccsR3zw==
X-Received: by 2002:a17:902:694c:: with SMTP id k12mr4786501plt.98.1643308537221;
        Thu, 27 Jan 2022 10:35:37 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id 17sm6732615pfl.175.2022.01.27.10.35.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Jan 2022 10:35:36 -0800 (PST)
Message-ID: <44c0f2b3-4b8a-cbd1-d382-c104494b19d6@gmail.com>
Date:   Thu, 27 Jan 2022 10:35:35 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 4.9 0/9] 4.9.299-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com
References: <20220127180257.225641300@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220127180257.225641300@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 1/27/2022 10:08 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.299 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Jan 2022 18:02:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.299-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
