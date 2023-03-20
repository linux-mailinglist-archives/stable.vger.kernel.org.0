Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9171E6C255B
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 00:04:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjCTXEY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 19:04:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjCTXEX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 19:04:23 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00EB62CC7B
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 16:04:14 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id bf15so6186617iob.7
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 16:04:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1679353454;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+yUZjR/qMJXhLe/J3/juEcp+ow37U+EJGerSZ99l/M8=;
        b=M5xX1vVFGXpdmwonnZsBel68/KmGTna+nV1/sEkix5WjqyckVYhqzPt++KEvWoruWb
         b3jN1dk1o/dnO2+PJD4yydMG+ffei9JmdnSUeEqxY8+tHLnUWIUYN3D/1FPgmipPQUEC
         mhqR4rMO63F3EYiDiFPKy6KdADejymoPMfShA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679353454;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+yUZjR/qMJXhLe/J3/juEcp+ow37U+EJGerSZ99l/M8=;
        b=FTrMHSScjfZ5aTlluZKv8N7d4Upv+3Dxv8GhPe1znEq51KfJu1GFonBXKIcV3M4gmQ
         n265DVRPr/PqcPvn0cG5Ccgici5zuZv58goeh7vAaqRxtn8YItO51PIsshMcowQ3cIbH
         cdZ4F/WPwUdH5ESXgU/NxEBr3WDnM/AmfDXoUxKUY+/ilQobxB40rX2fSA2o57XVOo69
         y9nK+JeZRp7s5NWKpTmonurCAVmw8MI9Ix9YJl6EXnkUjcS6JqvjU9xBVDjTawRVFKgg
         wgZlNY512uokzoh2NYPME/eehUx/DEJPmxxLAKWor1XPjQNb1R9l7OWa4B3CzNvCErfw
         SViw==
X-Gm-Message-State: AO0yUKV+1ns7rVMwIs4c8zC2BDlnBDhUQe+NXU2H0/mAnDVonAoyU75S
        XLWEUdaUCtHixTXp8eTgNUSSsg==
X-Google-Smtp-Source: AK7set8FRrJRIFI2f9vGCO2q/0xoYAKI0RO3PmBHifIG/3tMLnp2titgv9yXro8S4Zb6MB3lpk9kFQ==
X-Received: by 2002:a05:6602:2b95:b0:751:d1c9:92bc with SMTP id r21-20020a0566022b9500b00751d1c992bcmr639690iov.1.1679353454249;
        Mon, 20 Mar 2023 16:04:14 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id c11-20020a023f4b000000b003c449a192cdsm3496941jaf.73.2023.03.20.16.04.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 16:04:14 -0700 (PDT)
Message-ID: <de25435c-8478-7d4b-a09f-26294168b729@linuxfoundation.org>
Date:   Mon, 20 Mar 2023 17:04:13 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 6.1 000/198] 6.1.21-rc1 review
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
References: <20230320145507.420176832@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
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

On 3/20/23 08:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.21 release.
> There are 198 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Mar 2023 14:54:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.21-rc1.gz
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
