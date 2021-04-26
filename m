Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F23436BC56
	for <lists+stable@lfdr.de>; Tue, 27 Apr 2021 01:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235546AbhDZXsn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 19:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237643AbhDZXsm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Apr 2021 19:48:42 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E19C061756
        for <stable@vger.kernel.org>; Mon, 26 Apr 2021 16:47:59 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id a11so5396700ioo.0
        for <stable@vger.kernel.org>; Mon, 26 Apr 2021 16:47:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+tSA2vHqduwPMny3gKSr+7+Kt2hCWAuaRx6Pwl2EWls=;
        b=VankTGYHiYvSftLoC3sBfK31lkLgaWdTOf5FDsuLiROC3LIQQ+Kel1dXvYLjTZpzd0
         t/DUDssWtapkvsrMn7kAz9P6DRVTbZiJ7CJlmGKwz7Yf2o2Awg45DoJ6af/5vcBAhVWS
         ORh3YcbUJxFANY1/M+n3iSwGqTOuRJDOXrqHw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+tSA2vHqduwPMny3gKSr+7+Kt2hCWAuaRx6Pwl2EWls=;
        b=TpRGA5bE0uK4Sk5/Xoe21NmWv31ju82ChAdQsr4huvd872jOoLgCQuw+8EqFGC7er1
         2I1HZtyNvFAyuV4cmQX7cvuGFfx8i8kk2vc8QTcNcI1r9zVOW3sQrCyKo7YbgamFO+n7
         I5kT/dy9Zsg1yPajB2Vm94QmaTf+4lb813aDimWtng9shubc3UhR508tozYcZxR87La5
         Oiv/X7fg3Ajuh51u13W/0pG+nsWIVgHJRP2yTBkeaabAjXrGM7Qi2JmKw1eAj1QWwQck
         2YXs5lS5pDADyMhSzEghsFD4nBEirQXf83rZX83D+6UQsPinE/WEPu69IeDilP+4fD2O
         uEiA==
X-Gm-Message-State: AOAM533zGUglLqnFHONSf19uk+7LiUdnj5UVaZ+3XvPj+sC0nT5WuonF
        1ljnPLLStf3tH7qzT5v8EjuEJA==
X-Google-Smtp-Source: ABdhPJxgZ5H0e5caVJQ9vFiu0mxr0nTzwS/2uZssi9TvsUJHf27jZLwoVSlvP6HbOvhMuZhbXaHwVQ==
X-Received: by 2002:a02:6654:: with SMTP id l20mr19123016jaf.55.1619480878953;
        Mon, 26 Apr 2021 16:47:58 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id i12sm620893ilc.27.2021.04.26.16.47.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Apr 2021 16:47:58 -0700 (PDT)
Subject: Re: [PATCH 4.9 00/37] 4.9.268-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210426072817.245304364@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <a8958755-2a7e-e619-6fdb-21ff879dbef5@linuxfoundation.org>
Date:   Mon, 26 Apr 2021 17:47:57 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210426072817.245304364@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/26/21 1:29 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.268 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Apr 2021 07:28:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.268-rc1.gz
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


