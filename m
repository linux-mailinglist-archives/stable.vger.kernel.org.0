Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D215455CF33
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241764AbiF0V5r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 17:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241879AbiF0V5L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 17:57:11 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 671DF1A395
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 14:56:06 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id i194so11010426ioa.12
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 14:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qzu8UZCKhXbZgKEQvFHqCgJ6gOqBiEV7P2Vz6hn0wX8=;
        b=IvPENyiieJEmSL0m4xjVa1zKm0eeT/i9vna25dYrLAcK0MowrkF76+GlLUKbL1rWvq
         ejxhZeV7CkzzoJRPJHiVpAmecJLHn78K5msEk2bsJpOfD73FTfMwxdNVqCk5MfEeJRqE
         avUVXGl9fToIkW/Z/oYBPp+tU38pUevKzPh0c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qzu8UZCKhXbZgKEQvFHqCgJ6gOqBiEV7P2Vz6hn0wX8=;
        b=2q/WMnBpDjvOKlWdYn1o+pr0hNwFtJGrqSk0VKugShybhhshJlW/Bdiruef6QzAJ8o
         d97OmObk1jQAY4JYOo7f1mADgNBSZqTggSgfoVSlsJG+yWLbNximdo8bDsuObPU3ReQQ
         qzQdsqXVPUPet7ma77b5s6QjM0o7VK90cHT5prQ/2e0bfriwgj6yi1qHBt5nsP1aiZ2r
         bRj5RPdxOywlCxaCF2gJUc7ElCLN99VBuD5/0x1+8e8yvzoBP0FAS2K8bXCEOcNLpIVR
         2Biiu1R3SRuUI1KhpDABJgKvn+V7/NVRb4zdsFS8OrKIyldrZbkutWIXCX4ksuh0ujlx
         5BRA==
X-Gm-Message-State: AJIora/GJmDCtqbIKVMbxx6pJaHH7CbAbHQXMO+qF0WIQDivMrVSgZdk
        2C5brg3G6iHhNcCRpHySkh34qQ==
X-Google-Smtp-Source: AGRyM1sDdg3zkdGpJxNMA0//YM98bWSELkawQF3QSgRHZW/zy2d5o6DzPdNoFCsh3AfGNbGyTNeg4w==
X-Received: by 2002:a05:6638:14d1:b0:339:e8ea:a7c4 with SMTP id l17-20020a05663814d100b00339e8eaa7c4mr9466183jak.309.1656366965678;
        Mon, 27 Jun 2022 14:56:05 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id x13-20020a92dc4d000000b002d94b276fc8sm5089846ilq.6.2022.06.27.14.56.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jun 2022 14:56:05 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/102] 5.10.127-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220627111933.455024953@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <fb7ca467-a438-93de-dba2-db7b5330b4fc@linuxfoundation.org>
Date:   Mon, 27 Jun 2022 15:56:04 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220627111933.455024953@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/27/22 5:20 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.127 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Jun 2022 11:19:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.127-rc1.gz
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
