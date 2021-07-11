Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6A43C3FA8
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 00:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbhGKWby (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 18:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbhGKWbx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 18:31:53 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BA79C0613DD;
        Sun, 11 Jul 2021 15:29:06 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id n10so944352plk.1;
        Sun, 11 Jul 2021 15:29:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ns02cmkmVIYQ5wbcmNgNQuVbou4Z986ogp+yKH0hor4=;
        b=iJlrqhUEIvQRmqR+fNg1eITRwoyLnzHX7yFQOvIJB6reWbwkEIuqI4ZM71UIPw+3M7
         /QBzzB4n1oYcqXRipI1sV43eyVRvKXMg+ihGfp6gKhyso89sheXd/tlENwGcehM3KfoZ
         3wzHgxMgD61SFJpUKzyEllmmRRmUcpYiB7CDhzxlc58az+i7ZLUUR2Atps7QOB0sCKRR
         ysucNIWPYLSxiW+bWH0nY2uABIGUJ+6TfuoIRJM4oHgzSkdZoAv/6fl1BPGuDbwN9GBa
         Jr2W4GWCDP0WrwAvPDMISco520LkRgLayUWYOZ9vK18RAD582BfgsDUJl0KU7zPJaPZv
         BJqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ns02cmkmVIYQ5wbcmNgNQuVbou4Z986ogp+yKH0hor4=;
        b=OWxavaLo8lqT/9XUaIJ0xw0ft230RyMjIH3oZWGRC9KLqZ7bPG2ddtOoIvx6t0L79u
         VrTwpdkghq8K/82Vx6pVFEdZ2xedru3Tc+5aUhS4vYL+upmOtlOd/23lYKRCxHGfTZpI
         l7BrOYRnWIDgu5rizxOzPxi6WdXRE7k/WpTnpKf42PbXIK5mRPiDdY2hff3QNIxrGRuP
         Wc/bc+rYsZk70RfO5lddgHVaDPMeUZ3rjrRRyTEtIAkllOfrfbSHyIm+zDiO+/li01o5
         jO2XX1LCTdRVUVa7eHfj2ILqMBbf3VXo9cs51+XnVZGkMRwlxNF/h7+wqWgVxZrWQq2j
         48WA==
X-Gm-Message-State: AOAM5310CH05Fj8Oy1yIsTR/yxTGuqIX6SIpahWjwt0MjfztSx/8L0Ja
        uM2zjKAZJrp4vW53zULVj2fWyE1ZGqqyGg==
X-Google-Smtp-Source: ABdhPJwJzDowqPOM9e2+NQEE8BBaJfR4japCjLF0oRpU+sjU5JYMHTNjbyHsy1kXT1g9ahlSBsnvTw==
X-Received: by 2002:a17:90a:65c8:: with SMTP id i8mr11121560pjs.207.1626042545564;
        Sun, 11 Jul 2021 15:29:05 -0700 (PDT)
Received: from [10.230.31.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u125sm13768377pfu.95.2021.07.11.15.29.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Jul 2021 15:29:05 -0700 (PDT)
Subject: Re: [PATCH 5.12 00/11] 5.12.16-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210709131549.679160341@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <8d3355c0-e6c9-38de-55e2-f553b9eeea9a@gmail.com>
Date:   Sun, 11 Jul 2021 15:28:56 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210709131549.679160341@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 7/9/2021 6:21 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.16 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 11 Jul 2021 13:14:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.16-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
