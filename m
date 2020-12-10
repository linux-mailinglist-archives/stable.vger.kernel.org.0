Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 590982D69A9
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 22:23:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732879AbgLJVW6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 16:22:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390134AbgLJVVf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Dec 2020 16:21:35 -0500
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E614C0613D3
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 13:20:55 -0800 (PST)
Received: by mail-il1-x143.google.com with SMTP id q1so6755180ilt.6
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 13:20:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4uFGzYs8qHfrR2krNU4unXQBRmY97A7kmkkWKOiw/YE=;
        b=EQVH/dBH5yYML1g8d0nTycEaSuBQihJcJqB66swU5V1JDm1AaJCy9D6gKXyySTRz5o
         GuuHlf/9db+8H9vsFHr5z2YhniBsq0JA8rF9BXxvj8BTmp9SJfaoT8tLas/cXVRTx9DL
         GtHSXC83cCCFxjssIPLswGnKQsh8jPCAveI+Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4uFGzYs8qHfrR2krNU4unXQBRmY97A7kmkkWKOiw/YE=;
        b=koMyPkSytv7TuVU+HQjvYpLit/DKkd6PxVOEQLrHOnRsikLnNv8qxKe3A/N98HWd/o
         gozn1EQpMjsrcnmDWL1171BXKyaa0jV1AXGaXmORr9hE0neNPvj1CdqQdRIohjcQvuk8
         puP0VUOPqRDeWDAWzVXUNKUUZVSa4wuIVJiYcO4d9NaBlEAfJD/KD+EDZVa6CREJXPrf
         9Nrs81UVFtRO3t2/Hf3v1CTXKQ8S+cD/7yqek+CsUqQmj/5K8UZ47VZWwIveQmknYmmh
         /54EKctzrl+YuixOKTPCZaaP//HgOEL+ACVkevMuOyD1+YUPmdy/Vboowp5N/fi3iqg7
         j7iA==
X-Gm-Message-State: AOAM533PRw5TQgBikasBm0JUnm+VzdjCDn51WA4m6i0jGbdPQThM+/o+
        185LjegTCyt1JNuJ+8qc/a51rM8izrZKeA==
X-Google-Smtp-Source: ABdhPJy7i3mTqD1wuZZrhvadiWoZMPXlokYOkuf2XEIoMGseFyHrgBBflLL8yRZiRtFjPK51WpZKFg==
X-Received: by 2002:a92:d3c6:: with SMTP id c6mr11157038ilh.7.1607635255014;
        Thu, 10 Dec 2020 13:20:55 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id a7sm4107507iln.63.2020.12.10.13.20.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Dec 2020 13:20:54 -0800 (PST)
Subject: Re: [PATCH 5.9 00/75] 5.9.14-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20201210142606.074509102@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <f7f39893-de51-9962-db18-303ca60e57bd@linuxfoundation.org>
Date:   Thu, 10 Dec 2020 14:20:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201210142606.074509102@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/10/20 7:26 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.9.14 release.
> There are 75 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 12 Dec 2020 14:25:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.9.14-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.9.y
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

