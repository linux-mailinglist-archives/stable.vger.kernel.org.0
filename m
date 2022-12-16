Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4E0B64EBF8
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 14:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbiLPNPi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 08:15:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbiLPNPc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 08:15:32 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A55E3B9C5;
        Fri, 16 Dec 2022 05:15:30 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id ay14-20020a05600c1e0e00b003cf6ab34b61so4095256wmb.2;
        Fri, 16 Dec 2022 05:15:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=U6vape/K9pnaJlDnSHi71/S2eew2s8oAgi2GcuyJr7w=;
        b=NLZIxDRvaBg09uYmB05NVGlfFgsM464YV4dfl87tccVxpKakbCNzZcGBXjk7S1UMk8
         8F5wGjJr7qOdiWYYQJYHKWmCMmvmfh5zPRZqzpLI/RCMBreqE3htETqMlDkPEFukDQ1y
         IpulM2fqI+JcatW9Rq7JdZRvSQt9ywZ1X/LKbE8rccnYQql2RqmIUqbBVKBs6dF6sapj
         q9AXObH5zMCJ4cWIX0ix3Wssm8wh1Bfzv3TaB5w64RJ2ivVyUPTiARvXX8XXkycwOjKB
         mBVcyJtKG8lDo8xKdWag3XW3ZlV+MmqPeZ0PQqehbpdV55ee6J/CSD0GCl8CKLyHNSe3
         yGnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U6vape/K9pnaJlDnSHi71/S2eew2s8oAgi2GcuyJr7w=;
        b=JciUj5+/ON/yuKfOajswJ4FyFs2QaD14Zs7vPhHPun8nb72Ty5nCXFagAra9i0j7uk
         gnq7iXFVSZtkP0A2SaekEyAeR3Jkz/FYeOnyiH0oC4IyXN8CDGsvigsM0Jyf7NU6vy0c
         G40CBWdmBA8foB/JN8CscQXvjs8UcKHF+FK8KEmBucDT2qS11mWEOsD6GkPVwbBBV4T1
         dS+lpovkejrtvVrdew3HwVSRgAELOlkIcfYc+Rp+iDWvOhQheSj51zeat9cJDUHHjXYi
         6HE5swC9Spvcsba98aczt6JXo/aJV240sI+kXEwWysSlGe5VArOu9ErMD2c4+gURfK85
         riFw==
X-Gm-Message-State: ANoB5plFBcBP0J5/1ncBVQez3b1Lkrnq59rI8FYeiazfEbn5KtugD0HW
        F5wVloKdH5Y90rZhwSi2Y5c=
X-Google-Smtp-Source: AA0mqf6Mu47uRmTadCwmCNfwLaGp88C+FUnqUC1x8ZdL/mptD2Q2Fe0vtaYqIKOLcAWmOzKxnykJ1w==
X-Received: by 2002:a05:600c:4e01:b0:3d2:3b8d:21e5 with SMTP id b1-20020a05600c4e0100b003d23b8d21e5mr8230872wmq.14.1671196528998;
        Fri, 16 Dec 2022 05:15:28 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id y21-20020a1c4b15000000b003d1b4d957aasm2556229wma.36.2022.12.16.05.15.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 05:15:28 -0800 (PST)
Date:   Fri, 16 Dec 2022 13:15:27 +0000
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 6.0 00/16] 6.0.14-rc1 review
Message-ID: <Y5xvb4JB4ceOZdCQ@debian>
References: <20221215172908.162858817@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221215172908.162858817@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Thu, Dec 15, 2022 at 07:10:44PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.14 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Dec 2022 17:28:57 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20221127):
mips: 52 configs -> no failure
arm: 100 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
csky allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/2364
[2]. https://openqa.qa.codethink.co.uk/tests/2368
[3]. https://openqa.qa.codethink.co.uk/tests/2367

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
