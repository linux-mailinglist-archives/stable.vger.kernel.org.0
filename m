Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B85232B0B8
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345264AbhCCAyh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:54:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235076AbhCCAUZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 19:20:25 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 996EBC06178A
        for <stable@vger.kernel.org>; Tue,  2 Mar 2021 16:19:19 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id 133so22638122ybd.5
        for <stable@vger.kernel.org>; Tue, 02 Mar 2021 16:19:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JW1Fu4Y9hN6xAYARes5cfh1tpWz1vPxhWkj9gQP9lMg=;
        b=u1nwXvtWmXFyEWnp6VppaODAurHV9DyB0Hjtg4WhYgLJVNAaoIYeGJZvU43qMBUJ6E
         IimgA+XS3J5QwuPCb+tO6o9paf11kNThyRGMElbfERtDWM6tg7RKMBHM6hkBjx2TNkFj
         OZn61IWqGoUx1mJO0BlY3FtpWDlbc6MErJ8pv/xoVwQa2urYmDCCwSmKgctPgLkBb44M
         cWiqTvILyMC8/sIgRNeraaWg8r7RXj9ftkUPl7pCM2LV0SUr8p9hhBKyfWKaFXBtJr/j
         Yac8vr0Eod4rNzqVMvFe38E7kuDnD2dppBfLoaFX266TkyDIxtSKKz6k1RFaXJlguCV0
         mu7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JW1Fu4Y9hN6xAYARes5cfh1tpWz1vPxhWkj9gQP9lMg=;
        b=RHZoPZmX8VimY+lu0OJYvKANgd2x7WZt6EMzwo5v5c5gWW2Fm7H0l6SiJi8XdR/hvK
         uVu0gA6oMk648rvfZpqa0IJInvlL5r1uFEv7b7kjDzPdIfP+aRW/aEx5P9M515GbCJVt
         jqTDh3GrVD9cWWnrBu5zkGLYhH/ZU6wvvo1I4oO5UkhPZuGttPSsNnUNjSBENrnzC6HG
         Pa/sbLdMUJ1uTrnB1MK2vV4JnPK6CwNfiPjSvsgWCUnpGX3uRFTa1LKCTK66bW2fqjSd
         OEEjTAEYl5YTthyeQV3hlUKajDOZ8r1vMZVDjE3eyTOneNaHZGh7DQESNrlXSTcZpAEh
         dV7w==
X-Gm-Message-State: AOAM533n7Aosi76pXhSCD4BAO6QtaBpQre9DhM7jTmVh6gBwFXFWtDQP
        Y4iR6aR21+I6+shZ87KNsiNWx6fmIy4cxAu6Bjd1kw==
X-Google-Smtp-Source: ABdhPJyRJft9qC3F2zEP87gLkkL8hWzq9DSLyGwU9vBpLj1qV5qHyP+0wGclenGJnbIjvyqXGUZQfBpD7UTJ5dJvT2k=
X-Received: by 2002:a25:d74b:: with SMTP id o72mr33962620ybg.190.1614730758774;
 Tue, 02 Mar 2021 16:19:18 -0800 (PST)
MIME-Version: 1.0
References: <20210111170622.2613577-1-surenb@google.com> <20210112074629.GG22493@dhcp22.suse.cz>
 <20210112174507.GA23780@redhat.com> <CAJuCfpFQz=x-LvONO3c4iqjKP4NKJMgUuiYc8HACKHAv1Omu0w@mail.gmail.com>
 <20210113142202.GC22493@dhcp22.suse.cz> <CAG48ez0=QSzuj96+5oVQ2qWqfjedv3oKtfEFzw--C8bzfvj7EQ@mail.gmail.com>
 <20210126135254.GP827@dhcp22.suse.cz> <CAJuCfpEnMyo9XAnoF+q1j9EkC0okZfUxxdAFhzhPJi+adJYqjw@mail.gmail.com>
 <CAJuCfpF861zhp8yR_pYx8gb+WMrORAZ0tbzcKtKxaj7L=jzw+Q@mail.gmail.com>
 <CAJuCfpFzxiBXp1rdY=H=bX+eOAVGOe72_FxwC-NTWF4fhUO26g@mail.gmail.com>
 <CAJuCfpEOE8=L1fT4FSauy65cS82M_kW3EzTgH89ewE9HudL=VA@mail.gmail.com> <20210302161716.89a65d3cb5b60dbc5074cfa7@linux-foundation.org>
In-Reply-To: <20210302161716.89a65d3cb5b60dbc5074cfa7@linux-foundation.org>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Tue, 2 Mar 2021 16:19:07 -0800
Message-ID: <CAJuCfpF72mevYd4zQ_q-Tyn+Bj-fa7ywudu=iM6L7e4B-42fpg@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] mm/madvise: replace ptrace attach requirement for process_madvise
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Jann Horn <jannh@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Jeffrey Vander Stoep <jeffv@google.com>,
        Minchan Kim <minchan@kernel.org>,
        Shakeel Butt <shakeelb@google.com>,
        David Rientjes <rientjes@google.com>,
        =?UTF-8?Q?Edgar_Arriaga_Garc=C3=ADa?= <edgararriaga@google.com>,
        Tim Murray <timmurray@google.com>,
        linux-mm <linux-mm@kvack.org>,
        SElinux list <selinux@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-team <kernel-team@android.com>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Michal Hocko <mhocko@suse.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 2, 2021 at 4:17 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Tue, 2 Mar 2021 15:53:39 -0800 Suren Baghdasaryan <surenb@google.com> wrote:
>
> > Hi Andrew,
> > A friendly reminder to please include this patch into mm tree.
> > There seem to be no more questions or objections.
> > The man page you requested is accepted here:
> > https://git.kernel.org/pub/scm/docs/man-pages/man-pages.git/commit/?id=a144f458bad476a3358e3a45023789cb7bb9f993
> > stable is CC'ed and this patch should go into 5.10 and later kernels
> > The patch has been:
> > Acked-by: Minchan Kim <minchan@kernel.org>
> > Acked-by: David Rientjes <rientjes@google.com>
> > Reviewed-by: Kees Cook <keescook@chromium.org>
> >
> > If you want me to resend it, please let me know.
>
> This patch was tough.  I think it would be best to resend please, being
> sure to cc everyone who commented.  To give everyone another chance to
> get their heads around it.  If necessary, please update the changelog
> to address any confusion/questions which have arisen thus far.

Sure, will do. Thanks!

>
> Thanks.
