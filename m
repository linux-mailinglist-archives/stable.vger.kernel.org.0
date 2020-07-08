Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC95218AEA
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 17:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729924AbgGHPOA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 11:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729812AbgGHPN7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jul 2020 11:13:59 -0400
Received: from mail-oo1-xc41.google.com (mail-oo1-xc41.google.com [IPv6:2607:f8b0:4864:20::c41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEBA0C061A0B
        for <stable@vger.kernel.org>; Wed,  8 Jul 2020 08:13:59 -0700 (PDT)
Received: by mail-oo1-xc41.google.com with SMTP id c4so5360046oou.6
        for <stable@vger.kernel.org>; Wed, 08 Jul 2020 08:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vCLsIz3cUn0ECQyTT1GzhIyLiG7jZa3O4U6Vs5fBW0Y=;
        b=EIRYuJm0AM6Zp6FgWg6RlDHM7aWTT35bXIJZi3FOegpSBk/MNR8CLtEyAJBr0vb7ef
         bHAkUI7u2rdzStiBAfejkkaj0hPNFPeAme5cDkJ9T4nd8sLDXANAgMG5fx6ER7sxgmE8
         HYdpGH4Rmd22kk3ttGv+tm82LPZOmjJkLaog0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vCLsIz3cUn0ECQyTT1GzhIyLiG7jZa3O4U6Vs5fBW0Y=;
        b=G3kOVa93UtcNm5r4b+wPgWNhkvh/3t9nr1QUwYJo5zVlZVILpvSGwRpbfMGdT6MC51
         ciRU2WY21TdORZK+5AxX7Dt0KwpqrzMpSkysYG253/Anv6a8MSdSoNdNsaSHzqC8Drm0
         N9hRLpJk1YHLwY9pCDAanKpcnRy2vVVvOd0Z+xltCi7dOQPmgUgw6hGXGOConBj8AaUz
         ghFQfdwhfgMsU1Wdc0mq3vaddWKPVlo9anY+k6DbuEVe5TLIjL9wK8g0QtB70XpAoJNd
         CvztDYL7UL7hTzjm9ffse9nLHjnrel/auVt6ZLPt4SdEZ59BV+68Qzucfi924KfxFsaz
         Au7w==
X-Gm-Message-State: AOAM5326NvZWp0boXMj4VE4wb50ozP3cAEs+FTIwpkpELUUQouklJsm+
        GEQa6c5ehynVv8HHSwbcNHKLVA==
X-Google-Smtp-Source: ABdhPJw1ChwjOnjxHCznvTWZ0JUFggHDYyOer1CD9zW0IxpwuSvoSuk1s7U5Y7aVta93OINJzHheJw==
X-Received: by 2002:a4a:b34b:: with SMTP id n11mr51096516ooo.41.1594221239214;
        Wed, 08 Jul 2020 08:13:59 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id v6sm30783oou.2.2020.07.08.08.13.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 08:13:58 -0700 (PDT)
Subject: Re: [PATCH 4.9 00/24] 4.9.230-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20200707145748.952502272@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <a64805f8-f026-af4d-11a5-8e8b12ce3f17@linuxfoundation.org>
Date:   Wed, 8 Jul 2020 09:13:57 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200707145748.952502272@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/7/20 9:13 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.230 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Jul 2020 14:57:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.230-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
>

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah

