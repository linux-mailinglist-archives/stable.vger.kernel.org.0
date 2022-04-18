Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1510A505E0D
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 20:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347440AbiDRStx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 14:49:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233797AbiDRStw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 14:49:52 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 900432C12E
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 11:47:12 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id r12so9384321iod.6
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 11:47:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+xlC0/vhq9DS4MywfAGPmUw8P8N5+SAf6g0dQ1E684k=;
        b=bTZWrTYZ8Skc1emb+YBn8UeXzm1GU2rzq1c5vlTuSFaVK7bQr/KMzez2D5Sm8Fzciv
         c6lmv4tP0d/pF1OrUBtW4X3QVNdbJQ/JvvU348OAleDoPSDf29+uOqKYDA22FgaIoMAI
         s//z8OUxTmA5rkuBQYeS6Z6Z8kJKx/mVBZPoI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+xlC0/vhq9DS4MywfAGPmUw8P8N5+SAf6g0dQ1E684k=;
        b=DtIPOX/O+XHlqW5ur9919/SuEhS6CoeYqE4fnq19xIw6HTAmveBSbBa8cr0DQHlNCF
         32itB4CNQbu3vKSzTnVbzzD5JygZvZhl0oXdA/GcazMol45W1e2eJ/LQlz5TLy+5DgJ3
         tRAQX8CinBJZf13Zg6wWOjyBvMSNNwq6GcVR0SaFgEz461A6tM/VpZJHyUI3Dc25y6RB
         qEKzkvQ/1aaFrys1BFKgJ/4r8ZmmquDNyce8ZY6ikBXBcdNXOF2Y/R+bp5l2qAsLo6ON
         k4aRiCnImcnp9BVd2uF6KQEVMOpVRx/P3Zm0WhfBt/1M8AcNeBFUE0YE1yWjcXigqw2B
         2u3w==
X-Gm-Message-State: AOAM531RS+6FJxogVdjf5kfeKuMv2qhC+uuYv6toG5sTb5zyCvGFdgPX
        HaaZRgNBpyrO715eBRj2yMVDpw==
X-Google-Smtp-Source: ABdhPJwHyd9CLmCOOxk2j/UdG5zFE9tkCKjdtWQ9zOONUVAhbubxfI8FDeYhENTOdUzghpJEEe7YtA==
X-Received: by 2002:a02:93e1:0:b0:326:7a7d:a2b0 with SMTP id z88-20020a0293e1000000b003267a7da2b0mr5470151jah.44.1650307631765;
        Mon, 18 Apr 2022 11:47:11 -0700 (PDT)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id a3-20020a5ec303000000b006496b4dd21csm8439237iok.5.2022.04.18.11.47.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Apr 2022 11:47:11 -0700 (PDT)
Subject: Re: [PATCH 5.15 000/189] 5.15.35-rc1 review
To:     Guenter Roeck <linux@roeck-us.net>,
        =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220418121200.312988959@linuxfoundation.org>
 <ec6408b7-14f4-fc97-3371-3f6cd9a46d24@applied-asynchrony.com>
 <8d09a73f-acbd-82dc-77f0-540d106b6e67@roeck-us.net>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <4e2a8939-faf3-44c2-a0a8-9f6fd996db34@linuxfoundation.org>
Date:   Mon, 18 Apr 2022 12:47:09 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <8d09a73f-acbd-82dc-77f0-540d106b6e67@roeck-us.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/18/22 10:27 AM, Guenter Roeck wrote:
> On 4/18/22 07:07, Holger Hoffstätte wrote:
>> On 2022-04-18 14:10, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 5.15.35 release.
>>> There are 189 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>
>> drivers/gpu/drm/amd/amdgpu/../display/dc/dcn31/dcn31_hubbub.c: In function hubbub31_verify_allow_pstate_change_high':
>> drivers/gpu/drm/amd/amdgpu/../display/dc/dcn31/dcn31_hubbub.c:994:17: error: implicit declaration of function 'udelay' [-Werror=implicit-function-declaration]
>>    994 |                 udelay(1);
>>        |                 ^~~~~~
>>
>> Caused by "drm-amd-display-add-pstate-verification-and-recovery-for-dcn31.patch".
>> Explicitly includng <linux/delay.h> in dcn31_hubbub.c fixes it.
>>
>> Current mainline version of dcn31_hubbub.c does not explicitly include
>> <linux/delay.h>, so there seems to be some general inconsistency wrt.
>> which dcn module includes what.
>>
>> CC'ing Nicholas Kazlauskas.
>>
> Should add: The problem is only seen with 32-bit (i386) builds.
> 

I am seeing the same build failure on x86_64 build on AMD Ryzen 7 4700Gtest system

drivers/gpu/drm/amd/amdgpu/../display/dc/dcn31/dcn31_hubbub.c:994:17: error: implicit declaration of function ‘udelay’ [-Werror=implicit-function-declaration]
cc1: all warnings being treated as errors


thanks,
-- Shuah

