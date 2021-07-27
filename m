Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB13B3D6B20
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 02:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234291AbhGZX4w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 19:56:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234161AbhGZX4w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Jul 2021 19:56:52 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AE53C061760
        for <stable@vger.kernel.org>; Mon, 26 Jul 2021 17:37:20 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id u25so13163923oiv.5
        for <stable@vger.kernel.org>; Mon, 26 Jul 2021 17:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wz64oqIceKfccqacwFc7KJMmvHXls6h/Cb9BJwMP9Ws=;
        b=K/cbT02tkdoZ5hKqi4EZ+uJ/Ca1U0Cfck3JlJWuvUWwlBWMf80JaoX4lpsVjNlE5wE
         0fl5w4UH4EeHIhrrURV+i8L73nIW4Ef9QNL89DUPZSRhsMKcd7RviVoGoFzr8SnIkV/E
         Fl0N+N0bGwHk7VzEOLbsZ/ZzXx6yGzmV4EMbw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wz64oqIceKfccqacwFc7KJMmvHXls6h/Cb9BJwMP9Ws=;
        b=Edt/lM7sbylrmrCXw0oLBoBMp3ooxctRqqvSZElTmnZIuIMKRCRYCqb+6NrDy3EqIU
         PFTpGzMksSyn1UKVagMeUN63VM64zeyKmotbYufbr/+2WsyKwsNDp7It4+kWwciQqrn6
         FNwA6wAQzdmCHURI2u8H8vKUaiDrp6qXw6FXgI6roe7yMhKH2x2Ty+pfTh9v9VmwntMw
         1i36ABInq6Oon60cKNdlTM7cglYVjovV7Yy5V/z3RpcpnwrxLI7ChfApPmKrek+fuoxZ
         AX3pwLBofmLOJQf8r2P/OQXRHmkD9tHDQKV8Uqxn2OHjjXLPfeW4FALJSh1OfnpGZsmo
         AlQg==
X-Gm-Message-State: AOAM531kB7G4AKOol9kZnS1SJwMaYyznpILthEdmc+6xAAl4CsECzkUF
        fjLoLaDchw6IZ6GKip4K/wFE+A==
X-Google-Smtp-Source: ABdhPJxwfNsbwZS0LFQhPXre7HK74UenTsplwMqG4edlY/upvcLifyPXsdej/Fe75HzvEqSKc13ahw==
X-Received: by 2002:aca:d406:: with SMTP id l6mr1129778oig.7.1627346239696;
        Mon, 26 Jul 2021 17:37:19 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id s32sm295205oiw.46.2021.07.26.17.37.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jul 2021 17:37:19 -0700 (PDT)
Subject: Re: [PATCH 4.4 00/47] 4.4.277-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210726153822.980271128@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <29a2968e-cff5-2b04-ed50-d26ea972af73@linuxfoundation.org>
Date:   Mon, 26 Jul 2021 18:37:18 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210726153822.980271128@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/26/21 9:38 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.277 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Jul 2021 15:38:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.277-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
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
