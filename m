Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2414A43B825
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 19:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237792AbhJZRaO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Oct 2021 13:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237794AbhJZRaG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Oct 2021 13:30:06 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0807EC061745
        for <stable@vger.kernel.org>; Tue, 26 Oct 2021 10:27:42 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id l7so20073iln.8
        for <stable@vger.kernel.org>; Tue, 26 Oct 2021 10:27:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=s2zwyCBh1paOTTXt8fUDSGpqKi4SEJ035/tPnw1p0ys=;
        b=bysRDNs/cH0nCs8nZorj4GcQlPV5VMCvsoLeV9JeMCq/9NfeuwuWYqw/OoSGmSRE5n
         jejCz/D6vwP5OgBACVd3hNzalo2nXzwQHSPSNHzFfSJkCepx4WNN+sR+GC2Mt+anIfUq
         7KApmv61aXd9L1qjJeMqw+Xl5tsbxoaMVZQfk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s2zwyCBh1paOTTXt8fUDSGpqKi4SEJ035/tPnw1p0ys=;
        b=3rJPpAqCJOSw0Setge6CDtq22RED/+wjVNfL9wL6Q9sS1p1tgCnqX4sQSQRYDkYQfP
         eRgCBDTGLhhvUm63hI12OvvnLIyhekYLdUvtP/DXUIWvlnX1a+hW/A8mkQtEXAszdvDm
         LGoOOyL2bRX5yeIphEsSamFMFLD9gVEOxK7dz4NbmQqgs2LukQ3SdiDlx1dHofcuwPNZ
         ApuwBCEdzqzQ9xsj9rQsiRiN/IZhtgQQIuP64mimdXoZ64okzloid1rOuXicHYnpVQs5
         IQX2WTCX4yp6X6WEFUDMWDF9pHUe2tQ8i06E3FaBSI2JS6ovDvyAvCms88k0EZuHCS07
         lGdg==
X-Gm-Message-State: AOAM531fRUvKeEmSq+WPob6OdM/EphRamdy4xIVvKfR9gvDSt6Nkuh93
        y4PYTC/XxDyaohYui7B3uQGnkg==
X-Google-Smtp-Source: ABdhPJwRhooGocSG2/tVzmMEh2bgcM+NlDbdaaTCuj2XBdh2pRrbnX5lFdWjfxgXzRY/m3sSoRNHOw==
X-Received: by 2002:a05:6e02:f44:: with SMTP id y4mr14161710ilj.117.1635269261515;
        Tue, 26 Oct 2021 10:27:41 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id z5sm10208797ile.42.2021.10.26.10.27.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Oct 2021 10:27:41 -0700 (PDT)
Subject: Re: [PATCH 5.14 000/169] 5.14.15-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
 <46e778e2-0f9a-576f-9f4a-8964b8b9ca50@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <71236fec-39d1-7601-4523-b06ba49b5da3@linuxfoundation.org>
Date:   Tue, 26 Oct 2021 11:27:40 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <46e778e2-0f9a-576f-9f4a-8964b8b9ca50@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/26/21 11:25 AM, Shuah Khan wrote:
> On 10/25/21 1:13 PM, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 5.14.15 release.
>> There are 169 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Wed, 27 Oct 2021 19:08:09 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>     https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.15-rc1.gz
>> or in the git tree and branch at:
>>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
>>
> 
> Compiled and booted on my test system. No dmesg regressions.
> 
> Tested-by: Shuah Khan <skhan@linuxfoundation.org>
> 
> Upgrading to Ubuntu 21.10 caused issues with the boot related to
> zstd compression which is the default initramfs.conf for 21.10
> 
> If others run into this:
> 
> Change the default to lz4. I ended up enabling
> CONFIG_DECOMPRESS_ZSTD=y for 5.4 since it has support for ZSTD
> 
> On another note CONFIG_ZSTD_DECOMPRESS and CONFIG_DECOMPRESS_ZSTD
> naming rather confusing.
> 

Please ignore this comment about compression for 5.14

thanks,
-- Shuah
