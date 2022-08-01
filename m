Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD6825873D7
	for <lists+stable@lfdr.de>; Tue,  2 Aug 2022 00:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234465AbiHAWVR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 18:21:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234568AbiHAWVQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 18:21:16 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C56992FFF1
        for <stable@vger.kernel.org>; Mon,  1 Aug 2022 15:21:15 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id v185so9434219ioe.11
        for <stable@vger.kernel.org>; Mon, 01 Aug 2022 15:21:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=w4Wkl/vaeanU5CATfePgSiEEuu91H19kZGf6hH8fOek=;
        b=CIiqrt1epLTGK4psmDwMtuvxjAwep67srmtYsjUZP3oHUxqubiCnBleG1gA8efCkIP
         H8LXc6JhaMX7ptYAqGQLCTP/Es5w8huanSdu+9g5ddIxxec63NgO6aQCUZpeiRTlSiVN
         9fdBJGWIPNN9n1I6nIV7N8/Lyuxi6eMH10Pjo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=w4Wkl/vaeanU5CATfePgSiEEuu91H19kZGf6hH8fOek=;
        b=wT8IkXp95yp8JXv9EsiBUr+oMHV0m1IIQO4Mi0w21iBO4lqo/+DoRdzNQOunNiJb59
         RiXDTXTLCO1/qJCMw5Ztudmr29rSGYQaGgq79523S3v2ITlif1voCft2W7j51xdjG41s
         WIZIls6gZlkEB3lvzmFICAeHkJSgmPiPnOf5eT9c4OqZJThgqJPXtDXJ+yngnJBC3QrC
         urg5VwQcTmlsm7XhG2YXFPmxLf/Q6rUPj2VuvQ+ADgyAfBGdyDus7hXziOt1dlzUJdGO
         ZB+AJvXKvrgch/7PPuvFtiOwiezLJDm+KEkp5sLou+ULncASUsbpfznmXd3OJiwNLkyc
         R3aQ==
X-Gm-Message-State: AJIora9Bd2ZhQpBIc7jU2wMCR4HHARaHn4GBHGyzT86Zcty5QD5QN/iH
        V1j4rLD/Gx0gA5fasLceZiFW9w==
X-Google-Smtp-Source: AGRyM1s2zeTgWyDw1FSAi/PsGiKiW4RBPkQN4VOt+TT5X8fBdAw38A3+DgDhw+8EBPT0ITDwRjw5pg==
X-Received: by 2002:a05:6638:138f:b0:341:4711:4c2c with SMTP id w15-20020a056638138f00b0034147114c2cmr7200228jad.178.1659392475227;
        Mon, 01 Aug 2022 15:21:15 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id n26-20020a02cc1a000000b003415f2fb081sm5711261jap.125.2022.08.01.15.21.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Aug 2022 15:21:14 -0700 (PDT)
Subject: Re: [PATCH 5.10 00/65] 5.10.135-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220801114133.641770326@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <e213a88f-bdb1-73af-db8a-3041bb05fb79@linuxfoundation.org>
Date:   Mon, 1 Aug 2022 16:21:14 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220801114133.641770326@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/1/22 5:46 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.135 release.
> There are 65 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Aug 2022 11:41:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.135-rc1.gz
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

