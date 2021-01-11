Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D77D2F24E0
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 02:17:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404030AbhALAZW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 19:25:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404143AbhAKXjC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 18:39:02 -0500
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 541BAC061786
        for <stable@vger.kernel.org>; Mon, 11 Jan 2021 15:38:22 -0800 (PST)
Received: by mail-ot1-x334.google.com with SMTP id q25so563193otn.10
        for <stable@vger.kernel.org>; Mon, 11 Jan 2021 15:38:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rUs9B0GBzcbQupCp4dQGB5oaFGpEbU2gvOFBT7hS9pI=;
        b=Y6vFICgdPQg+RslusFSizFWpROSs5dTM3on8cnCuX62snvSEo8S8kpiPmkXnJ/zr8N
         xiebv7nZjm5VRe3i1YlWaXLYvL8bfWkn79m1Gdi5gafA8V6jscUwiuqvKad17k6Rlm+0
         uxc+MfL722ANsrLADxcYS4XaSlXOzcQnZuMSU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rUs9B0GBzcbQupCp4dQGB5oaFGpEbU2gvOFBT7hS9pI=;
        b=NzSJiUsmD6Oxh5zagTSJEpMMNkL3wzMTCcJVm9Nv+lJDkHdyTIEQTlh3d4o5AmgivV
         NnjcqMms1nQ0Xk0bTtwGSnchtKEtn4tP+w33YJepQr+0I9zeJvUpWGolJN7RHZNKsS2g
         hASJ2XSZYvc+ouEu3tu4iVwakFYupnXVDWey0H+3z6fjv2W5P6VPJK9mGfuFd07T6YQw
         D1430mvu5QYhirVvwBKmttK6q400p4jAoisgi7uD0qiBWNcUsPglFOtVUVL14/hzBh4g
         Yv7W2j8oiYZUZ3RHQbue9aK4AOCre0Mnd8r4AjWjeAyZRqgDKWr9REvGjadO/9pvnjBZ
         ppKw==
X-Gm-Message-State: AOAM530Htc3r/3Q8/HL7ZyHY2+hDlez6e9y3lUKTy3XrP/BT+AMBDfkz
        OnPG+Oh9bY5PT54qpm06V42/Rw==
X-Google-Smtp-Source: ABdhPJxC567gjlAwPeCNwcNL3IqBJ3gs02JXDUD52aZ4hfHSp4qrhzCIr33hiH97GC1kMSzxRCZM0w==
X-Received: by 2002:a9d:803:: with SMTP id 3mr223415oty.331.1610408301591;
        Mon, 11 Jan 2021 15:38:21 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id 39sm279466otu.6.2021.01.11.15.38.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jan 2021 15:38:20 -0800 (PST)
Subject: Re: [PATCH 5.10 000/144] 5.10.7-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20210111161510.602817176@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <86231e8d-f3f4-9f02-e436-761f93b881d7@linuxfoundation.org>
Date:   Mon, 11 Jan 2021 16:38:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210111161510.602817176@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/11/21 9:15 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.7 release.
> There are 144 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Jan 2021 16:14:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.7-rc2.gz
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
