Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F07D7665069
	for <lists+stable@lfdr.de>; Wed, 11 Jan 2023 01:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234711AbjAKAf6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 19:35:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235316AbjAKAf5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 19:35:57 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D6C0322
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 16:35:52 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id d6so1522232iof.6
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 16:35:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Jko9O+H74wBBe0vOgpMZquu4AW4dJPh7ek9zytA8QWA=;
        b=ej5SdkZ0rhZ8OirQ5cw+cdTsBKp2j6imgTWQsU6NomwCVNByPVX27BICW7YY3aAXG8
         h4Ov0PriuTmzAAmr508gHAfF5cYRaxOwM92Lxi2hUoyL5z9H0It0NOOW4uhvNXOF9jnq
         dOzgT57GV/CWsQzGMDChc5kLScIhV2c4JmCGQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Jko9O+H74wBBe0vOgpMZquu4AW4dJPh7ek9zytA8QWA=;
        b=gVEOf3yjGGX0KYXxFiDIevToeN/u8ND2b9KjA1uycceQt8L/JM2a/NDj4T3SoxRh2J
         Pi36OyJsumgLKj1Oanv/5RyxPPMUOfoJ1aQ2tB7g3SafjZqmnZIRT/SqZDeDvQWMTZ+b
         Aj/vGQYxiZmPKZnuKLthb7EvPx4TGJyg3atBojaim39imuXcmM0ahM0XNafTI6s90BWF
         sqPc7XmBOax1wdd150HGCWoMvu2bm0EcX30p09jNIxQ8H1OyYJ3jwIYApf1nKp24HQxX
         ym4HCxj7AhLnRNLfe0e2j+fJGIvd8nqFkcfHvrX/3kxxNr9zCRn1noC4UBFTSzvD+PoM
         Q6Hg==
X-Gm-Message-State: AFqh2kodT4KKm/mJcpPUow3Z0fk/9ZvptdF4YbMC75DV/8Qh7zgFYHn9
        t6Dq5cWH5wyTUQWDkJl2GvI/c+nEvN7s3PhR
X-Google-Smtp-Source: AMrXdXs70iWKDDZEzh1upPNH2VzfIiP+zp3BGuibA61MaamqhSuNsHg+3IfwNjQemF5pZboJPVXJRw==
X-Received: by 2002:a6b:e812:0:b0:6f3:fed4:aa36 with SMTP id f18-20020a6be812000000b006f3fed4aa36mr8574987ioh.1.1673397352003;
        Tue, 10 Jan 2023 16:35:52 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id u10-20020a02c04a000000b0039d756fb908sm4086138jam.40.2023.01.10.16.35.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Jan 2023 16:35:51 -0800 (PST)
Message-ID: <ac8d8ff5-75ca-c399-7c1c-b71ebea2229a@linuxfoundation.org>
Date:   Tue, 10 Jan 2023 17:35:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.1 000/159] 6.1.5-rc1 review
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
References: <20230110180018.288460217@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/10/23 11:02, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.5 release.
> There are 159 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 Jan 2023 17:59:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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

