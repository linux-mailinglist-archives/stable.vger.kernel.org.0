Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3C7B48F376
	for <lists+stable@lfdr.de>; Sat, 15 Jan 2022 01:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231504AbiAOAZZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 19:25:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231486AbiAOAZY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 19:25:24 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78D9BC06161C
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 16:25:24 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id r16so9736782ile.8
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 16:25:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=K47FaHwTV4J1SuMx8/Y6BqOow5A1THVY4efkflHLIDg=;
        b=fKCc9WqXlqcaKQ+Od2hJzWck0ZWTmw+FuBh3zvDzmlg6BFHRNGF2xQAvqmgM4RGWiE
         0otfFuFGw4eHHW2IVHlCh6DkImBQIAqPuBq/mTYZWiIpkoWTs5mAjfcQJ92riVSqMWpu
         xcxOxjBevfQxUEh0rvf8cP8NbqoP04r72l3OQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K47FaHwTV4J1SuMx8/Y6BqOow5A1THVY4efkflHLIDg=;
        b=3naqGX+jn8JToEGNjtIHVdBf03SbqSi9bxw4up6pUCR+8ZaQscM5wMOnSKUVAbD16q
         zJXK2xt40QbiZyEyklDo7UH0uzLptUGflBfxEI1mr1o6R3jB6MMZaDRNES872edso8ob
         EWqtrIZk3VxmS2+I5sQSL+tTIwZQbwVwc3dkSGH7ejIIeqEZGSnCfWG3rBKdXV1MD7VE
         eESGizFh2VAF0IWZgSPx+nmtD+njJMAzLPaWjO+QJjJznX0SjddRjcR2a9kreFc2hr02
         6rm1okMgcmT7NqqkZO5fXLWfL3QBWQgOL1vI62HT9C2MPVGBDwqeZuoAQi3uwswmGozr
         /gvg==
X-Gm-Message-State: AOAM532BaTszK1uIUEQxltk1jQCd5SzoIfmmG3ewzzptAO6vSY+K3QDp
        zFLmEofHzF53g5CvJDbrgCxAdijcmY213A==
X-Google-Smtp-Source: ABdhPJyGnrMMz1S3WSexqoUXh+PQXA1+Njaa6ZvzEHJ+7Txq8zYQMq1dQjb46iXdRAbHJ9deJN/Amw==
X-Received: by 2002:a05:6e02:1b8d:: with SMTP id h13mr6271492ili.26.1642206323830;
        Fri, 14 Jan 2022 16:25:23 -0800 (PST)
Received: from [192.168.1.128] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id b3sm829832ioc.16.2022.01.14.16.25.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jan 2022 16:25:23 -0800 (PST)
Subject: Re: [PATCH 5.16 00/37] 5.16.1-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220114081544.849748488@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <da1d204d-bc51-760d-985e-7a3daac62f2a@linuxfoundation.org>
Date:   Fri, 14 Jan 2022 17:25:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220114081544.849748488@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/14/22 1:16 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.1 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 16 Jan 2022 08:15:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
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
