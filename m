Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36FF24D0743
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 20:08:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244763AbiCGTJN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 14:09:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243291AbiCGTJI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 14:09:08 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CB32140B5;
        Mon,  7 Mar 2022 11:08:13 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id a5so3467828pfv.2;
        Mon, 07 Mar 2022 11:08:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kFb39DhtzBOEiTvJ8DRyfwtFmt6tOtRlA7N4icLPqaI=;
        b=hX2QscGRvKMWIhowa/vFQTKrx/SaxFAKVzwejydcyNkETF0oZLYQC88IMbJ6E4ylaa
         vlp9tIM8tM/t56r0qNJmVuXWj53iT72O9kpTXBd37rYBy042dyyg3UMrblpVXDSYjRtL
         80rPSmnVcvmSjv9YXnJID2hkqocYuL2BUqSivfyCZNk5F6n1s8bEGq77vdT8UEcouZd+
         wl97RkygwJHtPClz512QoJweJeMP/2x//YIH7Rrb4OUdZg9AgX9MiW6g84P5hM/CJEBJ
         cgiooaJ4qNVl+c/BaJ0hjGuWB1lDnXckLIjN3cORv5WtiiwaU5KKkXqmRvX55Bc2HPOv
         n6UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kFb39DhtzBOEiTvJ8DRyfwtFmt6tOtRlA7N4icLPqaI=;
        b=pc96oVQ8MmFW+XWb/LFTLBvixr0CesxhDRwJJndgqHSz1b2AG3auo0xrAC9yVa1Gkg
         4Xs7L9H4CXtsS+ww5Txv4gA3weqc8NpCoOYj3uhGtAzzCYNGNVaPlNS/jSkAkn5tgKGC
         ABzu6daJBdH7aLYh23WwmqNO/T57nAWffKWy0EKRgKknX5wI7+LldxtoLO+yBRXXRUFx
         LzwDOBWhCjPAB4UWIfVdLIqGniV7dSGgtO5wuXtKC09hz0LKhsbpV/3yMPw+FsoDpQSD
         buAoJx6BiKMsDHpZSMPOFwkb0JlTH7umusvwPBMsiXm5VtCy/FJVInrtX4bjB52b56lX
         Kd4Q==
X-Gm-Message-State: AOAM533giVabIn0yAnFhBBOtVV1Ux59x7+D3OwYWcdeg4lqWzVeMAvF2
        JOI7ESJl1StJJfn99qDNKNc=
X-Google-Smtp-Source: ABdhPJy+mVIyq8K3UhWcoeRCrz8g7+eGjHf8ASk0owLd233ugDXTclH5Ru5xltfJBLtEoKgT1B+ZBg==
X-Received: by 2002:a05:6a00:2296:b0:4e1:905f:46b6 with SMTP id f22-20020a056a00229600b004e1905f46b6mr14426780pfe.16.1646680092471;
        Mon, 07 Mar 2022 11:08:12 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id p25-20020a637419000000b0037fa57520adsm8557270pgc.27.2022.03.07.11.08.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Mar 2022 11:08:11 -0800 (PST)
Subject: Re: [PATCH 5.10 000/105] 5.10.104-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220307091644.179885033@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <44b79e93-b26d-9a89-1e4f-70228895fed8@gmail.com>
Date:   Mon, 7 Mar 2022 11:08:09 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220307091644.179885033@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/7/22 1:18 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.104 release.
> There are 105 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Mar 2022 09:16:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.104-rc1.gz
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
