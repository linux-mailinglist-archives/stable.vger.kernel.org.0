Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C91C438AE35
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 14:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232298AbhETMbK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 08:31:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233367AbhETMbA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 May 2021 08:31:00 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECF4AC04868F;
        Thu, 20 May 2021 04:30:30 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id 124so3407320qkh.10;
        Thu, 20 May 2021 04:30:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NaNY9SfYLqqOrW2ih6TU14/XllrmHd8SYORcWh3RyZY=;
        b=cmjDK05PXVCAYDR2Ji2n7oXjUtL8UL7OWR/PRUU66VYPAP1OlYxBh7MB4GViCN5jWR
         C+2pXnYcRfqqmuVqu5ClSzF3kfZHexXXZidXF3nIHIzwb/49LK8scOOre/Tp5J8GTvBi
         G9Vx1RpCj0aoZ0LqryFtmhTaJ/x3wFIp9sTKZP1PaPNrHiZOBvoXHqJ04w+cJR1SO4Wy
         UEKiwH9aW5/VtRP6X2YaymfRNemNKWLuz1qU2Je2+yoYnMvkZm1vSJQSEIXOdeOoNt5l
         6WElm0r4v9gQM+0N5PDYjKBR137eNNojwX+VCaf2YTXcRj9mC0/oF/LgbD1cF+D2a+7N
         lf3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:to:cc:references:from:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NaNY9SfYLqqOrW2ih6TU14/XllrmHd8SYORcWh3RyZY=;
        b=iBebDgGqlzadw0q0KdDc4oDujN+/mEENwfrxuH39TFox6TkK2XYLVHuz2qLH766I5p
         EPMOSfoFZz7NX3DDRpSzbdFht3XHu8SjYkhr9Qgu2VMYiUQDI/g4b78JAfi1xPFjYms9
         eWrbRUrAR/N15g5apfIrf6p+K45lIWoaPP9ITLnD4FcKSENlNDqF2BR81ci3ejeB99zW
         yWg9EIqaFdRA7f6f3jv47jDiGZQK9dHCN/XseR9SThq8JZgNB2Wo8UstcBQT4Xygcgqu
         XHc+cneAhx7z+3M+8u0uhjZ5bKJqDPzvJ/TGjygo0mjpqZ/EtgnSENOlrmlCOnR5Yue1
         tV9g==
X-Gm-Message-State: AOAM532k9gFhXSzBemoYddOpj5bgUpoOAMfY9tVffLt0iBNVy2w3dNyj
        +pml447TXScMURN47d5On/jXAcIarws=
X-Google-Smtp-Source: ABdhPJywsut+2A7b/XF954BE45BCzr6KoOEEI307zQdcJEKvz9GeiMmvNgHQFgLXB1PXchUgLj/Ksw==
X-Received: by 2002:a05:620a:2a0f:: with SMTP id o15mr4303779qkp.295.1621510229875;
        Thu, 20 May 2021 04:30:29 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p14sm1756788qki.27.2021.05.20.04.30.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 May 2021 04:30:29 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
References: <20210520092102.149300807@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 4.4 000/190] 4.4.269-rc1 review
Message-ID: <cf63f39b-6323-4c11-8e53-d04532ed0b6a@roeck-us.net>
Date:   Thu, 20 May 2021 04:30:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210520092102.149300807@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/20/21 2:21 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.269 release.
> There are 190 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 May 2021 09:20:38 +0000.
> Anything received after that time might be too late.
> 

All mips builds still fail.

Building mips:defconfig ... failed
--------------
Error log:
In file included from include/linux/kernel.h:136,
                  from include/asm-generic/bug.h:13,
                  from arch/mips/include/asm/bug.h:41,
                  from include/linux/bug.h:4,
                  from include/linux/page-flags.h:9,
                  from kernel/bounds.c:9:
arch/mips/include/asm/div64.h:59:30: error: expected identifier or '(' before '{' token
    59 | #define __div64_32(n, base) ({      \
       |                              ^
include/asm-generic/div64.h:35:17: note: in expansion of macro '__div64_32'
    35 | extern uint32_t __div64_32(uint64_t *dividend, uint32_t divisor);
       |                 ^~~~~~~~~~

It looks like the changes conflict with the code in include/asm-generic/div64.h.
That code is completely different in later kernel versions.

Guenter
