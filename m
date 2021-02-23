Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC4F3322F9A
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 18:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233128AbhBWR13 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 12:27:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232653AbhBWR1Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Feb 2021 12:27:25 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3813FC06174A;
        Tue, 23 Feb 2021 09:26:45 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id u3so17267784ybk.6;
        Tue, 23 Feb 2021 09:26:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+e1SOqNQT+ncD78kfXdm8sEW7IGY/MIzMOG2zu8j9bI=;
        b=OX2jURIAShj1XnuLKZIKojjp+xgHb1pzwBQbezq+ECvnIHv64irGjIMIWvHB5n6DMG
         C6dYYjiS7VN7qlOsovm17L6BbU+u/ghftqkG0tNgG71wKz5l/KfnRadld9qhPJiKplD0
         s3qAahJ4cegV7ErG8Lgrngqq8efFs4rK2ZtnsnCvoA6zLLNPkTD40/DNcaHnmZp2aaIm
         tRg9UqWS06eGm652YCNb5XeNIKoaMfEdn8xa6UUkL11hxKAiDQAr++ULBHnv1LQxdvwr
         rohBG7LqHW5gMRu2Lx6G56ibF56VrTZMUMFs2lDSY5tBgh4H5jH+x48AU2+kEFjbKAgG
         kc8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+e1SOqNQT+ncD78kfXdm8sEW7IGY/MIzMOG2zu8j9bI=;
        b=Kz/t7ozbXXHBdnDSCSakK2fGiBcgkVlfjrKAfGhZ4e7qMAjjmybaGRh3s6qJwLDiOP
         iFTCZBdvBkGNAE0j9uR3ZaFvw2oRXOLwDHhdDE+JZo3keD33oaWmb3rFfhwB+wdw0x5u
         X3+13GKutMu5HONVHTKOVPOvm5qMvRpJz/nAB+G0loICE3wXMr0Wc34z+7v8GerZ18L+
         e2HsD7yxIYEzdnTEn94FQjkykIPk/C1d2fdEwM7mzMLphRdsvUe4+KuwA7FAkRelvyW0
         dDjp0Rz8J/FIB2NqrVJAnahJO3f/TFBScAgTvNOyrnuo7bV7xW+tqVA5frYi22HHK/hQ
         OXIA==
X-Gm-Message-State: AOAM532C8LqTMt5XCVRHaquxsAVQTzxSxSAuR9a7MPmYozBtdVYvcdGz
        ED4yU/pbkihiVXpfGfdLS76fpkqpVFjHErrKGwE=
X-Google-Smtp-Source: ABdhPJys5nW/CpjrAKsPqacbKZaSKpqlXZglGa8aGVxc2W79ap77Q/q/++bj+DOucGPEl9ckUdI0sfQYVgLS4F8XgP8=
X-Received: by 2002:a25:bd12:: with SMTP id f18mr18148398ybk.403.1614101204364;
 Tue, 23 Feb 2021 09:26:44 -0800 (PST)
MIME-Version: 1.0
References: <20210223012001.1452676-1-jetswayss@gmail.com> <YDUUbRJ1waVyoO+f@krava>
 <CAAmO479hYwswvNvd4LBMQ7bjhYeDvFohpu9p=FzeUjZ-BY=5GA@mail.gmail.com>
In-Reply-To: <CAAmO479hYwswvNvd4LBMQ7bjhYeDvFohpu9p=FzeUjZ-BY=5GA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 23 Feb 2021 09:26:33 -0800
Message-ID: <CAEf4Bzbv0BmL0iLycTc1Y2Kak4VQ1wQT0w7AVD1KeGC5topLDw@mail.gmail.com>
Subject: Re: [PATCH] tools/resolve_btfids: Fix build error with older host toolchains
To:     Kun-Chuan Hsieh <jetswayss@gmail.com>
Cc:     Jiri Olsa <jolsa@redhat.com>, Alexei Starovoitov <ast@kernel.org>,
        bpf <bpf@vger.kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 23, 2021 at 8:38 AM Kun-Chuan Hsieh <jetswayss@gmail.com> wrote:
>
> Hi Jiri Olsa,
>
> Yes, exactly. The missing SHF_COMPRESSED value causes build failure.
>
> Compared to conditional compilation, your suggestion seems to be a better
> solution. Thank you for your suggestion. I will submit the patch v2.
>
>
> Hi Andrii Nakryiko,
>
> Yes, it is possible to detect whether libelf supports compressed ELF
> sections at compilation time. I can think of two possible methods.
> 1. Check SHF_COMPRESSED is defined. (If libelf supports compressed ELF
> sections, SHF_COMPRESSED should be defined in libelf.h or elf.h)
> 2. Check the libelf version by _ELFUTILS_PREREQ (from elfutils/version.h)
>
> Best regards,
> Kun-Chuan Hsieh
>
> On Tue, Feb 23, 2021 at 10:43 PM Jiri Olsa <jolsa@redhat.com> wrote:
>>
>> On Tue, Feb 23, 2021 at 01:20:01AM +0000, Kun-Chuan Hsieh wrote:
>> > Older versions of libelf cannot recognize the compressed section.
>>
>> so it's the SHF_COMPRESSED value the build fails on?
>>
>> maybe we could do just this:
>>
>> #ifndef SHF_COMPRESSED
>>  #define SHF_COMPRESSED      (1 << 11)  /* Section with compressed data. */
>> #endif

Yeah, I was hoping it would be something like this. Or we can just
#ifdef two regions of code that rely on SHF_COMPRESSED.

>>
>> jirka
>>
>> > However, it's only required to fix the compressed section info when
>> > compiling with CONFIG_DEBUG_INFO_COMPRESSED flag is set.
>> >
>> > Only compile the compressed_section_fix function when necessary will make
>> > it easier to enable the BTF function. Since the tool resolve_btfids is
>> > compiled with host toolchain. The host toolchain might be older than the
>> > cross compile toolchain.
>> >
>> > Cc: stable@vger.kernel.org
>> > Signed-off-by: Kun-Chuan Hsieh <jetswayss@gmail.com>
>> > ---
>> >  tools/bpf/resolve_btfids/main.c | 4 ++++
>> >  1 file changed, 4 insertions(+)
>> >
>> > diff --git a/tools/bpf/resolve_btfids/main.c b/tools/bpf/resolve_btfids/main.c
>> > index 7409d7860aa6..ad40346c6631 100644
>> > --- a/tools/bpf/resolve_btfids/main.c
>> > +++ b/tools/bpf/resolve_btfids/main.c
>> > @@ -260,6 +260,7 @@ static struct btf_id *add_symbol(struct rb_root *root, char *name, size_t size)
>> >       return btf_id__add(root, id, false);
>> >  }
>> >
>> > +#ifdef CONFIG_DEBUG_INFO_COMPRESSED
>> >  /*
>> >   * The data of compressed section should be aligned to 4
>> >   * (for 32bit) or 8 (for 64 bit) bytes. The binutils ld
>> > @@ -292,6 +293,7 @@ static int compressed_section_fix(Elf *elf, Elf_Scn *scn, GElf_Shdr *sh)
>> >       }
>> >       return 0;
>> >  }
>> > +#endif
>> >
>> >  static int elf_collect(struct object *obj)
>> >  {
>> > @@ -370,8 +372,10 @@ static int elf_collect(struct object *obj)
>> >                       obj->efile.idlist_addr  = sh.sh_addr;
>> >               }
>> >
>> > +#ifdef CONFIG_DEBUG_INFO_COMPRESSED
>> >               if (compressed_section_fix(elf, scn, &sh))
>> >                       return -1;
>> > +#endif
>> >       }
>> >
>> >       return 0;
>> > --
>> > 2.25.1
>> >
>>
