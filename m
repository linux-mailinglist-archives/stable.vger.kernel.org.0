Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 872D1334A6C
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 23:04:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233858AbhCJWBl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 17:01:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233807AbhCJWBU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 17:01:20 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC3B5C061756
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 14:01:20 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id k2so19680721ioh.5
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 14:01:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=w2N/Ui0FPsDG5VvjMDBi5pl6ygCSR2qqM9L9qwIdVTY=;
        b=ItUnwFtDp7nKbo6lP5//AUVngbFebFzqdZrL2ThIK6fq3hqyAGCD3aUSNBZFj8ytw8
         5kFTZF8Xl3nsrDOH2RSiMsIe/EYfHK4bbgZit3bIGXjRUqAltVcN+633UVqcBR9tG5SX
         CiPZdsQDfrQ5cbAcjgA2yiwLJh3NQBFOzY7tc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=w2N/Ui0FPsDG5VvjMDBi5pl6ygCSR2qqM9L9qwIdVTY=;
        b=OE6MEO7aWYPyJ+8Gg/KaPeSkpIMwH7UhhqikinZk78N+bWwQIMFQKkqTowuVaNZc87
         lEDs+jVTNW+vALxVttIXWZCuVImXBwPahTuQaTCXDf4rSb96Jvl6282Hn9Tubxmf/S7y
         oNR4ppu5e/fHJNareww//ClWi9h93OnyrDM9ypngumsivtTyL1N8aBsAbxXk6MDNYiAI
         WZDreXfkMixjSGED7KC7Ol5ENzVgrHbmjB9NbEZdGRHn0EOvxtoUogq9gAA5jDJYmlL/
         fDnvcJMuPQqTKwdz5h6LGp4W34r2F4Jc8/JbhiG/Q50eTA5swEJKltxuZ+mAvibOCWRh
         9FPA==
X-Gm-Message-State: AOAM533f1Mg4vECz96RoqzCS1ws/DjFuf2qwGGsdx5PVSWNoEcLJ3hjo
        WZp1DX6dp43skaKCHxadT63qaQ==
X-Google-Smtp-Source: ABdhPJzX0FdvZMPzA8rKuLxgkQo1PXLSD6J7G0z0Qn4Ia/1GwV/EMa5KqdXtSMX8cpQD5ZMqCdNc+Q==
X-Received: by 2002:a6b:7010:: with SMTP id l16mr3770525ioc.96.1615413680247;
        Wed, 10 Mar 2021 14:01:20 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id h2sm359447ioj.30.2021.03.10.14.01.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Mar 2021 14:01:19 -0800 (PST)
Subject: Re: [PATCH 4.19 00/39] 4.19.180-rc1 review
To:     gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210310132319.708237392@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <a3616c83-9a91-7148-886e-55579bf8908a@linuxfoundation.org>
Date:   Wed, 10 Mar 2021 15:01:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210310132319.708237392@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/10/21 6:24 AM, gregkh@linuxfoundation.org wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This is the start of the stable review cycle for the 4.19.180 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Mar 2021 13:23:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.180-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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
