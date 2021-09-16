Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63EAA40ED72
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 00:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241110AbhIPWlL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 18:41:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240632AbhIPWlK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Sep 2021 18:41:10 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB891C061574;
        Thu, 16 Sep 2021 15:39:49 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id r2so7643027pgl.10;
        Thu, 16 Sep 2021 15:39:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hcvMGmaViKexoBKlNpVXW0vJfHwXPEo8GYbPdbsJdxA=;
        b=eA6qmU2AKCV6RC8AoOcY1lxxyNTsrSRZZ3yolVAwmJweD575A3w16GWmvrmjEsStj3
         7qIsFhEjUzs5NWAz5k5E26RgcsOehRIhswIKYO1bFIY1HnUJfVFXPrQWMYSM0mm1hyYK
         YxBd7V8w+kZeRWSggqd3iK7sqIfxKqQ9ATTYCJittt2e4dP5cm5QA4s1VpVNwYOiB39F
         Z3RvZS1C06paF9WyGdfVR+kRyVo7PSriksRyrL6IA7VRF6KvU5ol3uI0bdqW25scBGbd
         QJHy424Bug2eV31bupWHI225uz+I5HJ59IJR2KQ4BRsjxBbanXtC7202yDaiNPsxfALE
         E3Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hcvMGmaViKexoBKlNpVXW0vJfHwXPEo8GYbPdbsJdxA=;
        b=kt9oUdK0cqhX0qED2c/RyjHN1V1V32FsBWQuYuUoWrd7yjQnuHzNDDmf76MaeFqEy/
         228c1mTUVniHnfKJqeWLLfOgBm9xb9Z0E82HAqoEdYd/RI7AG2u3AY+f4bhJIn4ns01W
         UidnXkfBaAgMlUKsj80f2ipN3US6xHchVOgPAqhHQQiG6sEf+onZI56MHvPbCaJtuke+
         +54vUeZw4x3HLKXmaEaH1tV16GucUlUzYRsji/PmTqebn8yOcxEPjThiRKDOSCT7BwxK
         1NqiasILpzazc+ZAm7Sm5227aNnVF9tMZX6BVM/La5fepYMXTSAJgY0hCeVQ5e2Q6eQy
         Z/pQ==
X-Gm-Message-State: AOAM531R+uFc9CB7CvuW9PKm3t7qMMj68iQTssHlQJJyP14TcghSGWkg
        ldyalBBCYlmZFA+Qa/7nHRG4JBB/taY=
X-Google-Smtp-Source: ABdhPJxFfbV3Iw1fCzzHQpuRp9HRkJfYrX+F2+JgkX9rivQIq9qXVhka1VyabHCzFKbYGjsAmuPIZQ==
X-Received: by 2002:a63:da18:: with SMTP id c24mr7013495pgh.226.1631831988700;
        Thu, 16 Sep 2021 15:39:48 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 22sm4216541pgn.88.2021.09.16.15.39.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Sep 2021 15:39:48 -0700 (PDT)
Subject: Re: [PATCH 5.13 000/380] 5.13.19-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210916155803.966362085@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <d96c87a7-ef07-0461-ec2e-e4b79c87115c@gmail.com>
Date:   Thu, 16 Sep 2021 15:39:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/16/21 8:55 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.19 release.
> There are 380 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Sep 2021 15:57:06 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.19-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com
-- 
Florian
