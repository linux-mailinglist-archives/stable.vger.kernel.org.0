Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 660BF422FEA
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 20:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232861AbhJESZp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 14:25:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233472AbhJESZo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Oct 2021 14:25:44 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEC1BC06174E
        for <stable@vger.kernel.org>; Tue,  5 Oct 2021 11:23:53 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id t11so304892ilf.11
        for <stable@vger.kernel.org>; Tue, 05 Oct 2021 11:23:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=b2E8jHBStXuO0189fxGrDNSvK7tMw/8nYSa6Xbvb+J4=;
        b=Iw8pS7hNBTEgbQwrfLhoSgvGMUKHbBExa9VYoS7ogF/dg1IiAZOvMGrQXw5FxYfF3z
         ZdRhIgPpkb7GczxgKVHvPbPMUG8o6u0DrvEBXrb7tW9yzH0H7pGt/YXlnrUjq8N0yFVV
         1n6m5VdCie1TF5oFNerZlmXt0qyP+3sIKgSx0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b2E8jHBStXuO0189fxGrDNSvK7tMw/8nYSa6Xbvb+J4=;
        b=mUE+SLXjZ8UoEz/mEdigQSjSfu7AjrHIeuR0LR1pTjV5v/g5Rxy93R7ckQbkt580K/
         rEmsoGAdK86ty0NEvSaf5BOFKUZ1JcaWjk7lwoVB3JihIb/tVED9x2/ELfMKOmvd0UFi
         yqEKLxhdMm0i1eyfE3gsbKSirqD5oN6vAJIhT0D2TGD8iqEzxGWrzZ7TFhEoZcGV2s3v
         UP2NrCaZ2K5a0+WnzoxfDYkLkM1j++E0fBZm4TPei2P7fsdfDkERXc0zLHSrzULww2wW
         7dC1vis8x7Tn+LW4CLzZa4K3bQZDEhknk0YTNuuCJmHKWx18N9/VyE1p1q5kqzPtm0sL
         bK9g==
X-Gm-Message-State: AOAM530cEQPdKxYcnFB6F680CwAHw5vyLc01jG+MMfidp1LFNBaC7h5+
        mHHXeR3ZluZGKsDlIsvpq+AnqQ==
X-Google-Smtp-Source: ABdhPJypk/XBzpTukdeavAygNAZEVMcB0O7BYZTsnv4+kwLNK6mwkJugLNC46a9rbfsm6L+ahwOWOg==
X-Received: by 2002:a92:b301:: with SMTP id p1mr3883695ilh.10.1633458233099;
        Tue, 05 Oct 2021 11:23:53 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id z11sm11392922ilb.11.2021.10.05.11.23.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 11:23:52 -0700 (PDT)
Subject: Re: [PATCH 4.9 00/57] 4.9.285-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211005083255.847113698@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <ef7cdb35-119a-8b30-5b4e-18d6ada500b8@linuxfoundation.org>
Date:   Tue, 5 Oct 2021 12:23:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211005083255.847113698@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/5/21 2:38 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.285 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Oct 2021 08:32:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.285-rc2.gz
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
