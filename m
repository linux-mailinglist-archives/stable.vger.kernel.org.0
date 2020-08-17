Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59A4F2477FB
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 22:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbgHQUOC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 16:14:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbgHQUNz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 16:13:55 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30092C061389;
        Mon, 17 Aug 2020 13:13:55 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id 77so16189286qkm.5;
        Mon, 17 Aug 2020 13:13:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2iB7Xz00n5+0Lgu+wndRSafBvCLWjlpZRZyNPVeU2aE=;
        b=FqbjGe9U5+KoOmxxjyJUB/RZzrdUONjZiYMyDKoUkuh/2yHKnD6zT2Uj7I8UbYuYAG
         QKES7m4drXles2frxuunVXJFU1vO1nTqmKZtt9pWAP++iA9oQf2C6rcqPgkgJq3LFSBX
         lcHri0k4ctEipOVQzk2ZLIF4Zno7KvX8T8mxizBKLaRryyosyhgMbAVe5l5ZNGawNZcB
         JMeGxi8/ZTYXacW+5uXhoZSwXrvm3+V8etyM/j7swCB+x8Eyz25aPf+13K1O9qptwy0f
         Wu+weqYJRxwBupy6n1sgAadO/uIXEAL/BHeBAw1uDn6HckGZAQ45nlUhdDG2KSNvUAI9
         41fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=2iB7Xz00n5+0Lgu+wndRSafBvCLWjlpZRZyNPVeU2aE=;
        b=j5D2bvwczN7VvQMNm3359TiFjXDcaMiTr8oqJe5WD8PyFtrsgbWEhjJqjzzNmgD8qR
         f8UoPWozBwCBPKN+B3W18ef8pzDqBCE9kVC1AWEtwzaBgj0+QEVWOC5TXAVybQSjrnU3
         gifrBKID06Q+qAMgw9Q+6lz4NknA6OdeqK5h07VauyDfocviKACmCPNalLjfNjEFsl5a
         uTEiGJRRhsjvaol1qjW7KmjsxzKKFmGSJyxRvobkwoiyEFgjbyLT8ES+wcaskfnzwz2M
         u9vMt3VcPiMudOTDY9EObXk5qw950Za9813RRqBiK72VixtKILm+cGDMOsrCyWzuPLyu
         YXaA==
X-Gm-Message-State: AOAM530fHNLLhO/nFMbue+akz0cvC97BKHT4kS5r82Tlo2oA/jkvhBov
        EAem/LSZ+uY3XeHUxLNvVzg=
X-Google-Smtp-Source: ABdhPJwcD83COjwoesiJj86XB2SqJAdVYnEaAF0ceFWHGp52ZZZ3SM1gxfEjep5vmUDLeI3v8fGScw==
X-Received: by 2002:a37:6cc1:: with SMTP id h184mr14674031qkc.101.1597695234334;
        Mon, 17 Aug 2020 13:13:54 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id k5sm18742660qke.18.2020.08.17.13.13.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 13:13:53 -0700 (PDT)
From:   Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date:   Mon, 17 Aug 2020 16:13:51 -0400
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Sami Tolvanen <samitolvanen@google.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Kees Cook <keescook@chromium.org>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Fangrui Song <maskray@google.com>,
        Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?utf-8?B?RMOhdmlkIEJvbHZhbnNrw70=?= <david.bolvansky@gmail.com>,
        Eli Friedman <efriedma@quicinc.com>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Daniel Axtens <dja@axtens.net>, Ingo Molnar <mingo@kernel.org>,
        Yury Norov <yury.norov@gmail.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: Re: [PATCH v2] lib/string.c: implement stpcpy
Message-ID: <20200817201351.GA2246446@rani.riverdale.lan>
References: <CAKwvOdnyHfx6ayqEoOr3pb_ibKBAG9vj31LuKE+f712W=7LFKA@mail.gmail.com>
 <457a91183581509abfa00575d0392be543acbe07.camel@perches.com>
 <CAKwvOdk4PRi45MXCtg4kmeN6c1AK5w9EJ1XFBJ5GyUjwEtRj1g@mail.gmail.com>
 <ccacb2a860151fdd6ce95371f1e0cd7658a308d1.camel@perches.com>
 <CAKwvOd=QkpmdWHAvWVFtogsDom2z_fA4XmDF6aLqz1czjSgZbQ@mail.gmail.com>
 <20200816001917.4krsnrik7hxxfqfm@google.com>
 <CA+icZUW=rQ-e=mmYWsgVns8jDoQ=FJ7kdem1fWnW_i5jx-6JzQ@mail.gmail.com>
 <20200816150217.GA1306483@rani.riverdale.lan>
 <CABCJKucsXufD6rmv7qQZ=9kLC7XrngCJkKA_WzGOAn-KfcObeA@mail.gmail.com>
 <CAKwvOd=Ns4_+amT8P-7yQ56xUdDmL=1zDUThF-OmFKhexhJPdg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAKwvOd=Ns4_+amT8P-7yQ56xUdDmL=1zDUThF-OmFKhexhJPdg@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 17, 2020 at 11:36:49AM -0700, Nick Desaulniers wrote:
> > > Though I don't understand the original issue, with -ffreestanding,
> > > sprintf shouldn't have been turned into strcpy in the first place.
> 
> Huh? The original issue for this thread is because `-ffreestanding`
> *isn't* being used for most targets (oh boy, actually mixed usage by
> ARCH. Looks like MIPS, m68k, superH, xtensa, and 32b x86 use it?); and
> I'm not suggesting it be used.
> 

Sorry, I meant the issue mentioned in the commit that removed
-ffreestanding, not the stpcpy one you're solving now. It says that
sprintf got converted into strcpy, which caused failures because back
then, strcpy was #define'd to __builtin_strcpy, and the default
implementation was actually of a function called __builtin_strcpy o_O,
not strcpy.

Anyway, that's water under the bridge now.

6edfba1b33c7 ("x86_64: Don't define string functions to builtin")
  gcc should handle this anyways, and it causes problems when
  sprintf is turned into strcpy by gcc behind our backs and
  the C fallback version of strcpy is actually defining __builtin_strcpy
