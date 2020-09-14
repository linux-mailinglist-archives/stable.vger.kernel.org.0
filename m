Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC89268814
	for <lists+stable@lfdr.de>; Mon, 14 Sep 2020 11:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbgINJQg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Sep 2020 05:16:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbgINJQd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Sep 2020 05:16:33 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12392C06174A;
        Mon, 14 Sep 2020 02:16:31 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id n13so16746705edo.10;
        Mon, 14 Sep 2020 02:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XXy/wM2htl8rGdlFZEO1cSyO0iLpVUoMkmwaTLnGh7Y=;
        b=Gy6frrKpAhm/U4ECz6t6JookWgXUzuBG/YmtM/vp0fegQQQlXyfQISfmiKNMzFIF4x
         2wGO7lcW5rjp7XVKiWw8w8ggxPgDO6z/vmqseIxOb/bPjKy/9WvFJ65S7jz7FIvbCqby
         nWvEDQDbTf+H7CrtRI6R3DoZr5Fxb3ymAXanK83P8VOxh+4ISx+Wg8kpRgezrK+LqoRb
         H7hP5E6xOdmoT337Ca3RUplVaZMNcX2IcousmLqxgfjuVZv5jqpi3P1jg0wwohg/PJQ2
         m3tzGXdfjQ2wT81gKiTU0BNXTORKhjSRfzk0MQaRb85bTwryf3u8g/E8YKrK4CIANhrF
         gPoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=XXy/wM2htl8rGdlFZEO1cSyO0iLpVUoMkmwaTLnGh7Y=;
        b=IyIbnkRkaoSJtQaLtPBxmQRHN66owSR1GqYcBSDPeHWvdEw3MUGv6rO6P8DwTEvaCd
         8Z1urcUqAu+diCJFKClMqpfkrgwTWtCmTe3/FHjV3H272kn4nxa7I6C3YDbiLO8phRXL
         5Z1LjKsA+Hgds8lQUcqYS+O5hYF4isFOWIfkxGHdDncVOFOxRnPm45E4zwx2RKq31cQB
         C823+60CASqbHnwSdwOi2EkZ2Ipk7TIF6autEKyrUgy9GFb/UBW62RTzS0YBSSrZ/Och
         maX7rPIA10BfImnKEMN6reVFwF612/DgtByc3arbzURFWTdxkVdHlQ7d0Xggp7fQiNtL
         ygjw==
X-Gm-Message-State: AOAM530UcbiuZ8xP04BBdNyb7obaqUdwng/FRebzGaQibj2oGIw+mPoW
        NXzq6v/8IBGzS7fztsT22AU=
X-Google-Smtp-Source: ABdhPJxsTH23qFvtGZgKcPOWJngZAz4+NnnzhQdifQpvY+O2WIlBXxLFfnO96I7eUVCxjSAcT8ORkw==
X-Received: by 2002:a50:fd0a:: with SMTP id i10mr15856716eds.277.1600074990515;
        Mon, 14 Sep 2020 02:16:30 -0700 (PDT)
Received: from gmail.com (5400A980.dsl.pool.telekom.hu. [84.0.169.128])
        by smtp.gmail.com with ESMTPSA id c8sm7266991ejp.30.2020.09.14.02.16.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 02:16:29 -0700 (PDT)
Date:   Mon, 14 Sep 2020 11:16:27 +0200
From:   Ingo Molnar <mingo@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Arvind Sankar <nivedita@alum.mit.edu>,
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
        "# 3.4.x" <stable@vger.kernel.org>,
        Sedat Dilek <sedat.dilek@gmail.com>
Subject: Re: [PATCH v2] x86/boot/compressed: Disable relocation relaxation
Message-ID: <20200914091627.GA153848@gmail.com>
References: <20200812004158.GA1447296@rani.riverdale.lan>
 <20200812004308.1448603-1-nivedita@alum.mit.edu>
 <CA+icZUVdTT1Vz8ACckj-SQyKi+HxJyttM52s6HUtCDLFCKbFgQ@mail.gmail.com>
 <CAKwvOdmHxsLzou=6WN698LOGq9ahWUmztAHfUYYAUcgpH1FGRA@mail.gmail.com>
 <20200825145652.GA780995@rani.riverdale.lan>
 <20200913223455.GA349140@rani.riverdale.lan>
 <CAMj1kXFnuzdmPxCytCbFdgtLo8Bb4k247ePgbLuZ1mANEn=azw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXFnuzdmPxCytCbFdgtLo8Bb4k247ePgbLuZ1mANEn=azw@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


* Ard Biesheuvel <ardb@kernel.org> wrote:

> On Mon, 14 Sep 2020 at 01:34, Arvind Sankar <nivedita@alum.mit.edu> wrote:
> >
> > On Tue, Aug 25, 2020 at 10:56:52AM -0400, Arvind Sankar wrote:
> > > On Sat, Aug 15, 2020 at 01:56:49PM -0700, Nick Desaulniers wrote:
> > > > Hi Ingo,
> > > > I saw you picked up Arvind's other series into x86/boot.  Would you
> > > > mind please including this, as well?  Our CI is quite red for x86...
> > > >
> > > > EOM
> > > >
> > >
> > > Hi Ingo, while this patch is unnecessary after the series in
> > > tip/x86/boot, it is still needed for 5.9 and older. Would you be able to
> > > send it in for the next -rc? It shouldn't hurt the tip/x86/boot series,
> > > and we can add a revert on top of that later.
> > >
> > > Thanks.
> >
> > Ping.
> >
> > https://lore.kernel.org/lkml/20200812004308.1448603-1-nivedita@alum.mit.edu/
> 
> Acked-by: Ard Biesheuvel <ardb@kernel.org>

Thanks guys - queued up in tip:x86/urgent.

	Ingo
