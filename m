Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2098C218B05
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 17:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730028AbgGHPSs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 11:18:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729500AbgGHPSr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jul 2020 11:18:47 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C30B3C08C5CE
        for <stable@vger.kernel.org>; Wed,  8 Jul 2020 08:18:47 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id t198so25549116oie.7
        for <stable@vger.kernel.org>; Wed, 08 Jul 2020 08:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZuoUzrDuDd0J/oVgMoGWhxlVUdrJuDrqViZgxHnlo/Q=;
        b=draIj9k8f7stBC5+C3bynh8LM4vQknVR0yAsbyEFMVqoHLAg9lVDQYES2yFYA6G2SW
         gmRHxGfw9NtoUTmF3rBh3qGYhDYdCljoRZ6JbagyUQBFSuyEJCmdVDPmqs2WY4pblNEN
         eqkwRVStrD8XXeqn6pDFkCzSBIr4ltf07PpOw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZuoUzrDuDd0J/oVgMoGWhxlVUdrJuDrqViZgxHnlo/Q=;
        b=oBv7udqNsSfQWcqy2KWLaBmu/s0znPhHhr6cyB+wJdG7k7uLOXmyP2DO5LH18eWAhL
         slf+zA6GfVAvBKdJauJMXdV8/62glkpUG7lUm/UZQHorHfevkzRhnF3FodEPBLJcNzzT
         go14UDKfR8QDBcr4UVY3GjJvZnord1+bKfx59TrJMF9spHfjtTEOvZnaOSi8xydFdgec
         BjN+/Q7uSxlEirjRGsqOxbSkyxBBt2fZvqdDBkf8IvdWDwDpwaMln+nW/Xx4ARHbdJg5
         jeJ/TCgcxqeg1v9NcswM/lBOHEjmTw4BkLSjxG4x4GgdLeNTZyPigpFiNDRvMsTYeHep
         uOnw==
X-Gm-Message-State: AOAM530GCgGE7dI+CeBLWF4uEX+cGXPKdNDR/p/E39SPzJFYu/7G30Fn
        H0lnG86xTJWVfhBGCtsrzwSbUg==
X-Google-Smtp-Source: ABdhPJwADAsqoQhJjqYOqyXMgxuA5fhLeFm5MSaw/twe212+yNaFvolz9pLcFe5Jz0L5EvQGmPTEkg==
X-Received: by 2002:a05:6808:2:: with SMTP id u2mr7238927oic.173.1594221527159;
        Wed, 08 Jul 2020 08:18:47 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id r22sm24675ooq.37.2020.07.08.08.18.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 08:18:46 -0700 (PDT)
Subject: Re: [PATCH 4.4 00/19] 4.4.230-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, skhan@linuxfoundation.org
References: <20200707145747.493710555@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <e643820b-24e4-6888-7be4-26aab756cf17@linuxfoundation.org>
Date:   Wed, 8 Jul 2020 09:18:45 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200707145747.493710555@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/7/20 9:10 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.230 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Jul 2020 14:57:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.230-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah

