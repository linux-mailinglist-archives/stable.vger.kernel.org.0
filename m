Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35B9C19630C
	for <lists+stable@lfdr.de>; Sat, 28 Mar 2020 03:15:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbgC1CPW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Mar 2020 22:15:22 -0400
Received: from mail-il1-f195.google.com ([209.85.166.195]:41577 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726225AbgC1CPW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Mar 2020 22:15:22 -0400
Received: by mail-il1-f195.google.com with SMTP id t6so7039839ilj.8;
        Fri, 27 Mar 2020 19:15:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8NLaXs1x53Gpt69OjCAT0PST4jBvOMzZ0ezBjlwS/+E=;
        b=DFghnsHViTgJ9RL7jMFforLYX0+RowmIiQVdwcFajuJdt/5ExEC5/37isR1jovsz4q
         sRotz1R3zFO5t54FKvpZ3B4pYc/TcyvWe9O8uHUFDqOU3B+mBG9fxfIqKlGiTHbCaRHK
         ZjwkMr/LMYN76kB74RUEKs1MfnkUMriP9306IDGCnLe9yZdTrYys14uOew7s1hQbanJD
         oN4s55atQFFTqompck0UPETIpdmStJTeMvjQIbi29hz1Q30EvNYpjEbh6KpKpasqkUgO
         e9ef/zX2fR81MvOXr6s23Ge8TFXxjGMFd1hO+AjKHiRMPnimP81DVGvtJFEWLUhQEc10
         rRbQ==
X-Gm-Message-State: ANhLgQ1xlNVQuUfZ4C8D3B4VdaUKXxSH3ke0J5goSCgM7Zihko7mry9Z
        NJ8Ux4KJb7XbMW1GrDE0adCmMP2E083aUW1QYoo=
X-Google-Smtp-Source: ADFU+vsVcyTNByy/XEUldC3+4+I9377tEMzAOpSrVXzyOQpcXiEQEJK0O1fiCNoJAUxf73P2M+cpSy88hsh2XYGxPHc=
X-Received: by 2002:a92:8510:: with SMTP id f16mr2068838ilh.208.1585361722101;
 Fri, 27 Mar 2020 19:15:22 -0700 (PDT)
MIME-Version: 1.0
References: <1585107894-8803-1-git-send-email-chenhc@lemote.com> <20200327150336.7953F20748@mail.kernel.org>
In-Reply-To: <20200327150336.7953F20748@mail.kernel.org>
From:   Huacai Chen <chenhc@lemote.com>
Date:   Sat, 28 Mar 2020 10:22:09 +0800
Message-ID: <CAAhV-H5MS0sX5eov49ed-0mjsR72BdMc7o8L24uP1qHdGwRzEQ@mail.gmail.com>
Subject: Re: [PATCH] MIPS/tlbex: Fix LDDIR usage in setup_pw() for Loongson-3
To:     Sasha Levin <sashal@kernel.org>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        Fuxin Zhang <zhangfx@lemote.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Sasha,

For 4.9 and 4.14 please backport b023a9396062 ("MIPS: Avoid using
array as parameter to write_c0_kpgd()"). And for 4.4 please just
ignore this patch.

Regards,
Huacai

On Fri, Mar 27, 2020 at 11:03 PM Sasha Levin <sashal@kernel.org> wrote:
>
> Hi
>
> [This is an automated email]
>
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
>
> The bot has tested the following trees: v5.5.11, v5.4.27, v4.19.112, v4.14.174, v4.9.217, v4.4.217.
>
> v5.5.11: Build OK!
> v5.4.27: Build OK!
> v4.19.112: Build OK!
> v4.14.174: Failed to apply! Possible dependencies:
>     b023a9396062 ("MIPS: Avoid using array as parameter to write_c0_kpgd()")
>
> v4.9.217: Failed to apply! Possible dependencies:
>     b023a9396062 ("MIPS: Avoid using array as parameter to write_c0_kpgd()")
>
> v4.4.217: Failed to apply! Possible dependencies:
>     0c94fa33b4de ("MIPS: cpu: Convert MIPS_CPU_* defs to (1ull << x)")
>     380cd582c088 ("MIPS: Loongson-3: Fast TLB refill handler")
>     5fa393c85719 ("MIPS: Break down cacheops.h definitions")
>     9519ef37a4a4 ("MIPS: Define the legacy-NaN and 2008-NaN features")
>     b023a9396062 ("MIPS: Avoid using array as parameter to write_c0_kpgd()")
>     b2edcfc81401 ("MIPS: Loongson: Add Loongson-3A R2 basic support")
>     c0291f7c7359 ("MIPS: cpu: Alter MIPS_CPU_* definitions to fill gap")
>     f270d881fa55 ("MIPS: Detect MIPSr6 Virtual Processor support")
>
>
> NOTE: The patch will not be queued to stable trees until it is upstream.
>
> How should we proceed with this patch?
>
> --
> Thanks
> Sasha
