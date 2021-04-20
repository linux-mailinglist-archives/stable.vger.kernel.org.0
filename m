Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0190364EF4
	for <lists+stable@lfdr.de>; Tue, 20 Apr 2021 02:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbhDTAID (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 20:08:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbhDTAIC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Apr 2021 20:08:02 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB015C06174A
        for <stable@vger.kernel.org>; Mon, 19 Apr 2021 17:07:30 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id y10so8762923ilv.0
        for <stable@vger.kernel.org>; Mon, 19 Apr 2021 17:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fr+9CTykaM/VL1Pe5BL6Otoo2ID4/MAwuwsj/VFWyKE=;
        b=QzvtW03L4VhifiBiiZgKkLXiZfGbORbhhM4HS1ajyEJN8vfROU+Kc+9cbALUkeop/Z
         Y4jM8NFL3G6YQp0ifsStxfgEe0aomdHdxiJvXkEmI505R2QLZV0Lhjj8i726geXH4Dl1
         FTceB5TYwrHBx/ZORgDKsStQqKbqooyjv7L0g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fr+9CTykaM/VL1Pe5BL6Otoo2ID4/MAwuwsj/VFWyKE=;
        b=r1T9MFh+Ix+6+Nf6PGS5v/IQQeTy9LQNxXP+zlfwW/BdBQq9p5q/YQIA2JS/nWo5Xo
         ILfDOqo0IiiQ7yR7ccFpxG8VbRPw9z/pIK1c05FoNIzoJIIG8VKs2KGfX/G4jIwrvneV
         NuJavrz9Ec6n7YpEWd+7ruV9HYOzMQkFj25nYjUs11SIvmNJayMoWPyCEtSbtC3hyqcb
         0ySHkdsNxyb8wJSX/HHQXKmMHeD5vKMGHxzANj+WXVA97hlodqZCOYYHhNEDYPgTWm2I
         VzDNJzft4Ucxn+e77gS4i+WDnYeIdCUkVdPwJmwPx+tj99nB8CvPIpUrrvTVgGAfZ7HX
         5oKw==
X-Gm-Message-State: AOAM533sheFGC4+RzKOb1jQnsMTclEeDeC303aPENWuHYijy5ulytisr
        H7V2Qgb4dG0Zq35gQbj94Dc2og==
X-Google-Smtp-Source: ABdhPJyDRSHmn5UxUmErGat0/57ZFxC5L9ci7ArlCHRv/tJbZNZfvhedR3Gi6VCxhDo9jYYBYkTxew==
X-Received: by 2002:a92:cc02:: with SMTP id s2mr19015901ilp.101.1618877250050;
        Mon, 19 Apr 2021 17:07:30 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id h7sm7850690ilo.31.2021.04.19.17.07.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Apr 2021 17:07:29 -0700 (PDT)
Subject: Re: [PATCH 5.11 000/122] 5.11.16-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210419130530.166331793@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <5139e8e8-0b11-bf0f-24fa-a19f669d8283@linuxfoundation.org>
Date:   Mon, 19 Apr 2021 18:07:28 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210419130530.166331793@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/19/21 7:04 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.11.16 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Apr 2021 13:05:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.16-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
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
