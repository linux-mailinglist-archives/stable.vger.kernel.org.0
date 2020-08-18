Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7ED32490FB
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 00:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbgHRWgT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 18:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726600AbgHRWgR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Aug 2020 18:36:17 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFA99C061389
        for <stable@vger.kernel.org>; Tue, 18 Aug 2020 15:36:16 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id e11so17573981otk.4
        for <stable@vger.kernel.org>; Tue, 18 Aug 2020 15:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BGwu3Ds0lw1nWujgjMlTgJ2swL0a/mGPBlrtoFhYI7A=;
        b=K1q6wCriz1mvkgWRy3bIzsmUPGlnOhmtun/yZdnwkRGIkfEF6TEAtZlu9WzD/wjk/T
         PsxARtcw5m+ub2tmEIf7AMcGIXANDXVD/TG54HlaGs1+EgwGYZkEiv6Nux7m9WKb4Ba7
         4BjcxeOognk+Q9mdSZm+882cXOYtGhxx+OQzk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BGwu3Ds0lw1nWujgjMlTgJ2swL0a/mGPBlrtoFhYI7A=;
        b=b8Fuiuq2IfcUePZ+Y6VkOuHOBA7kDSVA82okHnseHKM3Tw1aXp/OwQSx5jJziINxOr
         h2Fd5ArRMnMMwSCMi8t+6YhzYfUevnqSyymJSK8QkO3rwj6UyUo1BaRdwzbYqfawviID
         D+YAQ49NrRgVeVmebgnj40KjpEnEX18uULRp+6RNh38R19P9ruQG+bLxwC+ajB4A6mIn
         NEiJxt9WITJf/qj2FB1xi5PF4J9X+EUbuZpVY2ycvzXxm1QVYaVuNiHWn0+e1jqMGi6Q
         9OuO3iWrCPRErVfV0boawHP7Jw7SF6itIj7F58QmKtL2kAFx6XUxTDpKAJwgkWUkqTdH
         si0w==
X-Gm-Message-State: AOAM533n1n8JfLI9Cl5y+EAbNqdrMzrBbDbnf1CXMvBEqHo1aWBzQoTP
        q+2S7oV9G05K6+yoV83N0Wk1aQ==
X-Google-Smtp-Source: ABdhPJw2iZqlHJiP8nQv+clZaUptBeUGbLFXBjCxkIDvpJyhd/VyMmWUSQlhCqF+cbiBKcEEBFTRuA==
X-Received: by 2002:a9d:6e18:: with SMTP id e24mr15840134otr.132.1597790176318;
        Tue, 18 Aug 2020 15:36:16 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id o24sm4297429oov.8.2020.08.18.15.36.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Aug 2020 15:36:15 -0700 (PDT)
Subject: Re: [PATCH 5.7 000/393] 5.7.16-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, skhan@linuxfoundation.org
References: <20200817143819.579311991@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <65aa9e77-5bd3-d8e1-36b4-2d1c306767a1@linuxfoundation.org>
Date:   Tue, 18 Aug 2020 16:36:14 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/17/20 9:10 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.7.16 release.
> There are 393 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 Aug 2020 14:36:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.16-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.7.y
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


