Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3CFB6E8171
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 20:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230459AbjDSSsj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 14:48:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbjDSSsi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 14:48:38 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D4194682;
        Wed, 19 Apr 2023 11:48:31 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id k9so35589pjf.4;
        Wed, 19 Apr 2023 11:48:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681930110; x=1684522110;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=D+SqyhX+3FqHam7C3q5QGtUBNfi8q4FZTru56mM6qbE=;
        b=RzC9ADprsx/h8HXKtQDNfM8dxoNlVlh09sxEpOYd+VfMAAg6p8i0BmSyuFYXupcKoE
         l2NnD9c0WnohldgQE0x+N4xn6jAYjQW/bbaG5wlPOaibUIOX337opAIZ0ymZfm3EvY0f
         JqzsKLZVfe/dzf+egRGzFyUVkbYXdCuTZDl9gJkfqAJLIrM7FGK/7++RsbrVBO6pyZjC
         wNj8KCThgJsaBL9E18Qj6jIQQ8eCPaqgFGQvP8SqZt+7dk4/Ri/8HbTUaTpEUlzC747F
         gcLg4D2UWmueyGYyvNL1wWkxkcC5i999zdEHD9+ekqBB/jKFR9DcocprDjfQChlqaNUA
         v2qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681930110; x=1684522110;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D+SqyhX+3FqHam7C3q5QGtUBNfi8q4FZTru56mM6qbE=;
        b=JTSKzi+70klQ0Q0+kXaGN1pPLCDmiHQXrj34LCSioRC8Jb4pvrB/TG0m9LiCcY3BDf
         kzc3IiRU74uHMkfiCmnBtq067ge5WdI8+TN8vYE4CAD8TLIzv+QSYuKiHNGXzGdCghq/
         qvCBf7a0ym6WDzWZXrDxvRox9OPsubZhQXd5v6O27VnooCbYzgZkg00g3mFzchD1v/gd
         mfYIcqJoH435Z2C+hf58ateJODLdjUihvV03Yp1R0IBGgRqW+1DshJf6acWEwRw1Flv4
         GW9P+qnbtyrN9SXRyj2Lpc1QkN7L2uD2UForXg/k3lAzSAKXomaWvxS1JelpMU2VQj1h
         tpmQ==
X-Gm-Message-State: AAQBX9eunIDAo/NwJAYn6Bf4GJyG80R9lRmDKNBI/E6tO14DgFViKsdI
        kl5BNJFNT1UcKzew7m94O+A=
X-Google-Smtp-Source: AKy350avFjskgNR3WRTTklTxIYMSEHrgekcU1SuOqrQwD8V74+LOBJcu3Gt4aFNfPV8NLLUuZG9wHA==
X-Received: by 2002:a05:6a20:2619:b0:ec:7696:ee96 with SMTP id i25-20020a056a20261900b000ec7696ee96mr3218648pze.38.1681930110495;
        Wed, 19 Apr 2023 11:48:30 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id r10-20020a63d90a000000b0051b72ef978fsm8829366pgg.20.2023.04.19.11.48.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Apr 2023 11:48:29 -0700 (PDT)
Message-ID: <e40e811d-51fc-d7c2-c3a8-69f22e8663b6@gmail.com>
Date:   Wed, 19 Apr 2023 11:48:24 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 6.1 000/129] 6.1.25-rc3 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230419132048.193275637@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230419132048.193275637@linuxfoundation.org>
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

On 4/19/23 06:21, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.25 release.
> There are 129 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 21 Apr 2023 13:20:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.25-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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

