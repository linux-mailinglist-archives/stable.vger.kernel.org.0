Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 901D5A0902
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 19:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbfH1Rx1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 13:53:27 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34452 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbfH1Rx1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Aug 2019 13:53:27 -0400
Received: by mail-wr1-f65.google.com with SMTP id s18so727662wrn.1;
        Wed, 28 Aug 2019 10:53:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ctwr+81XjxtZjBI+RKeebPhdkGvaIWpze3WikDHHYro=;
        b=gkbV6uEU80/diE3++JDNmX1wcMIg3kYn/u9jPDs8Lhf5QPmsb5N6z0ooqMV3C+kpM8
         8FtT53NgimT5aZUXjLp1BwSgHcC7Q2cHRXkXYjV0j8NKoNsI0tGqWcE7eQJMoShNIjJ8
         LDFsg7n9maVJZnMFor0FW0veP3QDr/0xKq0qRPSBoFp2W5UnMs1SyKUHGYiAhP1HNXxk
         c94GVISeezBd/TmOpNFCv9Jgye3BlaMNBceUSmyYvBWlKxVHsoi11aRaRosRvWM4tDnV
         hE5x8uQ/TyqHmLMw2a4ULrvqtKy4zkP2WzHNAThRIeZ3/7fQx12SVS0jzSK8V8XRC0yK
         B0xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ctwr+81XjxtZjBI+RKeebPhdkGvaIWpze3WikDHHYro=;
        b=Sog6KFf8vABo9Wwv8TT7rOwo2P8q60hgL+IhhJH7dcNXYwLCs100l2dLTxCSHVJTRi
         iKA+gHT+0dz+eZ+8uydy50WPO+YmtR4cFTIIA05h4OH3BFdzrdzMM3P7hqlmDwGUW2X8
         j49lZb9L57kFLE+mBTFi0z1qyMUV8i37XOvTGAkThaX2U34l9FD6vUB8BggXLs+cCvbM
         klFqrso/++27NaLhw6FanHdljU4sg9s90ldpPips4LbJKZbZdNMKYF2UUl8bAjrfP564
         Lo8+/l2afzCQhtROjmNR02NeAQvEwl7EVxvqa8pXFTQB4hMZslXLivZGOV/SEeKEeYpp
         HzSQ==
X-Gm-Message-State: APjAAAWWK6iCETtTxNNzPATLaXVXfBMH4XCIkvb+40ORiDJS320mcmen
        HjQ5ojfUK/Nnkg1HYdOofh8=
X-Google-Smtp-Source: APXvYqxvNmDaH1yjem5r4S/83Vg1D2RbeIF+UfqytUPsvepRWyCtZKp6p6ALBQ0zWevb7HBr1Ivsog==
X-Received: by 2002:adf:c803:: with SMTP id d3mr6529921wrh.130.1567014804807;
        Wed, 28 Aug 2019 10:53:24 -0700 (PDT)
Received: from archlinux-threadripper ([2a01:4f8:222:2f1b::2])
        by smtp.gmail.com with ESMTPSA id w8sm10456031wmc.1.2019.08.28.10.53.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 10:53:23 -0700 (PDT)
Date:   Wed, 28 Aug 2019 10:53:22 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com, stable@vger.kernel.org
Subject: Re: [PATCH] powerpc: Avoid clang warnings around setjmp and longjmp
Message-ID: <20190828175322.GA121833@archlinux-threadripper>
References: <20190812023214.107817-1-natechancellor@gmail.com>
 <878srdv206.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878srdv206.fsf@mpe.ellerman.id.au>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 28, 2019 at 11:43:53PM +1000, Michael Ellerman wrote:
> Nathan Chancellor <natechancellor@gmail.com> writes:
> 
> > Commit aea447141c7e ("powerpc: Disable -Wbuiltin-requires-header when
> > setjmp is used") disabled -Wbuiltin-requires-header because of a warning
> > about the setjmp and longjmp declarations.
> >
> > r367387 in clang added another diagnostic around this, complaining that
> > there is no jmp_buf declaration.
> >
> > In file included from ../arch/powerpc/xmon/xmon.c:47:
> > ../arch/powerpc/include/asm/setjmp.h:10:13: error: declaration of
> > built-in function 'setjmp' requires the declaration of the 'jmp_buf'
> > type, commonly provided in the header <setjmp.h>.
> > [-Werror,-Wincomplete-setjmp-declaration]
> > extern long setjmp(long *);
> >             ^
> > ../arch/powerpc/include/asm/setjmp.h:11:13: error: declaration of
> > built-in function 'longjmp' requires the declaration of the 'jmp_buf'
> > type, commonly provided in the header <setjmp.h>.
> > [-Werror,-Wincomplete-setjmp-declaration]
> > extern void longjmp(long *, long);
> >             ^
> > 2 errors generated.
> >
> > Take the same approach as the above commit by disabling the warning for
> > the same reason, we provide our own longjmp/setjmp function.
> >
> > Cc: stable@vger.kernel.org # 4.19+
> > Link: https://github.com/ClangBuiltLinux/linux/issues/625
> > Link: https://github.com/llvm/llvm-project/commit/3be25e79477db2d31ac46493d97eca8c20592b07
> > Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> > ---
> >
> > It may be worth using -fno-builtin-setjmp and -fno-builtin-longjmp
> > instead as it makes it clear to clang that we are not using the builtin
> > longjmp and setjmp functions, which I think is why these warnings are
> > appearing (at least according to the commit that introduced this waring).
> >
> > Sample patch:
> > https://github.com/ClangBuiltLinux/linux/issues/625#issuecomment-519251372
> 
> Couldn't we just add those flags to CFLAGS for the whole kernel? Rather
> than making them per-file.

Yes, I don't think this would be unreasonable. Are you referring to the
cc-disable-warning flags or the -fno-builtin flags? I personally think
the -fno-builtin flags convey to clang what the kernel is intending to
do better than disabling the warnings outright.

> I mean there's no kernel code that wants to use clang's builtin
> setjmp/longjmp implementation at all right?
> 
> cheers

I did a quick search of the tree and it looks like powerpc and x86/um
are the only architectures that do anything with setjmp/longjmp. x86/um
avoids this by using a define flag to change setjmp to kernel_setjmp:

arch/um/Makefile: -Dlongjmp=kernel_longjmp -Dsetjmp=kernel_setjmp \

Seems like adding those flags should be safe.

Cheers,
Nathan
