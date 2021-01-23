Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30B9B3011A3
	for <lists+stable@lfdr.de>; Sat, 23 Jan 2021 01:26:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726123AbhAWAZd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 19:25:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726404AbhAWAZP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jan 2021 19:25:15 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55EACC06178B
        for <stable@vger.kernel.org>; Fri, 22 Jan 2021 16:24:35 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id u8so1724505ior.13
        for <stable@vger.kernel.org>; Fri, 22 Jan 2021 16:24:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DtNbcqsJSngTaphFUhqACWWs1J4IlLKO4LilIGIHQ6s=;
        b=fUMYRagIbG6+TFLOmTKm3Ecj7MymuOA4HqNGqsIsaj2eBBXCK910F7/c1+Lynxr1lp
         TDtHK6Q4bVTSC4LKh//UBkyfn38QathZkOQy9DL6omUeWc7mKPP4x4o1ZdUzo94/ool2
         MwAvZFawSlSknKDmj1xtMXk+GiFgrHuOwVJcc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DtNbcqsJSngTaphFUhqACWWs1J4IlLKO4LilIGIHQ6s=;
        b=jtHsLYVmCJt0r2r79fIoNLrwltmG7XZ/2IWAehPMHVrIhs/k1oqbvYzU6L/Ag/cYEv
         h3wHtZ9vBjKYIpOWdUn5Znhjxd3S5h6DsZO9WWK3gzgECdUiP6l1l4QKC7Qgkj1kHGJh
         hRFpY2jiSFrbIw9gVXKklZ5QKs4MntYscXsCEfIxyWlhAgRvvxV5iOgVt6+x6ASkU019
         Y74vqBKmWcIJqz1hCj2fadNt1m+B0lUv+Os100Kq57YL80NiDaUoSzpy8LG8iW006Y0G
         O0X3hm0Ix0wBmbSebn5JY+1kCjDaRhKf1TTP2OY6Tuawb4gJDsor7Z8kSYapQDCXG2no
         YPgw==
X-Gm-Message-State: AOAM5333fGnjZ+Bc+F8zzobN28GGOt7kgSY2Pg0MC05UtRwF7CVOtOPN
        yxnDUyJLsk+nLT+h5N3hQly5EYjywHdjAQ==
X-Google-Smtp-Source: ABdhPJy3iPBfCt2Eut2m0TBonAoi43e/Z3T53kIr1QufD5OzNwY2OKchCuU8NwDRPQTn50spoxyZ+w==
X-Received: by 2002:a92:cb47:: with SMTP id f7mr6080407ilq.169.1611361474642;
        Fri, 22 Jan 2021 16:24:34 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id s6sm6867732ild.45.2021.01.22.16.24.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Jan 2021 16:24:34 -0800 (PST)
Subject: Re: [PATCH 5.4 00/33] 5.4.92-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20210122135733.565501039@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <8d452e67-f82e-25a1-55c0-751d4478b57e@linuxfoundation.org>
Date:   Fri, 22 Jan 2021 17:24:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210122135733.565501039@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/22/21 7:12 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.92 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 24 Jan 2021 13:57:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.92-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
