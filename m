Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4D32F85CF
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 20:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730047AbhAOT4P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 14:56:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726970AbhAOT4O (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 14:56:14 -0500
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5118C0613C1;
        Fri, 15 Jan 2021 11:55:33 -0800 (PST)
Received: by mail-qt1-x829.google.com with SMTP id z20so6920606qtq.3;
        Fri, 15 Jan 2021 11:55:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IGs2HkGiaxO0w74PW3RRJejo5AsHL0mLZAB29K0969g=;
        b=NVa21p5g1DiYyhwL0/547ZzJOdy0nx8VxQE/C8A50Ogs1TeZYYvCM22N96jXQ2CpgV
         /dl7/WLWSLQ0GeV3L9LojLF7EVCveCMY15HGDXnmMsOYiI8vJpNuJc9suZHByZVv9V9m
         L4+QEYfxKdKu6iHqL4742ikdbAyRMTO4tK8sPCpxNLKwAMC89U4VpR6BkjLhQGu9+xOY
         jrkTpUuHRhd0NAQeqvhXWOYGw6DnugyEhvpP/cehl5GESA6kM79rCuJ1B9qsz/0WNaxX
         CoPlrcmHRFFvKDs2bWv9gHBMGT34JmhRocw/vDTr2euEIxCYL0INNWnm5+LLHCoPIGAR
         0x5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IGs2HkGiaxO0w74PW3RRJejo5AsHL0mLZAB29K0969g=;
        b=UgkBLkXWX2RhZ3ojHadL4V8bnwNBR8yHsCl1hMFLOge1DTNu8UfMmrrh6S5PiVOF6/
         QFIXI3cdJBYJHJABwXR4q3FHZeLpeCnpHOf3012ZuETvnBEGA7Yop3Xbssv4nUBQkWcY
         P9qksIoCrm5oYVApSeGXcQ/TWJcwQaT2lAbpFNY2FDgHzBwH/+odQbA0HZ/YPR8OAdt2
         OVjZMV//eg9Ja6RvKjQMm9I5C4/qJ4Kx6CxI5+Aj0iFRp8LcA5Fy6AHcqMOx+ghOzmwP
         H2o+qZDRmJxynBGlnZHjML5JktQc1OdYia1ZJPDx6FlVejw+AFT588LhrngBeQULnIGT
         GSpA==
X-Gm-Message-State: AOAM533Qp8bgDj885wi4uhLf7qQz2EKbf4P+PXqPM7HHRww23MI5mO3x
        XaKiVJJRXqFvzWlNTqnJlFHg3tzP2z4=
X-Google-Smtp-Source: ABdhPJzlcqg0ByCj56goYvg+A0tTero/MfIfcJ7PhDPNspgtPvpTBEbIzy0FLRavdmtH5XstDS3HEQ==
X-Received: by 2002:ac8:c2:: with SMTP id d2mr13697639qtg.207.1610740532868;
        Fri, 15 Jan 2021 11:55:32 -0800 (PST)
Received: from ubuntu-m3-large-x86 ([2604:1380:45f1:1d00::1])
        by smtp.gmail.com with ESMTPSA id q6sm5673360qkd.41.2021.01.15.11.55.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 11:55:32 -0800 (PST)
Date:   Fri, 15 Jan 2021 12:55:30 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Fangrui Song <maskray@google.com>
Cc:     linux-kernel@vger.kernel.org, Jessica Yu <jeyu@kernel.org>,
        clang-built-linux@googlegroups.com,
        Sam Ravnborg <sam@ravnborg.org>,
        Marco Elver <elver@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] module: Ignore _GLOBAL_OFFSET_TABLE_ when warning for
 undefined symbols
Message-ID: <20210115195530.GA3843886@ubuntu-m3-large-x86>
References: <20210114211840.GA5617@linux-8ccs>
 <20210115195222.3453262-1-maskray@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210115195222.3453262-1-maskray@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 15, 2021 at 11:52:22AM -0800, 'Fangrui Song' via Clang Built Linux wrote:
> clang-12 -fno-pic (since
> https://github.com/llvm/llvm-project/commit/a084c0388e2a59b9556f2de0083333232da3f1d6)
> can emit `call __stack_chk_fail@PLT` instead of `call __stack_chk_fail`
> on x86.  The two forms should have identical behaviors on x86-64 but the
> former causes GNU as<2.37 to produce an unreferenced undefined symbol
> _GLOBAL_OFFSET_TABLE_.
> 
> (On x86-32, there is an R_386_PC32 vs R_386_PLT32 difference but the
> linker behavior is identical as far as Linux kernel is concerned.)
> 
> Simply ignore _GLOBAL_OFFSET_TABLE_ for now, like what
> scripts/mod/modpost.c:ignore_undef_symbol does. This also fixes the
> problem for gcc/clang -fpie and -fpic, which may emit `call foo@PLT` for
> external function calls on x86.
> 
> Note: ld -z defs and dynamic loaders do not error for unreferenced
> undefined symbols so the module loader is reading too much.  If we ever
> need to ignore more symbols, the code should be refactored to ignore
> unreferenced symbols.
> 
> Reported-by: Marco Elver <elver@google.com>
> Link: https://github.com/ClangBuiltLinux/linux/issues/1250
> Signed-off-by: Fangrui Song <maskray@google.com>
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
> Tested-by: Marco Elver <elver@google.com>
> Cc: <stable@vger.kernel.org>

Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>

> 
> ---
> Changes in v2:
> * Fix Marco's email address
> * Add a function ignore_undef_symbol similar to scripts/mod/modpost.c:ignore_undef_symbol
> ---
> Changes in v3:
> * Fix the style of a multi-line comment.
> * Use static bool ignore_undef_symbol.
> ---
>  kernel/module.c | 21 +++++++++++++++++++--
>  1 file changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/module.c b/kernel/module.c
> index 4bf30e4b3eaa..805c49d1b86d 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -2348,6 +2348,21 @@ static int verify_exported_symbols(struct module *mod)
>  	return 0;
>  }
>  
> +static bool ignore_undef_symbol(Elf_Half emachine, const char *name)
> +{
> +	/*
> +	 * On x86, PIC code and Clang non-PIC code may have call foo@PLT. GNU as
> +	 * before 2.37 produces an unreferenced _GLOBAL_OFFSET_TABLE_ on x86-64.
> +	 * i386 has a similar problem but may not deserve a fix.
> +	 *
> +	 * If we ever have to ignore many symbols, consider refactoring the code to
> +	 * only warn if referenced by a relocation.
> +	 */
> +	if (emachine == EM_386 || emachine == EM_X86_64)
> +		return !strcmp(name, "_GLOBAL_OFFSET_TABLE_");
> +	return false;
> +}
> +
>  /* Change all symbols so that st_value encodes the pointer directly. */
>  static int simplify_symbols(struct module *mod, const struct load_info *info)
>  {
> @@ -2395,8 +2410,10 @@ static int simplify_symbols(struct module *mod, const struct load_info *info)
>  				break;
>  			}
>  
> -			/* Ok if weak.  */
> -			if (!ksym && ELF_ST_BIND(sym[i].st_info) == STB_WEAK)
> +			/* Ok if weak or ignored.  */
> +			if (!ksym &&
> +			    (ELF_ST_BIND(sym[i].st_info) == STB_WEAK ||
> +			     ignore_undef_symbol(info->hdr->e_machine, name)))
>  				break;
>  
>  			ret = PTR_ERR(ksym) ?: -ENOENT;
> -- 
> 2.30.0.296.g2bfb1c46d8-goog
> 
> -- 
> You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/20210115195222.3453262-1-maskray%40google.com.
