Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7628C3FF82B
	for <lists+stable@lfdr.de>; Fri,  3 Sep 2021 01:58:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234355AbhIBX7q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Sep 2021 19:59:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245324AbhIBX7p (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Sep 2021 19:59:45 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 650ACC061575;
        Thu,  2 Sep 2021 16:58:46 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id q21so2223993plq.3;
        Thu, 02 Sep 2021 16:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=+NU2YOSnshAhAfj7HPnfTJ/ZV8MW6iNFINNL9VzpNvw=;
        b=ddAppI87UDd90sTltAARDY7/zFqCvV7KxrUMjK+5PvVD0CsicD4rBaWCJYvXCblds0
         FnIb0Jes1npCdlKoGPQU/9A1zKrCV+/ewvTIFQnEnI4jkHDCstyjjCaJuUS21ANP0Jix
         w9bmZyMVQboaSwExgwFrg3+wxAivZ9Lqqw1hlHlEtcUNKBbm0rhYiTGU5kuhngQwZSw9
         RefNEFfloA+tq2BUt/0/dgCY04jv0hBJeQ//MIOIhFI7X+e/pAgwurjHIqYEys8igHEA
         iFLZgHcGTdK37knLuU8WMGWvfMrk86e+yjTpRLIsQJ4BFz4fgkanhPrKMnNRh0oAmL9y
         RdHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+NU2YOSnshAhAfj7HPnfTJ/ZV8MW6iNFINNL9VzpNvw=;
        b=WMMwXrmoBwXJdkeA8AS6SjU+EqT7G0oSDZWAkn0xNcevhDQ3H0jCVneNh3PrVWkUAo
         DAH1zfDQNikHg1hoiz4oUZRkfkQFAYKFWABVwptpxlTUkVuxfTWB28Y3tvgyJ5VRclKH
         3DWlpK0yHmUYXKNoLWpfZeI1wMKyT0L68l+aUsGR1GmS5s+egNHnUy7WBA6HIW0TUDuC
         eCSUSNfvvNgHK2ld1bMr8U6gy/A1s5KWUL1nD26ozwZCo/6p4/RVvQ/etIm2+ClCQm/4
         Pqd6qLfdmfhUNiT+dmVh7tCs1h2LUkInIcqSCiGHRjUkHkcMW63TD5rkrV1a1W278Ll3
         p0HQ==
X-Gm-Message-State: AOAM5332PMNORiutuelzJPk817qUhJn7V9hynLm+CFVeNmVfyjsBGoYh
        2jiQ42a1OVGg6w7zFQ4zWzo=
X-Google-Smtp-Source: ABdhPJycx1NhZBmEWP2ncvB8Z2dVY7TGuZkISarQF2DjsHtN6dN+G9N+reJ0Hc6joA0bBOqmhFGJmA==
X-Received: by 2002:a17:90a:d304:: with SMTP id p4mr765313pju.176.1630627125645;
        Thu, 02 Sep 2021 16:58:45 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id a194sm3365962pfa.119.2021.09.02.16.58.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Sep 2021 16:58:45 -0700 (PDT)
Message-ID: <e5dd61f7-899b-29e6-7b36-7ee9c24895ae@gmail.com>
Date:   Thu, 2 Sep 2021 16:58:43 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: Re: [PATCH 5.14 00/11] 5.14.1-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210901122249.520249736@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20210901122249.520249736@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 9/1/2021 5:29 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.1 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Sep 2021 12:22:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.1-rc1.gz
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
