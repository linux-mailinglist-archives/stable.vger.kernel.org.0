Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7FB42718F
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 21:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240479AbhJHTvf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 15:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231408AbhJHTvf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Oct 2021 15:51:35 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F5DBC061570;
        Fri,  8 Oct 2021 12:49:39 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id m26so9072749pff.3;
        Fri, 08 Oct 2021 12:49:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0tKzt9N3xvFa5iJIR1QUieKHhNP4G1ot+Kb/UJKzTgo=;
        b=RWzOAjGY8rzho53IoomGAnc0QBvpyNjUmVm4qXb1CSXfct8JjTJQ6mvfpG5O9Yvvdw
         2NA6VO6u4ThTO7LQ0YKkTVp8iQYa/AgnsYw7T16m6tQD5hKTsiHMENs5VQjo5CTAwZkm
         e0jqt0UITpYS93AZiUTeBjjCuLRCwMntNqnr8SIiyRlf+2tKynQt5GvY4Srme1B9gTPY
         bSuAyr4MtSKjqta5sjnDhXqhMh0XqZqK4TOU8TaYG7kwBNL6mE3kdjtC5kHUFeTnTimb
         ujfLnkU73MfhCkJs89vGnn2jz3LpWMFpvhagYfPTijbY540xIK6Uz/3ylrPwhHYFy3CZ
         NZkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0tKzt9N3xvFa5iJIR1QUieKHhNP4G1ot+Kb/UJKzTgo=;
        b=v85fhWOmW7yC2BVD7xHKXxgmvau7DhgWGB8nb/UzsVNDRxe010sOwRz6831EbIWtHd
         GY5KPSzwY6gmyX6j7KcYa3hU2LiSJldHQvgOY+cqmfSEHKMMitYATUndatEbC+47WUDC
         nvzcJvVeXFxZm9GhlEzOpOpeq+c4wjKXz/S4KYXWX0Xgl8YM7lKFESPRcuYyb0tRFMo2
         Xxq6Z16ckTcSm1txRNmaBbeLUCZs4cHiiu3BHcqZZ8QCg9a48zRtodhEpxP2HFf+krMm
         56siek8hjGKG3O4f5BCjuyXnxT4B/Lcez8HRWf5fH9lyivI30LTD9I2dMTHf2jZ3hdo6
         aa6g==
X-Gm-Message-State: AOAM532/9NoGsEo8GjTNZ0fydH2L0mOjNBQYL4y7A9qFImneeWa0pDrA
        rlZZF74N+WVdABwB/YZ44KwfSZPsCrg=
X-Google-Smtp-Source: ABdhPJxbcnvmAXYaJsGITKnx6tL/jFWvsrp7BBZHH2RwwTToxZYNkzNtXHBzu7dldQDDs9cvmtPyAw==
X-Received: by 2002:a62:5209:0:b0:44c:68a7:3a61 with SMTP id g9-20020a625209000000b0044c68a73a61mr11815886pfb.83.1633722574663;
        Fri, 08 Oct 2021 12:49:34 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id c3sm141430pgn.76.2021.10.08.12.49.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Oct 2021 12:49:30 -0700 (PDT)
Subject: Re: [PATCH 5.14 00/48] 5.14.11-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211008112720.008415452@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <e1e59aee-662d-30a0-c00b-911c7b3f3503@gmail.com>
Date:   Fri, 8 Oct 2021 12:49:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211008112720.008415452@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/8/21 4:27 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.11 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 10 Oct 2021 11:27:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
