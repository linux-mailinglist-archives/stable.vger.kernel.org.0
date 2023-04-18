Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF7046E69AF
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 18:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232553AbjDRQhO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 12:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232558AbjDRQhI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 12:37:08 -0400
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87EC913F8A;
        Tue, 18 Apr 2023 09:36:58 -0700 (PDT)
Received: by mail-qv1-xf31.google.com with SMTP id dd8so16879293qvb.13;
        Tue, 18 Apr 2023 09:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681835817; x=1684427817;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=hQMVNzmxnPRhXRrnZUKXabKxB7Nk3knrEnVbtcVAOP8=;
        b=VOrZYJCnwn80hQqcvXOCYGccfqhDTKL0ub4IWpYiXqwJ/RGBJYJUnxv9JgxNCeImOc
         SNwvE09BBjQ2abSV0p/eLWx+xehkNYr8ytDYZlH2QT0+5h2gz7Der05xJgEktoiT7tgD
         Pzdmjpyety12X+iS2OCc9bof/E1OXftfSg2QUbIYS2QI10s70rcjoqBmnOYD6KRHhw9o
         JFmMnFRuzqJ9VQUwig6YgKp6QLb2J9Ly1LYNYDdVCDVKmDwLTIfw9qR0jE66f0OQmReA
         5khvxksPlvw6vng6wKQ038NIrkC8xgnMEqVUud7MYlT3dDpLRE8tee5yjud1SaQcioCq
         ipXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681835817; x=1684427817;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hQMVNzmxnPRhXRrnZUKXabKxB7Nk3knrEnVbtcVAOP8=;
        b=RkZR7Mz55HqkdyrEgbGsCO7HjCS8qDtT0CiXRSP1/mUsonTpqrZFUQTII8ZN+WIB7R
         IlpmbhKvKD6CR/Vjytcms1RPCYKeatBeJhKL0oBPWAvqdNl4zvMK98D2RXHAV+2GLezF
         A69W2CWizE2je+a0a3jn5FZdxXaHu1VxESK9kZAaW3p/HxI58h0xsleVaxvHyV+i/tI5
         1flwbwY+5blGneGR4XUpf2mfClmYr6nro5Dl3bSHnluIMsl1K3mu5GWBWhBiV9dq1lzD
         yHn3nXqkGB428SRyVSn46wNlnH341TeAgD7rUZZ5i66A358T77muMJ73YzInlFA7Vz52
         c39g==
X-Gm-Message-State: AAQBX9dLQTHPbQ5jVjT3Tg74Nief3d2HKLz2adCuTQSG/d5DhK6ve92h
        /jtXxp2eACrJs2U/MpWhLGc=
X-Google-Smtp-Source: AKy350Y/U9ti+MSNkNB4Qy3YiD8IYL4EXmxxipaFWCSPTzlw+kEQDz1DGjxWyzuJQ4gMSHpePurdhQ==
X-Received: by 2002:a05:6214:412:b0:5ef:56e4:f614 with SMTP id z18-20020a056214041200b005ef56e4f614mr26473744qvx.34.1681835817590;
        Tue, 18 Apr 2023 09:36:57 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id ne3-20020a056214424300b005e8f61012e9sm3801692qvb.26.2023.04.18.09.36.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Apr 2023 09:36:56 -0700 (PDT)
Message-ID: <5e902e3b-c0aa-9d6a-0418-2e27f5081190@gmail.com>
Date:   Tue, 18 Apr 2023 09:36:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.4 00/92] 5.4.241-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230418120304.658273364@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20230418120304.658273364@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/18/2023 5:20 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.241 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 20 Apr 2023 12:02:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.241-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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

