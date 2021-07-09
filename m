Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8AE3C2AEF
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 23:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbhGIVnK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 17:43:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbhGIVnK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Jul 2021 17:43:10 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D065EC0613E5
        for <stable@vger.kernel.org>; Fri,  9 Jul 2021 14:40:26 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id h24-20020a9d64180000b029036edcf8f9a6so10929057otl.3
        for <stable@vger.kernel.org>; Fri, 09 Jul 2021 14:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QIHH0Vr7DE52Bl4e9VjhaMJuatVGStHYfexDRtUfJ00=;
        b=GqXKV+DNuQ07bSjVKx8TFl4qGL1nQIWAEZY9Z0b+TP+o3gB80KjT8Y/Y3+TYsaF+kV
         ef6A1QJpTo/dbGqpyX3J+hgnTs2BKmDeuCenyfspBVo+iUyus/uVDdL4yAiPTFhm20wN
         L+DwkPGkAa5HBjft9kl1BV+/U/QuLxNt9irKI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QIHH0Vr7DE52Bl4e9VjhaMJuatVGStHYfexDRtUfJ00=;
        b=s3DHq0M+wtYBimGRruTAm28UWLbNMB6xHXntqWBrhl3Knm846AwmFRZnP/4AsHuUWC
         VNFLsAlOiOyIO7SuTus+oQ+UmdxbC2jRM94yFq0eL0wUic2BjOPjE2gdPEKiWKKNyMR0
         B+VBYhyjLx2YH1Ll18Td/cKGlf7LgifSHxjVCLNsDJg9vibjcrI8k3iTfxMa2+Cmc3tT
         fRgOa3cZ+GICTKyW06tnI3TlSzDS/YNSAP/4wMuOneH4+2W4XNShBf0LaLWNO4ozzIPk
         4TIyO4Cf8BRLNkouCE1z0gZdyWHh6sgXft+sUOfV4fn99pijTDlhX7SXX8m4u/MjQbk6
         gGDg==
X-Gm-Message-State: AOAM533bLYu6MAMnLegU+yLvaWseOejEtIBHMq6Ln8yMvbBFcf51lkwo
        TOkE7GNQFqpn5e3xPRS77PVRAyiG71rRVg==
X-Google-Smtp-Source: ABdhPJxAU+wi0ijHJjllrZ+C0AOM+8hnReuCo5y87yK3KrxeHioDmrw7u4wKsCmEi51PAya54ZMD2w==
X-Received: by 2002:a9d:6a81:: with SMTP id l1mr22090200otq.239.1625866826225;
        Fri, 09 Jul 2021 14:40:26 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id z6sm1406038oiz.39.2021.07.09.14.40.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jul 2021 14:40:25 -0700 (PDT)
Subject: Re: [PATCH 5.10 0/6] 5.10.49-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210709131537.035851348@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <8ea08d36-c3bc-6080-2da6-b1a287bd993c@linuxfoundation.org>
Date:   Fri, 9 Jul 2021 15:40:24 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210709131537.035851348@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/9/21 7:21 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.49 release.
> There are 6 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 11 Jul 2021 13:14:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.49-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
