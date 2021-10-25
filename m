Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C20C243A615
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 23:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbhJYVqk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 17:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbhJYVqj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Oct 2021 17:46:39 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D492C061745;
        Mon, 25 Oct 2021 14:44:17 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id f8so2044179plo.12;
        Mon, 25 Oct 2021 14:44:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BH7A55640DKrzB5hvumGyqffc9nxKnZV26J7qLVkD3k=;
        b=QXPKzgmjzH4uqeQRuqDvLOjXJqAl1meT6/tPH3y2G1nOtceQqXXusmlnkqZm5tmuv4
         iYYUQXBrDhg+NB8nUlpx4MRk3enm5phRXaF4ApJbCWOEojN4g2WN0JESgJ5gKw2cEKgs
         XI5YNXJoXxc4pAzkd+PMJ0FrpN3Bld0ynT+1dk46h2V1QVARXfehL1Z6ehJk4BgRgyz4
         ivf/5DugYt2GiXUYJ2z1ITmChz8TaSpN3ahsy65viHVzS6RaZX+T+wpyKrPJ0n4RXCtd
         HgxNw0s1YkDyUTkRiXryaB8i1HX4AIHHF8T9RSUZK28Yr0gODWYlAI7UheG1KLYblt3m
         M/Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BH7A55640DKrzB5hvumGyqffc9nxKnZV26J7qLVkD3k=;
        b=CT/G+RBT1QcQeLg3HALrWLWC/ghvLgMFXppwK+/YTw6KP3m6sL5Iw1hENUir1gA3Mt
         1kZDqvuImm3MrEPmI/dK9ptVqdwBIG8G0t1EJouc2gCHcm/CEMMA2vQp7h4Cgz00dc3D
         ZjHdUQpnKYKYr/60HJYkvWM6TenYnx5KnridXsM0lpQx22f8D3ch7AFXx5ZtJZfrevNV
         hegFQWjilUicCdUgyPLx4NLjUN87YD34Tge9/l6enJLntrlWOL8hl7FPcvqubjl/rox7
         LGdcYGBmWlF335QcQ4FI/LZ/L5HOLAlFmOibjxjrfU1cAMCukhU3qFZ0tSHjTN1O8Mle
         vEnw==
X-Gm-Message-State: AOAM530pRHf7wdwiQZQIu1zCYw5ofNU5D2WZuAnI1QH+/vTNqFz0frcW
        Nga8J5jXOtnWjexi3wwqb2eN6PvwD20=
X-Google-Smtp-Source: ABdhPJwJ4Dl2vr3K70GnZxARvUI2/czHgZWu+jTttZ7I73IwDpx9QSxKLMPubsyrwjKvUJQKzaLd1A==
X-Received: by 2002:a17:90b:4d88:: with SMTP id oj8mr35163750pjb.175.1635198256085;
        Mon, 25 Oct 2021 14:44:16 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id bg15sm8088787pjb.15.2021.10.25.14.44.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Oct 2021 14:44:15 -0700 (PDT)
Subject: Re: [PATCH 5.14 000/169] 5.14.15-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211025191017.756020307@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <cf7c766c-047a-ea13-cddc-ec47dc36136c@gmail.com>
Date:   Mon, 25 Oct 2021 14:44:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/25/21 12:13 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.15 release.
> There are 169 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 27 Oct 2021 19:08:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.15-rc1.gz
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
