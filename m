Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4BF54802C1
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 18:26:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbhL0R0o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 12:26:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbhL0R0o (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 12:26:44 -0500
Received: from mail-ua1-x92c.google.com (mail-ua1-x92c.google.com [IPv6:2607:f8b0:4864:20::92c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4482EC06173E;
        Mon, 27 Dec 2021 09:26:44 -0800 (PST)
Received: by mail-ua1-x92c.google.com with SMTP id p2so27757993uad.11;
        Mon, 27 Dec 2021 09:26:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=BTNObzR7wa6fFqfDjRZRUmFN+jzNO+k7X/yYBbYXPlc=;
        b=gMjabIH9P5mCtzTVy/8PIJO5FBN2hkYTOUKKMd7nbBqWg1QVuhBu58N0kEkUZQ9aRx
         cGeNBNVKywvWrfxEBAUpPqsKSQYKQ4KaDwkbS3kD02nNI4CWrXLrB6/bPg2HyJQUadTw
         8P8O0AWgYY8ZtE5eHJW71EzKsGf8WKHrUkKuzwvPMvooiMhRawClJ32ZoKef/M09OMfi
         3PIQRIhbknhdCLjupdqmflB1zflIrmpIQtZfOYCi7jrGHBbhcOhE2079HFD+1sS1oxPG
         l1fAI+AdqHaNxhs8LoGq2qaY5TYnrO/ZWc8KANuBWNRJCi1yce7oI+X4TfFS2CW0S5Zb
         DGIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=BTNObzR7wa6fFqfDjRZRUmFN+jzNO+k7X/yYBbYXPlc=;
        b=MfEHobztKb5DidK/jqgUfoy1SpbXkhrZLJRyQUcVcxjmSbSlLBwA+PLMPgjLMLCnIn
         EG5l/D6C49eLKJGefnND0RU7JvQRQ4A06fm0OsSM8B1kvKwYvpfr09MBiO8pwjDcu8Zi
         2LLGHMxAqnC4m7HQVNBR1neY9hadsIHvxE2gc+YuRg5nISpZBTKDTywGmZtaBOxUluV8
         TWtZ179zQ3ojPRitHLESaANnoTyyqNMl1Lsq3/RvgINY6b/jgbr0mfIfXhmzooMAziXo
         4zkkGh3C5AuyrE15BWHJ7cFMrCTHuLlxDI11puqiorVm+6CMPQ5mm+SD0tk9BrCnIXCk
         VmYw==
X-Gm-Message-State: AOAM531YINPrOPxo9KszRJLbMflnQNv+VYHL+XbFX9QREgV7IgWgWDQu
        7fYM6oR0VAYwjLl2qjYjFUw0zFRy7Zc=
X-Google-Smtp-Source: ABdhPJw51TgiBdDGQLKYJFS81bZE5MKpY8jYAeUBjQR9XJyM8Yqo0/h2YSrdEH42jGI0oyqjaNNltw==
X-Received: by 2002:a05:6102:509e:: with SMTP id bl30mr4556535vsb.43.1640626003307;
        Mon, 27 Dec 2021 09:26:43 -0800 (PST)
Received: from [10.230.29.137] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 63sm3192031uak.17.2021.12.27.09.26.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Dec 2021 09:26:42 -0800 (PST)
Message-ID: <9495a9a6-fd17-dd6d-97b1-08d5a8b822ec@gmail.com>
Date:   Mon, 27 Dec 2021 09:26:39 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 4.9 00/19] 4.9.295-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211227151316.558965545@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20211227151316.558965545@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12/27/2021 7:27 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.295 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Dec 2021 15:13:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.295-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

