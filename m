Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 954CE44DBF5
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 20:06:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234452AbhKKTJU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Nov 2021 14:09:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234451AbhKKTJU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Nov 2021 14:09:20 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4BBBC061767
        for <stable@vger.kernel.org>; Thu, 11 Nov 2021 11:06:30 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id r26so13339634oiw.5
        for <stable@vger.kernel.org>; Thu, 11 Nov 2021 11:06:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LpIa3bf3TBcLyYaC3IxwKT+0MuYL8c7Wg6LYYqflE7o=;
        b=CIYt2g5J0Lyve/8qbSE8bFc70Fm2WZUlttuBcdM6ht4dq+H1MzI5jvJ2MNha0kON8a
         THItPp/temDILqK9z76LWvDiczb0XjMKT6NolJcGtRtcQyVqI5TCd/TEkOwmrkxfPwfS
         w5SSXTA7gosLfCeIzY2ffySMunmd9UgVECTLU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LpIa3bf3TBcLyYaC3IxwKT+0MuYL8c7Wg6LYYqflE7o=;
        b=5rbExfjYiRUbxCYXkpsMAUbg89xKt3ab2al+b+RHhUfzQOmGTsBeaCNp7QV8sZpGI/
         B+oibsD01asGJBEFSVPxh9eMEHRxhfUrhk56LNtdnuptPJO0u+9AXt/NS7K+4tYEbdyR
         yWlvDiqKsNZzr+GW8u+7C8fNVIsyUhUpQrxSJ/naiOKoiaBtDjofPdcYenqbOpZ8WtcH
         W/lfJN2s8I1SpWjvuTBTeoHQ3U/BNqmSI+0SXgECYWGIBwF6squtB24g/T58M/AhCIT0
         e6/lun/Uco2rvT9iLkgmVJexbUpW7xO3ziSvyoRZUcMwbzk7y2qxEi5ydrAHYxB09ng0
         7N7A==
X-Gm-Message-State: AOAM5313CnplCfLgCpY3oeks9ewrtsEpt6pyjxSiBnt7KSVGIflF4+uo
        4zS4VEF0pXr3DxO7dQr9tb5c8A==
X-Google-Smtp-Source: ABdhPJyzzQSEz6nUU3Gp0wOt41rFinz9WqOulfcmPc/hA/zS+esoIM4qOgOpzTZSa1znyYMEkoyl6g==
X-Received: by 2002:a05:6808:1287:: with SMTP id a7mr22286086oiw.59.1636657590264;
        Thu, 11 Nov 2021 11:06:30 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id j20sm865199oig.52.2021.11.11.11.06.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Nov 2021 11:06:29 -0800 (PST)
Subject: Re: [PATCH 4.4 00/19] 4.4.292-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211110182001.257350381@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <43b28e19-eda2-1da0-2e50-e390c865ea10@linuxfoundation.org>
Date:   Thu, 11 Nov 2021 12:06:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211110182001.257350381@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/10/21 11:43 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.292 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Nov 2021 18:19:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.292-rc1.gz
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
