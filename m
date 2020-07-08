Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37EC521886E
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 15:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729240AbgGHNFP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 09:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729115AbgGHNFP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jul 2020 09:05:15 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A9B7C08E6DC
        for <stable@vger.kernel.org>; Wed,  8 Jul 2020 06:05:15 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id k6so33832430oij.11
        for <stable@vger.kernel.org>; Wed, 08 Jul 2020 06:05:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jnHU4ybCuZZYlQELmFh57D27dj28RTyWDhd9i79ajHo=;
        b=h48cBOjNmtf7x5yXbFeHtd7Hx6qMVw16CwUKWbcQBhZat4JXVBdU3ZFLvNDytpPmK/
         XaRllPX4CdmkYUl+xZH64SKTUBrlnKou81mggbJTAUbKpi7luTAocDYu39RfD28XRC1d
         p3wSfmN2FvA1eqljY1ttGqqKW8sywgW//bhQg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jnHU4ybCuZZYlQELmFh57D27dj28RTyWDhd9i79ajHo=;
        b=FvKQG7+5PjTBEz3G78ijBHHGYnRBCC6u/kJUldKb8wvSy/AmwE7jIk0iNw95+292hi
         mrSkrAQqo7IM4CWe1kBIVDv2acvwqEoX3RQ8IutyczPbOJoLqy0GCM2bsLnxVbnaRcmP
         6vXW6LQWbsgaRFNL538vVkvh8vaL6MXSvbaQzjqjusWXBjfYIzaVm/GYaFf+0zoSrkFI
         pv1Gkpc/P/PYPl+2v20JZ5FupEFOhdWroxbNW5cn44RbjCeiPmchFTgyBl/Ccs41T1Me
         9FUJ4gbNeNIYqM/uGZtyWynnWQcc+nciNQFQhTiaetq7WnrVbCUzyDelX7117GfKn98Y
         8IZQ==
X-Gm-Message-State: AOAM530fsIX94L4mwj6gugbwRPZcT6M6GelVxUGK3QxmkxlpWVSClHo9
        9/d+0ik0Jp7tHyG3NjocVRPuQw==
X-Google-Smtp-Source: ABdhPJw+gH7No5NB7zvrPYHmMGTVrSWNZb+xYGOe+4Tdm9UIvka5yC+w0QdExTvjpvhDxpAU9Zd8Hw==
X-Received: by 2002:aca:53cc:: with SMTP id h195mr820451oib.49.1594213514603;
        Wed, 08 Jul 2020 06:05:14 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id i4sm761460ook.30.2020.07.08.06.05.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 06:05:13 -0700 (PDT)
Subject: Re: [PATCH 5.7 000/112] 5.7.8-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20200707145800.925304888@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <552f9118-eac9-56cc-c321-dd9b97eff09e@linuxfoundation.org>
Date:   Wed, 8 Jul 2020 07:05:12 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200707145800.925304888@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/7/20 9:16 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.7.8 release.
> There are 112 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Jul 2020 14:57:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.7.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah
