Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9E5734DD74
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 03:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbhC3B1R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 21:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230388AbhC3B1G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 21:27:06 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 797FCC061762
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 18:27:06 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id z136so14698310iof.10
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 18:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fRAE/WheTlRGTuVVO/Vczac1fWfkN3AKYXmkl/E6nZ8=;
        b=L/JVv/iC/BLXngDoIkV0yKrE3X8r1yvD5kZAF53YQzLssQwLLA7NxZwxNMSO7sp0q+
         MYS5rGGs0oOnXBUsQ9rK2T38m5Y8U2zlxTGkUdrvDk5mZY3A77jrzuKmfJcekvsKM/v2
         dWrk3aWQWnomNG1XapRSxQKxyCT5KzRmFn4lY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fRAE/WheTlRGTuVVO/Vczac1fWfkN3AKYXmkl/E6nZ8=;
        b=eCruxPM/ta8SX56lgXDwPvf4cwcTryBme0Ts9Ja/z/IMjb0DSDqdOxOi0EsH9njJpu
         h0pBvqdAD3+oe53E1OkKgnsG4etFvoVJQl+gV8+CxJizoc/yMtkyWyKXy95SB3GOzf2O
         l2VN0PosC8pm0uSe0VHzw65fBiqqAnkqpfG+pP3fzHSN9XgarEHSf1ee8N8Oqkrcuj7w
         LA6645Bn/MVWQDs2q6W9Kt+HOH5Jwo5h/u8TvgF6Y612xVlAt+3bIpyjXhPQ8jlagOK9
         5VGfWGvRpK+1AirV23G7Hpl3MdqU21TahbZhFPfmBn7nmDlYISIKniFT19mwCbo0Mo2/
         Y+ZQ==
X-Gm-Message-State: AOAM530SMojj64Cv1KZg+wdg3ptvUIRNDGZBqCZx6/owKWt9hQUuXKr/
        ULOE+JnxnFDgaSwIUpOPPpVAYQ==
X-Google-Smtp-Source: ABdhPJy2Fctleg3XEnc7lRwVYohRHwidIPSc8SJyOxroRTPy0Aftf20k1xBwVp7dA9yVBsVlHNusGg==
X-Received: by 2002:a05:6638:2726:: with SMTP id m38mr8147372jav.6.1617067626005;
        Mon, 29 Mar 2021 18:27:06 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id o8sm6659219ilt.4.2021.03.29.18.27.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Mar 2021 18:27:05 -0700 (PDT)
Subject: Re: [PATCH 5.4 000/111] 5.4.109-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210329075615.186199980@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <91fd67fc-f55c-262f-17b2-31901b2806fd@linuxfoundation.org>
Date:   Mon, 29 Mar 2021 19:27:04 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210329075615.186199980@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/29/21 1:57 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.109 release.
> There are 111 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 31 Mar 2021 07:55:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.109-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
