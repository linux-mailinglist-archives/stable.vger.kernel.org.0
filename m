Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADFA52422E2
	for <lists+stable@lfdr.de>; Wed, 12 Aug 2020 01:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbgHKXnp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Aug 2020 19:43:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726143AbgHKXnn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Aug 2020 19:43:43 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB8F7C06174A;
        Tue, 11 Aug 2020 16:43:43 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id b25so266295qto.2;
        Tue, 11 Aug 2020 16:43:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vVYy/T/u6izyIYXA6EUbzp0+LeJ2m23WS7/Kot+WNrE=;
        b=Yby0aUts73aRfCsw4V6P+RYSKTwKF+8rHhYs7KENngCDKF+H++UO9BkAysZ32g3b0e
         lGr4e4VmnNbJo5p6UuV/ECFV2bbOblPYSXMWOJ0qVUJ5z+R+yU0Ol7MT56e2ku514rnO
         dLjE2ofh5qyA8ext65sVpqmx7pePdwn7O/MhO4X+8QFx21Ocv64dpn0JrLyumzF3Wu77
         10Rjyn6+LoDpNJX0Kj6bI+XcjQdw0f9dcndqgKwhCGI57P+N9JEO5zrpOUSY5QL2RBvb
         kwM4Q39RLWo5waDKV5/Du22gSRiv8+iwmyO1ZUTk6A5Lxwrx5EpVujXBgiNyMUfbLoDB
         zY7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=vVYy/T/u6izyIYXA6EUbzp0+LeJ2m23WS7/Kot+WNrE=;
        b=qq23P0/sntn5aqXJ0hBJDjIN8kblnF2Oi7A4KKDTDUhaCtWM6Oi+ZZnHKLKOd7Lmd5
         UgmKg2xCH0N1PMMPEdsuSLyA7Og1Gs7NH/qK70KQbnZOC7HOp630tSfQxXxwtn8PdK8+
         83ckehlTuNkeslfy7WKrh1moh0762JOwJzmHZqAEvX5nZrFxRqYb/M86nsD2VllBYqHx
         Xv3uMLa8syeWCFYnmjIIhQCKbUlE3OS+WRCyzDxxQl8N7j+WPPU+HEHsKWhpguTjRkK9
         qiQzSibaa/BmtJFenjkUUM3G2VeR8WQJDyQ0Z8w5b+RMgCfPSB7KG1UlfXT3TDs7Tsdr
         X+qA==
X-Gm-Message-State: AOAM530FB+po55WQnM+fydnoSlnNlEblaQiSg4pkB5uByz9DUv3XxsYH
        x52H6Fhcle8Dj2L11re1Nps=
X-Google-Smtp-Source: ABdhPJzudyfHP6Ux2+lbRuA+IPyYdUAQq2u63fY6ljJl9CUwh+fBtrGqlYDBMrWmHmUiOa4GXyNyWQ==
X-Received: by 2002:ac8:428f:: with SMTP id o15mr3499525qtl.213.1597189422871;
        Tue, 11 Aug 2020 16:43:42 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id x57sm424168qtc.61.2020.08.11.16.43.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2020 16:43:42 -0700 (PDT)
From:   Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date:   Tue, 11 Aug 2020 19:43:40 -0400
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
Message-ID: <20200811234340.GA1318440@rani.riverdale.lan>
References: <CAKwvOd=ypa8xE-kaDa7XtzPsBH8=Xu_pZj2rnWaeawNs=3dDkw@mail.gmail.com>
 <20200811173655.1162093-1-nivedita@alum.mit.edu>
 <CAKwvOdnjLfQ0fWsrFYDJ2O+qFAfEFnTEEnW-aHrPha8G3_WTrg@mail.gmail.com>
 <20200811224436.GA1302731@rani.riverdale.lan>
 <CAKwvOdnvyVapAJBchivu8SxoQriKEu1bAimm8688EH=uq5YMqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAKwvOdnvyVapAJBchivu8SxoQriKEu1bAimm8688EH=uq5YMqA@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 11, 2020 at 04:04:40PM -0700, Nick Desaulniers wrote:
> On Tue, Aug 11, 2020 at 3:44 PM Arvind Sankar <nivedita@alum.mit.edu> wrote:
> >
> > On Tue, Aug 11, 2020 at 10:58:40AM -0700, Nick Desaulniers wrote:
> > > > Cc: stable@vger.kernel.org # 4.19.x
> > >
> > > Thanks Arvind, good write up.  Just curious about this stable tag, how
> > > come you picked 4.19?  I can see boot failures in our CI for x86+LLD
> > > back to 4.9.  Can we amend that tag to use `# 4.9`? I'd be happy to
> > > help submit backports should they fail to apply cleanly.
> > > https://travis-ci.com/github/ClangBuiltLinux/continuous-integration/builds/179237488
> > >
> >
> > 4.19 renamed LDFLAGS to KBUILD_LDFLAGS. For 4.4, 4.9 and 4.14 the patch
> > needs to be modified, KBUILD_LDFLAGS -> LDFLAGS, so I figured we should
> > submit backports separately. For 4.19 onwards, it should apply without
> > changes I think.
> 
> Cool, sounds good.  I'll keep an eye out for when stable goes to pick this up.
> 
> tglx, Ingo, BP, can we pretty please get this in tip/urgent for
> inclusion into 5.9?
> -- 
> Thanks,
> ~Nick Desaulniers

Another alternative is to just do this unconditionally instead of even
checking for the -pie flag. None of the GOTPCRELs are in the
decompressor, so they shouldn't be performance-sensitive at all.

It still wouldn't apply cleanly to all the stable versions, but
backporting would be even simpler.

What do you think?

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 3962f592633d..10c2ba59d192 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -43,6 +43,7 @@ KBUILD_CFLAGS += -Wno-pointer-sign
 KBUILD_CFLAGS += $(call cc-option,-fmacro-prefix-map=$(srctree)/=)
 KBUILD_CFLAGS += -fno-asynchronous-unwind-tables
 KBUILD_CFLAGS += -D__DISABLE_EXPORTS
+KBUILD_CFLAGS += $(call as-option,-Wa$(comma)-mrelax-relocations=no)
 
 KBUILD_AFLAGS  := $(KBUILD_CFLAGS) -D__ASSEMBLY__
 GCOV_PROFILE := n
