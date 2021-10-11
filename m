Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF924293DB
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 17:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238798AbhJKP5X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 11:57:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231766AbhJKP5W (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Oct 2021 11:57:22 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 720EAC061570;
        Mon, 11 Oct 2021 08:55:22 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id qe4-20020a17090b4f8400b0019f663cfcd1so15038425pjb.1;
        Mon, 11 Oct 2021 08:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CZJo6g/i9Q2cM0GXok9ma/L/m86106M53JonQvj1M8s=;
        b=bv1qIXtU+08GVBxbzwjh9mjOCANLFJyauSlHxykHNcxxdQ21tmMwgd+WbkgULh69On
         08553BNBFBJ/Fjbs463UAmqLh4OLuxtKUox1ot0891J6xBrRyWk31WayyuUeGzzgJWaD
         oxyjGwsa3PcvInPDnV4ykMQsTDy2Sbc9Ud+LoV4sBeIobJibkspkflCiK8zlzzlYxvQX
         VTNa74GwWVqyv1GUuHHPFpnBnlQIlOnEUI+fcYxvF/cB32HsXELEAfntLwfLTE0fTRHT
         QvP9b6zGYo6hDDqmgVJGIVpiGUZnWomaGqGv39+KTfTwMQhEHkI2udD5bq3MFfkhE7mD
         Mswg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CZJo6g/i9Q2cM0GXok9ma/L/m86106M53JonQvj1M8s=;
        b=ggerSJFhkp9fOH4+H9l+FYglbpw0H+87XwTLi7kuuvs0Z9oEM7m97yQpuxM0pG7TJe
         jNxkwF4q5kPp6Ni4jVaKnNjnFxKk72txwfZ6QLSHGLzatd+WwBWiSvQk4Z1U0er+WVpv
         91A3kaRb9fvGMNpctEoUAg8ZQPAuiE7ljsqr0z1ghWx977qPyU0XTlBzOObHec34Zq5f
         XM+02QQqm5r9+acK8Wqy575POdXnpZda/z4+bLg+f9u7uGatkwRF20C7orkPqXu9SDLZ
         r49a66bvKVnwQi1o4t4pMEIt9BLe+CQKyw+HqVhKM6KGP0eDpQe+OEUfvU+eHAbWAdiZ
         DU4w==
X-Gm-Message-State: AOAM531Pi4sCbmbfBqbKKl4fotoVi1PcRYSN4Ok1bQeLGF8fN7UjJIaC
        DP6akZ8CamrdgWwqComQLamFcIIzrPY=
X-Google-Smtp-Source: ABdhPJxh2JO8BRlJmW1D9BUMPV2qRx1PwqgG29m2PL2uDS7U1c4mQf+wswZhW6Iz2kAayyfG/yvbag==
X-Received: by 2002:a17:902:d2c2:b0:13e:f4d2:ed3f with SMTP id n2-20020a170902d2c200b0013ef4d2ed3fmr24644325plc.87.1633967721342;
        Mon, 11 Oct 2021 08:55:21 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id q21sm8565673pgk.71.2021.10.11.08.55.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Oct 2021 08:55:20 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/52] 5.4.153-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211011134503.715740503@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <95d435dd-fa70-7b6c-c09f-9a9dfed1683d@gmail.com>
Date:   Mon, 11 Oct 2021 08:55:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211011134503.715740503@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/11/21 6:45 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.153 release.
> There are 52 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Oct 2021 13:44:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.153-rc1.gz
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
