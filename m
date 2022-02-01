Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0985F4A6524
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 20:46:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232120AbiBATqm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 14:46:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231865AbiBATql (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 14:46:41 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ED89C06173B
        for <stable@vger.kernel.org>; Tue,  1 Feb 2022 11:46:41 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id e79so22562405iof.13
        for <stable@vger.kernel.org>; Tue, 01 Feb 2022 11:46:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=shWzrMOdzXk8dl6SzVhCHa0A4LhonoVByHBdkG2UtXU=;
        b=L2iPu7KHT5U3KiH3kV6Fpbak6OEdL4ghq3fdLNC5DK2NbdUMdugEAmICmHQ6tY0zZQ
         0CeWkWrnZ8+u6CxznmwUbQXtmcsYvogFchevImPiZjLE/kFIgRiNWdPnqRzEVybW6CGc
         dwwVqWMMe2ZubGNKQlOJTIS2V0Q1Vovcm4c0U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=shWzrMOdzXk8dl6SzVhCHa0A4LhonoVByHBdkG2UtXU=;
        b=5UUpAKV027GoYMwVmYFxeAHcNatcE/Aoz3sVQtr6IlIGQd7zRWNPf3JGSep0yeVsC8
         oakEJc3y1jtfT7eoEQ4HH3KrYJYR47PnI4cEHSC3Ehi13nKUFbjuaZELDAjQ7zpK7Wb8
         9UwIWTltycEPoGrPeYo7ej/pW86+icfB3RuTbT5vNmXNLDMoYFVwdtpyX1LYeSoyzQ1K
         sqXpee24LSlbWrWK/qf1TGkdeTTfR7/e1qHlxbuxjOeISe4TSkA29k2ikcq+mpHwgEVh
         oGoAt8KkyYv6OnAQcLjirhiaPjNktCD4SHDQ46E7rmrVpiHfS6p/zxy7GhexA0fGRXBC
         uMbw==
X-Gm-Message-State: AOAM532aVM0RRdaQyW9PMYrFwwrfg+OkWC8b+opco+qOkkI72Ttng4w9
        dDJ/GBa1RYAJxciAJCxCo7wg2w==
X-Google-Smtp-Source: ABdhPJyKVFhZsu9u898JQhGfmjZGmzxEdox5fSdXSRy3JQnXw0uQuHDsI+blU6tX3DrGjlTpABPqbw==
X-Received: by 2002:a02:b10e:: with SMTP id r14mr13984036jah.226.1643744800937;
        Tue, 01 Feb 2022 11:46:40 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id f4sm7766091iow.53.2022.02.01.11.46.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Feb 2022 11:46:40 -0800 (PST)
Subject: Re: [PATCH 4.4 00/25] 4.4.302-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, Shuah Khan <skhan@linuxfoundation.org>
References: <20220201180822.148370751@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <8ef32c1a-2123-522a-bb65-9e421fe07a7e@linuxfoundation.org>
Date:   Tue, 1 Feb 2022 12:46:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220201180822.148370751@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/1/22 11:16 AM, Greg Kroah-Hartman wrote:
> NOTE!  This is the proposed LAST 4.4.y kernel release to happen under
> the rules of the normal stable kernel releases.  After this one, it will
> be marked End-Of-Life as it has been 6 years and you really should know
> better by now and have moved to a newer kernel tree.  After this one, no
> more security fixes will be backported and you will end up with an
> insecure system over time.
> 
> --------------------------
> 
> This is the start of the stable review cycle for the 4.4.302 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 03 Feb 2022 18:08:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.302-rc1.gz

Couldn't find the patch. Didn't get pushed perhaps.

thanks,
-- Shuah
  



