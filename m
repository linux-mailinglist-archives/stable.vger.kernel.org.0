Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8252DA350
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 23:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408258AbgLNWVx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 17:21:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2440954AbgLNWVu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Dec 2020 17:21:50 -0500
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2222C061794
        for <stable@vger.kernel.org>; Mon, 14 Dec 2020 14:21:09 -0800 (PST)
Received: by mail-io1-xd42.google.com with SMTP id w18so4639973iot.0
        for <stable@vger.kernel.org>; Mon, 14 Dec 2020 14:21:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HF/WBwS/ZBNGWY2y0QipZP28Qi8JaINnoQSzLWyEN44=;
        b=Xx+6yk+Kqx70rK0zJ45aBlLi27a9912m1D2gs5ceH1rgsXeqNLrx11ITCSh+G0bdoi
         3n49UyA1Yi8YikYlzrEnADdYJbZY+5SJLNpgsk1FxJdo/U5TKB/6W3Cc5u/JU0FmPaAs
         OSHlMm+Iz945gpF+ZR6RFdktAMMliqG7ABP/Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HF/WBwS/ZBNGWY2y0QipZP28Qi8JaINnoQSzLWyEN44=;
        b=XSculi6HTS/ql/JokqdjYNdDT7FjXRWLouEYXrcxdo+B3+r2k7oDMQU4GVXuVnicY3
         ++gue+HI6JMBI4JNMi4ijLcpqYiBupsS608EcuXRJrvhJgiZf0Nr2WfGIkQMYehi+qoF
         0Y0shxKwWIw/dcLiZdJSglA8YPBac04ta12l6/x0q8o2gVuWqvXSl4hZlgQusl0zrlMq
         kpjaKP0/kRYx95PpzJWutEYZNxuK2vaEgxPHokzLDxEbZhZqTNlUQIpEUQVQJCQfguzL
         EE5k0jzZUE2JG3vtl62c5RZsaAx+Q/tHJ5OFADfqg2BrrHWR7Lc83rVtPm5+F6oIodX7
         JBsQ==
X-Gm-Message-State: AOAM530wrw22ixnG9BvEgFNvqOfuP44O/774IkI4GEHXGblRRxuITsBj
        knsXtRiNwqM096XpxHUomLlHeA==
X-Google-Smtp-Source: ABdhPJwVKtFAChZtYZivT1rexBYN9JQmkzjB1rb86rYrAmsaAEbl1bzAVHCFICxhbPwLZ1LvQW4iWw==
X-Received: by 2002:a05:6638:2:: with SMTP id z2mr35531327jao.2.1607984464494;
        Mon, 14 Dec 2020 14:21:04 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id g6sm11979942ilc.85.2020.12.14.14.21.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Dec 2020 14:21:03 -0800 (PST)
Subject: Re: [PATCH 5.4 00/36] 5.4.84-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20201214172543.302523401@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <425de779-55db-760e-314d-326e57d59035@linuxfoundation.org>
Date:   Mon, 14 Dec 2020 15:21:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201214172543.302523401@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/14/20 10:27 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.84 release.
> There are 36 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Dec 2020 17:25:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.84-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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

