Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C21A3462965
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 02:03:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231304AbhK3BGl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 20:06:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230498AbhK3BGk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 20:06:40 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F76CC061574
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 17:03:22 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id v23so23918267iom.12
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 17:03:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xaEDEeoEjSBOh1jN7srHyKK0bQddQfhozUdscovQYbs=;
        b=Flf2d72KifYhGpUiV3CHeKl7a+AkStXeumUOuAucR1XYFEeTu4pX6Enq6cV9vJ9nPV
         xqEJnocq3/kLgvWuw2HwC3uN74pMh1yz9gGOFm3SMqu+8izBrXSb2ghB9a5ZD9cH8e0C
         CgvJYx61mIzoGn23tcRGjkoUMnEro+iAnyIi0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xaEDEeoEjSBOh1jN7srHyKK0bQddQfhozUdscovQYbs=;
        b=ZRqTlvcUcNtPdQypnOe7Nn2KdpblMZ8Nq1rz53ev7FtqEGS5qMJGm/Kh8atYIxc0//
         GPqr4iKY50/ugNCl63SUPVv4ucw4JqmhzwojWLG0JDBB+bpwx5zFfCW2WmDZU7JrudDS
         zrk/UL5V7SPX5Zd+zE1sv8JjL/YQ5zMd1y7WoZxHtMfStSxcUPL8mRPYPvbLKg9SvkeX
         N1xZvnXAa5dO0c8ddhKRWRFoGbOU5b7ZCMlRa8p4ygK70ydAh7XHCYb00WHIo2e+koOM
         FznvJDGkdX5DkwDbjLyG5HWEIbQe5d02PwZs8vIdm4XkM4Btd03+jWzNzaA1zQphFct2
         IOBg==
X-Gm-Message-State: AOAM533srPZLxhTiT+gZbn/9VYm19erpEGFX5h0vsw2EpAxp6xjj2HuF
        wefASWXTGnZYlo6hE0i3hkZNQQ==
X-Google-Smtp-Source: ABdhPJzVvhQSU3cfNQX/SLNaVobxgQrRfifnucMk7sfs84qIPrActNF1Fus9ruPd1QuU3NRWn27fPg==
X-Received: by 2002:a02:9a14:: with SMTP id b20mr75699367jal.52.1638234201431;
        Mon, 29 Nov 2021 17:03:21 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id q4sm8936055ilj.7.2021.11.29.17.03.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Nov 2021 17:03:21 -0800 (PST)
Subject: Re: [PATCH 5.10 000/121] 5.10.83-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211129181711.642046348@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <a4b6c36b-3c3a-85fa-b193-2fbd1407d853@linuxfoundation.org>
Date:   Mon, 29 Nov 2021 18:03:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/29/21 11:17 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.83 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 01 Dec 2021 18:16:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.83-rc1.gz
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
