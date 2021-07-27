Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFEB33D7D18
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 20:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbhG0SIo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 14:08:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbhG0SIn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 14:08:43 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77447C061757;
        Tue, 27 Jul 2021 11:08:42 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id mz5-20020a17090b3785b0290176ecf64922so5499395pjb.3;
        Tue, 27 Jul 2021 11:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8hbMtFweUxVxc+r/mIdp40F7u14TjsmtdgBO9LYV8/I=;
        b=s/MMZZOjwMHmYKZKO5zujliHjzCiH2HYmaBfHrUgAq6TB5lVdvFrg9ZeI3Lum236I5
         UU1t4l8trprAiijYjv9CgK3HlvOgAkiO++6ZJA5vg7rep/vQJ5Brf6daOZEJHIjCs00J
         /ukCjDgStxzQR6W21ZgU3oiVjoRTZJzOjZLMtiso6aekfO5w7Bkr26kabmNsVwTCBfOE
         pde4x6OnTCs0zfSyeiXToQ8/QtdUZm9HOrUVsMclxChNZx94FI2XB/uWqqGgq0J/mPpg
         bYF22wMijzq3/7RcvF2c5sJs2hjkJthCbcFNym7/p0Yy4k+Vbtag/FKh0UML8JMoFhHg
         /Z/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8hbMtFweUxVxc+r/mIdp40F7u14TjsmtdgBO9LYV8/I=;
        b=sb8jvqCevHF2snkE5hz1RYgjlIBj2T5EEs8cwUXPec+I8D3UbaxiTyuTJZaUKCpMbw
         VqunnbeLn2OOaouwztBcbti2rVLW8uR2H0PKE1Lcnrmq8sYvn6RvL/ZvgULgpCJB8Qrb
         KSjEeECv5tNXibnSiG/CfKjyh1NnByzdjTzzg27cp9g6HmFe5JUW6czel61DiIsG81Pu
         tAMh4T9dpxdwQ40cwUt4y2lohJUw5nveJfL6lQ3tSfm6+kPZpGTnOb8sCuSmowwfVHpc
         QXulPrMhm+XYl4hNDUXB8hxfMwm+tZeP/zx9dQpMgfiuU1UdrlZ725a+pu8+xDcVPJuS
         fVdw==
X-Gm-Message-State: AOAM5319GjR4By/BK1G7MLKbRG7aX+1UrBQuROPzIw+pNKSvhsyMcZcj
        ZsMqB0nI+WvZufDZOWs9zskt1nCtmok=
X-Google-Smtp-Source: ABdhPJx2AdYpEAEBPfjvRpzJsbMXfU+s5Hf1c8fmLgc39Ju/SZopc/vOHx+x04jml5ph55dg6EbiCw==
X-Received: by 2002:a17:90a:bf0a:: with SMTP id c10mr23342223pjs.59.1627409321617;
        Tue, 27 Jul 2021 11:08:41 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id j13sm4178393pjl.1.2021.07.27.11.08.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Jul 2021 11:08:41 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/168] 5.10.54-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210726165240.137482144@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <61951dfa-c241-e846-b56e-0173b2637521@gmail.com>
Date:   Tue, 27 Jul 2021 11:08:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210726165240.137482144@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/26/21 10:06 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.54 release.
> There are 168 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Jul 2021 16:52:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.54-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
