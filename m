Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD5F505D61
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 19:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244667AbiDRRTt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 13:19:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243899AbiDRRTs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 13:19:48 -0400
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E905324F18;
        Mon, 18 Apr 2022 10:17:08 -0700 (PDT)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-e2fa360f6dso14832590fac.2;
        Mon, 18 Apr 2022 10:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:content-language:to
         :cc:references:from:subject:in-reply-to:content-transfer-encoding;
        bh=Zg3Y0Niabr5mInc5x0j++5jaTsSFfuwq8dY4f1u/+7M=;
        b=HPiklLcvKEBBdEi+y+TBmRnMf1JIihSvjWGShZBTFhx8IqyjSyPPjxzHmW9koKBqgR
         azRqa99Ba3Fs4f1z58LxUawa0MLB9qr6Zq3PQOw149yt47qX/JMBsfdXRtZ5iE8tuayv
         /U50RUgLF9hXreofMp0cJe+NJpSU0u3+OZj9qda11NkqjEBdiFQbwnjdcoFe/mWWGyoW
         mBJ380RpRQvEEoByQC3LdXWKC9brJQX7+rWis5TLKb+yUkPOcJywJPGIXaQuuGqCKdQE
         w3HHJKoNSbpeTgYgyANXSidYqy/ah2H/EJsol7+ZzQjGoA7qItu0RyIKT1XhMvdbJlyI
         hfBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=Zg3Y0Niabr5mInc5x0j++5jaTsSFfuwq8dY4f1u/+7M=;
        b=o0ltf6mmiIA/a470E52Tv059YL4Gw57PBFovG1Ts6WnG87jX/h76jc1SJi2Pd8sLaT
         Fz5jzsv8wodEv37C2cvah7ALzJR5Ci/5tJUBfcYV0AEo92uo8uITApfc72xnrbI2oUbR
         HXXjYLyZtelPzY23uUL9OJJsCr1KqnwmwPsl6+QqpNX06V8K6tCAjBigZYHQpM3nNpLu
         9JNUpq91JkJ2TLbNX3ReTAqJ/XgUTKM2+ON4fw4pGV/YYszF6M3PsuTsL8X5gXvXeNUu
         +WbTowXtLOcPQvpO8U4rTi0W0FrS+WD1ziCVUBK/Q6YRsfo2riW/PeynZSRvDTeG/HTf
         +lww==
X-Gm-Message-State: AOAM532LxmjUfwAP36zILBy2fgpKoO2f0P8vFhHuf9KPNtUp+rrOq8iz
        pYXaHtQ0nUcYwqar4zuFufY=
X-Google-Smtp-Source: ABdhPJwcttx4d6za2ibxfAEVnOL1KQAEVp7bYKdZm2MbqbsgovdTR49vpbUrrYhZn2SVG4QV2FqpsQ==
X-Received: by 2002:a05:6870:a2d0:b0:d9:ae66:b8e2 with SMTP id w16-20020a056870a2d000b000d9ae66b8e2mr6278442oak.7.1650302228063;
        Mon, 18 Apr 2022 10:17:08 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c3-20020a056808138300b002f76b9a9ef6sm4253530oiw.10.2022.04.18.10.17.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Apr 2022 10:17:07 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <44a6bced-1e80-fa22-4c0c-0d07b2f8a83a@roeck-us.net>
Date:   Mon, 18 Apr 2022 10:17:04 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
References: <20220418121200.312988959@linuxfoundation.org>
 <ec6408b7-14f4-fc97-3371-3f6cd9a46d24@applied-asynchrony.com>
 <8d09a73f-acbd-82dc-77f0-540d106b6e67@roeck-us.net>
 <fe7e1bac-60b0-ccab-b88e-243b41f64132@applied-asynchrony.com>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 5.15 000/189] 5.15.35-rc1 review
In-Reply-To: <fe7e1bac-60b0-ccab-b88e-243b41f64132@applied-asynchrony.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/18/22 09:49, Holger Hoffstätte wrote:
> On 2022-04-18 18:27, Guenter Roeck wrote:
>> On 4/18/22 07:07, Holger Hoffstätte wrote:
>>> On 2022-04-18 14:10, Greg Kroah-Hartman wrote:
>>>> This is the start of the stable review cycle for the 5.15.35 release.
>>>> There are 189 patches in this series, all will be posted as a response
>>>> to this one.  If anyone has any issues with these being applied, please
>>>> let me know.
>>>
>>> drivers/gpu/drm/amd/amdgpu/../display/dc/dcn31/dcn31_hubbub.c: In function hubbub31_verify_allow_pstate_change_high':
>>> drivers/gpu/drm/amd/amdgpu/../display/dc/dcn31/dcn31_hubbub.c:994:17: error: implicit declaration of function 'udelay' [-Werror=implicit-function-declaration]
>>>    994 |                 udelay(1);
>>>        |                 ^~~~~~
>>>
>>> Caused by "drm-amd-display-add-pstate-verification-and-recovery-for-dcn31.patch".
>>> Explicitly includng <linux/delay.h> in dcn31_hubbub.c fixes it.
>>>
>>> Current mainline version of dcn31_hubbub.c does not explicitly include
>>> <linux/delay.h>, so there seems to be some general inconsistency wrt.
>>> which dcn module includes what.
>>>
>>> CC'ing Nicholas Kazlauskas.
>>>
>> Should add: The problem is only seen with 32-bit (i386) builds.
> 
> I found this while building on my Zen2 Thinkpad, which is definitely 64 bits. :)
> 

Interesting. I see it with i386:allmodconfig and i386:allyesconfig.


Anyway, I suspect that commit 178fbb6d552f2 ("drm/amd/display:
Implement DPIA training loop") may "fix" the problem; it adds the include
of linux/delay.h to drivers/gpu/drm/amd/display/dc/os_types.h. I don't
think it would be appropriate to backport this patch to v5.15.y, though.

Guenter
