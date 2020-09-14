Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5176826888F
	for <lists+stable@lfdr.de>; Mon, 14 Sep 2020 11:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbgINJf7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Sep 2020 05:35:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726312AbgINJfz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Sep 2020 05:35:55 -0400
Received: from mail-oo1-xc42.google.com (mail-oo1-xc42.google.com [IPv6:2607:f8b0:4864:20::c42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83B7BC06174A;
        Mon, 14 Sep 2020 02:35:55 -0700 (PDT)
Received: by mail-oo1-xc42.google.com with SMTP id k13so3868832oor.2;
        Mon, 14 Sep 2020 02:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=r9cbH5W71i4ID4miB4mL4ql1K0EFgtyqFKMoedqtXIw=;
        b=L+p4RPrbK7472Kq7cKPf3EFxE/ienX0dyXoGoL6wtty2tvGxR155yhqBOQ3GuIRlTH
         W7Az56geOL/eLxslsvt8dXrDObCvR9G2xJZsL1sA++zRXbGMPqeDnwrUlwGQpWDXDTNb
         A3Hq6Xnl6pPzr7kw87Xzk9iLUx4gcS7r+CbASHz2iLKrOf7qRwqwCBR0t8shJJtRFlm1
         8UeIcrWnn+LNJxxtQ5I2WT66XJzBu3WU7cx8Me6xxqbjJELIqaHc6s8lWPmHghKYzBsM
         Q4EfiCNsgoo9ZceYa0v9gSEduhbDo4pRhr9V2uc5hDEjGt58oN+7cn/yX7DvEA9Htk53
         kPkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=r9cbH5W71i4ID4miB4mL4ql1K0EFgtyqFKMoedqtXIw=;
        b=ihNvp2hsv1oQggJExf8Ds3c114qxto8Ly8pqsfaqZBQt0U7bBKRL859j4FW2F08QCc
         fe/AIhSENYCHyIws/3gQQ24knfmVeDpefm6P7PElICtuBVbGw/6TmBMZ5U2R10NXCu2w
         Ushfsjy/qeTKzmUcRPpmNGWK/l7NjUVpJuRqfmcjbzXrf3uDaXq1rW+LWAIkPuz4ZjW5
         bdOkPTua6FGYmJQohcP6PKDfu1R4NNZ/9ipWvfyIyZ8rPRf+pGOD6ei6UZc+CNcXxnw9
         giTewo3nTXerr6qSAX48t5TFpJYH3/IOmnsgpJrnjH2qM30llm+Y844y8FwE2r3SXefu
         uWhQ==
X-Gm-Message-State: AOAM533yNEuATHb/uEBaT0kakFyT6GFk/AFnJuypHCI3Oa7yzFepkBkp
        5GJsEuxGt/q0FXaMSDdHLgBitTtVWyWeVbEnefo=
X-Google-Smtp-Source: ABdhPJzCoAkRyfjVFXcXLJnHBrJrT55KV39gIdmZHdePO2XQX+TRRd5m9eTZB313pO4ugmJMrfGde2bfAgNavd1ELtA=
X-Received: by 2002:a4a:2c02:: with SMTP id o2mr9510259ooo.24.1600076154986;
 Mon, 14 Sep 2020 02:35:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200812004158.GA1447296@rani.riverdale.lan> <20200812004308.1448603-1-nivedita@alum.mit.edu>
 <CA+icZUVdTT1Vz8ACckj-SQyKi+HxJyttM52s6HUtCDLFCKbFgQ@mail.gmail.com>
 <CAKwvOdmHxsLzou=6WN698LOGq9ahWUmztAHfUYYAUcgpH1FGRA@mail.gmail.com>
 <20200825145652.GA780995@rani.riverdale.lan> <20200913223455.GA349140@rani.riverdale.lan>
 <CAMj1kXFnuzdmPxCytCbFdgtLo8Bb4k247ePgbLuZ1mANEn=azw@mail.gmail.com> <20200914091627.GA153848@gmail.com>
In-Reply-To: <20200914091627.GA153848@gmail.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Mon, 14 Sep 2020 11:35:43 +0200
Message-ID: <CA+icZUXnkBwrHxfCkAraPWzSks2RhRAfDr9=m-tDympmCp2zng@mail.gmail.com>
Subject: Re: [PATCH v2] x86/boot/compressed: Disable relocation relaxation
To:     Ingo Molnar <mingo@kernel.org>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Fangrui Song <maskray@google.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        e5ten.arch@gmail.com,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 14, 2020 at 11:16 AM Ingo Molnar <mingo@kernel.org> wrote:
>
>
> * Ard Biesheuvel <ardb@kernel.org> wrote:
>
> > On Mon, 14 Sep 2020 at 01:34, Arvind Sankar <nivedita@alum.mit.edu> wrote:
> > >
> > > On Tue, Aug 25, 2020 at 10:56:52AM -0400, Arvind Sankar wrote:
> > > > On Sat, Aug 15, 2020 at 01:56:49PM -0700, Nick Desaulniers wrote:
> > > > > Hi Ingo,
> > > > > I saw you picked up Arvind's other series into x86/boot.  Would you
> > > > > mind please including this, as well?  Our CI is quite red for x86...
> > > > >
> > > > > EOM
> > > > >
> > > >
> > > > Hi Ingo, while this patch is unnecessary after the series in
> > > > tip/x86/boot, it is still needed for 5.9 and older. Would you be able to
> > > > send it in for the next -rc? It shouldn't hurt the tip/x86/boot series,
> > > > and we can add a revert on top of that later.
> > > >
> > > > Thanks.
> > >
> > > Ping.
> > >
> > > https://lore.kernel.org/lkml/20200812004308.1448603-1-nivedita@alum.mit.edu/
> >
> > Acked-by: Ard Biesheuvel <ardb@kernel.org>
>
> Thanks guys - queued up in tip:x86/urgent.
>

Thanks.
Did you push it?

Git-Web on <git.kernel.org> seems to be slow this Morning - checked
Linus Git an hour ago.
Does Anyone know what's going on?

- Sedat
