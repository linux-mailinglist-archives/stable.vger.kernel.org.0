Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15830409DE8
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 22:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242271AbhIMUIb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 16:08:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242319AbhIMUIa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 16:08:30 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33C4AC061574
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 13:07:14 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id n128so3198476iod.5
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 13:07:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SstMYN9Y6kYAHn8TYVum/LVcegTItQer/pPQe9iDNAI=;
        b=dOuDkES/Mj6+o7yprciTunrQRAniyB1UDOlLAXXu3L2W6PlPCAE89e0dX9u2L7TkV6
         fXInFnE8dF0+fbnZPejXlbfUbUUn2oANFfNtEo7ROU68qURnh8eI9flGgSB3AkTVzKXB
         Ej7VwcgXf1YY2qjTgppADRdk+Hb0Jg9S+Axeg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SstMYN9Y6kYAHn8TYVum/LVcegTItQer/pPQe9iDNAI=;
        b=cGBzwujVNY2ppXlW+8qslnfRrVv5vH0+9VQW5GtoXEv8BpVp06eBipq9ewyjCpAjN8
         19JhNpA774KZ+vpgWZuEAMXjfIjRNp8gPqSTpBVfqwPfaIYyWjKIABfMhIm10yOC1U9R
         NNW1F1XjAtFzXGNP4PMN0S9K6TWfirtQ7aMM+7Ows8PncEhBehu7zezlnCiMaocogAAr
         5LgM0LH0fFzXGOLl8/S40isXNqBDL0K5aOkq40vwCzS/LBLPkVj2mK7QLqVIIGo0YkgJ
         xOQIgW2eHP9yL3/NE/w4nSLYsn0MmlxFhzv9/+Gqiz8j2Xrem79sajFE8UgMae9XL9N3
         8m2Q==
X-Gm-Message-State: AOAM530RcnP5lYwXHICf8KLFEmYhDZHDFIysUyfq/OdFK7PRA295n2uR
        uRqhHDbpPbZiJqO0Mx6anujBGRYlGi4IBQ==
X-Google-Smtp-Source: ABdhPJzeYf082OjGWixKEvAYoGjYYa+L3pulpSl+shHahZVy9TlLy2Ruj0lefHL0nz9U4LBYtm/l+Q==
X-Received: by 2002:a05:6638:d85:: with SMTP id l5mr11162033jaj.2.1631563633695;
        Mon, 13 Sep 2021 13:07:13 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id p19sm5253417ilj.58.2021.09.13.13.07.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 13:07:13 -0700 (PDT)
Subject: Re: [PATCH 5.13 000/300] 5.13.17-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <21805676-d400-e8bb-cdf6-642594fb0b39@linuxfoundation.org>
Date:   Mon, 13 Sep 2021 14:07:12 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/13/21 7:11 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.17 release.
> There are 300 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Sep 2021 13:10:21 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.17-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
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

