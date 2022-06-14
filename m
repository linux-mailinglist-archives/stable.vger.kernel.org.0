Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 107E754BCF4
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 23:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231695AbiFNVrz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 17:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354575AbiFNVry (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 17:47:54 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EF8D2F018;
        Tue, 14 Jun 2022 14:47:53 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id r1so8815109plo.10;
        Tue, 14 Jun 2022 14:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=9at74Ur5iFmxD4FiiT1PBdnAQKqJy5K3xGJAUdKis8o=;
        b=cjsnkv/ubJU2AJbT92xgSiwYXIANuIcL/P6qSm8+LLruTKr1iulg5W0qq8ZmmIhtsx
         Kp7dqFe9bCVB0TAO/1U1BrdLR2m56CZee4zwoCNC1kTFYH7jZW74Zbk+r/nCarpipy9z
         3KSchLiQmVrcIOo4wM7CejPrgBCHPiq1J243S45nGnBJF1fZCNRvSR+8x7CSATwT9qqu
         M/P9lFDdOfFjw1+QW4XYtTlnlzneB7SuOmFMT7ulH97weiNJ4mgi/reoNp9TalsTq315
         d+vou0pYECTsiQJjBU676mWlWOZgq2MWDx1lavBPU0abSppOhIMAg0wCCHH+7O6H+DNi
         8drQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9at74Ur5iFmxD4FiiT1PBdnAQKqJy5K3xGJAUdKis8o=;
        b=Okq9Ji+uhndQmztMbvI4OmETVf5wAojOWUgiAhA/rAyXGBnhz3rYoJwwBZ5Dh2p3An
         iUkxSGe7UaI2WpE6veEY4M2ldG69LrMVMcvGA7D2Mq/ql56nXYCHDe+TQjWIfJk7egIP
         /I3ZEjzbXBf8kuV8uooP9VRJVqZl9UPhlEO88m6EFSP/1OrnxykwACMq0NVWi48sZ93n
         WKy5UAV66j/i940dga9NAP8E8ajaFD+cRR77j4Vu2Gx2NGzL7FpoyciQ/2gmmTJN2HVm
         vUmHgt5tzOxPDEi0mOpgp9Jsz6CQZha2ry0JSrjyWWZIJfASQRb7Pu4m+2hxIwqIluyI
         5xqw==
X-Gm-Message-State: AJIora/gVEZ4yoByXTMAU2p6uhL8Xf0Pz29riwamAleXrKNKPmkK89xF
        K7/WMVNKNpUXPlwwR5JiUDw=
X-Google-Smtp-Source: ABdhPJwruWIz30qqZLL5q1pgfsjO7GdDAdz4i4ZPEVIPKh8PGJn0PmxWN+YCTlF1X/kR78N1T1KyWw==
X-Received: by 2002:a17:902:a615:b0:168:ea13:f9dc with SMTP id u21-20020a170902a61500b00168ea13f9dcmr6247464plq.34.1655243273070;
        Tue, 14 Jun 2022 14:47:53 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id a13-20020a17090acb8d00b001cd4989fed4sm68750pju.32.2022.06.14.14.47.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jun 2022 14:47:52 -0700 (PDT)
Message-ID: <02a06521-d0ee-d413-e055-8eca3b630879@gmail.com>
Date:   Tue, 14 Jun 2022 14:47:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5.4 00/15] 5.4.199-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220614183721.656018793@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220614183721.656018793@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/14/22 11:40, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.199 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 Jun 2022 18:37:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.199-rc1.gz
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
