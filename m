Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 483814FEAEF
	for <lists+stable@lfdr.de>; Wed, 13 Apr 2022 01:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbiDLXfs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 19:35:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231431AbiDLXc6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 19:32:58 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBD456D979
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 15:21:18 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id p135so18007687iod.2
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 15:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Gl+YqMB1WW3Ib7L+XCeBKpWla23lkdhnXW3bHwJTMT8=;
        b=GMeyzwBOf1UAQTAdYkU+w+Eotzg30VU1F93bzVm6GfCm7eayvv3TNG7IIq45+Nif1H
         KGpz5BrMhxviT5dQr+6JO/ZUfpiD/rhS80XRWgW5163Rbw2lZXgyRjQMrBkjXXSojjWC
         GyDCa5J/3ofiaDTSpfp8EeW5krJ28cxf2h38s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Gl+YqMB1WW3Ib7L+XCeBKpWla23lkdhnXW3bHwJTMT8=;
        b=iaucksG+n891OLcpeGng7Jo0GcReVGdVADerBiUbT5emQJB0mlofwrXV+uDLxfJaH5
         GIjjEDZLAbE0KBRh1OF/rz8GytyWlvWntCydz3otq/wioKBJAG82LZMnJ2WxQx9hkcHm
         WGPgko1gDRI9qDcr3o0T5L+DHSXlrvZruojO+IKzEykMhqhjLw944XnN7WpUV+2Ddy/V
         BeNzV7WpdkwjA2vRO8Qpoosqhf4+14nA7k3C6c/x1rm4QRW5eFZhBHEyPbWFODLSAz1q
         Z+EfKggx7BPIr41J2Au9OYKnZw1iGUHT1pg96fhX/257WF5cM9JT7vjEuCOuIS1dKx7r
         vm/g==
X-Gm-Message-State: AOAM533Yiuwj3L/SBVopGaWxliA5lAGi9qbPrVxKeQZA++bH/ahWl+fL
        ONdghB+8vsf0/idsCrNSru36ug==
X-Google-Smtp-Source: ABdhPJzDTgRjGvzK8TyuYVbOVCUWj1YHnTHkPHES9mbxla3byGwlb/0PhwCjf8NjNKAvW0Vpevu3Gw==
X-Received: by 2002:a05:6638:3049:b0:317:9a63:ec26 with SMTP id u9-20020a056638304900b003179a63ec26mr19674690jak.273.1649802078223;
        Tue, 12 Apr 2022 15:21:18 -0700 (PDT)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id n12-20020a92dd0c000000b002cac22690b6sm2908668ilm.0.2022.04.12.15.21.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Apr 2022 15:21:17 -0700 (PDT)
Subject: Re: [PATCH 5.15 000/277] 5.15.34-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220412173836.126811734@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <9c5405fc-432c-e45e-98a4-3ce252a5210e@linuxfoundation.org>
Date:   Tue, 12 Apr 2022 16:21:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220412173836.126811734@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/12/22 11:47 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.34 release.
> There are 277 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Apr 2022 17:37:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.34-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
