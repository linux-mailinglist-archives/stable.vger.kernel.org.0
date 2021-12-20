Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79E8147B624
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 00:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232968AbhLTXTh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 18:19:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231765AbhLTXTg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 18:19:36 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D356C061574
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 15:19:36 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id j6so7383539ila.4
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 15:19:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DW8wPu9eqK0gawnkdcmcEY13lZdnSdmHittyZk+DxFs=;
        b=U8Jv0/3HOqMzCTyOC1e02jDUYy1nufNoPJvR3wGNnprqsFspz5SDcH5KaQN/+Vcg2J
         rgAk7QpWuMFdbJYfSxGuCYVsFQI++H39/MwPOJk7o/bGrtg4Jxy+ogdDHvIF+e1f0ZgM
         +9w1Yy2APn7/cnv0gITNy7/Mtn1PvGuC1tvSA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DW8wPu9eqK0gawnkdcmcEY13lZdnSdmHittyZk+DxFs=;
        b=3l8UNPfcheRyatJ2sE7FjOfNlZrO9LR8jVAysJf4vPYGyAZ2IA1tFs8eIVuGgR8SzS
         NPZLATzwKldH0rMRKuOdL5DE+78m9S0JW3EqK0E8UaM3uwIEKbyMCG5l67f61Lbo3gUO
         A0uzT+51yBfZDj7RobzXV0NIkXC1N5kK+IuRAapy4T2XZZKSTPStcjUW4w8CzCPKhh9j
         XQlnmI6paag4yDDY+onfDDaJDEsHZvNs9kg98m7uBhsyph3GibWk6Ym/RagM4OPGK8nd
         woiMx2Sx/sbcPmMbTBCVngJtmyrRBmclCrpEpjyRHAqAlCEZh0HyUo33kQ/25NfDFCYs
         8eGg==
X-Gm-Message-State: AOAM532A7bB4X/Kb5DbDCqS+0eTUT4W/8z5LK7GemNWajDg9B58c0cZs
        +rqzeX/DJhgvYI3wAYKSYdQk7Q==
X-Google-Smtp-Source: ABdhPJwajiYUTIZMBkjfMvOHaBxT+FKyRAIrMIR3ZfaeoW8VBJX+Glig0tT1UvU9lYiJEFmVkTDblA==
X-Received: by 2002:a05:6e02:b2a:: with SMTP id e10mr175834ilu.80.1640042375947;
        Mon, 20 Dec 2021 15:19:35 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id x2sm9820928iom.46.2021.12.20.15.19.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Dec 2021 15:19:35 -0800 (PST)
Subject: Re: [PATCH 4.4 00/23] 4.4.296-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211220143017.842390782@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <159ad835-37eb-887d-c556-7a8e809b6aab@linuxfoundation.org>
Date:   Mon, 20 Dec 2021 16:19:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211220143017.842390782@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/20/21 7:34 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.296 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Dec 2021 14:30:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.296-rc1.gz
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
