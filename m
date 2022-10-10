Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1D0F5FA358
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 20:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbiJJS0i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 14:26:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiJJS0i (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 14:26:38 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0816E13CDF;
        Mon, 10 Oct 2022 11:26:37 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id d13so832746qko.5;
        Mon, 10 Oct 2022 11:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AKoZhuu3E5SAsgI7oUky3IaJgpIEJ40e2SZVdy8gII0=;
        b=h5Pm9+hx3SH8L5RFEw+71QgQL6FYHhbZpklTFH/a9E1Qyspls9FfvNCFwPMXaaaJI6
         gRCpSNzjtO/Vndzhyjsn1vODuTcZAnpBLfGMej9RpZ5bK/wiiBH3oz6/nNLfDw4oAUNc
         +WQr2souXiBEDdzCxSNISgl/pI1Lz8AvFD/DZfl9/9bno1L4FBpKDVP3x5TdgOcicneB
         iGL2Ww03SUf/AGdsu6eBktQm1jD0t0YlWVdx6zEL5BQ1Y0GmwetDk/N7dsI8rdcKeixf
         AT3fvTyAoA8zpo7UXsde6wVnFPAPfLIA/3GQDY7glJixmzpwkONsFVWxAkGR5l9XPsjx
         cl2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AKoZhuu3E5SAsgI7oUky3IaJgpIEJ40e2SZVdy8gII0=;
        b=4xSzSS4do7Vuuz3cXI4GKe7L7hdnxbxX6BWq4uTo6/bQX468KSJjeD8Xig/t0fUd7E
         U6uALjmIeKB+0eEpxZsRWIGJN1pBWVpQBSS5TvjvmtC5ei446A2EIU4mam+qGsQtgZEk
         MNyyT0l7E8vQkfoNe2/FEXg6CA6InJfaCuMrQ8B8d6toieAkUPdiEB6OGejZf2Z8tR3g
         OTsIeKWJfChUD7jy4ONMsOWUTA4JTUmPIfmElEs462quQCehutaxE1VtuDw7v6aRAIiV
         b4J0VABzQIvq1Muevc4FqvLranCuyEuzmSnVdbIe5qjYbGDqlofS05v/+u8p2hwO9EDZ
         ocXA==
X-Gm-Message-State: ACrzQf0tQOHu0CRQsKCmBMtGeVXr9eE0qIZSJiLnYOVTJB4BLssz4AKp
        Sg2la3dV0b0rDPBbWFT6FoR6cL3Mrqg=
X-Google-Smtp-Source: AMsMyM6IKacdxq/07ukv50SSLOjif5AjMKhjrahT90N2D90Oab/hMH0qh5kFquaXMwPPnwTJ8jcT3w==
X-Received: by 2002:a37:6942:0:b0:6cf:22d6:a887 with SMTP id e63-20020a376942000000b006cf22d6a887mr13842815qkc.0.1665426396092;
        Mon, 10 Oct 2022 11:26:36 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id i19-20020a05620a249300b006cf3592cc20sm11367416qkn.55.2022.10.10.11.26.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Oct 2022 11:26:35 -0700 (PDT)
Message-ID: <bea13f81-7033-e242-1de0-6b7b4a9b98c7@gmail.com>
Date:   Mon, 10 Oct 2022 11:26:33 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.15 00/37] 5.15.73-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
References: <20221010070331.211113813@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221010070331.211113813@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/10/22 00:05, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.73 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Oct 2022 07:03:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.73-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
