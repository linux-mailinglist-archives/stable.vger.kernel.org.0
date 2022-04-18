Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1073C505C6C
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 18:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239081AbiDRQae (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 12:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234285AbiDRQad (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 12:30:33 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00E792FE74;
        Mon, 18 Apr 2022 09:27:53 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id e15-20020a9d63cf000000b006054e65aaecso1560930otl.0;
        Mon, 18 Apr 2022 09:27:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ugT6u+C0I3KSL6RCIIwvLGw6SDuB9e9N5NTAuy1X0MU=;
        b=ZQuoJlv9hb47u9ZXWciB1viIiCqQpcr68faG+EpcdNbTqusJAXVYoHLEaOOQLnlHfU
         X8fLpDJEhTjtySM6iJo3Qi4XlTd1yqwqlXgCChTWeYr6wFIM0CM3nPjxdN1S3FZwtO1u
         NVvASt4hSEpCKxO/T0l7NCzC6iAcKJTfQouOSK75MDo7VgoqHBILwXvI/x6Z/oEtFFXK
         ectdzs9lHFkK7iYREBMywmPdoq8GASpWvBqh1JDOB9LeK1ClxKF6GAM8LzoLrSiMm8OV
         MhT8Dnvm/+1k3yQaGNXR2iim5IdEvFa1Uf+Df3ynvUxYJxY+ZM+FeebdPQNtF5cbJH6B
         oHIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ugT6u+C0I3KSL6RCIIwvLGw6SDuB9e9N5NTAuy1X0MU=;
        b=VMK1k0b7XpRwqGg++hPVqiPUT7xx2dMA8w3w8RiMdmznTJd1KSd8syNBb3pj2el9bL
         zyhsqTj5RuKK6HgvvPXEBO4oUDf1fUtLNNTNnnZbdw+hkXVJq5jLyXABCjSwdWHVodbc
         BgdOpSy6bMMYZEN9g3Q565bOgB0uhg8cbc4Clgo65CVkyKS6C75rUdYpMUjTOfpUXqOS
         cEwIUu1S9rxHG+VKbxpszwoVT2emPtwYkVFC8TQuJ4o9jqD56IZmiLIU1nCnw43w0RyJ
         9qjSo2PI1WQkXTstDZh4HoNtJfrUSPDSjz301z4k48NrRY8nqkLb70FW1KC24R2GA7cO
         2yPw==
X-Gm-Message-State: AOAM532N068PRqTjqNL9WEdGtS/xSNXg4+7x5hrjphsbc8GsbMp8TBPt
        sf1VI8BaJxtx1aGe+xRj2MI=
X-Google-Smtp-Source: ABdhPJyHUlDx2nQA/FG4o8wwOtrW0dJqteowz3ZOiJfzrMUcd2O16hTJSzEQE0I7ohzaoiycKAdnBA==
X-Received: by 2002:a05:6830:19d4:b0:605:4c22:cc82 with SMTP id p20-20020a05683019d400b006054c22cc82mr2281768otp.134.1650299273280;
        Mon, 18 Apr 2022 09:27:53 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l14-20020a4ac60e000000b0032993003287sm4395101ooq.38.2022.04.18.09.27.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Apr 2022 09:27:52 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <8d09a73f-acbd-82dc-77f0-540d106b6e67@roeck-us.net>
Date:   Mon, 18 Apr 2022 09:27:49 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 5.15 000/189] 5.15.35-rc1 review
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
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <ec6408b7-14f4-fc97-3371-3f6cd9a46d24@applied-asynchrony.com>
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

On 4/18/22 07:07, Holger Hoffstätte wrote:
> On 2022-04-18 14:10, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 5.15.35 release.
>> There are 189 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
> 
> drivers/gpu/drm/amd/amdgpu/../display/dc/dcn31/dcn31_hubbub.c: In function hubbub31_verify_allow_pstate_change_high':
> drivers/gpu/drm/amd/amdgpu/../display/dc/dcn31/dcn31_hubbub.c:994:17: error: implicit declaration of function 'udelay' [-Werror=implicit-function-declaration]
>    994 |                 udelay(1);
>        |                 ^~~~~~
> 
> Caused by "drm-amd-display-add-pstate-verification-and-recovery-for-dcn31.patch".
> Explicitly includng <linux/delay.h> in dcn31_hubbub.c fixes it.
> 
> Current mainline version of dcn31_hubbub.c does not explicitly include
> <linux/delay.h>, so there seems to be some general inconsistency wrt.
> which dcn module includes what.
> 
> CC'ing Nicholas Kazlauskas.
> 
Should add: The problem is only seen with 32-bit (i386) builds.

Guenter
