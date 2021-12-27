Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80FB8480324
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 19:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbhL0SCe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 13:02:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbhL0SCe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 13:02:34 -0500
Received: from mail-vk1-xa2e.google.com (mail-vk1-xa2e.google.com [IPv6:2607:f8b0:4864:20::a2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09AC3C06173E;
        Mon, 27 Dec 2021 10:02:34 -0800 (PST)
Received: by mail-vk1-xa2e.google.com with SMTP id s1so9009516vks.9;
        Mon, 27 Dec 2021 10:02:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=Y2C/xe3k3sk7ZQaWg63VZ7wIrzoxBxKM7tnsM261u4Q=;
        b=Q9v6trgPuZwjd4z3p61NONzxFWLbYZzxXU+VxnCKbDAFMzrBffT/37G+uAcJtOEDYn
         fsVty1RY0TfESHULgD19Ps+wneiDa0utHNOrYijZYGTrQgdxqpFP75n5EfkK7XwjAc9l
         iCJxd6FeBmFyYZJoZXXNPgc4WkpwXV1ughISWCE/AZhN3AfCc+krSX4hiRNmw1NfgYBV
         ZT11mhE+dacKz5javEJPczfiocoaAQXwT/1DUTl+7D9AYq3H2fND+2s7euyZINOoCAcT
         DJh9FFm/hlzTYj5w0SiKG9czGv9szVrxRt4VSinq0HS2W7341Qg4Ut/ZwoshcAC5UIFg
         tqew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=Y2C/xe3k3sk7ZQaWg63VZ7wIrzoxBxKM7tnsM261u4Q=;
        b=BiJdW+z/Aig94WC3RUum+tYBkV9W9Tmfzw3GEbTBZCLiqHPAckosAcudFYrwoE3IQN
         rkbXkdAV6ICVYlqT0BoZZWFibwHP2LTjL8Ms8EmIDjKenht0AuiloxJCr5IYYaCpacCf
         VApDlJjKjKd455TcLNzcrAsNkj092c77AShdwQX8aVqdmG4gsQ8KJ2Si4hrFI4R0V5YB
         GYUh+Fh+EXawlXfCTo2r0zT93sc8RAQ7KFcCFM/oyKyfd+TwLJYXfNl60d91IA8jcM/D
         uAXqGzOtEKSp93uiw00wIpPLiC4hMLROOU7jZC5FYJYYFujJbei5DG+5ZrElQJDLIzk5
         p06Q==
X-Gm-Message-State: AOAM5300JoEsPzpoPtLHyySP5VlzDvwok5WGlDln1K/LBeB4QozokuZQ
        MN7IG8+LdWMdhxkXV/hy+B4=
X-Google-Smtp-Source: ABdhPJzSqm6nnVOXDxooqQkMk2unVs6RmGdm4zu4XAutaafW0kBYlfvpenQvm+DC7cTbfPmWDGjy9g==
X-Received: by 2002:a05:6122:513:: with SMTP id x19mr181296vko.40.1640628153124;
        Mon, 27 Dec 2021 10:02:33 -0800 (PST)
Received: from [10.230.29.137] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s17sm3140149vke.7.2021.12.27.10.02.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Dec 2021 10:02:32 -0800 (PST)
Message-ID: <f6b17214-f8b5-ad87-c36e-2e3f374b7fbb@gmail.com>
Date:   Mon, 27 Dec 2021 10:02:29 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.10 00/76] 5.10.89-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211227151324.694661623@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20211227151324.694661623@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12/27/2021 7:30 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.89 release.
> There are 76 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Dec 2021 15:13:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.89-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

