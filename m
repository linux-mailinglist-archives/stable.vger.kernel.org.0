Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8573F457972
	for <lists+stable@lfdr.de>; Sat, 20 Nov 2021 00:18:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235538AbhKSXVP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 18:21:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235469AbhKSXVM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Nov 2021 18:21:12 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00FB5C06173E
        for <stable@vger.kernel.org>; Fri, 19 Nov 2021 15:18:10 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id z26so14792700iod.10
        for <stable@vger.kernel.org>; Fri, 19 Nov 2021 15:18:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aT6hrhuWj3ZYzGaOlZxezTwCrC6bMSZiYfy7gkx4Mf4=;
        b=BkGDXNt+StKNTgZZsZht1DOOO6ciL1KKT/QU30f3FGZ9bSTCXK8Tymdk+fHlHEI6Wg
         nlblamnDMM1AdgTR8b3FGzFsuSpjKMhcxlOQk022ouXV2HeNpT45ZBMmphXSOT1FuuIr
         t8HRPnbKSyMalCKloc2y9A+CEMybwozB6Ko3Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aT6hrhuWj3ZYzGaOlZxezTwCrC6bMSZiYfy7gkx4Mf4=;
        b=i90yDl8zlek8jZoGbMk3uzd04QUbNSHsRJunmQCkQFFFlPyqaUaj0G7pTTrxUE9p23
         jzpCeqsfpjEGWEGgZR5q58z9RiFo8H3L8mYAp6F+suo6KQWppB/auDPnwtSfczKWrjbu
         1f8nDXpdgRqBMw4xsgS4jAhxkKtIifXvJVJ+se1AROczEGFcAifwgKuYsqaBEchuWQIo
         ZqCSdE0Q1zOiaf2Yyv5HXks3LXDj3lWnwNq2QZJq0Vn0GQ5u8qcS/enadX/3DH5REJq8
         pZ/ncNcG8X0eaqYD3F2pwBnKM7VCfoS2x3NrMGVWpq6IQFcFReT35m5VZ58VeKf7M4V+
         WP6w==
X-Gm-Message-State: AOAM531M0ztdAaeFQTC2QINiLFVwmimCj/u1NrrVq+GpM1swF01bIR0k
        CIZLlA8YK/5HEuXuEWf6jLzP9w==
X-Google-Smtp-Source: ABdhPJw3XHrxFaZCfi1/jt5fR31gpMg9fn3PLrZ1/4xILAsgyGr+Us49qMkzDTc5x16LqVYN1PHTcw==
X-Received: by 2002:a02:caac:: with SMTP id e12mr31829423jap.29.1637363889403;
        Fri, 19 Nov 2021 15:18:09 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id c22sm600143ioz.15.2021.11.19.15.18.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Nov 2021 15:18:08 -0800 (PST)
Subject: Re: [PATCH 5.14 00/15] 5.14.21-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211119171443.724340448@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <bca7991d-ccf8-de7f-beb9-52b61bfa8f4c@linuxfoundation.org>
Date:   Fri, 19 Nov 2021 16:18:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211119171443.724340448@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/19/21 10:38 AM, Greg Kroah-Hartman wrote:
> --------------------
> 
> Note, this will be the LAST 5.14.y kernel release.  After this one it
> will be marked end-of-life.  Please move to the 5.15.y tree at this
> point in time.
> 
> --------------------
> 
> This is the start of the stable review cycle for the 5.14.21 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 21 Nov 2021 17:14:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.21-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
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

