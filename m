Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB24E5F37DE
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 23:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbiJCVed (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 17:34:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbiJCVeM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 17:34:12 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61B131D0DE
        for <stable@vger.kernel.org>; Mon,  3 Oct 2022 14:30:10 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id m14so2343220ilf.12
        for <stable@vger.kernel.org>; Mon, 03 Oct 2022 14:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=GuvWtx0dm7LPC5ol2oLdRALGrQDEsJrdHlyh83t0IvM=;
        b=dSRQTFR71uRO8bz3HOUdASSr2GwOsA2q6Z2HVcwpPE4OQuiFrgysp3xfGDF7HN5SFb
         8pCS+GLk4B6ELMgPE2UV46Y/rWDw+GHc7eUYfTWKqVUaJG81/ATx4aSpJ/IB8qD/4eKg
         9qdkyuuME0+UNWotJ2jRdtveT+776Gg3AVudE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=GuvWtx0dm7LPC5ol2oLdRALGrQDEsJrdHlyh83t0IvM=;
        b=S3USORV80WAzO564XSNXx+hBEIzevlTCHMoxCCwQqbSxdheYrmAVv+4vxdtsiomKu2
         v+6BslrWIcq3pJpb6jgJz0zVv34Kgv0Y/ltXVIL6xn80RzNT2/V4VpRpDFfJE7fH7cIG
         ODTRGu/7GOP9GPPWkJ3WWAyw+pBBMg63IKf2LHoBN1xYqVSacJHyYVTDnj7/Cel2f2Ql
         INmllQ6Dk3Bl3lyixiOH+wjiwOPXKB2bWKeNeU2u1hN8WCanlUX8Zi0OOwTJbLOhCFZk
         fwSdv+cOjisBknK+cspD3vc75Dh8mCQ6ABRTyVO6L5RIHHhICoLbON2UqkJRMVLGzsqa
         ORHw==
X-Gm-Message-State: ACrzQf0zoAq2cgAR2DEo0bD1uzb86t4r+r5WGoeQinNmnbozPMP4jVp0
        ldd+y1UIgO13ewD6VLj2QQFqSA==
X-Google-Smtp-Source: AMsMyM4SEwAg6ufglkCCwzGIKm4vHlVH5rBftWsUvVZJhxUoiXQljVbwXA3VJM+0KlugHaWg6HjWrA==
X-Received: by 2002:a92:b009:0:b0:2f9:91d4:6d47 with SMTP id x9-20020a92b009000000b002f991d46d47mr4893197ilh.158.1664832609754;
        Mon, 03 Oct 2022 14:30:09 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id u7-20020a92d1c7000000b002f90ff8bcbbsm4209963ilg.37.2022.10.03.14.30.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Oct 2022 14:30:08 -0700 (PDT)
Message-ID: <4e95484a-2d47-b3c1-52bf-f3b9a27884e2@linuxfoundation.org>
Date:   Mon, 3 Oct 2022 15:30:07 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.15 00/83] 5.15.72-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20221003070721.971297651@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221003070721.971297651@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/3/22 01:10, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.72 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Oct 2022 07:07:06 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.72-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. I am still seeing the drm related
regression and didn't get a chance to isolate. Will try to do it this week.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
