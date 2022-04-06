Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4DB54F6D0E
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 23:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237027AbiDFVkZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 17:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237713AbiDFViV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 17:38:21 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40D7B19E0BB;
        Wed,  6 Apr 2022 13:57:21 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id n8so3064726plh.1;
        Wed, 06 Apr 2022 13:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=M3MEvVhFzzQotX/HtGN33NXma/P1r5Q4BewBuovNpfY=;
        b=XThIusyP5gQrtUaD6/zthwHE8c5RPOKm8a5sKlDsSfVlC3gBySFZCk8aB3u05C/ivD
         rxv+JtND51CbSMLRJjT81jDR93ah53ZuuGD1RymF1mpBshKQnQLBFlvEkra2onYWqq+L
         pUY59TCqy0MMb8vaA2mWAa164mXvybUnI2G/TsBLuioD1KXAgCOGBfVbCb+NGsFnVkpQ
         Tv6pX+ytgvOs31+mPiQ7Jq48g5jbueAs16RkYXpYyuZyrUXdp6fg5+clPaHZ5gcsNS4p
         0uh1yOutod6DU796aTgsFw++n0lg0W24wO13lXfCn6G/ABJdTPkvW+XycvNIdwe6eS3u
         TQqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=M3MEvVhFzzQotX/HtGN33NXma/P1r5Q4BewBuovNpfY=;
        b=pb5w6NudaaqIH+GNXJPMCC8O5oJDm06DxT53ltpB99HoePSeaOXQhDDQSztHI9rq/3
         U0NO7o7ToxaM9X92gBCP7Xssp99RaP/pWxYjEQV00z630xrKcTlzWh6FcN9FvNyjXW6I
         obUfS0N/x6w9IYoicbEj5gU7mNigh6V1dBxiPlNxtZGAqxn5vhm8TVpLBq8Fwn56YAMO
         8haZwkesYqPzuY6LgGk0D4BDpyi6NJ0Kn9JtUEvIrGhwbV25SCle5X+daPBfX83T4E6B
         lR+J0VWAhPu91/siAC4UJNGzrf6TNbER/o/+DOGgtDZmtxQUsLk/GiO+a4rBQW+VY2ny
         0qoQ==
X-Gm-Message-State: AOAM5336gZOSoeKIXNBcGvE38GQLxezmJIgAWnFcSqIPNZzjodywyGQl
        9F0/nokfO/VjK22w3jyuz12ACpUgGbM=
X-Google-Smtp-Source: ABdhPJyc7wOVogs1ZMhi7IpPK+ws8sRGaM/8iHCg7kxdSQXEs5Vl5E+/v+8rkTWC2xtBzq/Fugxo/Q==
X-Received: by 2002:a17:903:41c8:b0:154:7d05:9829 with SMTP id u8-20020a17090341c800b001547d059829mr10396053ple.41.1649278640617;
        Wed, 06 Apr 2022 13:57:20 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id v13-20020a17090a088d00b001c64d30fa8bsm5257426pjc.1.2022.04.06.13.57.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Apr 2022 13:57:19 -0700 (PDT)
Message-ID: <8b4692ca-7877-e086-3097-9835caee0735@gmail.com>
Date:   Wed, 6 Apr 2022 13:57:16 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 4.9 00/43] 4.9.310-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220406182436.675069715@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220406182436.675069715@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/6/22 11:26, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.310 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 08 Apr 2022 18:24:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.310-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
