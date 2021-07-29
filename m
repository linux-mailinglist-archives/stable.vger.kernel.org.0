Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4EC53DAF78
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 00:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234458AbhG2Wua (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 18:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233896AbhG2Wu3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Jul 2021 18:50:29 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F11FC0613C1
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 15:50:26 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id c7-20020a9d27870000b02904d360fbc71bso7475231otb.10
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 15:50:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ypj2utpfciylNFGFFZ3wDJyqCqU8NHRgi8CgObBGu0Y=;
        b=Sql9qkyB7720PCMjSIL43qlg/uNTEp2UXzYRsZi8QJmK0VCxuwC40Hsjhm7VoR+95W
         tv5m9MNV7qIsQc2t3q96ANqm2ByldgbOx+UiBjt95az6SuKyR1K+wmkNCGjKV6j49/ww
         VrFzKLebRfNMtiE5PCqbeOsZfzU9yu/xUYIpE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ypj2utpfciylNFGFFZ3wDJyqCqU8NHRgi8CgObBGu0Y=;
        b=Rz4HaJfG+vfG3F3PVLX9mUpTxK01cygw8GY1Dmfh5NoSl0GqJ18DZNK59eyrGkhs5/
         TTceT2cVAJkAie52VIC4ODbNT3Dls495RO3QFrSzt3Se68MvsXkW9SjT87U/c7fL137e
         Va6r7fl2Vpef164gK9qOzDmDMnlNj3wfHxYi26c6B7bOfjY4WsjWTVyICEk8+gUEv71x
         HwgW9NMPme9DQP44fjIi8MCs/SPDw5M+t1QGPOtO90XBwMvwVuousP6gYFhALbgrByKQ
         PnHh4qy7k0QZNrTW1LL9zqa0T/8SnS9oqxV+Us2W4zgSIakSppp4DdqfTQbWapbjp+uO
         2HcA==
X-Gm-Message-State: AOAM5308uIJ7Dpt2jk4HAM8wH2ba3aoSu/nfKbA2r+y9z4OwPklJgs8T
        zykjoJ5Fy2S7WrlmxV1E0fHqoA==
X-Google-Smtp-Source: ABdhPJz2hqsmqotdwGjU1uVxBQqS02wkc5fivdN5CeeqGNq3ghdBagShEz5EL3UapOjFkHDHF8G8jg==
X-Received: by 2002:a05:6830:12d2:: with SMTP id a18mr5317933otq.363.1627599025504;
        Thu, 29 Jul 2021 15:50:25 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id s35sm773388otv.44.2021.07.29.15.50.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jul 2021 15:50:25 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/17] 4.19.200-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210729135137.260993951@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <84ff69be-abf9-e945-8023-2ffcd3fd5b8b@linuxfoundation.org>
Date:   Thu, 29 Jul 2021 16:50:24 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210729135137.260993951@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/29/21 7:54 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.200 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 31 Jul 2021 13:51:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.200-rc1.gz
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

