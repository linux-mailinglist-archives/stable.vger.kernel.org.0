Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C60E24C8D2
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 01:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbgHTX4L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 19:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726664AbgHTX4I (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 19:56:08 -0400
Received: from mail-oo1-xc42.google.com (mail-oo1-xc42.google.com [IPv6:2607:f8b0:4864:20::c42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBB95C061349
        for <stable@vger.kernel.org>; Thu, 20 Aug 2020 16:50:13 -0700 (PDT)
Received: by mail-oo1-xc42.google.com with SMTP id u28so817181ooe.12
        for <stable@vger.kernel.org>; Thu, 20 Aug 2020 16:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yOUlFnTL+XyX6xjHFLowjyeqpIKSlnIJUWb6WpqEMQM=;
        b=YGJwshJsH1wNFoOWIvfJIQp5Cf1LT/9VcJA/XPy4DFr4x22/NkrMoaLTzY6cAivNtg
         Lh9nBCOI/Vbu6gnz1rGhh+NjftRRUQqh/SsyS/iWDn4bu3Ne2mhjdWvFJV6orzaMv0PI
         zl9R11C2LQe7cusYbPVmckA5TjliVE8QTY5aA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yOUlFnTL+XyX6xjHFLowjyeqpIKSlnIJUWb6WpqEMQM=;
        b=bm2dM6IY+3U4+sljkTgy0sxckyJKKRdVHUx2a03HmJ+raMdu9VhyHGwgeqC+dgjvGn
         nbsqjoTszIQRsLkbW9cZsVkL6kJduMRRteekvGwAg27nA6PsPAZwluEopnZYQDboE3+T
         dZhDsapwWDbgMp34i/1T5sPLVcB0ZaM40BSIUAd3EMgGZmnW11OCCcih4AMzTemvscnd
         mFx1m8aBLGryIS5I6/lrQfDo1u6G/j1IkTT45d0zCTz0wV3otlWsewq25TwxeFhA+K25
         YZlOgSyo9NS4lBZPWZsCDrJWQBuMK6sGfCkf4Iga+fF4/XsaxdTijRmsrCHmaXT1kcVx
         DLPw==
X-Gm-Message-State: AOAM5337eftdxJEb041mE6odjRCR0+3X5vSC+CFzK2pDSHu0OXylkwFh
        Tq4G1Bc8SwHbXkODKwBoJJjYNQ==
X-Google-Smtp-Source: ABdhPJyZG8oH4VKCjS1vegRO13xkgfdCIBly/mLpQtPV8tBdm5byU+kUyvopaaB3/3Zo61WYDw5sEg==
X-Received: by 2002:a4a:a782:: with SMTP id l2mr181821oom.62.1597967413403;
        Thu, 20 Aug 2020 16:50:13 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id h21sm16403oib.51.2020.08.20.16.50.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Aug 2020 16:50:12 -0700 (PDT)
Subject: Re: [PATCH 4.14 000/226] 4.14.194-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20200820135009.684062405@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <8de043e7-7b7a-c041-0dd5-f0384fd32713@linuxfoundation.org>
Date:   Thu, 20 Aug 2020 17:50:12 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200820135009.684062405@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/20/20 7:51 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.194 release.
> There are 226 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 Aug 2020 13:49:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.194-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
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

