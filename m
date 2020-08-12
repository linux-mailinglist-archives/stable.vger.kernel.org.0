Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7E92242376
	for <lists+stable@lfdr.de>; Wed, 12 Aug 2020 02:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbgHLAmC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Aug 2020 20:42:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726255AbgHLAmB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Aug 2020 20:42:01 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 794E9C06174A;
        Tue, 11 Aug 2020 17:42:01 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id dd12so319777qvb.0;
        Tue, 11 Aug 2020 17:42:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xKVZMt/dePQM4MuKFNd6Ajk9D8rVSs9BrWtvNC9qc9Q=;
        b=eUizsHu8R2pQS6jRVnAREKzRnltxbHGsHDlbgl5HiZ8T5WP5v7R/FdXEW5olp9Ng4m
         l+bFua7uNOEktthT8oYm4yfGaNTfxvC66ef1WD9u+GtMj3ENvmgEKl9eOksAcY8lu8Qm
         1K7I6by5x4eB0w4Iuf5XNtn5c90/CC9bdgZPoJ1GssLh3FVQGF4hZpbCur0oV53CKL8z
         w930PnLmAWlzYH7IkdedzATG4omTW+TFM8xH8gI2nTzShFENKKPraETMzUBJjQrNCfHH
         ccB/MSJUxR2xoQJzlWkIXPiAwqg7vVGVIW6H5gqZfugaLeHstlrWLHNy/BAlS+wUfQc3
         L8Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=xKVZMt/dePQM4MuKFNd6Ajk9D8rVSs9BrWtvNC9qc9Q=;
        b=nTCMeobPWgHCvE30bJMnUr8OZ6EkjxWu1DcmndUfVT1wuC3Py/Zf907ky2hNkkRc6N
         Q7goBzQ08na8IsOvHIUveh7g2N0tJfVyOyNHnfTPOBzFTDnYYILHA1gN5wnANZkrr/Jj
         ZRjD9HBC5PBYMkNYms2We1V4JczIBoFHMhvoPz+BrkkaX0AxOpEvHct5dSqa8GShujTJ
         WTrd9kuglRXafb6dbIRN0NM8tpVw3O+2z2ncFj/fB2W7AN/BrHVRkq1gEre8Hg7wZdHT
         UbnkVwxKVOR1lH/kQQUvuiFfSAXXuhyPAS2tJ/gkvqD2MAgVu84EahVniAj2yhmFkNKZ
         mEgQ==
X-Gm-Message-State: AOAM530xNHexvhepuSnlUTSfpTF5heNU67dFXjFHl/YHhVekffjP+Qj6
        ivVJISo3XqiYyGVUr1L1c+U=
X-Google-Smtp-Source: ABdhPJzOLnPrJZZPql96/UdA/v/SB+X6pwhuRB/dd7/mwcEzvawX/rCxuGUowLW4sIq7ayJZcY9Wag==
X-Received: by 2002:ad4:4089:: with SMTP id l9mr4196623qvp.175.1597192920425;
        Tue, 11 Aug 2020 17:42:00 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id w58sm544891qth.95.2020.08.11.17.41.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2020 17:41:59 -0700 (PDT)
From:   Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date:   Tue, 11 Aug 2020 20:41:58 -0400
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Arvind Sankar <nivedita@alum.mit.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Fangrui Song <maskray@google.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        e5ten.arch@gmail.com,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>
Subject: Re: [PATCH] x86/boot/compressed: Disable relocation relaxation for
 non-pie link
Message-ID: <20200812004158.GA1447296@rani.riverdale.lan>
References: <CAKwvOd=ypa8xE-kaDa7XtzPsBH8=Xu_pZj2rnWaeawNs=3dDkw@mail.gmail.com>
 <20200811173655.1162093-1-nivedita@alum.mit.edu>
 <CAKwvOdnjLfQ0fWsrFYDJ2O+qFAfEFnTEEnW-aHrPha8G3_WTrg@mail.gmail.com>
 <20200811224436.GA1302731@rani.riverdale.lan>
 <CAKwvOdnvyVapAJBchivu8SxoQriKEu1bAimm8688EH=uq5YMqA@mail.gmail.com>
 <20200811234340.GA1318440@rani.riverdale.lan>
 <CAKwvOdn5gCjcAVHZ3jHU+q=mD5rmFAHpEyHyLf7ixtdaQ3Z-PQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAKwvOdn5gCjcAVHZ3jHU+q=mD5rmFAHpEyHyLf7ixtdaQ3Z-PQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 11, 2020 at 04:51:23PM -0700, Nick Desaulniers wrote:
> On Tue, Aug 11, 2020 at 4:43 PM Arvind Sankar <nivedita@alum.mit.edu> wrote:
> >
> > On Tue, Aug 11, 2020 at 04:04:40PM -0700, Nick Desaulniers wrote:
> > > On Tue, Aug 11, 2020 at 3:44 PM Arvind Sankar <nivedita@alum.mit.edu> wrote:
> > > >
> > > > On Tue, Aug 11, 2020 at 10:58:40AM -0700, Nick Desaulniers wrote:
> > > > > > Cc: stable@vger.kernel.org # 4.19.x
> > > > >
> > > > > Thanks Arvind, good write up.  Just curious about this stable tag, how
> > > > > come you picked 4.19?  I can see boot failures in our CI for x86+LLD
> > > > > back to 4.9.  Can we amend that tag to use `# 4.9`? I'd be happy to
> > > > > help submit backports should they fail to apply cleanly.
> > > > > https://travis-ci.com/github/ClangBuiltLinux/continuous-integration/builds/179237488
> > > > >
> > > >
> > > > 4.19 renamed LDFLAGS to KBUILD_LDFLAGS. For 4.4, 4.9 and 4.14 the patch
> > > > needs to be modified, KBUILD_LDFLAGS -> LDFLAGS, so I figured we should
> > > > submit backports separately. For 4.19 onwards, it should apply without
> > > > changes I think.
> > >
> > > Cool, sounds good.  I'll keep an eye out for when stable goes to pick this up.
> > >
> > > tglx, Ingo, BP, can we pretty please get this in tip/urgent for
> > > inclusion into 5.9?
> > > --
> > > Thanks,
> > > ~Nick Desaulniers
> >
> > Another alternative is to just do this unconditionally instead of even
> > checking for the -pie flag. None of the GOTPCRELs are in the
> > decompressor, so they shouldn't be performance-sensitive at all.
> >
> > It still wouldn't apply cleanly to all the stable versions, but
> > backporting would be even simpler.
> >
> > What do you think?
> >
> > diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
> > index 3962f592633d..10c2ba59d192 100644
> > --- a/arch/x86/boot/compressed/Makefile
> > +++ b/arch/x86/boot/compressed/Makefile
> > @@ -43,6 +43,7 @@ KBUILD_CFLAGS += -Wno-pointer-sign
> >  KBUILD_CFLAGS += $(call cc-option,-fmacro-prefix-map=$(srctree)/=)
> >  KBUILD_CFLAGS += -fno-asynchronous-unwind-tables
> >  KBUILD_CFLAGS += -D__DISABLE_EXPORTS
> > +KBUILD_CFLAGS += $(call as-option,-Wa$(comma)-mrelax-relocations=no)
> 
> We'd still want it for KBUILD_AFLAGS, too, just to be safe. Maybe a

KBUILD_CFLAGS gets included into KBUILD_AFLAGS, so this already does
that.

> one line comment to the effect of `# remove me once we can link as
> -pie` would help us rip off this band-aid in the future?  It's more
> obvious that the added hunk can be reverted once -pie linkage is
> achieved with the current patch; either are fine by me.  Thanks!
> 
> >
> >  KBUILD_AFLAGS  := $(KBUILD_CFLAGS) -D__ASSEMBLY__
> >  GCOV_PROFILE := n
> 
> 
> 
> -- 
> Thanks,
> ~Nick Desaulniers
