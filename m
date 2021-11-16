Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77595453951
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 19:18:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239383AbhKPSVc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 13:21:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234497AbhKPSVa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 13:21:30 -0500
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1821C061570;
        Tue, 16 Nov 2021 10:18:32 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id q25so530707oiw.0;
        Tue, 16 Nov 2021 10:18:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AJg7sOX7y/dDBSs4YqM7U1f6mIeqvJrHEeNWwZmmLpU=;
        b=LDGSBipwyOs5s4aZyk/QmL7n8LPasIDfN9CMEj3fPh0kU0RTZW/ksloV26mWcEimvF
         0l7+dP8Clft55kkP67w/oYW0peWLPwEwJeq0NCsGMFZA+VXC5/Pw2W1RbGF9yW3KHlaS
         wyrrtS+zfubG/CTW7WoM0uEN74FrQoRWEWZIVWYNjzOsKB0ufLjYM0Db/kPtK+m4WEKK
         RLoRZ7Mu/rPVEgbc046bIASijBCyqlO1l3CaQD7FLl/6ksMSLOdwKD65XEkKnETYwmsh
         2s7afWSVxglAyIuS7FNU+ux/Vtq5+JH59UNpFWrPMwjfLdmlFJPbfM4nNJZL0iC8JVmG
         Kukg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AJg7sOX7y/dDBSs4YqM7U1f6mIeqvJrHEeNWwZmmLpU=;
        b=d2dsZG5iwIN3j2yUsXAOtUV5fu6J5d6HTeoVC5yoodniyMEQ/1RkAM/349r7+lhwe0
         piaAITQfUYjupbJ+ZnH+FEVJPhUWC2937ypLN/CtkM+5HxX6pejAf+9qn6e+zbyJmLwK
         b7IyqXLELYjj7mgneVT4DI2vb1vSI1Maxi2T8e/6euyHnn0FcUoszPxgolkzMauGUz04
         jqQg/+/w1MPVX2s2Sg0RnjnXSJnFM02ijRPLHnwgFJuyIzC9M29zrUr/1Lei4ZuWjtJZ
         5OPfVnPJ1y4SFpkgkqxxgyafUbgqeU+dxB4oa4Iwi8Bis0cWLnGZ5X5zNyFdHJtFDpqL
         szPw==
X-Gm-Message-State: AOAM533g0FAuWYW0zyTrEbCdScZAJjB7I12FPK0BoBXFOk/2UHHDsWdV
        bJRMAdS5O3vkF/WM027HBR/ykgYZuIU=
X-Google-Smtp-Source: ABdhPJyIe5tQvX8D1e9k6Eqb73EexEPHMI5WYM1/OuOmKDecHUkq/FUJKN53DfwLD1BUz2mPA2cBVA==
X-Received: by 2002:a54:4590:: with SMTP id z16mr8278988oib.67.1637086711577;
        Tue, 16 Nov 2021 10:18:31 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id be12sm3005279oib.50.2021.11.16.10.18.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Nov 2021 10:18:30 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH 5.15 000/927] 5.15.3-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
References: <20211116142631.571909964@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <2861faf6-734f-a12a-6e07-e2a34ded994d@roeck-us.net>
Date:   Tue, 16 Nov 2021 10:18:28 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211116142631.571909964@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/16/21 7:01 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.3 release.
> There are 927 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Nov 2021 14:24:22 +0000.
> Anything received after that time might be too late.
> 

Building parisc:allmodconfig ... failed
--------------
Error log:
In file included from include/linux/compiler_types.h:85,
                  from <command-line>:
arch/parisc/include/asm/jump_label.h: In function 'arch_static_branch':
arch/parisc/include/asm/jump_label.h:18:18: error: expected ':' before '__stringify'
    18 |                  __stringify(ASM_ULONG_INSN) " %c0 - .\n\t"
       |                  ^~~~~~~~~~~
include/linux/compiler-gcc.h:88:47: note: in definition of macro 'asm_volatile_goto'
    88 | #define asm_volatile_goto(x...) do { asm goto(x); asm (""); } while (0)
       |                                               ^
In file included from include/linux/jump_label.h:117,
                  from crypto/api.c:15:
arch/parisc/include/asm/jump_label.h:23:1: error: label 'l_yes' defined but not used [-Werror=unused-label]

Caused by the crypto patches, which expose a missing include file in
arch/parisc/include/asm/jump_label.h. The problem is also seen in the
upstream kernel and (as of this writing) not yet fixed there.

Guenter
