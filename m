Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD2A243B82D
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 19:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235192AbhJZRdZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Oct 2021 13:33:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231248AbhJZRdW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Oct 2021 13:33:22 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97BE5C061745
        for <stable@vger.kernel.org>; Tue, 26 Oct 2021 10:30:58 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id j6so83028ila.1
        for <stable@vger.kernel.org>; Tue, 26 Oct 2021 10:30:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qMoj/JXo773pb9LB9XZ4nlPqhqd3gs/Ga7ZC+r0/F68=;
        b=XxP74Q9b7W6BOchkj6HAfzI+2Q/OWQuqGhMIhqbIgyDmqNSUONFFKq8nXErUjQzsmq
         hSTZqrZbhpq9oe5QsMwjaHhRyceCvMhqiLRb5akdWKeKYyqUTGUS97jhFsE8Ci8dl66n
         5ZOslaqVolarWCaFXdwT1Nv+591pKo0ZcB/Ww=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qMoj/JXo773pb9LB9XZ4nlPqhqd3gs/Ga7ZC+r0/F68=;
        b=191LiJKl4022CjmTglmv+ie8ZmYz4UnH48K6b86omdz+imb8RByVzh/p+DNipXFXPy
         sP/VEhmmBYEgdz00rWcmCW10Sqh6ViSQhlDKcnClGjsC1oGiqTkXa9O0Y2q0vvp+L4Sk
         pXJ/QWNBbjPY3Cl0Rhfkbnsl1l2RF36Ve9tHXoqC7Tcgw8W6tmTpef9LFaOcooV4SV8v
         Pw8mlNsUbwaUct6YlSRErZwIhlZJXwY+unIVraqObTk57XXXOKW+R93xKWkZJ/4iCTqj
         4YxuWKIepw5zILQjFiKEw8ASRgIJ1t793J003hBmiaKRT7yqnqXy8Ny5yWLBBG+nhISG
         YLOA==
X-Gm-Message-State: AOAM5334ltIL+NqQmB58qPXhiom1T8UtRqQZYWkroW0p8WtQABtnPNzF
        D65BVNLCEqf0vNl1KOLoUI+ASZPQk7z7tQ==
X-Google-Smtp-Source: ABdhPJwJSx75Fj6xqm//+6mHZhZoijlHeO77DRriI86X+cxPM4kjVj9MSUICtZbeTovw8G7krp37Ew==
X-Received: by 2002:a05:6e02:17cf:: with SMTP id z15mr2359508ilu.214.1635269458074;
        Tue, 26 Oct 2021 10:30:58 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id x8sm8504394ilu.72.2021.10.26.10.30.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Oct 2021 10:30:57 -0700 (PDT)
Subject: Re: [PATCH 4.9 00/50] 4.9.288-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211025190932.542632625@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <c53f1f40-1f6a-b941-5ed8-708d83fb89c4@linuxfoundation.org>
Date:   Tue, 26 Oct 2021 11:30:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211025190932.542632625@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/25/21 1:13 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.288 release.
> There are 50 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 27 Oct 2021 19:07:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.288-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

Upgrading to Ubuntu 21.10 caused issues with the boot related to
zstd compression which is the default initramfs.conf for 21.10

If others run into this:

Changing the default to lz4 is the answer for 4.9

thanks,
-- Shuah
