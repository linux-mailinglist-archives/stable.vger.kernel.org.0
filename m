Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BCE64E7DA7
	for <lists+stable@lfdr.de>; Sat, 26 Mar 2022 01:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234161AbiCYX0Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 19:26:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234133AbiCYX0P (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 19:26:15 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9469434660
        for <stable@vger.kernel.org>; Fri, 25 Mar 2022 16:24:40 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id r2so10612609iod.9
        for <stable@vger.kernel.org>; Fri, 25 Mar 2022 16:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FJmvZccGaJGSNab8sq31mbD5qtNA4DKZHunSot0Hl4M=;
        b=R0whAKIQDX1WAnt8qm60IiyM4aeKpqzelT1FaZFxN2Ha6qTEMGzFcpkqzmGlAMALvn
         /Cs/NSoA7/hO9FLhseU4PgiauHNM0dpEzVs5Fs2m9t6o3wtEA/8BMpFX0YHHGFCWkd81
         9IAySz914yCnQ5v9Vx/EhbhGrRV2tnNjGN6LQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FJmvZccGaJGSNab8sq31mbD5qtNA4DKZHunSot0Hl4M=;
        b=RDlQI8IE4Lao/EAsTp1EmvdjGHo4xEk71ZjWbFWxcQe17VXtzPuBC/h23iJ9ZxccuL
         dE6NzOayrH0tojALDQhfYnYmQKZaupiP2lBfSBFyHTS97ZeNZigtP8/q3YBF/uhYsjw4
         /3QSXm/SQudFXwu+6LtwCwsOYNKMM9UyGyUAGkJunVCf22XrMtvnll/8YJeaXeapKq75
         Y8Nev2uZ0mkn5KWtNmCpDnDAzz6kDiyivi4VvsiWrYZF6i99SgqgyrBUPYcdOLqFc/Rg
         nCRDqlngoSfv+x7SsA3eX0ZdrN629TcgJ2pUQwByEHIn+Lby6xYW3YlXenSXwyXZoAQO
         UOxg==
X-Gm-Message-State: AOAM530Rx6C1pXJ5505TK0+RPFDiS3uOMAP681pnKLB55zlU654m6SaS
        Bh7kycf3OqdKAKXtGVtJKdiQrQ==
X-Google-Smtp-Source: ABdhPJyV5intVmTDpIFC0wVU6SUEbTydvEz/r46Neva3NGBy12Lr9h1DJ4vFEkFFlUpTrSQr3vAeXg==
X-Received: by 2002:a5d:8b47:0:b0:649:a70a:5715 with SMTP id c7-20020a5d8b47000000b00649a70a5715mr691623iot.5.1648250679973;
        Fri, 25 Mar 2022 16:24:39 -0700 (PDT)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id y74-20020a6bc84d000000b00645dfdd8a4csm3789689iof.38.2022.03.25.16.24.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Mar 2022 16:24:39 -0700 (PDT)
Subject: Re: [PATCH 5.10 00/38] 5.10.109-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220325150419.757836392@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <f5e7b06d-b03d-950e-76e8-f5673a1d76c5@linuxfoundation.org>
Date:   Fri, 25 Mar 2022 17:24:38 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220325150419.757836392@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/25/22 9:04 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.109 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 27 Mar 2022 15:04:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.109-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
