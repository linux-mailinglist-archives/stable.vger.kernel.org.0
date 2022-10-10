Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3A95FA6F9
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 23:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbiJJV2Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 17:28:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiJJV2Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 17:28:24 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A947579EF6
        for <stable@vger.kernel.org>; Mon, 10 Oct 2022 14:28:23 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id o65so9447264iof.4
        for <stable@vger.kernel.org>; Mon, 10 Oct 2022 14:28:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=beqBZm3JL2y3Op74AbSY9rCY2nqRVoCQveeVTUcU43s=;
        b=K0467Unq5iV8TNwyYC1b5kavYHgZS736nXleUpeJ9KH8+UUeeCyskvEfh/zy5p4ZNU
         ufVXv3Sr0inDENPgDfMQSU8tlVCxiL1YER20xGO/x76KC5wepEGoABUqeglq9YDWXtg8
         BlldSXwsk3uuMk8Kcx+D9KKy/UsaLc58d1MEk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=beqBZm3JL2y3Op74AbSY9rCY2nqRVoCQveeVTUcU43s=;
        b=K4w5/AqrTem+ymaFQY8l4ZvQrU80t06l0WNncKJq74shcCKhSBsFl9wMLS8TzU99En
         li8GeYo7r/+N1ySSKACqJk5lJmfS2d1c14Ib9ai+Q/4VLfYqcV6ry+X8jTQgZvqRiZTp
         t6FyvHcFQEOL3FRQcu1Z1AapTpRhdzaQEHgXogbZLUDgFyh7tBwhkg1ocybJpC0Ybjnm
         lXWQpJ0Oh9ID1n0JgdxlfBTjVtTwQXw7Yr5teo1MJbynYWTxnZMPeb2qImLPPJ04zlZY
         YAjDYl/IAQrfBryQfmIToKFv96DyqOigkJD0BTZmiwZcnvH5OQhvo6DqRh4vip6TzWlr
         mz3Q==
X-Gm-Message-State: ACrzQf2wmHT16hmyJ3+vcKH+wd4GLA+OrGueHWcOA6bBc0O0LJ0ElYBU
        HFL9dHvetMWK8DtZL+Hqvj5RRw==
X-Google-Smtp-Source: AMsMyM68MifSSECYuy5SMXY0QOC3A4RwA0pXKlDff3Rx+7kVYYAMgja0iRma2YDhe0tJ3K3MuYmDHg==
X-Received: by 2002:a05:6638:471b:b0:363:bb71:d82e with SMTP id cs27-20020a056638471b00b00363bb71d82emr3387771jab.141.1665437303038;
        Mon, 10 Oct 2022 14:28:23 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id h9-20020a0566380f0900b00363ae22a33bsm2409912jas.127.2022.10.10.14.28.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Oct 2022 14:28:22 -0700 (PDT)
Message-ID: <55e9f769-6590-0fd1-e59e-95bdd7f3dde7@linuxfoundation.org>
Date:   Mon, 10 Oct 2022 15:28:21 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 5.19 00/48] 5.19.15-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20221010070333.676316214@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221010070333.676316214@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/10/22 01:04, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.15 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Oct 2022 07:03:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.15-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
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
