Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBA033A6EEF
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 21:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233804AbhFNT2X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 15:28:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233965AbhFNT2X (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Jun 2021 15:28:23 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B60C061574
        for <stable@vger.kernel.org>; Mon, 14 Jun 2021 12:26:04 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id l15-20020a05683016cfb02903fca0eacd15so11922920otr.7
        for <stable@vger.kernel.org>; Mon, 14 Jun 2021 12:26:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oO/DFsinHfrjOd9hhaHYq6LD/oHJkMh4L4js/wcq0QQ=;
        b=B7vA3xYHvbKYylvardbQujQscx4z1Q1lcZfd0AX8gtk/zb+EcwPvXP0vVK+FcoiMRX
         84M9DIGt1X9R0M80Eh6Diyln9yF2qa0oQvrG1feo+7IFlcj9cy8kgIXNDXIHrsXY+PRm
         xIjVGWzOACkt/ugkTkk87Us9gkUClEXXCV10c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oO/DFsinHfrjOd9hhaHYq6LD/oHJkMh4L4js/wcq0QQ=;
        b=uFvuTHYypR9y1wa0+0vCat51NYdVQSmTnKme1oVfjznvuUAbzyr7CdMzsjzn8kzgWV
         Gcgw8/iloxF1g4DdQh9pdZ1k4IK3+KynVO+00A2D6urFWuOSz0QDidhxkWUfRanfWJAk
         3xDQRUyA5PIiY4lEoE/dHrn5fA0HJu/3siNEdwlgQN2Vq+7wgcAroi7aer93Z/SftxnX
         dfk00LPmcIb8jtDewOPMlvnqNF+IM4v+1jnEf7MXKI5ywS5a67h27CQvZg27RLpVv4pM
         OQp57eEmKgtBMBmBThVoX7TOvN85rxMkQGx1zTFKRZWhEJT2MIp1HTiB+5V+kjI9luPS
         BdgA==
X-Gm-Message-State: AOAM533HSXjg77tL6T7PWKJelVkMMdHmwfGyMWVsIEFJFMrhRidwMKbK
        Hjga5phIkcS3hBEZ3zSbYQBqyw==
X-Google-Smtp-Source: ABdhPJxmXMhRNJRhhQ9L2vURQkong90t5A1f8V2Ry+nmiijSkixB2RkEXwFgs6N+ybBLfCj4bxF2Sw==
X-Received: by 2002:a9d:3e53:: with SMTP id h19mr14589620otg.260.1623698764297;
        Mon, 14 Jun 2021 12:26:04 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id u42sm2881205oiw.50.2021.06.14.12.26.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Jun 2021 12:26:03 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/84] 5.4.126-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210614102646.341387537@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <40674f5e-a08e-b447-1020-2dccbd6ccbd7@linuxfoundation.org>
Date:   Mon, 14 Jun 2021 13:26:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210614102646.341387537@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/14/21 4:26 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.126 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Jun 2021 10:26:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.126-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
