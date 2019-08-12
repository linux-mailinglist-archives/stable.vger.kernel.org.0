Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0A8C8A3D2
	for <lists+stable@lfdr.de>; Mon, 12 Aug 2019 18:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725901AbfHLQzY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Aug 2019 12:55:24 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44291 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbfHLQzX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Aug 2019 12:55:23 -0400
Received: by mail-wr1-f67.google.com with SMTP id p17so105175095wrf.11;
        Mon, 12 Aug 2019 09:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=vj44gRBy7Pko0QV87SnpU0f39eDYWrx4v822lLczJLI=;
        b=pIOzlK+o9g7e3tz8hpTfcDLXZ7vxOPpgSYA0SeHbKb4dWYJ414ih59uANJjWMgjamm
         8+KZImlw+R2OZJ+x43CCP9J4hRveALpYnlxue2s8wZXhAEIhM2wCQbj7WKXMGEh29Pkl
         01udM2V8tTcT/m9lLMt+9Z/Y+5cMnKLiLzt+N0OAwPBp+GK2tKoyVj++s0hTjMVTk7H3
         IgUx3sRatM0XBdR8ZBhxngPMsjp7JQr2ZRUCiJf/hdaarRvXfYWik5OZx8Fpl6mQdHTb
         jh6W8Ga1NcDQhN2HhLnO7Ms4OOWNkG5dm6+kk5v7WqB1SZ/AjQa62g+iuAfTsWcpvc9i
         d3ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=vj44gRBy7Pko0QV87SnpU0f39eDYWrx4v822lLczJLI=;
        b=tr036CMrm6THjsv9h4Yd4vWZ88xqEbot460zDqcT9w0wPul7xAj9cRDzNB1WiN6IJl
         yug1CpSkh2wyH0uObGVhXhrE9FFxtxQDmpNlhSUT4iOEL4Aho3hgaB11VWa76070Mntf
         ez/WRoanh6DW/EkC0fP7hOUmh0p+DKrLW5V9TsyKS5gI/zNIDE8wuvw0w+j519bcelYg
         j2v5sYcCI9gfVsH65xurHcYTSaI5XgEZnCpstCYoSoASY2jl45zoIs64NUHycxs+kH+9
         lqLQp0U8nZSDarYx4bM4/OylD4PMYBYOSOt8BG9xSeMfoRinPEk0LQpzRJxHj1eassQo
         6dbw==
X-Gm-Message-State: APjAAAXYfxZmxs/eWeMxfPsidttA1I51hEQPkBOu9gaA349ub0+yBZij
        rLKILouNRlgF5R1noMQZI5A=
X-Google-Smtp-Source: APXvYqy2GJO9WC4FkkOW9kiEqG/CZcAka5TjICcxLAsR9ZdFv0jHIy5xOownE61O3d+VSB7SIadbLg==
X-Received: by 2002:adf:eccb:: with SMTP id s11mr9793177wro.351.1565628921084;
        Mon, 12 Aug 2019 09:55:21 -0700 (PDT)
Received: from archlinux-threadripper ([2a01:4f8:222:2f1b::2])
        by smtp.gmail.com with ESMTPSA id r17sm9360182wrg.93.2019.08.12.09.55.20
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 12 Aug 2019 09:55:20 -0700 (PDT)
Date:   Mon, 12 Aug 2019 09:55:18 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Christophe Leroy <christophe.leroy@c-s.fr>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nick Desaulniers <ndesaulniers@google.com>,
        clang-built-linux@googlegroups.com, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] powerpc: Avoid clang warnings around setjmp and longjmp
Message-ID: <20190812165518.GA6994@archlinux-threadripper>
References: <20190812023214.107817-1-natechancellor@gmail.com>
 <5da5478f-9320-43bd-0f5e-430db2ee9195@c-s.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5da5478f-9320-43bd-0f5e-430db2ee9195@c-s.fr>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 12, 2019 at 07:37:51AM +0200, Christophe Leroy wrote:
> 
> 
> Le 12/08/2019 à 04:32, Nathan Chancellor a écrit :
> > Commit aea447141c7e ("powerpc: Disable -Wbuiltin-requires-header when
> > setjmp is used") disabled -Wbuiltin-requires-header because of a warning
> > about the setjmp and longjmp declarations.
> > 
> > r367387 in clang added another diagnostic around this, complaining that
> > there is no jmp_buf declaration.
> > 
> [...]
> 
> > 
> > Cc: stable@vger.kernel.org # 4.19+
> > Link: https://github.com/ClangBuiltLinux/linux/issues/625
> > Link: https://github.com/llvm/llvm-project/commit/3be25e79477db2d31ac46493d97eca8c20592b07
> > Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> > ---
> > 
> [...]
> 
> > 
> >   arch/powerpc/kernel/Makefile | 5 +++--
> >   arch/powerpc/xmon/Makefile   | 5 +++--
> 
> What about scripts/recordmcount.c and scripts/sortextable.c which contains
> calls to setjmp() and longjmp() ?
> 
> And arch/um/ ?
> 
> Christophe

Hi Christophe,

It looks like all of those will be using the system's setjmp header,
which won't cause these warnings.

Cheers,
Nathan
