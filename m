Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51B80442295
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 22:23:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231817AbhKAVZu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 17:25:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231640AbhKAVZs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Nov 2021 17:25:48 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87537C061764
        for <stable@vger.kernel.org>; Mon,  1 Nov 2021 14:23:14 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id v65so23215531ioe.5
        for <stable@vger.kernel.org>; Mon, 01 Nov 2021 14:23:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/BbHXqtUJCnWAjRMtLjqWV0YsGsxdNBKiDO46eZaQqw=;
        b=FzPmXwWN8NBPi4jm60O03gwGY22OOwCB2z5DqQQ3Tnl+sEx9Zqxi0hmN8MOZYOCW9S
         sB2yFtcOfj/5yJVPLRlWj+aygXrYjXa2OiVRFO2d7bcDLXWnWfd20yZDCZDePU3f//WO
         u2s0naMaNvZsZpUlZc9D/P1iHLhkUlwFCkSbo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/BbHXqtUJCnWAjRMtLjqWV0YsGsxdNBKiDO46eZaQqw=;
        b=cKaUtftfw25/JrXKi1bgRfpsrl5Byw+WCMJlEvZRy9dZcXk1XRWRXlW9qEUWngu+do
         uW1AdzH5CK7l44bXJnOvCvhMgXLeFyLk3+mascv10E+jsD0qGJ/T8H4Wfi8kfHDhlyfB
         Joaq1ACYVaF+wdHTISmzQY7QlUEKeE8e5Av3Uo9766nlldiNhN65+DpfH6V/n85OWH3l
         6qkzzG7TOvCy+7Ph/akKpMKWA4GtpWZ1rko+FPNGCdXecjrCuUYXM7Fu9RGMVotJb2WB
         ehrGJdgfrNUNU7AfMLIsLavlzAXEUxRUfZSC2SbUjCvYD/CsCFx0TRy42ewuVmwLbz2e
         62Cw==
X-Gm-Message-State: AOAM530tDhkJtJtn9BYDRue/6w7BVj1PV6ax0Rq3mq8hTUsdMckN+Pfd
        k1iGv/SlMYvMYl8aOs/JJ4I7lw==
X-Google-Smtp-Source: ABdhPJy+goiktXO5TgxDyxGhVR3+holoWDAF0p7zE91CpWsf5UybL8A+LkOE4H2DjDIKOVJ10ATnqg==
X-Received: by 2002:a5d:8884:: with SMTP id d4mr22821814ioo.137.1635801794010;
        Mon, 01 Nov 2021 14:23:14 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id v12sm1101240ilu.14.2021.11.01.14.23.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Nov 2021 14:23:13 -0700 (PDT)
Subject: Re: [PATCH 4.4 00/17] 4.4.291-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211101082440.664392327@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <342fed49-6232-b66f-4be6-d26ceb0eaf60@linuxfoundation.org>
Date:   Mon, 1 Nov 2021 15:23:12 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211101082440.664392327@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/1/21 3:17 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.291 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Nov 2021 08:24:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.291-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
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
