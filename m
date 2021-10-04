Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 819754217DF
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 21:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234105AbhJDTrX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 15:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234107AbhJDTrW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Oct 2021 15:47:22 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6ABCC061753
        for <stable@vger.kernel.org>; Mon,  4 Oct 2021 12:45:32 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id l16-20020a9d6a90000000b0053b71f7dc83so23030667otq.7
        for <stable@vger.kernel.org>; Mon, 04 Oct 2021 12:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=07R5gtr0thKi8lqLlG7iaoLNNPBfHPfEwZ/0yOtKxFE=;
        b=WacU43aABjY1hTR7biZosffgSg/bbqO1aVw+ELOz2yAzExtR3dbygI9G0SDdePbGON
         Uxn9y/SYbtAQdFHW9ITIiKWu00McMfc7XNk4zU+hgi0efjHDgBVLNGggIRkFxEK2x/Qw
         l4ThxeZHSrFoYsMzQkWEwvKTEq5qtP34ajWLo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=07R5gtr0thKi8lqLlG7iaoLNNPBfHPfEwZ/0yOtKxFE=;
        b=upHAVdHDMCj8/wn4FY4X4wnZ48S9xmc4r4BKbjI5U9nppCd6pLsaVbZEB4i8hGwAJp
         9lkR3MdjJaGUoRFgNiDPUaOJnvtVD8as0Wo8H3aLKg4dWogX1Hw9E5xms8DT9uGfc13N
         0PzE9hyuDJ4SRbyvhlx5PxPcU+9H07QSNY4KpzH5oGMsahLsvqb0Kphn06H2TITCio9r
         FlVo0e4EYuK6cKjs8yUHNqZtnhHd/HNXicsDCn3c2ClmdEbyDeS6zdg0HJ6zbZ9i0ldA
         Ovou52mvugoGgGEcdPul0jqLKT+F0wvUfmNZJ+f1PHNMaXyBMmX87dIoKLiHvLZ2kg8X
         qgdQ==
X-Gm-Message-State: AOAM532SE9xKODkw2nBD5nvr6WfYHh3varyk61yOjrZZxZVuNGPDJdsU
        OA/gU4YpE7XY3Y1zKU/0vl7AUw==
X-Google-Smtp-Source: ABdhPJy3nRsOFNUpTnUX826E1YhNIUSsAil3VO1RNvSiGEF3H5QAMR/1WIwJlr6xx6dYoPwSPEde+w==
X-Received: by 2002:a05:6830:1644:: with SMTP id h4mr10446196otr.199.1633376732264;
        Mon, 04 Oct 2021 12:45:32 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id 30sm1795392otu.18.2021.10.04.12.45.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Oct 2021 12:45:31 -0700 (PDT)
Subject: Re: [PATCH 5.10 00/93] 5.10.71-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211004125034.579439135@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <0fcac942-a969-1bc1-7f8b-15abbe4dbf0f@linuxfoundation.org>
Date:   Mon, 4 Oct 2021 13:45:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211004125034.579439135@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/4/21 6:51 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.71 release.
> There are 93 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 06 Oct 2021 12:50:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.71-rc1.gz
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
