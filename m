Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 184322675E7
	for <lists+stable@lfdr.de>; Sat, 12 Sep 2020 00:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725892AbgIKWa5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 18:30:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725864AbgIKWat (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Sep 2020 18:30:49 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E125C061786
        for <stable@vger.kernel.org>; Fri, 11 Sep 2020 15:30:49 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id m12so9703234otr.0
        for <stable@vger.kernel.org>; Fri, 11 Sep 2020 15:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xrWJgJpkeSVBnkFKBQmIbISrKpWemR5O/kX349f073E=;
        b=WaASEkKOeSUFpn7FWyITzqzPT7s+N8hD4v5MKgz+PJzMNF8LFwruPNaprP2SxYpvaU
         2djQwCA3A8o0nfTtIaJU3JgbuwyPce2M13ClflPsW7M6wkWz3VG7PVCB6GdHIxhdFyt0
         BU4qauWGgo0szJGUle7PLBynd5bSFOO4VJPJY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xrWJgJpkeSVBnkFKBQmIbISrKpWemR5O/kX349f073E=;
        b=qMmpSpIJ7nFdB3XwItGIguM+2z5OkwJ9fdgB4S8HLpDYx3J2wbzcvXiHgh54NAcRNg
         Ap3ZCoI0Xs6gBGXJ4o1Jbn7XMEFiELgLOz9gAyHnGKgQin7fWoDFcFu7wbexs+wwHEyZ
         xtMFodv09u5NvKwGHVownYuj+LeK6AbgjwDSkTrOX2PfaitOnMjWoiZfV+XJeuFEBsRW
         RVpEuo7I7lcd/Tew4NWTs9p4RsXRgkDvKgRmwtbW2zsfei+/dzsJlbPOIP8N4l1xrMSy
         4XTOhkOTpJebOIWiaoGodwWszJTHy1fR00cH8SQZltrsxGX8mQ8qJX8FspnTQnustIFQ
         r9iw==
X-Gm-Message-State: AOAM5328M6s8luDJm/XgYAPVKvsr43MH8FpBCDHwGnkytKrO0vCRbO8O
        ZvsIepcnMHTBVscLnJNsIYX/qg==
X-Google-Smtp-Source: ABdhPJzCfnKGXv3005Ye0JD211p3GaVKcYRC4n+dgIfLX3hy/Qd+0MvyVvJiT1sJJwJX26IelBVx5w==
X-Received: by 2002:a9d:688:: with SMTP id 8mr2458266otx.122.1599863448552;
        Fri, 11 Sep 2020 15:30:48 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id c15sm526127oiy.13.2020.09.11.15.30.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Sep 2020 15:30:48 -0700 (PDT)
Subject: Re: [PATCH 4.14 00/12] 4.14.198-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20200911122458.413137406@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <a1deea4e-8d7a-3748-48d8-e4d2c9dd0582@linuxfoundation.org>
Date:   Fri, 11 Sep 2020 16:30:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200911122458.413137406@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/11/20 6:46 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.198 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 13 Sep 2020 12:24:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.198-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
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
