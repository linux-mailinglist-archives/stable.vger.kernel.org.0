Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 900CB3054CB
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 08:38:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234147AbhA0HhZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 02:37:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S317426AbhA0AAI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 19:00:08 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7364EC061BD1
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 15:35:55 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id h11so37197298ioh.11
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 15:35:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pH0HWgmxN/eit+0vMuv2N4ftpsb99TVZgeh+Q5+4pDw=;
        b=Gelg5lgNR7G4cWrcVdlxKRYn0O0KXihMT12iPs/W2N250RgwyQmJwrKfhGo3EzFHke
         lqQi9G0YcxwfYn3T0oP/Rg04ksIIy2cpJ4ZMEDat81A/0jYY6+auc7/C0SNIO9dXQVm3
         LGT9nVQ+ISH5dqbdDdyUrGsf0UVsU62vziRXo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pH0HWgmxN/eit+0vMuv2N4ftpsb99TVZgeh+Q5+4pDw=;
        b=qDVwWUXgSTBtSZ4sCkYnbwVNa1n130fHDkwbDOZ1Zrp7gI+rTEWp97ZJIBDJj+AuRj
         MmLsU4gm9So+10C/44rKh9vY1qslJUT/L+YhlEtQ3BOt7nj/KzZ9QjJvK3fcgZLv88nj
         ZkGAgFJ55/UdckBEjPcBbT1rrQnkQLdvEumRfK++nlhF/fdYc7w/4hCz9yV6SeiuA9tW
         3vYf+T8ke8+nThpCspEAJu0t/vj0wEY4QpL/t1x0IG1xD/BvmcYZn/eN6pH1pjlOxLhZ
         5gLl1aY4FF+MUSnikvg3+1G2b3dnMNjIAYJlsQ/JySm8fKxexfEg6RSmfEREDK1u+cYv
         XcAQ==
X-Gm-Message-State: AOAM5319cvKZ6oQbECYnfntCgAjmbWBvkVbevVlP3c/3aTB0YEVr/07J
        Upon2cLCmdIaviFfL46bWYjjxQ==
X-Google-Smtp-Source: ABdhPJzaprVtI8nJnCcWZh59JRO9avZF4eL+xO2BwoABUBYSOz7cit5mgbF2qeg0TWmWryNbYjRtlA==
X-Received: by 2002:a5e:840d:: with SMTP id h13mr5966446ioj.23.1611704154753;
        Tue, 26 Jan 2021 15:35:54 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id r6sm91131ilt.56.2021.01.26.15.35.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 15:35:53 -0800 (PST)
Subject: Re: [PATCH 5.10 000/203] 5.10.11-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20210126094313.589480033@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <10222e50-155c-3f01-36eb-a2857fe39c36@linuxfoundation.org>
Date:   Tue, 26 Jan 2021 16:35:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210126094313.589480033@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/26/21 3:03 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.11 release.
> There are 203 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 28 Jan 2021 09:42:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.11-rc2.gz
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

