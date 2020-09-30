Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1A227EAE1
	for <lists+stable@lfdr.de>; Wed, 30 Sep 2020 16:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730417AbgI3O0X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Sep 2020 10:26:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730195AbgI3O0X (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Sep 2020 10:26:23 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D0BDC061755
        for <stable@vger.kernel.org>; Wed, 30 Sep 2020 07:26:23 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id b17so1828962ilr.12
        for <stable@vger.kernel.org>; Wed, 30 Sep 2020 07:26:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cXCGZW/GuM/5IOGO9paoSAgp1GRJ9/f9ioRwrrondRk=;
        b=hVT5IYuQbm4+R/MaWscloTgYa6KLFIYIP+yvBJFftu9/VNQXLqsmsTkhLIxeffa9Gm
         hoIx1BmGvYx0O9XzM0rS3j43Q0gjQM+n6NgIfLYD0lW9VhuBhFrZRTw0cUNauzSyXHa4
         aYSpbhfzACd+dXcI96PmOt3EmmFwzYmFkutOc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cXCGZW/GuM/5IOGO9paoSAgp1GRJ9/f9ioRwrrondRk=;
        b=tbZKUpnpozkHCd9HVpR+TwidLpvjNSE9GzWhmHnHwc1mhu3wyXOAr6anERalknSPtZ
         ij6UqMqNF9kYhlBKI/qG7ZlasJax5nObnKf5zhLpFLHqTOA6XpBtGE/TxbGkDazwgAbk
         m4eol41GUsCkqb3fKYOps9elUjI6NkwHS+7G+MYcGVpOpBLUbJ6bB3fn96oKDRpBr2Bt
         O/Xw2tlz+3syJGBzZcofP2itxSmIJAI38ib6xP4CNXXN3cd8ck2R7n5OMnW5JBWWzUj/
         K1FRwlBfsRZNM9NgCedOTOe4GdD76BWHE8VfLBNUH9wjR4Sp/nAxRNB8HgNMVIm5cvGy
         DDPQ==
X-Gm-Message-State: AOAM532YR0Inx6VZgyKvX0HKUHiOsJt0vpyBhO/0doeFE+j0JBhWUmqi
        O4vaTYKoceBglSf8f36PbZZPXQ==
X-Google-Smtp-Source: ABdhPJwJq99LCiW4dbxu7/1wfjBE8vbMmdzUT70U+UHn12UbveeC1lTwiANg/xU/9r7IJZite6cnpA==
X-Received: by 2002:a92:9f56:: with SMTP id u83mr2237059ili.30.1601475982321;
        Wed, 30 Sep 2020 07:26:22 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id o5sm1058008ils.88.2020.09.30.07.26.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2020 07:26:21 -0700 (PDT)
Subject: Re: [PATCH 5.8 00/99] 5.8.13-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20200929105929.719230296@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <6e54e620-dbeb-0a39-b641-3fce97267b16@linuxfoundation.org>
Date:   Wed, 30 Sep 2020 08:26:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200929105929.719230296@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/29/20 5:00 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.8.13 release.
> There are 99 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 01 Oct 2020 10:59:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.13-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.8.y
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
