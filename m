Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7940BA1A13
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 14:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbfH2MbQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 08:31:16 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:34078 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727228AbfH2MbQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Aug 2019 08:31:16 -0400
Received: by mail-lj1-f196.google.com with SMTP id x18so2885292ljh.1
        for <stable@vger.kernel.org>; Thu, 29 Aug 2019 05:31:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=oBvyqV3fKnbJ8QZVXeywNBKJ8F7ZYc7lK6Du19esODw=;
        b=Lcs4R+w4EPu5Gmg4CeLmejmEyYCNSgKSFhV+NHrWSmuMJXqNjRwSuDAwyhn2oPXV53
         ETZAqhJfWah5oRUWf5KRXqFQsKN9WeNU292RG8poWd/ZsIRZSZFchNBh5zkQ4hU8fgJG
         +NKct3Dcqa+QUVHEitVnit9jbK4As4qjnPorXfSK/1gf3aqVaiFa54T9uXnA+iUSUFdK
         ogZQbrtjfXWgg8FyM3HqKlOXGEA5aLq/8f07iI5dOHjtaGkScl58QFI+hk2XMIVGQfp4
         t7ya29G7JQ1OzNYDw10iDzTsnHdWIL94mHViutUmENwC1BWc+xQMyLWcsC6PeZayr8B1
         6IgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=oBvyqV3fKnbJ8QZVXeywNBKJ8F7ZYc7lK6Du19esODw=;
        b=l4IGinDf4MSQwyiN9mLbbTOPDQ3Klb8JPip+/S+sb2DRydpDrfn8zw4iORs8Pugt1D
         rd3F4bIm7PYBB+0JanK3WWliSFvyg37s1/ehjDQiXJ8kglk2B4MASKm5ULBm4p65VqhH
         nKx8FYoohzje6OejmEGgN5VR1P9d2ssTcsRrtH4CJ284Llp49+tadho1OrVV3+42RC/t
         DkZnLPCGx5fHyQQIa2tsCALDqbY3lGs8Ig4wbrGJSInscgvTk6oGbhJr+HVfaJc3TKlN
         Ed/pjShRjzogxVxrEzdGMuLqWG9RJIFOLdSTLZxym7yGlTk/JGY05XRY1E/3X9hRyQCR
         ZJhQ==
X-Gm-Message-State: APjAAAWE5NwUfVwAZ+Dxp/FMOOURg/OvyP4FRo3qQ/tHcQdZ7Bpyk473
        y8E0o6MHRViApLrDUmyeI8Pr0I5pCFdSWwPblK+FNtAp
X-Google-Smtp-Source: APXvYqyWhAd/sPQ4DjUN36VNvi77GJrkiTgsYhx25DHEgQ+F5VJFjs04+yDUMVIAH5jrn/Y4/nMVODhDeA4DEpFin0o=
X-Received: by 2002:a2e:91d1:: with SMTP id u17mr5087670ljg.98.1567081873696;
 Thu, 29 Aug 2019 05:31:13 -0700 (PDT)
MIME-Version: 1.0
References: <CACU-xRs6-oog+4gG-zsn-J9MCRS8xF3y-1Aw+yq_iv6PHP7d+A@mail.gmail.com>
 <015acb3e-6722-70c8-b0d5-822f1505fed2@suse.cz>
In-Reply-To: <015acb3e-6722-70c8-b0d5-822f1505fed2@suse.cz>
From:   =?UTF-8?Q?Fran=C3=A7ois_Valenduc?= <francoisvalenduc@gmail.com>
Date:   Thu, 29 Aug 2019 14:31:02 +0200
Message-ID: <CACU-xRvN-HcxYPCzbxxiJsm11ExZBnRAVwRhKnY2c9QNBshc2w@mail.gmail.com>
Subject: Re: Kernel 5.2.11 dpes not compile
To:     Jiri Slaby <jslaby@suse.cz>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sorry, I forgot to attach the config file.
Indeed, I have CONFIG_COMPACTION=3Dn

Fran=C3=A7ois Valenduc

Le jeu. 29 ao=C3=BBt 2019 =C3=A0 14:28, Jiri Slaby <jslaby@suse.cz> a =C3=
=A9crit :
>
> On 29. 08. 19, 14:13, Fran=C3=A7ois Valenduc wrote:
> > The following patch causes a build failure:
> >
> >
> > Author: Henry Burns <henryburns@google.com>
> > Date:   Sat Aug 24 17:55:06 2019 -0700
> >
> >     mm/zsmalloc.c: fix race condition in zs_destroy_pool
>
> So this is f6d997de0883 in 5.2.11 and 701d678599d0 in upstream.
>
> > I get this error:
> >
> >  CALL    scripts/checksyscalls.sh
> >   CALL    scripts/atomic/check-atomics.sh
> >   DESCEND  objtool
> >   CHK     include/generated/compile.h
> >   CC      mm/zsmalloc.o
> > In file included from ./include/linux/mmzone.h:10:0,
> >                  from ./include/linux/gfp.h:6,
> >                  from ./include/linux/umh.h:4,
> >                  from ./include/linux/kmod.h:9,
> >                  from ./include/linux/module.h:13,
> >                  from mm/zsmalloc.c:33:
> > mm/zsmalloc.c: In function =E2=80=98zs_create_pool=E2=80=99:
> > mm/zsmalloc.c:2435:27: error: =E2=80=98struct zs_pool=E2=80=99 has no m=
ember named
> > =E2=80=98migration_wait=E2=80=99
> >   init_waitqueue_head(&pool->migration_wait);
>
> Obviously, as this is not protected by
> #ifdef CONFIG_COMPACTION
> ...
> #endif
> as is its definition in the structure (and its other uses).
>
> > ./include/linux/wait.h:67:26: note: in definition of macro =E2=80=98ini=
t_waitqueue_head=E2=80=99
> >    __init_waitqueue_head((wq_head), #wq_head, &__key);  \
> >                           ^~~~~~~
> > scripts/Makefile.build:278: recipe for target 'mm/zsmalloc.o' failed
> > make[1]: *** [mm/zsmalloc.o] Error 1
> > Makefile:1073: recipe for target 'mm' failed
> >
> > You can find my configuration file attached.
>
> You forgot to attach it, but you have CONFIG_COMPACTION=3Dn, I assume.
>
> > Does anybody have any idea about this ?
>
> Sure, this will fix it (or turn on compaction):
> --- a/mm/zsmalloc.c
> +++ b/mm/zsmalloc.c
> @@ -2413,7 +2413,9 @@ struct zs_pool *zs_create_pool(const char *name)
>         if (!pool->name)
>                 goto err;
>
> +#ifdef CONFIG_COMPACTION
>         init_waitqueue_head(&pool->migration_wait);
> +#endif
>
>         if (create_cache(pool))
>                 goto err;
>
> thanks,
> --
> js
> suse labs
