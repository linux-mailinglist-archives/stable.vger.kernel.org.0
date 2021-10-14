Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6271242E418
	for <lists+stable@lfdr.de>; Fri, 15 Oct 2021 00:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbhJNWZh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 18:25:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbhJNWZh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Oct 2021 18:25:37 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7C07C061570;
        Thu, 14 Oct 2021 15:23:31 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id nn3-20020a17090b38c300b001a03bb6c4ebso5849510pjb.1;
        Thu, 14 Oct 2021 15:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ozlybi8tKRl5/83koIfReggNMgS2RHxJuuBc9FhVK2g=;
        b=jFjVwOx+xwIvpmEgAC3pABr5u5XYMAptuR+pIYOxZNM0r+bfZI6ACcAcc3zqTC2IMv
         DB+j+OTJFe9SbuSLtQHEgQ/ZMp9CPsoCd2rybFk5fjP+jxXPavzpC2h+Bw8P7fkazl8n
         2zwQvkkQL1Ssz0giaYKKlY63ym1hVIrXSdKnC7QpEP8BKYlH+aKbDVvt9SFVynQ+QyZP
         pyymFZM+4uO9WdnAt5GByGTtEuELyJ/ORjm46zGD6Gx6++SyiacC+4aE9P6LvglOaXUW
         CLgFXmhK7YVMd5Ck81DW9OX15POqWgzL8WUZpjnp1kH/1Q1m94o7Ak+BIzblTlhxNNsR
         7RcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ozlybi8tKRl5/83koIfReggNMgS2RHxJuuBc9FhVK2g=;
        b=PfShgXNbJ6J31PHBAM7416D9+amo/+fue7snl1voVGeJ5qwc4NCoGJP/QI3wp6LNT9
         irbApERURT/euvUHFsXrsVBEnxtQehTezspF0c9gbaeFn+YUxhzKnTVjm4EZmTfi3mGL
         tbNBDk5STuQIPCwXU4K6iKD9tvuhnQkvOoC77e06dwJwI5Vk6S1m7C+CA9+yu4QA9O11
         y+5hFLDrQENP80/5l2YxqHzndM7pvtQNGah5wvdHv28OVo4uMdrPttUCHtLep/9FbRx2
         2+Z14puqmJlNX6ZNHET2a0vDW5kdKcA60U/06N8s4AOijqQ56HyhtLzNzgkwpfBWuTDx
         RTCA==
X-Gm-Message-State: AOAM531jpG0RCO1Z1DOo9LAUJcBYPGqYbOX7TCqPltZJKfff+ZUEtd+L
        gnlOzVP8RztrNEQyURkDNo+jcCBbleg=
X-Google-Smtp-Source: ABdhPJzinrz07qabMNXLToWmBRsINcGUtKBY17De0p9RBPqKuEBrTYR0J2APc+v5Blgimt8aA5Yarw==
X-Received: by 2002:a17:90a:3e0c:: with SMTP id j12mr23646564pjc.23.1634250210462;
        Thu, 14 Oct 2021 15:23:30 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id o11sm8715285pjp.0.2021.10.14.15.23.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Oct 2021 15:23:29 -0700 (PDT)
Subject: Re: [PATCH 5.14 00/30] 5.14.13-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211014145209.520017940@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <158dc65b-5aa2-0cae-687a-1328cbf4b8de@gmail.com>
Date:   Thu, 14 Oct 2021 15:23:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211014145209.520017940@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/14/21 7:54 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.13 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 16 Oct 2021 14:51:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.13-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
