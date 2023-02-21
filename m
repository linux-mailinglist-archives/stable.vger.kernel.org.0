Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C51F069EB84
	for <lists+stable@lfdr.de>; Wed, 22 Feb 2023 00:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbjBUXyv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Feb 2023 18:54:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbjBUXyr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Feb 2023 18:54:47 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A58CD23D86
        for <stable@vger.kernel.org>; Tue, 21 Feb 2023 15:54:21 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id y3so2702159ilb.6
        for <stable@vger.kernel.org>; Tue, 21 Feb 2023 15:54:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1677023661;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8wKzCBIrzleXPLPzgon4Kd+/Lf72uKEdFGeTeuKUEj0=;
        b=iatcsXEGN9iXSm0s4j7p4xxNxDf0jmkUNo1H8FJsECzqxoFrp2R7EESDRJUJi3Q0+5
         U6w7UGMcEfWAgQqgvhho/NwcQqAinD67Nqmh3SKLURppioDirYDyFil4xeS0VviwU1AH
         Hz1Epc2cjH3y5DOrdUMuA6s0Vf3PRmgqhiAAw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677023661;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8wKzCBIrzleXPLPzgon4Kd+/Lf72uKEdFGeTeuKUEj0=;
        b=jHDhCgoCuffI1E4Q15UwxPumD274pL13TqQcAtIDkMC/PAkEYSbZwJK5FkB3RFfJCm
         5DE088Ys5Nq5or7raMPBXOmIj6HY6gSqVP+T35aHz5WOrPZIyOB9+CktFaOFKVYHB5bw
         upZAFKF/DYDXP2n/+gBVMeTGlupW82fTdX38DyTH31wxJ8SGj8N50+ll9hbZY2XoFrQb
         YmdtvKpDAlSD7bpIQqRsmPswxR6N5QW8ZTmkqdp+aD3P5scDhtKhm3xf00LG2XS1hA8T
         b18z2+qKrqx5B3/hB9fpVrDYBiznw0fM4XLv5SRK1juv5V3tQIyY+IYZKszEyaaAnOHj
         ZSMw==
X-Gm-Message-State: AO0yUKXdr2HEbckqJ39xZAplK3XWMBm9r/hjSbNE3BE071Zh0KZOFkcJ
        WAIMDrSqUZOTxIBuzlWp3Ds3Tg==
X-Google-Smtp-Source: AK7set8greIh9RXufbMmZQqMyLNXcOJdQKVVXWxBalZCc19cdd8nj1Pw3dow4riLmlffporOfkSu2g==
X-Received: by 2002:a05:6e02:c73:b0:314:9f2b:f63b with SMTP id f19-20020a056e020c7300b003149f2bf63bmr3056666ilj.2.1677023660986;
        Tue, 21 Feb 2023 15:54:20 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id u3-20020a02c043000000b00363362cd476sm1575326jam.101.2023.02.21.15.54.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Feb 2023 15:54:20 -0800 (PST)
Message-ID: <959efbce-b31b-c06e-1134-2cd80bea87f7@linuxfoundation.org>
Date:   Tue, 21 Feb 2023 16:54:19 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 4.19 00/89] 4.19.273-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20230220133553.066768704@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230220133553.066768704@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/20/23 06:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.273 release.
> There are 89 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Feb 2023 13:35:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.273-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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
