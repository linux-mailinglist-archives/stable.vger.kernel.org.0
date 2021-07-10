Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 146973C36A6
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 21:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbhGJUAQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 16:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbhGJUAP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Jul 2021 16:00:15 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 438B9C0613DD;
        Sat, 10 Jul 2021 12:57:30 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id f12-20020a056830204cb029048bcf4c6bd9so13484075otp.8;
        Sat, 10 Jul 2021 12:57:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oSOVOygqjYTevr4ykHDxhRLH78rrn5KYQej/Is2G47A=;
        b=Q9/JR4t7W3g4E2KTTF9KFi9u4UAWY4wLD6y+A2rkozlmvq2/cIoicPEydm3EZcr+z0
         LJasaQ1EdxwvUEY6lmvL/pW04rtENcGap6B0ZZ7tiJ2M0iGDQ9rfF/kUk9mLpg7c7hC7
         KCzZXlZgmRlWHLnk78O/p8Io81LpMTIgClJKQqnL6CY5RLj14RRvPt9/Og9M6OwiwfG8
         UlxcTd7GiWl4wPifhlcDNF9z6u8QN8VvRPOvBvgih6AKE5U2B69zUgVnidOucOUsOsNQ
         HMgUCxat3ziySVafA4k3SjQ4AhhuMBwAa3zOldA89MqmloJHNIFgCOuEz1yGzGDlfnhL
         JtKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=oSOVOygqjYTevr4ykHDxhRLH78rrn5KYQej/Is2G47A=;
        b=NKCMSUwAVh9VlDDzERS6v7wTC52D7+3/i4mxCuJK7sd2s5zJuCZzhdtxufIfjc+Y77
         sgQ9Fiz9WyrK8vafxvFHILJhyvvLNqXN9PmqsxWExW2YCyhaRFAKhX2/pwQVW043ToHX
         uA+jaaKkzRwDjL34xgCXOAgrOQF6BsAItt4OZHqrobW+/EatkEFgXfSC5gNwNT470fyZ
         Nxre6lx7qqrYfh38l9vXhagjZsrviQAbq834JJdo3Sy22B4cLhzXV/Q7m3mWmKPR0+Ts
         Y/fgwsp99Qi1jC34O7Urwku5ijc/ZpWgLRO+rY7V3SMlC+MO8tQZgTnGiclTjyFd+b4Q
         1SKQ==
X-Gm-Message-State: AOAM530qF0bHMwNMvb0wgcbBpOpNqXu/KOFQkoqpG4f74FxlNY+D39pq
        eCUk2YIZ775UrBAIaYIJirs=
X-Google-Smtp-Source: ABdhPJwRjIDuLBuMfNjdZ3in8IFmov1hdlpQHpnY1FP7ioQiUvBtx7vdILkYz85A4wHNs9WTw5P7MA==
X-Received: by 2002:a9d:6484:: with SMTP id g4mr33758054otl.331.1625947049431;
        Sat, 10 Jul 2021 12:57:29 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j22sm1983458otl.46.2021.07.10.12.57.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Jul 2021 12:57:29 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 10 Jul 2021 12:57:27 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.12 00/11] 5.12.16-rc1 review
Message-ID: <20210710195727.GG2105551@roeck-us.net>
References: <20210709131549.679160341@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210709131549.679160341@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 09, 2021 at 03:21:37PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.16 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 11 Jul 2021 13:14:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 152 fail: 2
Failed builds:
	riscv32:allmodconfig
	riscv:allmodconfig
Qemu test results:
	total: 462 pass: 462 fail: 0

Build failure:

cc1: error: '8944' is not a valid offset in '-mstack-protector-guard-offset='
make[2]: *** [scripts/Makefile.build:271: init/main.o] Error 1

The build failure is not new and seen since v5.12 (including mainline).
It happens if both STACKPROTECTOR_PER_TASK and GCC_PLUGIN_RANDSTRUCT
are enabled at the same time (previously I had disabled
GCC_PLUGIN_RANDSTRUCT in all of my my test builds). See
https://patchwork.kernel.org/project/linux-riscv/patch/20210706162621.940924-1-linux@roeck-us.net/
for details.

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
