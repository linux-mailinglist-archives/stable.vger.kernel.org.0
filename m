Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5496966D380
	for <lists+stable@lfdr.de>; Tue, 17 Jan 2023 00:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235209AbjAPX7R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 18:59:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235728AbjAPX65 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 18:58:57 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 303AC2C67B
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:57:16 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id n85so6581876iod.7
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:57:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=v0z1gMS+9HIPFVX04fyPNMYdGM/BSmGc5mjByFwg7i0=;
        b=MXJfyBQvzfc54+UEP1wsRqVTY4QGsxrQ63Z7MCjyWylFeNA1Pa3fYeC9WUJ3m2xzs9
         M3hA594jAD2ayP8peodHINiSIOAspjJu4eLIQvQyuIQTU7IXe9tf+UTmPRoDR1lPiDb8
         iATk56rwoRdUbU17sNhQ+VYWSGvAkJUJX1Q7k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v0z1gMS+9HIPFVX04fyPNMYdGM/BSmGc5mjByFwg7i0=;
        b=B6BFIROCiItbZ5/Vw3GcoAwERbY8ei6o8R8rkmCJmbXW0eqe7DiCEifQE3Y/NsG6Bv
         vdh78vB+gVzWDoDvC0aZjFQAAOA7qKLgMXMLqG5w7Gk01b36KOZppGtvkP3w+wPYuhzp
         zfOPnydjtGYo4+dsONsS82RB0xmtsNmcgACpFacmbt8eCqmNXXrmVCoi3zrZ7fqRmCtS
         r8xcIVEAOZyVHEYve6kDQK+TqV3rosI1/GqAb11F+p38ToNeynRsOjp4TezP2rG6r3mp
         wZUpOyK7gkzgU130t+3D3dWXRS10SZmz0piMeoR0IRNSvqHvz+P6H4IAIoZvKQJqsozY
         8hzw==
X-Gm-Message-State: AFqh2koq5b2QGVWi4OhUjcfBF6I3lvgXnvDMSwrKJ34vBZi9E8V9PD3h
        0arSFfpVhhxeCu2jYhCmoU3fCA==
X-Google-Smtp-Source: AMrXdXsjU0a1tX7qEMEUNAqff5oTL17K5yyhmGG4LaKEQHNRJHN3N3WNSCLFPuDSKB+dfDPcUNLA6A==
X-Received: by 2002:a6b:b70f:0:b0:6db:3123:261 with SMTP id h15-20020a6bb70f000000b006db31230261mr144145iof.2.1673913435528;
        Mon, 16 Jan 2023 15:57:15 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id k66-20020a6bba45000000b006e2f42a30c2sm2685817iof.35.2023.01.16.15.57.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Jan 2023 15:57:14 -0800 (PST)
Message-ID: <88c77a57-c96d-ed03-9a5f-ee73ea1071dc@linuxfoundation.org>
Date:   Mon, 16 Jan 2023 16:57:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.15 00/86] 5.15.89-rc1 review
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
References: <20230116154747.036911298@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230116154747.036911298@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/16/23 08:50, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.89 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Jan 2023 15:47:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.89-rc1.gz
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
