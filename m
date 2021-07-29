Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F39E3DAFE6
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 01:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234443AbhG2Xg0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 19:36:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbhG2XgZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Jul 2021 19:36:25 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A991C0613C1;
        Thu, 29 Jul 2021 16:36:20 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id g23-20020a17090a5797b02901765d605e14so11824822pji.5;
        Thu, 29 Jul 2021 16:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=g84HSaU3rfhYGqgbKJC9g/CW8a+DWMUHo05N06Zkn58=;
        b=FiaGIghVljWc3hHZrmHGZctK0i1L7SJgT2A9tGL4j7r6R+B+xQTo9XIwPAYGAfxCBf
         gGJCbCURTNO4tKo3whwsYunRBNvrAoM9lfGOSIu2xFIDAzA3GYZFGM6ATatCLCIuZPA+
         WKeDewRzp6ZHYCMvFD7WwUH3Li279mB8E260/TO9vwwCv66KLX4lMy8O7AwoqHd3XW36
         GetysPZ48vqiI+IDT2cp1jxap3cc1y25W4bXXT6qwWIWc3A+m222VxWHLkylkdmUCboz
         M0sbumxML8ntKzSdAcPjVRWgWilauEzLF7WrFcjnWyKiE5GnUBhyJ+CTSF9vFQ/6xKBm
         RuPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=g84HSaU3rfhYGqgbKJC9g/CW8a+DWMUHo05N06Zkn58=;
        b=AHUy20AnLLIT3i66d9yAZMjOzXOM4XzIDqyYlW34lwRG7zYiAU3dWPI/K2N543/trH
         7igH3ZRceokDnRD42ouh3/N++KaRcati1ZgiH3QdJYjRNUV9XgtJkDuu+3A+od771VpD
         MCf+fLD5AFx0xWoYr7Cuh6YnKb0o9EZAoGOd4ZKk7LvlHrr3Do8tEWU+9suMgRPLWmll
         oVcATijDSTDTyfkVDl46w6nGu3zlb9UXbMdz2dP9FElpJiA57K31sbgvapR9UC6ZcEeS
         7uzxxY3jifJu0GFZZI7SVkRr5LPRZ6wGF8k5ZXRBtBVjJi+qfVeTEv2x6h0XgpuJf685
         N87g==
X-Gm-Message-State: AOAM533RuNKM3pwD3T2XQGRsUf6WicWFUo7g+6OhBitsszdcYfiZSOpo
        JSWUuq58+SWQBmKHvQJWmGiRHYySaVI=
X-Google-Smtp-Source: ABdhPJyBrl3LbAHuwkAbJE+2peGdI+c3zYo4lfDlxZxNONma+gGfYGLa9DYtW67Kd1h0ghvMW/uMYw==
X-Received: by 2002:a62:15ce:0:b029:3ab:42cd:d156 with SMTP id 197-20020a6215ce0000b02903ab42cdd156mr2917201pfv.81.1627601779346;
        Thu, 29 Jul 2021 16:36:19 -0700 (PDT)
Received: from [10.67.49.140] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 6sm818833pjk.1.2021.07.29.16.36.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jul 2021 16:36:18 -0700 (PDT)
Subject: Re: [PATCH 5.10 00/24] 5.10.55-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210729135137.267680390@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <05eebb1d-43c7-e9bb-ea41-6a628326d25c@gmail.com>
Date:   Thu, 29 Jul 2021 16:36:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210729135137.267680390@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/29/21 6:54 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.55 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 31 Jul 2021 13:51:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.55-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
