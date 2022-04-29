Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 786645153CD
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 20:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380055AbiD2Sjf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 14:39:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231183AbiD2Sjc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 14:39:32 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62554A5E88
        for <stable@vger.kernel.org>; Fri, 29 Apr 2022 11:36:13 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id r1so9210778oie.4
        for <stable@vger.kernel.org>; Fri, 29 Apr 2022 11:36:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=drjXCtx3ivDwHM62mHLD+ciWIMFTRh/2yWrMxqUb6+k=;
        b=DgMk0n2jjN9kc+6fd//pda8ZFQHS/PIN5wLzp3FZEkxgqdhYXqtBpeFTXWgc01MsP9
         qjMLVucOlRX8+84XSG4SYERbZG8F5XVl01Ay/iCOdYCTLv1WW4K4l5nhqZx9qLoH0W+N
         jmEWxHW8b75ftRZQxHVr7dhH2HnTTR1l5+nyU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=drjXCtx3ivDwHM62mHLD+ciWIMFTRh/2yWrMxqUb6+k=;
        b=429+2FObomi6QJlVNOSO7S99YVef79r8OY6ZLCNE5v1f2O28IVLF1NehGZSatT3qsn
         XQv4lc7+XYnoOqr82ZauMdFzvzCgocoIWVkL0bULZnXwGBbzIPHKKj6wIEoBSZQz/WhX
         RKZENZyzaw77NuJ5GOGMUS59T21UnHxcywYNQGngrjKDwK1BodhnC2lDP3D7kTBxkZW/
         9aY3HLrBLffsD2IzAxyRMp07Xvl0B3E55zhxZifiPUwr9ajpXqLUKa+bkR7UQuYr4TyG
         /4gRphEAaRQQFG+9dM6laqFKyCsCXmfR4gjHXnsLZNGRgv3Jt/hzhe5euqMqHq3lbhdp
         O3aA==
X-Gm-Message-State: AOAM531hIVtlyyq040b9D+zVNtxhpzXn+K/l5l269Bq6ywSHNzwQSfBO
        WVR6OchKkObYHyNXPHSwe/CsjA==
X-Google-Smtp-Source: ABdhPJweK4rrPZFOqn0AHyZ0+VPFxBEmTGP9XbXgLNkcgdt4qfUXftLATQirSX8fhc64yuiP8Br2pg==
X-Received: by 2002:a05:6808:f8b:b0:325:ae98:f735 with SMTP id o11-20020a0568080f8b00b00325ae98f735mr373283oiw.240.1651257372765;
        Fri, 29 Apr 2022 11:36:12 -0700 (PDT)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id o4-20020a0568080bc400b0032571d1f27bsm1536311oik.6.2022.04.29.11.36.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Apr 2022 11:36:12 -0700 (PDT)
Subject: Re: [PATCH 5.15 00/33] 5.15.37-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220429104052.345760505@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <bb7a74a6-d606-03fc-d1a1-cf6a22f8351c@linuxfoundation.org>
Date:   Fri, 29 Apr 2022 12:36:11 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220429104052.345760505@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/29/22 4:41 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.37 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 01 May 2022 10:40:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.37-rc1.gz
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
