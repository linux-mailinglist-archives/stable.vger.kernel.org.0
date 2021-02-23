Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D549323329
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 22:21:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233851AbhBWVU3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 16:20:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232457AbhBWVUX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Feb 2021 16:20:23 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A6A4C06174A
        for <stable@vger.kernel.org>; Tue, 23 Feb 2021 13:19:43 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id u20so18736774iot.9
        for <stable@vger.kernel.org>; Tue, 23 Feb 2021 13:19:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=u63oV/IsVXItCVk9ZBbkp5bGddjxsrCAdUFEq94LYpg=;
        b=XN1ZNE/m5AhEHMFgT0dtR7cxUlPCHp2KHrIMcMtCpEjpXo0j2pqdF4s3t66+miGnS8
         KbMexGoFP0SiQChJ0zNeg0+cxOQpNeTrq0GvkU5K3Li+T1BMjdARF03KsdQeGwGu93VU
         snKhQTzp6ZVc6TAlpi4LUk1xuzNYepJUEgNNM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=u63oV/IsVXItCVk9ZBbkp5bGddjxsrCAdUFEq94LYpg=;
        b=dV3xrkfX5zmSFwcUjjT77NvEUvDMxJz+vCDlWmSp5bf6S6VGu0F0GpeKympEj2hnCi
         6TWvOmmJbe8M+6E/iM4ofTvrM8hO8+DAs2pQ2JeLQUkk2lQotlHntQ/yybmpdASn9EiQ
         ABsRi+9f2xU8zyjA38njDjU3OE6VEwrGXrZ3KtwqXBkIy36DYDmro2juj5bWbKdFDnsh
         ThgpEM62G35vrbPgCDshHL0xJsfeMfgpXEBIVqESIPK9NUfeG23fA5HomRTUowN+uI3f
         SzYkSxS0Ek8VTd7LCMT9ZgVyHV2e8Zdjnvd3x11+B3ft9lDZsrfB6dssqhOWWfkm/s4N
         kCsg==
X-Gm-Message-State: AOAM533WuwxybwTGredEvdfHraDaN93LcSC5DzA+zFT0j8otSCr7Kun0
        8Lz7RWlMwC01usYzQ4aj2CAmeQ==
X-Google-Smtp-Source: ABdhPJz1MpjXj3WtzAQRCXnHLGHgCLQ9eeKeCAyyI2Oc9yxElKFJWtDsA+zINcPA7NlfiIYn3nPaiw==
X-Received: by 2002:a02:2944:: with SMTP id p65mr28839808jap.91.1614115182996;
        Tue, 23 Feb 2021 13:19:42 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id r19sm20003ioc.15.2021.02.23.13.19.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Feb 2021 13:19:42 -0800 (PST)
Subject: Re: [PATCH 4.9 00/49] 4.9.258-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20210222121022.546148341@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <79f1a1e8-505f-68ed-a0df-8bad4767669e@linuxfoundation.org>
Date:   Tue, 23 Feb 2021 14:19:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210222121022.546148341@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/22/21 5:35 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.258 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Feb 2021 12:07:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.258-rc1.gz
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

