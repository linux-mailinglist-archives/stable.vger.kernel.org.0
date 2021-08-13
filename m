Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D62873EBEB8
	for <lists+stable@lfdr.de>; Sat, 14 Aug 2021 01:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235746AbhHMX0e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 19:26:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235678AbhHMX0e (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Aug 2021 19:26:34 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B9AFC061756
        for <stable@vger.kernel.org>; Fri, 13 Aug 2021 16:26:06 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id s16so4220656ilo.9
        for <stable@vger.kernel.org>; Fri, 13 Aug 2021 16:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8KjlZeOTulaFH6ENv8cuIdGqBV299uisFEi/IjHaLBI=;
        b=XOD73QKWgfFcCPtR+LUrPTi5eGKuNAXAB5liWLxyjPc1X667720GDXBfbqosc7HZ1D
         dTuMzDJl5/yvqnYucsTDGtqAGDZKaVpAaGQrearPdPSSAjrG3aND12/TagPyDb9w/NCb
         /m9KzwiKXSoEJn9GcuRmyDSmrae7czFmRo1HA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8KjlZeOTulaFH6ENv8cuIdGqBV299uisFEi/IjHaLBI=;
        b=Yc+C5m9UWj0SMp97g3BsIcQKN3T7xoteO+uteuVjRmPRnevjSnRO5yDsQzXtDGxoXf
         H91zg+E7IBbcUGpSH0cMUFnOQ8xYhiqJvzOIXn8xlR6HZ1dfAxIcTmbm/gphrmAUyR3W
         /Sb5pUtXgrAV8pKsS/yaHPn9cowC3jmztcixkXvXZO5y/cSko5e1iagvCTzuOpfXDRuE
         QE6HMtJ2IR5SoPoJFw2ZJKhST/TfhvkWMcFr8/+fq65MCVEDKd6fv3lFqLrdeWcnD/4W
         YDpzxzIEu/WNi28CLMjzbbpgwDsGaEVZyD8UafHtnFwcpxSSA/YJMMEy54/G2eceRZNb
         gdqQ==
X-Gm-Message-State: AOAM5327HAifCnYyCkyr8BVpoT6Ay6kezNTOL1cExCprXBwm9vs4+kA0
        1moLDNlQz55XYDxVTldmkNQh0w==
X-Google-Smtp-Source: ABdhPJx2qbhEgPKHkpNZvBg7BZLPiowHnhC+EQOvNUqdoFH8p0LI11NdeWEMsQhPaHnb4h7Pq/Bgtw==
X-Received: by 2002:a05:6e02:154b:: with SMTP id j11mr3384310ilu.96.1628897166083;
        Fri, 13 Aug 2021 16:26:06 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id x15sm1478509ilp.23.2021.08.13.16.26.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Aug 2021 16:26:05 -0700 (PDT)
Subject: Re: [PATCH 4.9 00/30] 4.9.280-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210813150522.445553924@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <9e6ef946-e5df-bb15-6e7e-2242ff15c1d9@linuxfoundation.org>
Date:   Fri, 13 Aug 2021 17:26:04 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210813150522.445553924@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/13/21 9:06 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.280 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 Aug 2021 15:05:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.280-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
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
