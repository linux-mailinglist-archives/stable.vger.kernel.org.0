Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 093BC417D51
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 23:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343831AbhIXV4N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 17:56:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343807AbhIXV4M (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Sep 2021 17:56:12 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2DDFC061571
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 14:54:38 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id n71so14611969iod.0
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 14:54:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=q38Oq3zB6vT3rS4b58uZixkcliQwq7tc2umti9XDQ5M=;
        b=FZczlILtndYiyrBMYEdfIs6fQ7yImeB7In7C/8PJVZKVxilfF9rV+ZemQ9Z8RNYpp7
         SjsbRfjiOEqNOz/f3nXQ9fJCU1UzNUVSPS+9oI9AxnINP4BrQ4PBxMv4D4MhGx6kI3WR
         Vkf7HUmzF5MQeDATmgqLu3dCIARkLhYJIYqPU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=q38Oq3zB6vT3rS4b58uZixkcliQwq7tc2umti9XDQ5M=;
        b=Q/J8n2gx4w2ZfLR+yuwWgIDXG839J3F/3heNQgy6PPLP2xGjNUYRb8/23DsPgtmDn2
         1TCMBc/fbJi5WSUEAvfXASanmAf61SjHSEC2qRgMz7c9WUHOJOVhZcvuAfW/TovABhAI
         TiPn6bnimXBCY9s4VpGEkfuZ9yCCV9i3MI9Q8wArKOsaI/Fn4hmqN+zoVgVe+IZrt4Cg
         93WrxtmT0C1i7TLqHzWDDPBR7bxkR7J9noXRe5b4Uc7Pw7Q7zOa0nL4qzzHbQYL+76/a
         ZO+e4AVuHOmFo7/OasGtmLKpisnfZVA7MwXegQmcP1YmhQ/V2YHvYTQz07XwABjJKXpy
         pB7Q==
X-Gm-Message-State: AOAM530SgMFo3iZr5fK/7Ek8jszoTdp2sNFXznDfbo0H2CS1/NzXCJVY
        Oqiq06xEBuraAdzZ2s3gD8Jqjw==
X-Google-Smtp-Source: ABdhPJyOermPvQNyX+qjeSDqJw+ZTTJbZ/swVgLlRgD87mtrsUKqKV93NYX9aw5V1PHRyNUo39vyaw==
X-Received: by 2002:a6b:6002:: with SMTP id r2mr10938689iog.53.1632520478452;
        Fri, 24 Sep 2021 14:54:38 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id m1sm629750ilc.75.2021.09.24.14.54.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Sep 2021 14:54:38 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/34] 4.19.208-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210924124329.965218583@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <a68ef83d-6fb9-c175-20a2-1865a25f0b91@linuxfoundation.org>
Date:   Fri, 24 Sep 2021 15:54:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210924124329.965218583@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/24/21 6:43 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.208 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 26 Sep 2021 12:43:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.208-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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
