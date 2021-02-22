Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3FF7321DA5
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 18:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231387AbhBVRAS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 12:00:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231764AbhBVQ76 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Feb 2021 11:59:58 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62A53C06178A
        for <stable@vger.kernel.org>; Mon, 22 Feb 2021 08:59:18 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id v30so6819374lfq.6
        for <stable@vger.kernel.org>; Mon, 22 Feb 2021 08:59:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FFwPkS0p5vVEhU0P2C60Ifyemgozd+s11OO/HXf3eAM=;
        b=F+p5QZtOmxteI5D2sRuw9H7ycg22heSDZlMlmk5YVb6DzmZj9iScvzX0DjzIgJXHsk
         MhNkjMKrEMb1tJkDcMq9BzSaME6u+Cex7mgYDSdyU4JbzZ1PAr+Ex7ZRA3BLMbvNlIuj
         EVGL3AfQ7KU23sOktqO3b8VNfFmtyXVXB/sMED7DIhJC7ncZK6uTwMiVDTO0CJSNESfu
         nha3UIFLTjO7acM2LEiudikLAOITbyulAJ0ngHaoQp9ewH0kLRCv/qrUskl+sjzcWWot
         fgxvhwf+Zrj2pwJ8Qx+azJkH7zIBXQYI/zDRpc0aUNWvrbihF4mDm9Rpfc69TGnPMzjZ
         6c6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FFwPkS0p5vVEhU0P2C60Ifyemgozd+s11OO/HXf3eAM=;
        b=qCakz26AJZG/Rw/kUe9HQmbRv/lFkML5BQclzCOcejw/CgwQDLg/4pyKkma0y8XtBe
         p8JElEolGtHvxcF/oi7RJZrzjZArtnmR0VRegP9VO6V/McmmwEIWEU0a8OeVvI7AvIiu
         /iJNEZsQGkCtS1iHCq44+gKQGScS2sEC8i47A2nsxlWf2cTOyTGKnpbBQwW/53HuU033
         YtHA3J9VFQgrs21VGr/4koR/CXTTyTq9dabR9IybVKl2O3onGtd3p3D1ntZME+ISxKIZ
         mCiW3Z6/o7WQhos7bPBP92iwae4dQTEr8K5yQ8s9o5xlATPmSf3iLQSTtj9uRVuuFZ4u
         /Ayw==
X-Gm-Message-State: AOAM531kfDGRkMjxZ7TIf2yh1KDRu3tB8yhSJEvXjy9gSpr4AsS/r0YT
        7eUWevqWmR6/nzZ+0zOcJsYUMMXxIIBMrEdp7xQ=
X-Google-Smtp-Source: ABdhPJx/kZ5p+iu9lWfoqfuUFl5eT8t46oI41w92vcGJeUKHRQ3xUept7609T/CCFvjENmRodnoTEVKq8Oszq8RgwbI=
X-Received: by 2002:a19:2344:: with SMTP id j65mr14586042lfj.38.1614013156080;
 Mon, 22 Feb 2021 08:59:16 -0800 (PST)
MIME-Version: 1.0
References: <20210220092228.1432280-1-jetswayss@gmail.com>
In-Reply-To: <20210220092228.1432280-1-jetswayss@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 22 Feb 2021 08:59:04 -0800
Message-ID: <CAADnVQ+6XYNmN6+=n8nmPDF7Ne6RdpWUVE54xfTq_tn9p7p6Zg@mail.gmail.com>
Subject: Re: [PATCH] tools/resolve_btfids: Fix build error with older host toolchain
To:     Kun-Chuan Hsieh <jetswayss@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Feb 20, 2021 at 1:22 AM Kun-Chuan Hsieh <jetswayss@gmail.com> wrote:
>
> Older verions of libelf cannot recognize the compressed section.

typo above.

Please resend cc-ing bpf@vger, Jiri, Andrii.

> However, it's only required to fix the compressed section info when compiling with CONFIG_DEBUG_INFO_COMPRESSED flag is set.
> Only compile the compressed_section_fix function when necessary will make it easier to enable the BTF function.
> Since the tool resolve_btfids is compiled with host toolchain.
> The host toolchain might be older than the cross compile toolchain.
>
> Cc: stable <stable@vger.kernel.org>
>
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
