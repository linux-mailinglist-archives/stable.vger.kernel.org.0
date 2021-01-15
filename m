Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6322F8568
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 20:29:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733067AbhAOT2q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 14:28:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728293AbhAOT2q (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 14:28:46 -0500
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3078EC061757;
        Fri, 15 Jan 2021 11:28:06 -0800 (PST)
Received: by mail-qk1-x72a.google.com with SMTP id p14so12795325qke.6;
        Fri, 15 Jan 2021 11:28:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6zCZrnhgRt+dBoyQ8tcWZS1tIQoo0VWZii3AgJIF8i0=;
        b=Vgj8FNW6Or7PTM4LGoU0zBghO/2JuSVuOzZYSsvhZt1xwvDuTGXfNEgsmIhMp7KZGB
         abRgydY+HCbwOzxUCpfkL3Jb16lX+8Y8M8y6R+5CDXk1cCLA3A5NLT1a85pDGC8NN29w
         fNYfH1VhgN3NvJfYDN258yEuAD67w0zl1d7ysnrwLERXtZpAZJuKNqx3RQiRvwBPSUrK
         +v1Tx2CysJW+H6+t8Bq8rp7lbb7portcg9XcIGn96NcxDjrbT+vnuWpfINEXdaELtMBN
         BDCh9nQnkUkdv2G4lTrcCl2rB7q7czzK/oti2kKkkctq492Dv84k2gfWD82p234tv9zY
         zipg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6zCZrnhgRt+dBoyQ8tcWZS1tIQoo0VWZii3AgJIF8i0=;
        b=IPyfJt2UzuxaCaUv/BbFJg0htMTGJyWH2xlgfADKr4c34sFENaUXF/X0RFP9Iifl9+
         d3AgPwTzRowbMNtmicudHrWPd8NtfNFxAcfIeLnDtFspAUsfRt0Xu2JXfteEoZpmn4SO
         gN5DMbt6FaxfUKtGg3LD+sgdvBW1zAWJMNtfDfYpXYtYq/vkEeyXyqJmZBxJaSfARzG7
         swZA8eOJTQ8e2CKtJwDkxpG3DtvtUiZy13BWkgmJ1ybvtzLgd7ud7rYAjxfHe96tgbg2
         841ysbbyjWePzoIAkieTFO/P9q+YNij96HI9I0MOdt64iJUH9M26gHWoLgP1ztTdWQ3G
         u3ZA==
X-Gm-Message-State: AOAM532zq5R5WIp5TdLX/AA/zwaGRfUid6vTELgM8YebdOordiFGvIjK
        5Ay6daj3kBgrPp5wu6sOhc4=
X-Google-Smtp-Source: ABdhPJyS+ly5PTr5BeoK/LKEkRWdF61JTsfd8029OwK5cAQS8wVGCmwJEU/IthF/tu2lg2YLTy2Jxg==
X-Received: by 2002:a37:78c4:: with SMTP id t187mr13833259qkc.139.1610738885332;
        Fri, 15 Jan 2021 11:28:05 -0800 (PST)
Received: from ubuntu-m3-large-x86 ([2604:1380:45f1:1d00::1])
        by smtp.gmail.com with ESMTPSA id v5sm5619396qkv.64.2021.01.15.11.28.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 11:28:04 -0800 (PST)
Date:   Fri, 15 Jan 2021 12:28:03 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Anders Roxell <anders.roxell@linaro.org>
Cc:     tsbogend@alpha.franken.de, ndesaulniers@google.com,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com, stable@vger.kernel.org
Subject: Re: [PATCH] mips: vdso: fix DWARF2 warning
Message-ID: <20210115192803.GA3828660@ubuntu-m3-large-x86>
References: <20210115191330.2319352-1-anders.roxell@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210115191330.2319352-1-anders.roxell@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 15, 2021 at 08:13:30PM +0100, Anders Roxell wrote:
> When building mips tinyconifg the following warning show up
> 
> make --silent --keep-going --jobs=8 O=/home/anders/src/kernel/next/out/builddir ARCH=mips CROSS_COMPILE=mips-linux-gnu- HOSTCC=clang CC=clang
> /srv/src/kernel/next/arch/mips/vdso/elf.S:14:1: warning: DWARF2 only supports one section per compilation unit
> .pushsection .note.Linux, "a",@note ; .balign 4 ; .long 2f - 1f ; .long 4484f - 3f ; .long 0 ; 1:.asciz "Linux" ; 2:.balign 4 ; 3:
> ^
> /srv/src/kernel/next/arch/mips/vdso/elf.S:34:2: warning: DWARF2 only supports one section per compilation unit
>  .section .mips_abiflags, "a"
>  ^
> 
> Rework so the mips vdso Makefile adds flag '-no-integrated-as' unless
> LLVM_IAS is defined.
> 
> Link: https://github.com/ClangBuiltLinux/linux/issues/1256
> Cc: stable@vger.kernel.org # v4.19+
> Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Anders Roxell <anders.roxell@linaro.org>

I believe this is the better solution:

https://lore.kernel.org/r/20210115192622.3828545-1-natechancellor@gmail.com/

Cheers,
Nathan
