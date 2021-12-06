Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F162846A69D
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 21:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349305AbhLFURG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 15:17:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236134AbhLFURG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 15:17:06 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 418D8C061746;
        Mon,  6 Dec 2021 12:13:37 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id m15so11505039pgu.11;
        Mon, 06 Dec 2021 12:13:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Jz2JvRf9I6ml4as+7X9eW0RqKxewFk1AokBgn/81pZ8=;
        b=hRg3F60H01IupVj2WihRG0DJcAvMeLN98TThyo2P3RSaZ7kFFZ+Ydqfb8x47ju21FN
         7cI2CUwZ4boDzAyOvb/9mmOC2SF/XL7PBqvgkrZJy+ny0z6vBgXC1VlgInPdX+SdZYyF
         uaGSJ/FVfzOa9zDLRXHtu7FX/XUI6mXLqNqnydtL+E0m8tvFiWtokQn3x/QQbi6ph7ul
         RNMkfxSfWB9jW0eymppAsoT7Mp25RruHxBhE+OWT7v52G8rYY+is8U/XA7SYnyyd43P0
         O6w+u+PwQ8KV9HenR1DttcmF71RAC72pdXTMwqO/YdQSQw3XyCLcDROBe9eShvCZZJmi
         hq9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Jz2JvRf9I6ml4as+7X9eW0RqKxewFk1AokBgn/81pZ8=;
        b=71DF/4vVWnCWN/ekB7/RVVtWDa4rBydstM0aKvcsddx9pnAWBBTVXzfem+0N+fN2Vo
         04e3WVZGXSXPIMHoCHnvljeFyQHLFpC0Cjrd2AKrT3bTgnffEi0wOjs3s4vcXe1m0BUQ
         mjvrl2TAxK3hgXyIWfldax67Ij+sGkappyMIPsRyXMXDzKF2T1qu0B6dPl970jpZPMQB
         LLq8kiuLcrQXw1kaK8IGaDbKGmxnHBXZPl/jJFFDEu2wWcJklRUyfnqtlhnFfaU67JwN
         QK0wZpPbEqsmR5YMAX17ClvoNd5DUroaJotW7dNGpmy6zVMrbz1m4HHHqqmA+atSUo/P
         iyFA==
X-Gm-Message-State: AOAM530JhjaBFool0w0FV8gkGPO4AQPCxUFfiJkrg7CYNnLuAAuSJqbU
        JSM+GUa2SCickmq27l3uWa87oe1GYDE=
X-Google-Smtp-Source: ABdhPJzIwPbcaBZyKPEA9HUhm6UQg7JtrdJjETdxaIDHPPxzpEgpcDS/yl5o7WJxAs0cI/2IoW569Q==
X-Received: by 2002:a05:6a00:b4c:b0:4a4:ef57:fd72 with SMTP id p12-20020a056a000b4c00b004a4ef57fd72mr7648290pfo.2.1638821616402;
        Mon, 06 Dec 2021 12:13:36 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id k6sm202203pjt.14.2021.12.06.12.13.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Dec 2021 12:13:35 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.15 000/207] 5.15.7-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211206145610.172203682@linuxfoundation.org>
Message-ID: <b6a6b54d-90c1-cee6-cafc-9fa28354916e@gmail.com>
Date:   Mon, 6 Dec 2021 12:13:34 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/6/21 6:54 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.7 release.
> There are 207 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Dec 2021 14:55:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
