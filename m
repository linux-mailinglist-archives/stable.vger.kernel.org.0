Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB343CEFA6
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 01:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354508AbhGSWUL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 18:20:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1441858AbhGSWN7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 18:13:59 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91FC2C0617AA
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 15:46:29 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id 59-20020a9d0ac10000b0290462f0ab0800so19820437otq.11
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 15:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KyE2hPx0TqjwF+EWXbiY19sKAIbJLJOpj7hrFpzW8Jo=;
        b=FoqyEglhl36rO3FQbOJZIPaIFcaUh/wwHcS/yb0tvrWwASjD/ZL/M1qRfR0s5Ocvd/
         O+e8DVfTH5lLbuJRvP+HSUYIUWeDY9oOgEL+AwPDAGwum/ONs0PsGamjBuGxomQm3gxi
         XHcLJMJxaz0pJRkF2hrZ/3VbtWzgx+Rnwh8eaxT424m+kjFZeiD9O3ZVfIWGFLUJFx2q
         nK6da++hxiBJ0q/wFDAT5xEWLiXhgsXJLOuWW24TCuVmTbSWNZtGIcGQafKJKhtLOtZc
         K77kyEzBRDDzqK5YLy2V1Y3bBVim/eWuk044/pbzLlWNMBAEcnd5kUz4283vP5EYMWYy
         dPyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KyE2hPx0TqjwF+EWXbiY19sKAIbJLJOpj7hrFpzW8Jo=;
        b=QHHXe2HTyOiaGYmT33ioUIjMqUc3bGcjSBwRuO2i4g+G9khySyOGYWFoFm4kcCcHDO
         Uce1y9IinvSBWJsv47RxK8shsYbo4ty3Nx117fMuThkNNH1df/h16tkdjCA/7SrC9kIr
         QxKT/Whql2przwKFc4s3XPV+tvnDBxvgl3hI2uOy36tqG41+UrckUvKif5wXwIGdqsfZ
         /OqGvZKpxD4RVZsFdTkPLsl7vYSOmQmjP0LdeVqBXTvWcE+MannipLPyjjtw+IFLdmzN
         dTBNBuKa0KUf1n4UZXpkjSYvt1BsPZvgq4vMwahBIanHZ8uq0Fhieyd18Bf99hdCcT7n
         m3TQ==
X-Gm-Message-State: AOAM532Y/lJpA55m4WH27Y0aPBSQMsoj1tARtcRaGAOGbr8DTC7jevQD
        S95CUaLfODPEAs44lY+7jQW3zA==
X-Google-Smtp-Source: ABdhPJwLChe+v+azZgkQTIZP1+AE5vYylGV93HF03MP9Oo7qXvqymJiFoPb0sJQmzXez/ISopfWe6g==
X-Received: by 2002:a05:6830:40c4:: with SMTP id h4mr16818826otu.75.1626734788917;
        Mon, 19 Jul 2021 15:46:28 -0700 (PDT)
Received: from [192.168.17.50] ([189.219.74.83])
        by smtp.gmail.com with ESMTPSA id p4sm3613598ooa.35.2021.07.19.15.46.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jul 2021 15:46:28 -0700 (PDT)
Subject: Re: [PATCH 5.4 000/148] 5.4.134-rc2 review
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     shuah@kernel.org, f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net,
        linux-kernel@vger.kernel.org, namhyung@kernel.org
References: <20210719184316.974243081@linuxfoundation.org>
 <3d770ab7-5008-cbee-98c1-101d839739cd@linaro.org>
Message-ID: <b98fa7ee-bfb2-4c0b-19e1-9b4175e4a167@linaro.org>
Date:   Mon, 19 Jul 2021 17:46:26 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <3d770ab7-5008-cbee-98c1-101d839739cd@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 7/19/21 3:46 PM, Daniel Díaz wrote:
> On 7/19/21 1:45 PM, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 5.4.134 release.
>> There are 148 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Wed, 21 Jul 2021 18:42:54 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>     https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.134-rc2.gz
>> or in the git tree and branch at:
>>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> Perf fails to compile in 5.4 on Arm, Arm64, i386 and x86 (GCC 11 and GCC 7.3):
> 
>    builtin-report.c:669:12: error: 'process_attr' used but never defined [-Werror]
>      669 | static int process_attr(struct perf_tool *tool __maybe_unused,
>          |            ^~~~~~~~~~~~
>    cc1: all warnings being treated as errors
>    make[3]: *** [/builds/linux/tools/build/Makefile.build:96: /home/tuxbuild/.cache/tuxmake/builds/current/builtin-report.o] Error 1

Bisection points to ee7531fb817c ("perf report: Fix --task and --stat with pipe input" [upstream commit 892ba7f18621a02af4428c58d97451f64685dba4]).

Greetings!

Daniel Díaz
daniel.diaz@linaro.org
