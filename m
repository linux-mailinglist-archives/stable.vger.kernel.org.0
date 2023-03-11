Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 556726B57A6
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 02:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbjCKB7y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 20:59:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbjCKB7x (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 20:59:53 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E96313F18D
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 17:59:51 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id b16so2774407iof.11
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 17:59:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1678499990;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TmOK8Uz3KkGO3i5LKLy4ogbNt2yEolBlgdmXQA2p1DI=;
        b=Frg3LCd+nllIj2u9mw5A5CegEgBu3zY6KuOu4SYUCXb+OmWxiHrk2nN78PpQSRFmHB
         tpQ3zB0KCvy/7UM36UAzzVeHTSdchJJRLQ5t9vXHB7bpGWUSQPoheRu7iGeOsjWVPmt8
         k4O55Mn0/C7ebIi0omedT/r6LTHWSY1t56KHo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678499990;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TmOK8Uz3KkGO3i5LKLy4ogbNt2yEolBlgdmXQA2p1DI=;
        b=2iiLP6MCurPL/b8C8x1hvGq/V+uuPCPApTCm6z6RBxCKSZMjB61PnpG8HMKF8+iWyY
         b3vvVD4Ng15EzZZv8kFLbT3MBnIUy73U4QBI6/kFottsid2mqeigf7yjZxssjKUi7mfA
         hpklgwnkdfIZ0bjIz1qEjLFw2+3ON31Qs2K1uHG792G6lbTHuEZKBjVdTqzTOUM8hNba
         /fjb7drX3FcZLdWoIO0drI7a5WQh09x5xo5DD6hD0cKCimzFSppm1Z/gsRRbwuPFDDmA
         PhCuVcmm8CPjK/DojlHNflAiuM/QVo8WFZCKuR+/cZbYYtxV2STPcCrC24T61Xup5hDp
         GcPg==
X-Gm-Message-State: AO0yUKVpPTI3ajPYB5TIMLUttMsyYvIYKCvuN3T2CL/JPmJnLN+iVBc6
        w68JjSIq9fFFiCEVf8D5nBgePQ==
X-Google-Smtp-Source: AK7set9uqMsOEAiWqWPw3QPsocJFQRv6ctMGqakBIYYpV97+b24VuHfQw0KierQHXjRnN7rGXnwurw==
X-Received: by 2002:a5d:9606:0:b0:74e:8718:a174 with SMTP id w6-20020a5d9606000000b0074e8718a174mr4849943iol.1.1678499990288;
        Fri, 10 Mar 2023 17:59:50 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id k24-20020a02c778000000b003e545419425sm467240jao.84.2023.03.10.17.59.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Mar 2023 17:59:49 -0800 (PST)
Message-ID: <95f636ed-4d08-f323-7dff-92152287dae8@linuxfoundation.org>
Date:   Fri, 10 Mar 2023 18:59:48 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 6.1 000/200] 6.1.17-rc1 review
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
References: <20230310133717.050159289@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/10/23 06:36, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.17 release.
> There are 200 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Mar 2023 13:36:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.17-rc1.gz
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
