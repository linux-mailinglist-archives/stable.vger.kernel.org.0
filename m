Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A087A4ACB35
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 22:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238673AbiBGVYG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 16:24:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238531AbiBGVYG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 16:24:06 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42185C0612A4
        for <stable@vger.kernel.org>; Mon,  7 Feb 2022 13:24:05 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id i62so18680370ioa.1
        for <stable@vger.kernel.org>; Mon, 07 Feb 2022 13:24:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eDdGBsPKOvyM7Z/574p8aele2pn7rCdVSXIN51c6Vzw=;
        b=Du+0+RkhqiqETOiqYXiWPu6jp39Q0WexZ7xfVvJHP2DMoWRLEqwc/Kx5LaLj1x5BV0
         YxxM8FUgr4COoWQMm1B0FkEr+BtQJHvSatr7h32DWQIbtDoTDkABfIGz3BkpZ5T7s6CP
         Hh4P8f9QHreKUENymEIafKt4pDbbT0cqK24YM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eDdGBsPKOvyM7Z/574p8aele2pn7rCdVSXIN51c6Vzw=;
        b=mRsvkDtpUeK2ZpVwzBkETaEAd6EKOiSZVZjOdD3GZ3QkFcqIWeWysJ1hybbuemZUX0
         3YI05SjA6rnO7DzShhauisztr01yNc6awmAmTlsD+A0f5mavD2dBxOp33EimEWTLwnxM
         O/KhzMUOela3KmecguaryS3wOc01h+HjCUMzwN4McqJN8CAnx68g/aJ3QBp3+XdAow+d
         m66mjPktU92pjlMaBkLp3QnJwAndUwIx7OWw6jvwiRWb8wzZIkAwW+21T0TiqNTxHqtS
         y9FT8mYbAbCLIkfKvRMpUF23o+IFidOqlC3G5aBSJHEq0ckOA5FaEcN5zk1i+3dLLWKJ
         s27Q==
X-Gm-Message-State: AOAM533qnZ4OAAJmDNsnDmBB3nPbkzeyNZlbnFht8/VaJfHYGUSiNGnN
        t2yOyzQQzEyAPMJ4T+yk3NV6+w==
X-Google-Smtp-Source: ABdhPJxoK7tl421C0IuEj2Q/ViXGNmuw2H+pYdi5YDvfIZVqmDW24CnsLyJnlmBrm69psr5ro6C/lA==
X-Received: by 2002:a05:6638:2506:: with SMTP id v6mr798255jat.170.1644269044575;
        Mon, 07 Feb 2022 13:24:04 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id b10sm4324062ile.61.2022.02.07.13.24.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 13:24:04 -0800 (PST)
Subject: Re: [PATCH 5.16 000/127] 5.16.8-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220207133856.644483064@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <c960bc61-fa37-055a-5465-02d86881d367@linuxfoundation.org>
Date:   Mon, 7 Feb 2022 14:24:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220207133856.644483064@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/7/22 7:04 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.8 release.
> There are 127 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Feb 2022 13:38:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.8-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
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
