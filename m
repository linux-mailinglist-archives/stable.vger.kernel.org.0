Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 423603A6F37
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 21:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234188AbhFNTiV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 15:38:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233804AbhFNTiU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Jun 2021 15:38:20 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5354C061574;
        Mon, 14 Jun 2021 12:36:17 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id u18so6530073plc.0;
        Mon, 14 Jun 2021 12:36:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Cyr83LbV58MwQpyUsJoGsMK99Ov9lne0HxCQCyb3otE=;
        b=VxsfX32q72o8gxVzAsamkw2uV4jB4r/Cfb0xKBri+rAASUmeC4B0gjQaq8tJDLcu4y
         qCp0NG9hH26zDd6LHl8CsNmlEDg86n98SMwxRKq1ztZ9Z2nbKoL5wryPkbpLboSBg0G6
         KU3boFNKyNXOhadVjE0MG9+MgTdkC/8+QlEohmiqMePuWrx/wpAqpTWQXaJL+lP/UGoE
         tDU3buRhBrM7b1v1dcJq79hvXFrSCQdlfCynqe5M81twlM9EWPpEmMTJxEJJ+WdXLcf7
         jQCrLt6aLOu0Pb5o+jOi2mPz3fKK+dbh8jf106RxEPETkCzItnC+1B6CGHzlfk0ox51X
         fLDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Cyr83LbV58MwQpyUsJoGsMK99Ov9lne0HxCQCyb3otE=;
        b=rJsx/ALpqJL9ZZbhFgnS4S+WqQKzO92dNJsMjkVnjprBT5RLy5yO/M4uyS/USGUVdb
         03gcypl7St2dr7C/Ar4aZK1ZB4+t+JkrrwuNcrhlvnlqdMKB6aLsdNy7tsq42xBxuuEL
         vc+JQc0NwjJQCrDD301tPwQHCmIA20Ky+iiPBRERGnLJNLljM2J5/IGDPPeie8pOweb8
         cekjA0bHFZYkq6UHmfl1jUxVSO+qdllYMPtxmuVovxSaaXugK8yhKEPv8OrNg1JPckhi
         lpSvdqfD5Ntec8P9BslynnRVz5GTIoovE45mZEBocbQLvZoHinQOfAKWwTPFLEvMJ3U/
         +fgA==
X-Gm-Message-State: AOAM533Fwj7XQ1dbqq0ESTPy+r0jqBQQoWxujmfUA8Wp4YhSBfqy0DGc
        naaDicGINX07Gvfjm58IaBVtzv2snMw=
X-Google-Smtp-Source: ABdhPJxiudasxnIesbYkf7TF0HkdTwzgMIYtOKXR7sgKRxUIm+gc7jXc6yxmiQpiEpp2wN0G7cEO3w==
X-Received: by 2002:a17:90a:5b0a:: with SMTP id o10mr744115pji.143.1623699376997;
        Mon, 14 Jun 2021 12:36:16 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p14sm14418216pgb.2.2021.06.14.12.36.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Jun 2021 12:36:16 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/131] 5.10.44-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210614102652.964395392@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <1ad5d266-0537-2dfb-c3ff-32262c64affe@gmail.com>
Date:   Mon, 14 Jun 2021 12:36:04 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210614102652.964395392@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 6/14/2021 3:26 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.44 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Jun 2021 10:26:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.44-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
