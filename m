Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0968254BFCF
	for <lists+stable@lfdr.de>; Wed, 15 Jun 2022 04:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345756AbiFOCsA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 22:48:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345727AbiFOCrt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 22:47:49 -0400
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E318027176
        for <stable@vger.kernel.org>; Tue, 14 Jun 2022 19:47:48 -0700 (PDT)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-1011df6971aso12472796fac.1
        for <stable@vger.kernel.org>; Tue, 14 Jun 2022 19:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=B1G4oDCXdAsSRkBXg/6227Hdo7j8CpabB4ks2UbmviQ=;
        b=P45jWgZ6BEP7ghdsx/spSyePU8CcAQmiPkz7YP3Zhn12tgoLulGNzTJk0XMphGL0eu
         FdiLMBqIIf0Ivoq5jkNMAB9BTHdoz5zgaeU0hjXP5gHztE+hTa9PCwSNq6MAM9FTwVQl
         QePKSGmi8xK3PTVwWuzijRoTVsHDzCpFpT+J4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=B1G4oDCXdAsSRkBXg/6227Hdo7j8CpabB4ks2UbmviQ=;
        b=4r1sX80+eupPt03QIUgkJdgZa8s4xDg0jHRcA9G92TYNBMJ6Wfu9Qwi06rP6vqfUj9
         dpDS6RVs+vUEU3ykqz8w7SPWCachRzJ6CxNP1HIi4bjD2zzemcZZcPgsY8ale/K6wdJw
         qz4C8EsYxfFKoH/G1rQD/90dVbpeNmCguzXZC341Haw3+bj/cOEPCsezzWsoi3/VSnRi
         fUu3u9weMaP73yAd1yn9HBi5qA/f6r/e0Vb3bj829l5kzPixsWQ6GNHHFlRiAdiJAZ+5
         cpKLWUxj87WSdyZ7w4gGuHBiN4QSEKAXDCllUFCaIq5PLSIVMwpYSDMlj4OA0XdIBQvO
         tH0Q==
X-Gm-Message-State: AJIora80G/6l76vtQ0hlFuBBKuv0vDxqITtxnQ4RGM9cqsgVk1UpCFqZ
        q5BCNDXOCxtbOR26xU3E2Ek/sw==
X-Google-Smtp-Source: AGRyM1vbWg4W92j0nqP/FOugFUvH3fak2Ft8jDn6jyQeePafZ51cDLve0x3DI0uNBrRfwW231azNSw==
X-Received: by 2002:a05:6870:d390:b0:fe:5131:8ee6 with SMTP id k16-20020a056870d39000b000fe51318ee6mr4270384oag.28.1655261268229;
        Tue, 14 Jun 2022 19:47:48 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id d18-20020a9d4f12000000b0060bff068228sm5562843otl.66.2022.06.14.19.47.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jun 2022 19:47:47 -0700 (PDT)
Subject: Re: [PATCH 5.18 00/11] 5.18.5-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220614183720.861582392@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <21b32db5-060c-67af-1873-6558d6cd8def@linuxfoundation.org>
Date:   Tue, 14 Jun 2022 20:47:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220614183720.861582392@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/14/22 12:40 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.5 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 Jun 2022 18:37:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
