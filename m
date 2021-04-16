Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 815343616E2
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 02:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237016AbhDPAqR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 20:46:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234971AbhDPAqQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 20:46:16 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 071DFC061574;
        Thu, 15 Apr 2021 17:45:53 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id d10so18072653pgf.12;
        Thu, 15 Apr 2021 17:45:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dmjEQ+PcDryFW3YWt0Nhzw/ZkwBEiKeND45E4thTri8=;
        b=W+Aan76L1WsDfJ/uIE17T94rf7YSuy2Ed5TaXBfsKbDp2/XQjqvmS+hKNbQF/dYjkm
         PXtL2NN0gcEeGJEWnJtsQEwOT6HxnCwFw9rEdYgMS0yb7e394WBlhYL8yJjkTQ4lmy86
         IpwenrqTvKYng0IgmusLN/j9JgFHqBMuPEB5uyfOWkQNbkKKu11NrtU6Ylkdv6cU8owK
         5WrcDtTuHBKRlohy+yV8YQ28tgnYdx0sDa2DQu+LVM01n1kcdDP114IU3mKoN749xZNG
         l6DzWe92sqSJewnzHs4DMXAZBTsl9YF0fI8Ch7LaOfwcS+lCDgTTNCiuiLMLIS1rtErt
         AQbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dmjEQ+PcDryFW3YWt0Nhzw/ZkwBEiKeND45E4thTri8=;
        b=IF7zPdkl6ZV52VRZ6rZ80+njJz5XtB7trHXygrGs/SvsqMcRHR19EDXtMcM8fpJxcp
         0k6hw0Ftr8uprGpvRSOqR+ZwFA52cPw6oJsxMzC9RkASlaqY+C6RrOmGdJP9TXBjv3d4
         72DhdOdux8vOizctIyHAHDMndw/IfzLXPfX6PdtbqBhDZj8tATw12TYGemR9o2FTQH1j
         xUo8inGZZWG4luvixLGGvCHpzuKVeqL6H80QQu43tTBY8onPa+6rVyLDPzA36yJw/Xzs
         8/jL2nbXOrl6U2fn8gmGmlgbGSnP2jtqJbEGQ+8jf1aZYvzThh+r+vFCnlj7QhhIIev5
         7cig==
X-Gm-Message-State: AOAM532RXF70o5WelsFNiPeiB63rf1naFzLfcfDiYWI+jzipA5bfLU2G
        eJ9zLztFz9DiQ8RaWO5gXzxKCg6c5V8=
X-Google-Smtp-Source: ABdhPJxuF8dOrIh8sHvI9reuorYiCIa02BDGIgbniCCO9RshC7YM9uG4HIUozoJkLqnq+4ZjNCJ6yQ==
X-Received: by 2002:a05:6a00:2ce:b029:246:f904:a94 with SMTP id b14-20020a056a0002ceb0290246f9040a94mr5482236pft.56.1618533952065;
        Thu, 15 Apr 2021 17:45:52 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a9sm3048521pfo.186.2021.04.15.17.45.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Apr 2021 17:45:51 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/18] 5.4.113-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210415144413.055232956@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <4a6c389e-7780-2710-15cf-a037d2b4d48c@gmail.com>
Date:   Thu, 15 Apr 2021 17:45:43 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210415144413.055232956@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/15/2021 7:47 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.113 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Apr 2021 14:44:01 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.113-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
