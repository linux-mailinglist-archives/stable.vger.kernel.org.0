Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D188321DEE
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 18:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbhBVRS3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 12:18:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbhBVRS2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Feb 2021 12:18:28 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F824C061574;
        Mon, 22 Feb 2021 09:17:48 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id z6so7015195pfq.0;
        Mon, 22 Feb 2021 09:17:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=o7+96u6JAmle076F1DGWsKxvnfYFr7bF+Ts6A0Lm154=;
        b=Ufu4zhDT4BfJbHj+WFme/6bri0L2Sf8MBH8YEmfwuvDXWQPeWzk3q5IAlVTH/GaKPD
         KSU6OZD4iAn84vUygukaf+oEBLm/XKM/E6rPPhz1zCrsgoay2239wAyLrpbo9JD9sgXW
         D1NWM4l+Z4hjYwD3q51F/kMVunSiSUo9QpxilvlkIdRe3bq8X94dWbbfRHMLINIxRxir
         Ea2kt5ZfkTyIhdU6H8t8WAN/lv5oXCSsvcse2gPyq2Avul5IRCqXlONDGFr+/u55+YGw
         0a7FGeg2ou82L4KsLiQ63708eiZ5BDm5O13M2lQNWeURxr7Oy8RHFGecHRcEnWMFxFQH
         eLlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=o7+96u6JAmle076F1DGWsKxvnfYFr7bF+Ts6A0Lm154=;
        b=AbbzUfj232zQ9LFM69n7KGlkZmIyz6PRy5roz/duEUmxOHdyhcfbNRY3KTmwrdcC+7
         jfqURJQQYFloAIlygNGvBnkKfUK3hgAg3yL9yXSURHjICx0bmBU5KwzAdOZNYqhEkPRl
         OClo6hlTAlYcfHAtLq4YN7Ht0mFjipbUHT4A4Srrg9JzEh4NAsNihWOb1OWwFgjBaid3
         cPJnl16AClLR1PljO2hOhAT6pfwagElmdzvcocxNnXN6YmhcEB/uTEOzvnYbwgRBpl7D
         FsoG/6/BNkK4vD6GuWY6nEDKrFQi+TPIx+oxWCPr4Q1iEQZw4zmSj9bm5Eoarf2uk6ve
         UIkA==
X-Gm-Message-State: AOAM532EcZH5Ew5nXhmzSFkpnI2++Ln6eVfTiyrlD02yHikmX107WUJD
        GnkJhkAyg7ook22z52yAGXmeLRc2MK4=
X-Google-Smtp-Source: ABdhPJyZNsGy1O2WkdpTjqjCZCnPk/UErIhCPtsTKOxUgdcJDiQ2I+gxcVTBl286jvj/k0RoJpQORQ==
X-Received: by 2002:a05:6a00:884:b029:1b4:440f:bce7 with SMTP id q4-20020a056a000884b02901b4440fbce7mr23452204pfj.20.1614014267522;
        Mon, 22 Feb 2021 09:17:47 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s62sm11919237pfb.148.2021.02.22.09.17.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Feb 2021 09:17:47 -0800 (PST)
Subject: Re: [PATCH 5.10 00/29] 5.10.18-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210222121019.444399883@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <4a0fc47a-1ecb-211a-3785-a1f5166c1837@gmail.com>
Date:   Mon, 22 Feb 2021 09:17:44 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210222121019.444399883@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2/22/2021 4:12 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.18 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Feb 2021 12:07:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.18-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.

On ARCH_BRCMSTB using 32-bit ARM and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>

Thanks!
-- 
Florian
