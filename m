Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D242F4217EB
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 21:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234248AbhJDTwP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 15:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234457AbhJDTwJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Oct 2021 15:52:09 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CBDFC061749
        for <stable@vger.kernel.org>; Mon,  4 Oct 2021 12:50:20 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id u22so23173722oie.5
        for <stable@vger.kernel.org>; Mon, 04 Oct 2021 12:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aIi4xXyjdNoQlISRRqzpcoVrPTslaFUA/ea/B+cFFD4=;
        b=IaRGLVcosZmHc6IG85c902KQUpju+cV5aTvwp0WP6HlukyAVCpMCzYcBbop1F72ui+
         ccN5vTlYVS4QBbBRAdlCeWjpTAI+TVaO/nVxk+MYzMKtTa+jRilk8opyPflKNzHGHYpq
         CATbPsrTrIbzI/pVOx3Vk2iMmELj0CMEnO5bE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aIi4xXyjdNoQlISRRqzpcoVrPTslaFUA/ea/B+cFFD4=;
        b=zVzSUT2RaUTkUaxK3TWob175Ge2+s3nmC+CbwB53OQJ+VMmoXzRr4u3jUOi4QN3ifg
         h8TlSVQEW8WjSMniPEiNBsG9p5eMoMGEpDbpxfbLr0fnV6uF8Mz9oHRqlkl+sCXEdYU1
         VT3fL2rWnBlPagLlwnUFOgEKozKpZRwOTRpDOpAjJ9ME1tXPIXMavcGCgQv9ccgNQT1x
         2dxbkTXUQDzdEyZjw0UG/zMWe3d+sTFpqcPczCEeHopmCdtdM6Izb6/nCTfdZ52Mkzab
         dypwuwOfYyIZRE5gCrf93c3/TBaVi3a6FwhtGcPzawF3LTxn/Uea4sLA5a2E/gSyl/Kh
         l9Ww==
X-Gm-Message-State: AOAM531MWtNLjGLctyasokTRcFD1+8hgGIHb3iD+yVuGut2mY7kuttgq
        TfoL+9ubuXJBfZAhwqsw3TPmEGOh1HjM7Q==
X-Google-Smtp-Source: ABdhPJwgvpg8lThzJ+IZDtgsx5pb6dgtsin+iVRHnGhQkdYO2hGRL2NYApjwe8KB2vXdUpYs1CDYkA==
X-Received: by 2002:aca:1e04:: with SMTP id m4mr14513863oic.67.1633377019507;
        Mon, 04 Oct 2021 12:50:19 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id be7sm2962150oib.15.2021.10.04.12.50.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Oct 2021 12:50:19 -0700 (PDT)
Subject: Re: [PATCH 4.9 00/57] 4.9.285-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211004125028.940212411@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <eaa3d877-c889-d108-96c8-d2beb1bdd930@linuxfoundation.org>
Date:   Mon, 4 Oct 2021 13:50:18 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211004125028.940212411@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/4/21 6:51 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.285 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 06 Oct 2021 12:50:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.285-rc1.gz
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

thanks,
-- Shuah
