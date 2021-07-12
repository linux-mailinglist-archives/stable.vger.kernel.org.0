Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97DF63C61D2
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 19:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233964AbhGLR1b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 13:27:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233887AbhGLR1a (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Jul 2021 13:27:30 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A437CC0613DD;
        Mon, 12 Jul 2021 10:24:41 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id p22so4099296pfh.8;
        Mon, 12 Jul 2021 10:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bQLyPAi8R6ObnBNw0JvkyaT5QRGtNynnb0GtY60cgIA=;
        b=jWjFxAzmIhh51jU7LuzO6yqSbYW9dIShinNo85R7JhEuSgW+nHApq7ybXj+C16iycd
         De5KLFsl6m2I3EDx15RtWIOlIK68Py0UY6LaML3rBxNVIrBfXTPjW2silGUE9TJXqqdg
         vuCh14CwIfmjK0Mpx96EGJCUw9062nocGU3oEm2EuY70XAjX9uQnfC9zhkvG3CLlBr49
         pxd289auR/JaxkG/h210M0h32iBadKrQGw4I6wlrm5nbu+PhWOy1M7i7MCSGtc3QUAsu
         IunQt7Sg++xMDpiPMGDLLY20HHKB1yAizkJ1SGj+eR+fww+H9x4GqUrxICjFIIwTsuLc
         2P6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bQLyPAi8R6ObnBNw0JvkyaT5QRGtNynnb0GtY60cgIA=;
        b=l4yubW8hbMGTY56e8UrXKrXfuZ5+9bYZsv120SlLfZTfzGrifAWQJcX2E+VtFtpD7Y
         /XhVLsnR1IjJGrbyL2HG8+m7WnxqZmnUCBnlxxm1N1SnKalp5zoK1oDE8ITDHx8+PrnV
         wMuNYwdQhDeQ6liyMWIiI8PliUanM/+s27uf1C5kXoIVcBso53DMna4FmUB7PkNiMOjY
         cvOGfNvZD+g1uybikhuXA4NOkAQk+ghRJSyKIF9zCMkEWpqUwEOsLCGyrxWNgFY/B26p
         4bDhuTJBc6C0dzFWwP1FYRB33wovQpxfaAI4/NaypkR6chnGalmOJVVKneM9SAUAP084
         M/fQ==
X-Gm-Message-State: AOAM533WowrlUSy/q1wyGVtePl58gCUCjMSGk8GomeKfskRUuyrmcy0a
        IGCeN/4EY3cGW629FKIqdHVSo2lYeB4afg==
X-Google-Smtp-Source: ABdhPJxuZhQBVgJqKHkQo/ebXqauxxMDWNfnu+rr1qS0fRdoQY+lZWlDTGucXYK8MBj4AdFvc8IitQ==
X-Received: by 2002:a63:f54f:: with SMTP id e15mr226793pgk.64.1626110680672;
        Mon, 12 Jul 2021 10:24:40 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id j2sm16284453pfi.111.2021.07.12.10.24.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jul 2021 10:24:40 -0700 (PDT)
Subject: Re: [PATCH 5.13 000/800] 5.13.2-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210712060912.995381202@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f5a7bd6e-8242-c16d-ac4b-6ac8d77a51de@gmail.com>
Date:   Mon, 12 Jul 2021 10:24:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/11/21 11:00 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.2 release.
> There are 800 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Jul 2021 06:02:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
