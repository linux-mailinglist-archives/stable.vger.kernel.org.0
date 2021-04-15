Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E290E3615A4
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 00:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235660AbhDOWpA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 18:45:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235576AbhDOWpA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 18:45:00 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 933CAC061756
        for <stable@vger.kernel.org>; Thu, 15 Apr 2021 15:44:36 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id 7so19875165ilz.0
        for <stable@vger.kernel.org>; Thu, 15 Apr 2021 15:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=K6QwOJC/txLdkjoz36oCI2bVJnzMTChtJNvH/SoXmFQ=;
        b=Rx/3RoYUVhYWuJoi+Dp60mJCWS3kcIGJmYQMq4moV59v/2MFvQOV56oB/eDZtCWY/T
         RzFFdl6RXvfahr9cckrLiUKW7kQ8j5PQe8Z+sm837eKD2o5JW2UrADYtnia4ZFkn06Ui
         nrL3RitWmraUwv25WpBKZy0Xrpub03P/xqlNY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K6QwOJC/txLdkjoz36oCI2bVJnzMTChtJNvH/SoXmFQ=;
        b=VNylLjcm5WN9EKVCD9qmlMj9vQVkS0gXCcTGZAyxHRRErkcVfhNxr3Wax6TDXUr0JL
         aYIFd6hDgUTjKJcWBOx39gq2Y5lfv9rloAlvpa1oY0CREH3Y6UCfeEDfB0W1URRDdH2M
         y44tS1gycGWdOBbQtHMyfCjA9d9QMWCaQ5wR7o7+dlPPaj16vww4QY1lYzk0OAFpJa/D
         SJ32PXdeiPABWPrFJZ/g7S8+jRgni2uDWqm9VTKgesmCwl0rryexn+SNl5R4cudPDJZj
         9g9o0WQ3rF3TJEAFtC55tkmqOW+oYz7vdZ5Sr8h+ScobpHBazD+7gfzjtfBIESgi/d1P
         0ByA==
X-Gm-Message-State: AOAM533iqE0Vnh33xoe0RdVHssiwSA0QRNYPx+mjO15omFJ7eNaVUFWp
        ESq3DyZZSyWmb4od2C8WCrF6aA==
X-Google-Smtp-Source: ABdhPJwW/SdtlsQbrX2kqL8CGDoKXg+mqVkKT/8tjswJfM36R40zOMajYgOC55aG/0s0ZSjtHm+W2g==
X-Received: by 2002:a92:7307:: with SMTP id o7mr2991946ilc.5.1618526676123;
        Thu, 15 Apr 2021 15:44:36 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id k6sm1672563ior.28.2021.04.15.15.44.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Apr 2021 15:44:35 -0700 (PDT)
Subject: Re: [PATCH 4.9 00/47] 4.9.267-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210415144413.487943796@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <68b0387e-6133-ae06-1713-2c44cc4fd297@linuxfoundation.org>
Date:   Thu, 15 Apr 2021 16:44:35 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210415144413.487943796@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/15/21 8:46 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.267 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Apr 2021 14:44:01 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.267-rc1.gz
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
