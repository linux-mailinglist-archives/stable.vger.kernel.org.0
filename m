Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 874E13D687C
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 23:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232922AbhGZUex (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 16:34:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232788AbhGZUew (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Jul 2021 16:34:52 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD4B3C061757;
        Mon, 26 Jul 2021 14:15:19 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id m10-20020a17090a34cab0290176b52c60ddso1883146pjf.4;
        Mon, 26 Jul 2021 14:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=G/SSn0rBK6tqFNd7EDq6PH3Wo7WqYbfOcGRc3C+nqRM=;
        b=Wr6yb53gJ39rdM2lt+ku6pRSughO+Ggp6k0ZkTwlYKo4mYSL1fpG3poxNDfPWL+Msd
         uDSlQBtDv24K886t2NX7/0YAZbO1O7og3bGxNDEq9H5aBw+AevsP7Dr2+wc3ORYH4JOG
         2LmXF7jzF4NpDAIOHdThCfZ02JU9EJ0sQMSBBMRQAI8H//tmAVQiZHYUjoybIM+0myLE
         4mVsIRAwSdVGToJRwshVFC4qch2aKaKzD3w5Ia4vnzy0EDUUMJwscSdHOaFoqIGU6TFT
         JrGUP1UVdDL5YuCD6CztMMaaDpm3tz6HdRZFd8CuWfhvqj6V6nObMxeALdaOPde1wM4o
         sX5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=G/SSn0rBK6tqFNd7EDq6PH3Wo7WqYbfOcGRc3C+nqRM=;
        b=REd7tfNUNUzGhdsbIVkUJczWDMTqclCUt4jDvLE9KZGLyMmhB6yHbp0SNrN8WAQvAm
         QqHg0P0wP/021aodE6WVOUhth5CalwW2gUa8s6iNj5MJeweYNEIvwNX4vQ9qhYOvuOBx
         auwcT+ApK1j1opd0Iu76wZtvCIokm8rju2aXoIV1ch6QEG+yqj7K2wfzA5Z65b7h23Ch
         dZt6Z8tlpD32n1hfTARhySfsDuKgyIAFzUB7O2MX/oWjTxxgEKVOzA+ula5HSuGCN/z7
         DZOvshTHO8sBfOqgqyB37axOsbqaZS94qtVB1qZm/uVZbZhcuOA3dRy/OIP4DW7HWlpH
         gaBw==
X-Gm-Message-State: AOAM531bPWEwvs4uv6L/WSlNVDG+o0B+yx9NPHUFI3wfmUqFSK8NSxIS
        aL4XbiwVmdi8d3QwWMOR6cEhbbklOLE=
X-Google-Smtp-Source: ABdhPJy6I2BXFTq4eF/PwEewgLO1IuoswuXhS6h378YsIqulDdwnxtEleiVuTKcM2fxg8QRU0qzDTg==
X-Received: by 2002:aa7:921a:0:b029:2cf:b55b:9d52 with SMTP id 26-20020aa7921a0000b02902cfb55b9d52mr19353451pfo.35.1627334118996;
        Mon, 26 Jul 2021 14:15:18 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id f18sm987242pfe.25.2021.07.26.14.15.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jul 2021 14:15:18 -0700 (PDT)
Subject: Re: [PATCH 5.4 000/108] 5.4.136-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210726153831.696295003@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <37de3c1e-38e2-1b19-4802-e2e778bda711@gmail.com>
Date:   Mon, 26 Jul 2021 14:15:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210726153831.696295003@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/26/21 8:38 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.136 release.
> There are 108 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Jul 2021 15:38:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.136-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
