Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 879D95FB463
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 16:14:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbiJKOO4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 10:14:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbiJKOOs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 10:14:48 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BDF71157
        for <stable@vger.kernel.org>; Tue, 11 Oct 2022 07:14:44 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id o65so10912959iof.4
        for <stable@vger.kernel.org>; Tue, 11 Oct 2022 07:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+n5YscA4HddyjvBsHW84yB+9tpHbp087GT3ojAVwOsk=;
        b=AgAfS7o7WGYVZPgEAjpzc0SyVgC+wHPpD4dhv9MfvweeBvLspONIb08aEKYou7Ht04
         oSfR+I41FJHLufIPeVAsa6CWsTv38z6SNmtH0jR4tzIoQrnMXIf5AyoVHSMSViuxU1VE
         RUkJ4VPFLRGEl33NV7/A4QymPS+DOCk5UPISA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+n5YscA4HddyjvBsHW84yB+9tpHbp087GT3ojAVwOsk=;
        b=b70urXKXAYf5q7Rqvm1ft+uhjmxsYOk27l6BZXYj4NTGuL+IH1sgHnnV350s64IMp4
         wpCZseq2EKdQHuDybcj8KR9VnWChCewCvKr1vbtC1YK+Wqmy/n2ei4VWxh2OHdZQgAiP
         Q0FimcSCLA0QS7ihtLYZfQoDs0sqexebMUohcOWrD2UIKFXxZc4XHIQ85qjG0G+qb51c
         eTKAJhDLz6GEI52gFFcySTfskeh/VrBaPnEqQsymoSZR+8AM+QxuSuChYLiGonVJP+gz
         bYpnKSy24QgqX1fDjsHrqDQeMOYJsQdm49XEgdDnrT6QDPm+nXN7rat+HrZQUAin3d+L
         I+ng==
X-Gm-Message-State: ACrzQf1dCjBsy9mILqfpyqLmpekDcech8ZTn6Tgaq6WMMH0biCSn8G/P
        Ue9W2gw2UZLV45bZRqWS7SKHkw==
X-Google-Smtp-Source: AMsMyM58iXZDY/TZF84W4vv6jAwyyjbNctZpYSnAupguJ+q28PuMG4qHWqDBZQ2gLh3xcp/ZK1hajg==
X-Received: by 2002:a05:6638:2691:b0:363:cc6e:76b7 with SMTP id o17-20020a056638269100b00363cc6e76b7mr2658097jat.18.1665497683223;
        Tue, 11 Oct 2022 07:14:43 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id c41-20020a02962c000000b003580ab611a2sm5224131jai.93.2022.10.11.07.14.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Oct 2022 07:14:41 -0700 (PDT)
Message-ID: <9b226ec4-1f6d-240f-57f8-c015e4f45d0d@linuxfoundation.org>
Date:   Tue, 11 Oct 2022 08:14:41 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 5.19 00/46] 5.19.15-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20221010191212.200768859@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221010191212.200768859@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/10/22 13:12, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.15 release.
> There are 46 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Oct 2022 19:12:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.15-rc2.gz
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
