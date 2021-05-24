Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F66138F54F
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 00:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233699AbhEXWFa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 18:05:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233301AbhEXWFa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 May 2021 18:05:30 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE66EC061574
        for <stable@vger.kernel.org>; Mon, 24 May 2021 15:04:01 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id h24-20020a9d64180000b029036edcf8f9a6so2372625otl.3
        for <stable@vger.kernel.org>; Mon, 24 May 2021 15:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7Jx6T7AUStCN+yMAsUD0+8vxHJiF2x/A73kJOCfbeY4=;
        b=LiSWdOxdo3oz4OEzihp+M0twlw1UyOEllmO80RZZhkCJh32kmQmyZbG0cyAA88T8xL
         8okNyhrmVdHZplDa+aE47L/bB9k7CwtN8AM0cjsEE1x/nJzF/enAD1+psKZnBEwP7Vxa
         cRHVY6Pql3QMBmTp3sYRMy5wHZ2HPr6F0avvA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7Jx6T7AUStCN+yMAsUD0+8vxHJiF2x/A73kJOCfbeY4=;
        b=GofKAh2OzVKahzTc/A9jfZqRsmjWhvNxBiuSRp6LdaFs9OwFPZWgqE/qanfkPM/kQx
         0r2zHxT/IJ8Pg58Cm+Ku6fVwCw6TvK6gBw1vX4fZZkjPIUVMlWZIGX98+tfs6Aq61sLU
         9czqUm2caC6utQ0MkP6sKj5GhQMZNjK0mRwLsGXn5+g7YTGs7TgISjwDooAFCsFweOv6
         e8vvvJ2icv7e5pkMC5Q7ulE+IP0UD0hftbuaCCAtqQbh0GH9Gk3inWM8MfR3BNWyseHM
         FG27Dh94uazGEJ9owfbyrQp6lOEiTMNjeLGfkGma8Z/UktnOVg35yLIG3qkAxJbOvK4R
         rbuQ==
X-Gm-Message-State: AOAM532JWGv88l/TKtUrGSfbFOrKlbgx1DJuh+7YQxkKwcQstkthdp0d
        9fOwf2PG/2kSGVSQz3u6bPzY0Q==
X-Google-Smtp-Source: ABdhPJw9FcU7UGzEiPTnark6sTZqLVsQq5rIcmG2Kv0BuNusScdG+vbwcwXi4Dl69HezWulxWhrwzA==
X-Received: by 2002:a9d:71da:: with SMTP id z26mr20879971otj.41.1621893841159;
        Mon, 24 May 2021 15:04:01 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id c18sm3389317otm.1.2021.05.24.15.03.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 May 2021 15:04:00 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/104] 5.10.40-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210524152332.844251980@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <9f42496a-c5a1-0d52-f0c7-b6bec3cce33a@linuxfoundation.org>
Date:   Mon, 24 May 2021 16:03:59 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210524152332.844251980@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/24/21 9:24 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.40 release.
> There are 104 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 May 2021 15:23:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.40-rc1.gz
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

