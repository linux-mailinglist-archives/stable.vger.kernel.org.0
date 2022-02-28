Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB934C7C45
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 22:42:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbiB1Vm6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 16:42:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230525AbiB1Vm6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 16:42:58 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B428114CC96
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 13:42:18 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id q8so16364577iod.2
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 13:42:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=psCBzbXEDf6T/SWoNq2L8Jn+X5RxvEcj72+FIH1380E=;
        b=FRVQPlvlgtb9ftOph2cuTty7puYPGKS3oBL3GLLjUNdnRw5ZD1P52NGE5E3Vwaokam
         /6PEaakHj1sqi1yh4tHdHwQyt2Vjk+hUXK+OdFFUW5XFHQ6Cuk8PL1wiE9pl2N/qF3Hl
         t6AQ/Ps5D/GUaRIJPIYeuHK8c0+xIzZzN7qSU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=psCBzbXEDf6T/SWoNq2L8Jn+X5RxvEcj72+FIH1380E=;
        b=pMZMHoOyFOPX8ny9Dth6u/wHsLSVE2tbsbv8n8b3e4F5pm0ulKpSsMfQrPa/FWHeJu
         henP7IVKzhPcZs54Em9WmHYPCSAjZ1yCLEAXVQfgR0BygQg4KNHRfmEM4h/feuNHKOfL
         X94/Fu5tSDFBYwuC1aYieMhFLs94tCyWX4E7zkINMQRkMyt/lmcmDf2R9pjZZbdNb5tr
         sxdsJ64zyFxUuert1FlzUAQ0/xC+uhleWM3Q0uvD/mCOXlGroPgiMHiATKojHypYn27R
         36KBGE6r+dyid1vmQLMA5me3FzCG1npz8aVZdJwPRDbEfCPA0P57DH4dM1GtauwR5rL0
         QmyQ==
X-Gm-Message-State: AOAM5300+aTY14bBvGgMGAs59o4EfqBG6upqTm9nZBMuBC8HM8dtOqO4
        aWIsSTSBEy+oZ0T3iQ/jsJWP2A==
X-Google-Smtp-Source: ABdhPJyyuwpkhfFWxu/CuqzOs5vGs/IW6q7D8yAK8Yzox+34UhF2GsOq/rjmkiLlcffT1Dfc0JJ7bg==
X-Received: by 2002:a02:aca:0:b0:314:9da8:7be0 with SMTP id 193-20020a020aca000000b003149da87be0mr19029259jaw.280.1646084538129;
        Mon, 28 Feb 2022 13:42:18 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id t15-20020a92dc0f000000b002c2258e154fsm6694109iln.1.2022.02.28.13.42.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Feb 2022 13:42:17 -0800 (PST)
Subject: Re: [PATCH 5.4 00/53] 5.4.182-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220228172248.232273337@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <e435f20b-e2f6-0645-725b-afd1e4e00224@linuxfoundation.org>
Date:   Mon, 28 Feb 2022 14:42:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220228172248.232273337@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/28/22 10:23 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.182 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Mar 2022 17:20:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.182-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
