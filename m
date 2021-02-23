Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4FF3225F6
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 07:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231490AbhBWGc6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 01:32:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231582AbhBWGcr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Feb 2021 01:32:47 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 316B1C061574;
        Mon, 22 Feb 2021 22:32:07 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id m188so15370219yba.13;
        Mon, 22 Feb 2021 22:32:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DPPscTRk33SoDLbqxxX5n926bhjPDJW+amwIenmHvyA=;
        b=K/Wu4dqAMv7OubSmBWaPVPpEuDqYmqHJxLChgnVAjNpm2x7Ms8kdYTQfTbz5OG1W0n
         lRilE+wdSaGYP4lEL3fXl8FXgZLF25UAT2+lhynrohfX1YwhG6BtP7iod550Pha4Lr/e
         AqkS7wB92WJ26CSwn1JNTx6BIvbMODIcdAt7cFlUGf3QWIlrLZaUfkLqK8U9Toh6Cyv7
         /OPqCkauf1rsMpe3eVcZWfGFq/oEgm30t5Z/cjRNY+ys0zcklPgw9+Q4Sbx7CNNS7zkT
         qcouQY4U3fUeaTb9TCh62gejrzAfqfJuauZ3TmQHwhSsviA6kK9Fih6wXXdjL/ZdPC0A
         I/OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DPPscTRk33SoDLbqxxX5n926bhjPDJW+amwIenmHvyA=;
        b=RWqJfBK91MGQdCCcYfQpd6EECmwGjbU572uKTXRIM4zkphVfoamFvUQKIN/aWMBjOf
         JhDTTrGbjV9spU6+wA6DcpgWxNfnL9Tz+kYJ+kHAtQcCXL02r3n/gJQm2gsxEPZ/Cefz
         VX9+JyWmCuJRclynF2KozDn4WNUMMOTakS7xzxCF2kBQZ8WTm9eLdhlQwDE6xgXpoqhi
         qi5dtGk2aigeqch3DRGVhOaQVrjTyQ0LPo3AVjzOgcRz5mmDwtPSim7fsVkCKkPixI4k
         wZjfv8+fM9RqOOnRudez+vc8DIAQ6iFTqZy0E3spzUvErvQWRW6nZkyLrQXbNtp0b6ql
         vTGA==
X-Gm-Message-State: AOAM531n4xkajFEXXdykZ5ZBAQxd2kPUhlKX7DnkNyLD2wLUOvErb6jD
        b3hwxmo1GLnS54vLiX08NHPbeziMGuk4mDxD1Yt0TUsnims=
X-Google-Smtp-Source: ABdhPJxI7yg/dvu5J2zWZclsj5rUafi3AkfCZSlub/B+OgDLZ9zXTLvBEwpONYIlTzFzNJMR8k36cGKzO2Ddt1RRocQ=
X-Received: by 2002:a25:abb2:: with SMTP id v47mr37404236ybi.425.1614061926389;
 Mon, 22 Feb 2021 22:32:06 -0800 (PST)
MIME-Version: 1.0
References: <20210223012001.1452676-1-jetswayss@gmail.com>
In-Reply-To: <20210223012001.1452676-1-jetswayss@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 22 Feb 2021 22:31:55 -0800
Message-ID: <CAEf4BzZ_UkGGjRCa6js9J8kDgXkK+Fi91rRQ7U4Hy0t01aovOA@mail.gmail.com>
Subject: Re: [PATCH] tools/resolve_btfids: Fix build error with older host toolchains
To:     Kun-Chuan Hsieh <jetswayss@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 22, 2021 at 5:20 PM Kun-Chuan Hsieh <jetswayss@gmail.com> wrote:
>
> Older versions of libelf cannot recognize the compressed section.
> However, it's only required to fix the compressed section info when
> compiling with CONFIG_DEBUG_INFO_COMPRESSED flag is set.

Is it possible to detect (at compilation time or at run time) if
libelf supports compressed ELF sections instead?

>
> Only compile the compressed_section_fix function when necessary will make
> it easier to enable the BTF function. Since the tool resolve_btfids is
> compiled with host toolchain. The host toolchain might be older than the
> cross compile toolchain.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Kun-Chuan Hsieh <jetswayss@gmail.com>
> ---
>  tools/bpf/resolve_btfids/main.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/tools/bpf/resolve_btfids/main.c b/tools/bpf/resolve_btfids/main.c
> index 7409d7860aa6..ad40346c6631 100644
> --- a/tools/bpf/resolve_btfids/main.c
> +++ b/tools/bpf/resolve_btfids/main.c
> @@ -260,6 +260,7 @@ static struct btf_id *add_symbol(struct rb_root *root, char *name, size_t size)
>         return btf_id__add(root, id, false);
>  }
>
> +#ifdef CONFIG_DEBUG_INFO_COMPRESSED
>  /*
>   * The data of compressed section should be aligned to 4
>   * (for 32bit) or 8 (for 64 bit) bytes. The binutils ld
> @@ -292,6 +293,7 @@ static int compressed_section_fix(Elf *elf, Elf_Scn *scn, GElf_Shdr *sh)
>         }
>         return 0;
>  }
> +#endif
>
>  static int elf_collect(struct object *obj)
>  {
> @@ -370,8 +372,10 @@ static int elf_collect(struct object *obj)
>                         obj->efile.idlist_addr  = sh.sh_addr;
>                 }
>
> +#ifdef CONFIG_DEBUG_INFO_COMPRESSED
>                 if (compressed_section_fix(elf, scn, &sh))
>                         return -1;
> +#endif
>         }
>
>         return 0;
> --
> 2.25.1
>
