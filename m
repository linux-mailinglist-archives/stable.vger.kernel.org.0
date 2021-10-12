Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B89C442AB72
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 20:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233508AbhJLSE2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 14:04:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233250AbhJLSEQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Oct 2021 14:04:16 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2904CC061764
        for <stable@vger.kernel.org>; Tue, 12 Oct 2021 11:02:15 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id n7so15790288iod.0
        for <stable@vger.kernel.org>; Tue, 12 Oct 2021 11:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HWMBYFcPPSpPSOapwvCHPnEcEXN+cbXNvc/FUpmqj/s=;
        b=gzUMOO9quRcSZIuuuShZ1OIpfju6KJCf6HA3a3gQxZEB8+cZ9zdJaFm+GIMIvNBhcM
         jA3k8y3uSFHvYhTaVYkfW8IApKmorL7CQ2vScSAhr5b8odfL5cAp7XZynEGV7fgumiWe
         vb3r6qBfFLsO/tP8niYUUJJfQzOdV0tL0hSZs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HWMBYFcPPSpPSOapwvCHPnEcEXN+cbXNvc/FUpmqj/s=;
        b=E8joJ3IsrvpKhNDT6jJF/CYK/28VxhZp8UsU7rz4tx3jMJB0zBUnefxv2nLijHg+Sg
         dY9T0egRQF34qfh4lQQKnsh9QxwIL36MUTHlITKx+2sVOFqCrnLwqraXGrFibkUUGyDj
         eLVKpjxxxi0hfn4Wbwgex73POVM1b9hLdL3/0zQlCRjxav2RYHW36ew+hNGo9avEP+L6
         sjQjjI+6OfeBaO9yM3zLiqR9/YWUrQZUn8DDBXK5bqTDAT9ixcN4TgxgneESE/y7PIP3
         pjuR/gYonjlmim8MF6mbOvSEytRSKLiA2vDe5spsRnvsKN8JxslTO2zMzlWGEkzu6N9j
         TI3Q==
X-Gm-Message-State: AOAM533XLtaTh11Rmf46nAah0kdk5ibD/tFm4Raj7tEyDEAmfOyy9hl1
        DaOKojXz1BqR/7bqLLU7FaVk9w==
X-Google-Smtp-Source: ABdhPJxImgM52y6KPEok3S6p210meTqd7Uz0eoFQB3wM34Wkajm5FoQyVG6+/QIu9yf4Uf42uuLjOw==
X-Received: by 2002:a02:c761:: with SMTP id k1mr23313375jao.74.1634061733815;
        Tue, 12 Oct 2021 11:02:13 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id s5sm5836403ilq.59.2021.10.12.11.02.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Oct 2021 11:02:13 -0700 (PDT)
Subject: Re: [PATCH 5.10 00/81] 5.10.73-rc3 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211012093348.134236881@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <06abb5fd-ab78-6819-b5dc-784866e8de60@linuxfoundation.org>
Date:   Tue, 12 Oct 2021 12:02:12 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211012093348.134236881@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/12/21 3:37 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.73 release.
> There are 81 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Oct 2021 09:33:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.73-rc3.gz
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

