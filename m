Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD593799E4
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 00:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbhEJWSU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 18:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232887AbhEJWST (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 18:18:19 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A00C061761
        for <stable@vger.kernel.org>; Mon, 10 May 2021 15:17:13 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id e2so15493791ilr.1
        for <stable@vger.kernel.org>; Mon, 10 May 2021 15:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/laF9BmtKgW0H9f31XbZ7aORx9/cJFSeWS1RclZqKOA=;
        b=SW/BdLubqAYtSRc/EZHC1ubsMHTit8zd61l7A0lnXKJcrqRRyIw7nVk5t90IUOzD2g
         TAfMYCINYdZtabrZNDgpv0OTZhDz3MfSbuZ7g04smYyLsvSKplZdnWNp6XMW8zkdggVo
         B3jpaahRI/rP3iLK5aiA3ESP6BbI1jsSGUxZA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/laF9BmtKgW0H9f31XbZ7aORx9/cJFSeWS1RclZqKOA=;
        b=k/yfB//cNmnY7FJjfKVVhXISaeEhrI5O9UJz5l3UOJiUV4stV0nFGfBLj2Jt4mIjK6
         QNgntGDoB2Vtguxo3N1ihYuG+ZWqehedPVdF31klqTJPC2HIN0IgEClvXIoahFk0C+uk
         Chgm5d7ce2J2X6f2rxekbgSvG9zQTDBx73TJpStceZbt0sTAqDhjegwEQj5m4drEnVWp
         +oMtby97TrJq55npLElw1oezq7ok/ILiJKhYumW9B28CrHyA4ed+kVr6LhcdlCyavcK/
         qz4b/tr0rNdZMxK6CyABO5zj1xmBkQXETLg97xdj1f7VgoFjMaZ0rp+QyoTO6wbhVX3N
         NvZg==
X-Gm-Message-State: AOAM533DfxrI5f7AXVbg02r2hstvEWJ7vJzba11llWKriHy3Ed4HAvjI
        VCc1O/v6+7iJ2RQ23yNWyEL4eg==
X-Google-Smtp-Source: ABdhPJzRIH+YbgP9KRMFE6knQOq1ivnoPWKRXz2Up59glpEYt8oGiCMKGYMNBhH5bjv5bOEieXTxCA==
X-Received: by 2002:a92:3f08:: with SMTP id m8mr23152475ila.154.1620685032960;
        Mon, 10 May 2021 15:17:12 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id 21sm4468589iou.33.2021.05.10.15.17.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 May 2021 15:17:12 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/299] 5.10.36-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <13d32122-b888-83ea-a4fd-09c6c95b47af@linuxfoundation.org>
Date:   Mon, 10 May 2021 16:17:11 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/10/21 4:16 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.36 release.
> There are 299 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 May 2021 10:19:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.36-rc1.gz
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
