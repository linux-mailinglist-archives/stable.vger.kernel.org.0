Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36F5A455F8E
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 16:31:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbhKRPet (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 10:34:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231459AbhKRPes (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 10:34:48 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F557C061574;
        Thu, 18 Nov 2021 07:31:48 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id q12so5643987pgh.5;
        Thu, 18 Nov 2021 07:31:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Heyh4jSWNXWsiFfsW/dvUmr/cpROoRUCIgUw5CHwG8M=;
        b=XmaUb04IHxMMiCJ4NQ/KVbBbUMEFiFg9PQwlAqHmc/ug3KFt12LZ0i7mByBMYP8Agy
         0tR0NYCoxOsYrgtW8QVdOqFglGWzSkAjFU4oLL/sGW3gSbNXucuQNLcPxBeESiastYiz
         8mrd1xad24V40nmN7iZgUQC8n6+z9KBAer1tNWEKoSlMiV42GOxb/AizyXn7wPMeos6G
         6Qwaqhvq7IBNDnkar8NmqFBiBgWA5gcgPn0s+lokojRgu0Urw4FmbS6k2jiFjWVnSGFe
         0vQ9mXQzM2S5RGLCxH5awHcNFg8zqUFoo4Ai3m/iyhet1EcHrcE2GgB2SyzrwcumFsfn
         iVOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Heyh4jSWNXWsiFfsW/dvUmr/cpROoRUCIgUw5CHwG8M=;
        b=quxB7Xk80mJGMIi3ikM2kcmF8/YjliaiwdILz0Z0zk/XbXXqIfvwEOE+KffVDOqC18
         t030SfaDoBbZS31d+A660Ei36Kk1MEOqrQIV30wfXDjo99QJYzKeM/kIWoGdTku3OyH3
         o7e/mi3XZiFIXZ8aM8N88urz3ZAX1vMtu6DUZVX5BWGHK/ktnsaGcU1a2XhPms4RqGgp
         owr5P8h+xQS6k58XhNfGQ8s6wCRaSRegqrz1vDmhBZDXxhp5f3S0Tl5eiAweGFmySyjo
         FmGCc7gTtpOsNeaMd4ijQZ+wQHOI+pAzk5wCmDOBoii0sST/zODm6l/uwpvq3Kn3hnf2
         mVvw==
X-Gm-Message-State: AOAM533F5gxRb4Zh7waAYgGkoJllx4KqGJsWvIrYPn/DudWNWiz2zBuY
        LkPdaTYF6sFQYMc7ZHZLEtU=
X-Google-Smtp-Source: ABdhPJxm5EwR9H97WIyTmVLcjPzHVh0Nr3IMHZ1fq44A/biLLWy+oipxiBF/KWT+JrltK7vZHHdniw==
X-Received: by 2002:a63:5023:: with SMTP id e35mr11512864pgb.284.1637249508102;
        Thu, 18 Nov 2021 07:31:48 -0800 (PST)
Received: from [192.168.86.160] (c-98-208-6-104.hsd1.ca.comcast.net. [98.208.6.104])
        by smtp.gmail.com with ESMTPSA id a10sm65538pgw.25.2021.11.18.07.31.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Nov 2021 07:31:47 -0800 (PST)
Message-ID: <cb2fa26e-58e7-945e-4f3d-613ef3cb63ae@gmail.com>
Date:   Thu, 18 Nov 2021 07:31:38 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 5.15 000/920] 5.15.3-rc4 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
References: <20211118081919.507743013@linuxfoundation.org>
From:   Scott Bruce <smbruce@gmail.com>
In-Reply-To: <20211118081919.507743013@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/18/21 00:25, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.3 release.
> There are 920 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 20 Nov 2021 08:14:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.3-rc4.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Built and tested for x86_64 on my Cezanne laptop (ASUS GA503QR.) 
Everything seems good, there are no obvious regressions over 5.15.2.

Tested-By: Scott Bruce <smbruce@gmail.com>
