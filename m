Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9848A1F9D1
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 20:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbfEOSTO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 14:19:14 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:44472 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726084AbfEOSTN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 May 2019 14:19:13 -0400
Received: by mail-ed1-f67.google.com with SMTP id b8so1095417edm.11;
        Wed, 15 May 2019 11:19:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9TWMti7NJpoLAEiRwBpvcDer84lXGy6dP+2DegkgGow=;
        b=AO7+pprhouIpEekDN5tMTpywAEPc2JKYzV5/PN2BJIA/AE3dc8gHaAySYb+sFvYbjP
         baPICz2y6MfsqtunleCeoED20nclGyOG6Qh3Csod2VDk2M0uVDZy2ClStZL5vmfGQmzE
         mskOFCBz0WyKRIjgacYNNQSff/76/M+nZbFZSN7ZqCmA/mwvOXaR0/x4gmrKiqKpT2y8
         YI7zphf3QZHgyE5eKqFH++5iioOvDJEvwhjh+oPxgBUQmR+8q7Xm/bGCCyJoJiCPyRY8
         2zNqT0k5xTRbf+IkDHqFd3b3gDcAM7yeqUPKyNLBavLDx12kwldXLz1ceTdyfgBZlkiD
         Kkgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9TWMti7NJpoLAEiRwBpvcDer84lXGy6dP+2DegkgGow=;
        b=lYrvjY+a4S/9Cvv5IVI/Deg3CvWc4jXdZjv2eOl27e7V5+Dk8mzdvCylWrLImfOfeU
         1+npXHbDR/3+Y0JHik/g39femGXmyxhLC3sfH2N+vcq6IkZhwWFvUCy0gUuvLaXDMSo/
         L1Plp7k1QSRetyb3AEY/ANFK7PRWLRpVxWtDD45hSRv9c/b/OqR60InJCO2+jqbFFZ8r
         84mh0h2WGPaKyAlvzb5eXP4YDGB8vDLeqN1CwxOSyRQ+y7E4mvvp9TylpsfjbnTB8ehZ
         crE/0c6csECOkaRvR6+cnr9jQrLwF+ouuhrDJglO5a/9ubdS9SuFiBgjZGjAo5FdTr/K
         2tTg==
X-Gm-Message-State: APjAAAUoxLw3fizsQpVvTHZa2AXleW3C+ym2k49sLlyXCdlYpb01qOb6
        T/F+zwduIrbsVXopXSDjcHk=
X-Google-Smtp-Source: APXvYqwoO3d/5w5yxfxsUqNvRKItY7BFH8mZNqjnKMOv59W2BJl6/dTJAoXSgcNv8DgMMIS52CDRnw==
X-Received: by 2002:a17:906:d1da:: with SMTP id bs26mr34803987ejb.149.1557944351776;
        Wed, 15 May 2019 11:19:11 -0700 (PDT)
Received: from archlinux-i9 ([2a01:4f9:2b:2b84::2])
        by smtp.gmail.com with ESMTPSA id w54sm1048961edw.40.2019.05.15.11.19.10
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 15 May 2019 11:19:11 -0700 (PDT)
Date:   Wed, 15 May 2019 11:19:09 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     gregkh@linuxfoundation.org, clang-built-linux@googlegroups.com,
        stable@vger.kernel.org, Nathan Chancellor <nathanchance@gmail.com>,
        Alan Modra <amodra@gmail.com>,
        Jordan Rupprect <rupprecht@google.com>,
        Kees Cook <keescook@chromium.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] lkdtm: support llvm-objcopy
Message-ID: <20190515181909.GA11401@archlinux-i9>
References: <CAKwvOdk_KmyT4yZOz8iczxeP7mYq-h5LmjzkE5yhsodupRLxEQ@mail.gmail.com>
 <20190515181204.20859-1-ndesaulniers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190515181204.20859-1-ndesaulniers@google.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 15, 2019 at 11:12:04AM -0700, 'Nick Desaulniers' via Clang Built Linux wrote:
> With CONFIG_LKDTM=y and make OBJCOPY=llvm-objcopy, llvm-objcopy errors:
> llvm-objcopy: error: --set-section-flags=.text conflicts with
> --rename-section=.text=.rodata
> 
> Rather than support setting flags then renaming sections vs renaming
> then setting flags, it's simpler to just change both at the same time
> via --rename-section. Adding the load flag is required for GNU objcopy
> to mark .rodata Type as PROGBITS after the rename.
> 
> This can be verified with:
> $ readelf -S drivers/misc/lkdtm/rodata_objcopy.o
> ...
> Section Headers:
>   [Nr] Name              Type             Address           Offset
>        Size              EntSize          Flags  Link  Info  Align
> ...
>   [ 1] .rodata           PROGBITS         0000000000000000  00000040
>        0000000000000004  0000000000000000   A       0     0     4
> ...
> 
> Which shows that .text is now renamed .rodata, the alloc flag A is set,
> the type is PROGBITS, and the section is not flagged as writeable W.
> 
> Cc: stable@vger.kernel.org
> Link: https://sourceware.org/bugzilla/show_bug.cgi?id=24554
> Link: https://github.com/ClangBuiltLinux/linux/issues/448
> Reported-by: Nathan Chancellor <nathanchance@gmail.com>

Doesn't look like this got updated. I don't want to make you send a v3
just for that though since it's purely cosmetic and adding my tag below
will ensure I get copied on any backports and such.

> Suggested-by: Alan Modra <amodra@gmail.com>
> Suggested-by: Jordan Rupprect <rupprecht@google.com>
> Suggested-by: Kees Cook <keescook@chromium.org>
> Acked-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>

Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>

> ---
> Changes from v1 -> v2:
> * add load flag, as per Kees and Alan.
> * update commit message to mention reason for load flag.
> * add Kees' and Alan's suggested by.
> * carry Kees' Ack.
> * cc stable.
> 
>  drivers/misc/lkdtm/Makefile | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/misc/lkdtm/Makefile b/drivers/misc/lkdtm/Makefile
> index 951c984de61a..fb10eafe9bde 100644
> --- a/drivers/misc/lkdtm/Makefile
> +++ b/drivers/misc/lkdtm/Makefile
> @@ -15,8 +15,7 @@ KCOV_INSTRUMENT_rodata.o	:= n
>  
>  OBJCOPYFLAGS :=
>  OBJCOPYFLAGS_rodata_objcopy.o	:= \
> -			--set-section-flags .text=alloc,readonly \
> -			--rename-section .text=.rodata
> +			--rename-section .text=.rodata,alloc,readonly,load
>  targets += rodata.o rodata_objcopy.o
>  $(obj)/rodata_objcopy.o: $(obj)/rodata.o FORCE
>  	$(call if_changed,objcopy)
> -- 
> 2.21.0.1020.gf2820cf01a-goog
> 
