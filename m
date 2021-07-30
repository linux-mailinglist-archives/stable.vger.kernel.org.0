Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB643DB142
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 04:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235692AbhG3ClF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 22:41:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235417AbhG3ClE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Jul 2021 22:41:04 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F8B5C0613C1
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 19:41:00 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id a13so9647909iol.5
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 19:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tugBZfvXYKoFGzI6owhVnazhFLhG64XJlSaQgwvf6t8=;
        b=SrFhycpDxLOrIWOwVPhmpCqO3FrAwvJGwaDNfSEpRRnIo2T1lKXtdo12Cr4oKopuob
         z5moMF1kuYumy4wXVFzNwFdsmEX6G4yEkya1ydjgfRJuBYKH1GVRhbGnXM0sC2fRdi43
         cDcoNZkR6psEEPm0CXMffvE/LiYDlRIE8KOG4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tugBZfvXYKoFGzI6owhVnazhFLhG64XJlSaQgwvf6t8=;
        b=Rew/oDR63s+JUEEDUvHu5x4S1QLOH5ez7eOmSLMf6kRmPi3ErGQ6zt0TT8j3m1QUY5
         BjPz4qm9vY0If6XqpGE/bJ/809hWWA6gINWJa9dpmviIm4m/Btkv3+nPsp8jS75vrmtT
         ibkqusV46r4vG2zmZV5A3iRVE9RpsQyy0bLwgLvfNIoESNckasrQYY7bmwFUywVOlI40
         uuiFeQZg9FGxBrtaWnBCj60i+A5pwIrMlS608pkf0hQ4TbiYLACbyI+rcg7p4J3BoXS/
         wFTsgjlC0GRS6jdXskjiXd1c3jZ6OMaOJEMO+Gq+CyhiX/sqzp16m83Ewvr/XYeNnHXK
         m/QA==
X-Gm-Message-State: AOAM530HKYRqBLx1J1l8sZgqmbyIoSdov+nPiFdV8LoeFRLY/CEXHOmL
        QW8ZsTD3xNSvvJTE3DctVX8eAw==
X-Google-Smtp-Source: ABdhPJxEzaV34qDtQVd165S3oR3ElTt197wzvR4S+cwfPqPL+TeZD3pFHqphEeFFUsQ6lGanMM+EhQ==
X-Received: by 2002:a5e:a818:: with SMTP id c24mr413057ioa.180.1627612859518;
        Thu, 29 Jul 2021 19:40:59 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id r6sm164147ioh.27.2021.07.29.19.40.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jul 2021 19:40:59 -0700 (PDT)
Subject: Re: [PATCH 5.10 00/24] 5.10.55-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210729135137.267680390@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <b64db143-6a10-c052-db7a-74517f73fc6e@linuxfoundation.org>
Date:   Thu, 29 Jul 2021 20:40:58 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210729135137.267680390@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/29/21 7:54 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.55 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 31 Jul 2021 13:51:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.55-rc1.gz
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

