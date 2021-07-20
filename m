Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C47E93D01F2
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 20:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234001AbhGTSJx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 14:09:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233862AbhGTSJS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Jul 2021 14:09:18 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A0D9C061574;
        Tue, 20 Jul 2021 11:49:55 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id h24-20020a9d64180000b029036edcf8f9a6so22487863otl.3;
        Tue, 20 Jul 2021 11:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=38ysDMlFx7OfVJ/aFP43WJt09nhQQM4u+Uto2k8gEks=;
        b=FLNrJsaz5fXf7Xo66v38BaGPP1ocQoM/xxm8KEnVn5pgaEPyOFZHQMrx+kgbvPHzAl
         tejfoRHgLwZRoJyYIdw8+RGr392WD99PGlFeZ3jJQSE9Y5mYXZY4D350hqmG91XFma0w
         uDGbt/Giq6OF/2tKcQJkb6jYqK+6TCiZFOMLEi8L8DgYloMgxAFAdBjTu1odAIeu/Q0T
         ja4m2nLrxZDvr6/f3YtoyveOowNY7etzfj5gJOLQrOyrXj/mNHWtWJ8LQYf+1CvzqULk
         0nPeiNVmfpU/biN5Z3IHjPeE8GEoZwqIlsArql4rjJq6+kZeAYSkWVTZyfrTCSmulS3z
         3sOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=38ysDMlFx7OfVJ/aFP43WJt09nhQQM4u+Uto2k8gEks=;
        b=IxK5gtleYOpPq2Ud4sSq+DN9UHQau6iKsyRC6fhG6pZsw59VVZ5RNvmJLcU/oUtrte
         utP2RNLFQGas053IxBrBJJ/amuS39JE0EnAdpjpMoqoGwv0zCvyRV+lwQu72twq7yne6
         VoPJk3c1xzzTUskkfheKLLBRf3KXLs7Rk7XHXekhkygNt1KMkx26FhThbCm8c8FrjvBd
         US9AL9P/9emyBL+HMYNOu82fsbVeM3LxQEJMKP1S8oaVt8CgFnxMzrXQ3Ejd0uR7aR9D
         lEo9SNbvSWsHstK0RZ78eEXOLaFrfBEZCjoQL9vLAnlhL48UOkigM0ASlrY+dr3k/hsY
         n7tA==
X-Gm-Message-State: AOAM533xgRXjI3dVsD51wdjRcAdOZ/SNdLTsbUvFWF160lrqjmzWdA/D
        icKajAjh1fX31elfT6bvCwFqgvJ4GSY=
X-Google-Smtp-Source: ABdhPJyIrylkNRTWZUgUj5WIphNsXDuVP2tkhBXnf7xf4omEmU7VbmuAEf/BoKzz6q/xBg1DhHejCw==
X-Received: by 2002:a9d:171c:: with SMTP id i28mr23086764ota.171.1626806994253;
        Tue, 20 Jul 2021 11:49:54 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x30sm4414985ote.44.2021.07.20.11.49.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jul 2021 11:49:53 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH 4.4 000/188] 4.4.276-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
References: <20210719144913.076563739@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <a73a5e47-26f8-b0d6-c76a-c861ecd41c33@roeck-us.net>
Date:   Tue, 20 Jul 2021 11:49:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210719144913.076563739@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/19/21 7:49 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.276 release.
> There are 188 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Jul 2021 14:47:42 +0000.
> Anything received after that time might be too late.
> 

Building ppc:mpc8544ds:mpc85xx_defconfig:net,e1000:initrd ... failed
------------
Error log:
drivers/memory/fsl_ifc.c: In function 'fsl_ifc_ctrl_probe':
drivers/memory/fsl_ifc.c:308:28: error: 'struct fsl_ifc_ctrl' has no member named 'gregs'; did you mean 'regs'?

Looks like 'regs' was at some point renamed to 'gregs'.

Guenter
