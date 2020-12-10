Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4762D69B2
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 22:25:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394032AbgLJVYw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 16:24:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394035AbgLJVYj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Dec 2020 16:24:39 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A09FC06179C
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 13:23:59 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id y5so7186714iow.5
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 13:23:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Eh7W541r8QY5zvpqKf9LxNMZH8ioprodhGtACUkSbqc=;
        b=HKj54ty6NU8+Ji8QrdlHe1BB0LTuEA9230eyHGxfHQSXaFaWyOxy0SwHNm8rjlx3f2
         jv3QUBRklJiHsrBAzIoKK3DASE0CMSReJuBf/wOlVPjaKA2abdZx/mFYMjlEDepLC+Tu
         JwCj+C2TDKFZmB9qmRiF5h6etu2nlKVXki1fE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Eh7W541r8QY5zvpqKf9LxNMZH8ioprodhGtACUkSbqc=;
        b=aEZWKThH0599BFk5r7IBKH9I5k0NO8QRxB8IzVCns6gdzkNImpbSmyQjfJuYmz3odx
         +ZcXqTXX2ogCHqguGxVcKONqw/oZmTTCJRh2qXAvjiM0EOcRFIbT0N1gNpcMe6hKRr0o
         4aNw8ThKWTkqqI/+lK8mZOJ7GNn04fUZ+bTOwMT37CTHbr0VBnel3lflfy435fJfWQKn
         dDS3oVGucjHcBO3++iTsMdCCoAJ+8IVu49AA63b6WWsmbdLjTBP5rEy3U6Z8VnDEOPoO
         ZPQiL5nu1zrQZPmzHaFrvzhNXL2FeqQGWh9HtSl7Q1bgWldbBDx8tYzqQ5UUkY5BNxN/
         hxeg==
X-Gm-Message-State: AOAM532nluS0B/4QdGzdt4DPvLEqk2mNXvR8hy4whmlDNC29kRk149om
        oEXLFCqxnz8jTX3sHrnKkEFKhw==
X-Google-Smtp-Source: ABdhPJwUkcYnwoBbAklb0ZDJ3TC3Gx0pk4mnlr0fbSCBi731eT7FPc/r6IGlBUDVkM16CvoiT4UJKg==
X-Received: by 2002:a5e:9706:: with SMTP id w6mr10517966ioj.132.1607635438770;
        Thu, 10 Dec 2020 13:23:58 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id o11sm3084526ioa.37.2020.12.10.13.23.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Dec 2020 13:23:58 -0800 (PST)
Subject: Re: [PATCH 4.9 00/45] 4.9.248-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20201210142602.361598591@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <d70720bd-1e85-e279-af00-a570c78c6507@linuxfoundation.org>
Date:   Thu, 10 Dec 2020 14:23:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201210142602.361598591@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/10/20 7:26 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.248 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 12 Dec 2020 14:25:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.248-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
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

