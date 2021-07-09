Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8F53C2AF5
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 23:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231133AbhGIVqQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 17:46:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbhGIVqQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Jul 2021 17:46:16 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB259C0613DD
        for <stable@vger.kernel.org>; Fri,  9 Jul 2021 14:43:32 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id u66so8136206oif.13
        for <stable@vger.kernel.org>; Fri, 09 Jul 2021 14:43:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aqaPgMypMO2IdRAzUPV1UQJRjCHnKG3+6fPmPLHJpb4=;
        b=KS16yQgItddMmkaWyg0cFMUGpqgzmAqrFBioU1O/TASudlrPTvsa729+VyA/r036m1
         5tNssdEq5VHJI91d9BecKqmhnZybYua3DEhqnipbWzOVNY7CjnJksBFXe+8ScbBVvVo+
         sSrQCu3Q0cWbd0uYb0UI6TQvVR15dlPvNCv4Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aqaPgMypMO2IdRAzUPV1UQJRjCHnKG3+6fPmPLHJpb4=;
        b=eNRNlS/z+Xd4OcdsGDzrvbplxnJBZ5O19slYvd2HWSI3JQBFjh9fJJEJho8Vm1DtJ2
         FEbc/FkkEXufO3huD41gHx4oCAqvjrERq7Fs8B60X0QdyC6KuXLvyp0WpH/Z4EbxrBIy
         7VCCMw7n0+TqCM0dbTPpv5b4a7nXSJambCP4eYGIPRbM5Ft14CbQigt6ojidriVdeBL6
         JEngmi8lehRkIsXcB4g88r7dFvhzyzqoK0DkyGy4MZMcg1NCpkNpaZRbM9f/VylD6QMt
         Y9wJfDrLDjZoZqd+PYyO7OWSeo105YCuy/aP5ZEQkG9rtMLO6oeDpfjbecZ7hKZhyP9T
         8wIg==
X-Gm-Message-State: AOAM533XCAlFmc9k9Z8g4IP7TqHN6tfmcTnyPrjVxmxC9TrzWMz/1L5b
        KY/hDcQ0ppoN0zx3DjPAFS8AJw==
X-Google-Smtp-Source: ABdhPJzyD2HEPReuJ59kjbj90+Uywcy3bMHVzPyFZG/eG/aCJ9mZz2Bq5kvK1qt8r63P3CChIl3kXA==
X-Received: by 2002:aca:6284:: with SMTP id w126mr28826134oib.20.1625867012220;
        Fri, 09 Jul 2021 14:43:32 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id 39sm1376341otg.36.2021.07.09.14.43.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jul 2021 14:43:31 -0700 (PDT)
Subject: Re: [PATCH 4.9 0/9] 4.9.275-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210709131542.410636747@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <929331e8-4f54-1e31-2bb0-a2bf6ecc3fd2@linuxfoundation.org>
Date:   Fri, 9 Jul 2021 15:43:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210709131542.410636747@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/9/21 7:18 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.275 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 11 Jul 2021 13:14:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.275-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
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
