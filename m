Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB2EC3BDF71
	for <lists+stable@lfdr.de>; Wed,  7 Jul 2021 00:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbhGFWqM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 18:46:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbhGFWqM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Jul 2021 18:46:12 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A84C06175F
        for <stable@vger.kernel.org>; Tue,  6 Jul 2021 15:43:32 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id m3so392472ilq.13
        for <stable@vger.kernel.org>; Tue, 06 Jul 2021 15:43:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3z8HBALDhOfGLffR7q59/CWkLOtZ+J0gnG3EuaIOkM0=;
        b=GZ97IW5VEu5PGuRXf66jMXZdDUN8UDxtI3QG3ZDWv3+3YGOyjKhY0dz94bkPOFMgLx
         dXgjU1PqN99cB3U01SYSw/spjzhpVoI/HfvVu2k2ZmgdYLyaDLb8CNqZUwHilSsAYotH
         FTNARhah/1j4VgjbG0eKnN+z8sUPFjZZS/aww=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3z8HBALDhOfGLffR7q59/CWkLOtZ+J0gnG3EuaIOkM0=;
        b=Vipyy0w0IaCKM84Mp9Oba7WCIsiCoSQ11XSaz1E9zOHOgEpfyqtD99fQw2FOgt7MsL
         kvHWwWvV57PnxFPiWXFtngzuzwR7W99YEijHkwRUQL70b9eijFoWjHX3CI7q8NC/Tz13
         ol+I1exA8VYpqsZzO2tLkBTr3dnseMxb1YLjP5nDpb4kkAP421RSpvhxbNcZBTqOh/aA
         7QIzLDtE/EkqYvsW+gk6MfxwJdCwzB9K06Y/5WSOkRzclTwIqKfp406uROmrJ2gxbS13
         4m8/eubG51fJem7EZ62ayobkn/7NxK4cGFcDpbgKTcCqUKwaIiA2+mQC30BPs808ZY5V
         jmWw==
X-Gm-Message-State: AOAM533IIA7MlTTJtyQD3v72zuJkYtgsKAF7+BsQm+twnA/nvhuERiDo
        N2I22x6KonE/Pbj4wgbciVKeqA==
X-Google-Smtp-Source: ABdhPJybywlT0BdzN0NtmHN1lET+td4hMM6XIkIfXgfEgICRaXnHvSFKs8/uksqZHPmj3URtqDtUGw==
X-Received: by 2002:a92:c703:: with SMTP id a3mr16022097ilp.118.1625611411484;
        Tue, 06 Jul 2021 15:43:31 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id l8sm9292699iok.26.2021.07.06.15.43.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 15:43:31 -0700 (PDT)
Subject: Re: [PATCH 5.13 0/2] 5.13.1-rc1 review
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210705105656.1512997-1-sashal@kernel.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <41c9c1e8-f151-a8c4-2681-f8700aa6a9a5@linuxfoundation.org>
Date:   Tue, 6 Jul 2021 16:43:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210705105656.1512997-1-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/5/21 4:56 AM, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 5.13.1 release.
> There are 2 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 07 Jul 2021 10:49:46 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>          https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-5.13.y&id2=v5.13
> or in the git tree and branch at:
>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
> and the diffstat can be found below.
> 
> Thanks,
> Sasha
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah

