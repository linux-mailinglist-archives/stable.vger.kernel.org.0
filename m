Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C60A543B82B
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 19:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235305AbhJZRcq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Oct 2021 13:32:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235299AbhJZRcp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Oct 2021 13:32:45 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4504C061745
        for <stable@vger.kernel.org>; Tue, 26 Oct 2021 10:30:21 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id f9so229547ioo.11
        for <stable@vger.kernel.org>; Tue, 26 Oct 2021 10:30:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=a1U6A2ZWLNeytTa9KQ6DvkXTM80YVl1obfMQmxm8+cA=;
        b=Q6RqtzoCtXkFV5YdVj8u+iKrB5JBlM1gFZePPRp/no4NyFafwYd5iF7JgfLXJ5B6Gk
         Xz+gRe///e9AVwCxQmwDX/KLSl8k9tJD9dHM1i2c0hSrOWg0XauEtjpmDO1oyra88KfX
         IMm7LTdlTPupmtBeL2qX1ZjYFL15G5TvVCSUE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=a1U6A2ZWLNeytTa9KQ6DvkXTM80YVl1obfMQmxm8+cA=;
        b=73o0Pdqie7mdSTFrXnNfetqPlSJpWo2FiwTX/1jD365LExys+lmuKvVVQoU5R9EhUm
         48WNipNxYHYSRdNf5diabW6AzRub9JtUxSl4byt+PAaS1Q+Wb4eiXpY79LHt6aIAjxxb
         WpuRdEGxBm+M6/kLPMQXRCrUrgo6vwENqkkRmXtpGyKrc+m4R6o1jAkC9bM6KYVsA4m4
         Xryh3LVI9K7FZqPt+uQaWLI51P7qZYt3ZOAWSuPtkqecifein21dbWDM83j3Ja2bQDPz
         sbm2tJmBkq48y+TBB4tAxVIb1gEKz03KhOBiF3Rbr04N4wIpjaMOgEfGxDSAv9I6S7kk
         e7TA==
X-Gm-Message-State: AOAM533IQ+8zrPGjDnAq8K0PCilj+5jI2UNWNc5AsQU/6TwPgSvKbSHh
        27Vd6JftRsv9NUSEIwzQIIFF9A==
X-Google-Smtp-Source: ABdhPJx3Twn1eVGm2HxxEyUDT4bn2zjAi5MHaO/O28ozv7eCfv0dB1qKF7HPmJ8p0MkM6FQl8pST2A==
X-Received: by 2002:a6b:3c0d:: with SMTP id k13mr1516951iob.69.1635269421392;
        Tue, 26 Oct 2021 10:30:21 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id s7sm11683638iow.31.2021.10.26.10.30.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Oct 2021 10:30:20 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/37] 4.19.214-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211025190926.680827862@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <77e3b938-ca80-704c-7f77-4a8bf6823bbf@linuxfoundation.org>
Date:   Tue, 26 Oct 2021 11:30:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211025190926.680827862@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/25/21 1:14 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.214 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 27 Oct 2021 19:07:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.214-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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

Changing the default to lz4 is the answer for 4.19

thanks,
-- Shuah
