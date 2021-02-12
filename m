Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3A731A052
	for <lists+stable@lfdr.de>; Fri, 12 Feb 2021 15:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231393AbhBLOIR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Feb 2021 09:08:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230174AbhBLOIQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Feb 2021 09:08:16 -0500
Received: from mail-ua1-x92f.google.com (mail-ua1-x92f.google.com [IPv6:2607:f8b0:4864:20::92f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28972C061574;
        Fri, 12 Feb 2021 06:07:36 -0800 (PST)
Received: by mail-ua1-x92f.google.com with SMTP id 67so2919022uao.1;
        Fri, 12 Feb 2021 06:07:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZZgcR0GXQOuQH7akp/dBCCzUPB9l3DB+PduIt221Fus=;
        b=LwSJnQ9Rf7hYrkwVZMRDzruVm0i2SDp4GtwQaF5CkTY3sHxUJlqfaTiUG7vBZXAysI
         WOoNc4c7DZJ90E9NDXYemZqoZftzw8SueDOMpxFaprmEeIWxuupOI48xua7PFgZI8TS2
         MuCOrmK594Wcb0qTFn9LPw7GwTDNCwh9ncvLk+z6UtHWdktN5PfbBC/eqFOXGzQgSFRX
         6mL3Xf0H7pWjn/qdsrKfrV6cCXfXLaCFmLaPkchfA9iTlodzvz2zBkByjRw0CbCAg6C2
         v4D6aUG3BvdFwACvMlf+yXZRTcYmAiy+DnflKtJ+Lel3IL+BqQIuvkeYDunVhLXs8/TL
         78+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZZgcR0GXQOuQH7akp/dBCCzUPB9l3DB+PduIt221Fus=;
        b=RyTUMBqqRIyEooJbQzYse8B8ZLYEyk7BhiabW6fyVxtChtaH/fzT2PrlwFY44JpBHO
         DxsPf8jEdXUFH+E6nQgxXLC6+JyO0ybPtrRdBZWp/kTE2PAVMmvtnY+vPmiCXHrHA9T8
         w62EcOBeEzMds5sqqwB/475YE9HN81kQhZn7A8JhwbdJcG5/Si3DAuzoxu6XN3r+UCAe
         NQalUkTO5QqIjEpftJf4WiIQThWos78TA3VS14UXOvu1OnmNqRTMwZmEC3VDTxjtMpt8
         LE32kRq6eLMQYZtg5csHYK2LNBdrxTQ2ssHuyE5U/TigyVxQUYZ4aYRBqHvTADiQhlcM
         HW1A==
X-Gm-Message-State: AOAM531tynFG4FL6PfeGy583hzRdiBEZlacKVv+l2qe6qogdgo2gAj6T
        vK+yV92usjV8UfXUbfE8TUWcoJoaFFhPrKcJ9wpboVRByxNCtQ==
X-Google-Smtp-Source: ABdhPJx92cVtlR8nyOwrnpqoQUY5gXSHyY10cEr8vAqdJP/vf9c/d7G1G7CJoeOQjImt0yesSCuQ+D8ttFlZsja+xBE=
X-Received: by 2002:ab0:338d:: with SMTP id y13mr1550050uap.64.1613138855360;
 Fri, 12 Feb 2021 06:07:35 -0800 (PST)
MIME-Version: 1.0
References: <20210205163752.11932-1-chris@chris-wilson.co.uk>
 <20210205220012.1983-1-chris@chris-wilson.co.uk> <CACvgo52u1ASWXOuWuDwoXvbZhoq+RHn_GTxD5y9k+kO_dzmT7w@mail.gmail.com>
 <pIyZ-Jj7O2MYk1vKeyghnFmiFWk_5ZWm-Ze1gUqdDaXzImOVjVdjPh2uyHa-sxOPovRk1ApSKk_5zKBvOrzoSwXeXUu0LbZ75Q1D3gIK2Kk=@emersion.fr>
In-Reply-To: <pIyZ-Jj7O2MYk1vKeyghnFmiFWk_5ZWm-Ze1gUqdDaXzImOVjVdjPh2uyHa-sxOPovRk1ApSKk_5zKBvOrzoSwXeXUu0LbZ75Q1D3gIK2Kk=@emersion.fr>
From:   Emil Velikov <emil.l.velikov@gmail.com>
Date:   Fri, 12 Feb 2021 14:07:23 +0000
Message-ID: <CACvgo50Bki0GKW0SNjzn9zieWqHO=curbVhkL0ALpA_d2E5bfw@mail.gmail.com>
Subject: Re: [PATCH v3] kcmp: Support selection of SYS_kcmp without CHECKPOINT_RESTORE
To:     Simon Ser <contact@emersion.fr>
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        ML dri-devel <dri-devel@lists.freedesktop.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        "# 3.13+" <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 12 Feb 2021 at 13:14, Simon Ser <contact@emersion.fr> wrote:
>
> On Friday, February 12th, 2021 at 1:57 PM, Emil Velikov <emil.l.velikov@gmail.com> wrote:
>
> > On Fri, 5 Feb 2021 at 22:01, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> > >
> > > Userspace has discovered the functionality offered by SYS_kcmp and has
> > > started to depend upon it. In particular, Mesa uses SYS_kcmp for
> > > os_same_file_description() in order to identify when two fd (e.g. device
> > > or dmabuf)
> >
> > As you rightfully point out, SYS_kcmp is a bit of a two edged sword.
> > While you mention the CONFIG issue, there is also a portability aspect
> > (mesa runs on more than just linux) and as well as sandbox filtering
> > of the extra syscall.
> >
> > Last time I looked, the latter was still an issue and mesa was using
> > SYS_kcmp to compare device node fds.
> > A far shorter and more portable solution is possible, so let me
> > prepare a Mesa patch.
>
> Comparing two DMA-BUFs can be done with their inode number, I think.
>
> Comparing two device FDs is more subtle, because of GEM handle
> ref'counting. You sometimes really want to check whether two FDs are
> backed by the same file *description*. See [1] for details.
>
Thanks for the correction and the reference.
Seems like I've short circuited file description table vs file descriptor.

Emil
