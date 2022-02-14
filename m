Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 167404B5D99
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 23:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231849AbiBNW06 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 17:26:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbiBNW05 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 17:26:57 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF8A5F70DB
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 14:26:48 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id d3so13467555ilr.10
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 14:26:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mh9D1jdAVhkF4zCdTv1hqpvPFkjj3A/owqWFEQoM8Jc=;
        b=NK+HsFgCsmrzREjXtV4IBALwFHnBzhgW+Kd3nFYwrd8Qal/TRBwvsuUgOrIY0D19G+
         VSVNVQKVzqiuOsSgd22e5MEA51c8ngCoITfiKupXj4sncCypMingupKSW2IPidmay1r0
         qJJkkV210EndE93qesU8XmUyyu9bIoR2G3Te4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mh9D1jdAVhkF4zCdTv1hqpvPFkjj3A/owqWFEQoM8Jc=;
        b=lgE/aR+GLTFzonyY8fy9SZ1sLE3EU9P/Q5i5QD6cx0ykoVov3ekh5Ifa0agz9ZdzaX
         I2kzh6iJRIwbIeCan5UMf3bA72pEvkH556yUlITJHmKPXms1IB8prgQG1S6vTyIyaGMw
         dLZ5spUMbIOzTcEDD7prT2ai4c/PzCQgjtsIg7xashNt2SqTVZm47P6GZFdigLaqIfBL
         8l1Zn0HVFrlB3hQkEhnIXq55Kn7VFZLN8Lhvf0Apkx+mtg1qNIXLFTGlOKmXPuCRnIUG
         46e6zBvMpmwnPJ1ushFHQkbN5O6tmtCmuEVa9Fk0CGQWCX4VpPMAnmq9GjOygkqLFFNm
         MCLg==
X-Gm-Message-State: AOAM530W/C0GiASOyUqp4Qf006TgZ6AsUzrqRFBg/BGkSipB48FMxi2O
        JDKT4g+f8RgkFP2sh446XWxfHw==
X-Google-Smtp-Source: ABdhPJx0KwZr3TwrbXYZ3QDvRYtwLUNK9yUftEo2HtyVatHbrg6Hq4m0go5vvj83GH5SeK6VutsBUw==
X-Received: by 2002:a05:6e02:1487:: with SMTP id n7mr622725ilk.25.1644877608183;
        Mon, 14 Feb 2022 14:26:48 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id f13sm21329813ion.18.2022.02.14.14.26.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Feb 2022 14:26:47 -0800 (PST)
Subject: Re: [PATCH 5.15 000/172] 5.15.24-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <f452357a-b0a2-2473-4bd2-2c6461dcf966@linuxfoundation.org>
Date:   Mon, 14 Feb 2022 15:26:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/14/22 2:24 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.24 release.
> There are 172 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Feb 2022 09:24:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.24-rc1.gz
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
