Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0171C558C7B
	for <lists+stable@lfdr.de>; Fri, 24 Jun 2022 02:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbiFXAxJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 20:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbiFXAxF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 20:53:05 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75DF512ACE
        for <stable@vger.kernel.org>; Thu, 23 Jun 2022 17:53:03 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id s20-20020a056830439400b0060c3e43b548so758557otv.7
        for <stable@vger.kernel.org>; Thu, 23 Jun 2022 17:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ImHfPCaPUd1DihqvYfZq04kkw//axTluA3YmBvfUgfs=;
        b=WHLvXYLYfu7D56qF8RKpcuboBwpHZH3JppVUyb36DYHTG/Ve/zqSboyI5wurnB4+we
         YLXNmGcjyw6rvjR0WRavOn1kIf2qmyvFaSexN3uCeK2zkilM7agKOcpL8CNCl8sTB2er
         NmxBzAmXc+Eb9ccn3ipLicL/I5lhWiwEVi0cQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ImHfPCaPUd1DihqvYfZq04kkw//axTluA3YmBvfUgfs=;
        b=CNP6pVs2sPoloMUnxfl5NNemvnX6N7A6x+XGLVlrLOvPmtNpNqpmteDInSmIBVsp74
         H3Z3TiTK99qAeUEv9SbrwuLp0KpAKhnmMBF9wmlDXBOs7wrw6nq32RzsbBr8b1iZHcpn
         6xUjX5NdceGd9L52nasGX9c8M1QAKIEPw/HyFpZgEMGXMpmEiShVltKCbyVjGTNpOw7u
         V/BH6BZsKs0VebCbBApJtf8SnEyrYulOVsFYvLhXKF3FZ+F8Ku6AY6Ey2V8qWqMbP2TM
         Ng/Jo5p7hs4azAVAiqLWWjOxBEkmWpKbMC2xFESMPQJRC1mWBv8BKEpWnz7cOO+wanQ/
         1Ccg==
X-Gm-Message-State: AJIora+mCBSdgwtB2kklUA7dvITNRlSLIax7+ofICOn7Yi4gftgolVhc
        W/1LGFEP415maD9xh/NBfoEavA==
X-Google-Smtp-Source: AGRyM1tn8fdF5XA5R/54P2LuHPyeI5IzIaqG6YdCeNk8+/LKgCqOSydzygj9y2jEBSR8G4b4R0WRDQ==
X-Received: by 2002:a9d:6d96:0:b0:60c:101a:5408 with SMTP id x22-20020a9d6d96000000b0060c101a5408mr4827544otp.279.1656031982766;
        Thu, 23 Jun 2022 17:53:02 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id b4-20020a056808010400b0033519ba7d22sm367000oie.32.2022.06.23.17.53.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jun 2022 17:53:01 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/11] 5.4.201-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220623164321.195163701@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <6254d299-e86a-dfd5-7d0d-c47e28236f06@linuxfoundation.org>
Date:   Thu, 23 Jun 2022 18:53:00 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220623164321.195163701@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/23/22 10:45 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.201 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Jun 2022 16:43:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.201-rc1.gz
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
