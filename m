Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C4DF44B08D
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 16:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237658AbhKIPnX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 10:43:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239365AbhKIPnU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Nov 2021 10:43:20 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18E1FC061764
        for <stable@vger.kernel.org>; Tue,  9 Nov 2021 07:40:34 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id r12so78129550edt.6
        for <stable@vger.kernel.org>; Tue, 09 Nov 2021 07:40:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+EMLv0pX3sIpS9VRqQg2XXcKPnGn9gonP2t0LoKW7zE=;
        b=h/Fa9WFlfmnLechT6MgfRSeyUVjQ3/K7bzwP5M66KEKaXdGCwx72PVDR4I5OxdBwY+
         3fGtXz9DVagZCZ5kB+A55IRmxubkSQNCgiHUbrB09KuUlJjsawZFk09imA9i+BgH4dnw
         6WMyRfFQhUKa8l6JreqEzIbIjmO5Y5OSOXhAOYpNOy5WlZvOQWhftvMj8DGuTeofr5va
         MvhSNoFRzV9uhCRh68SgpWmfQmGbPT37PirqvAij5/4wQyQsDqIXJZxean8uhmnJ7b9L
         jI8pGJA4MFcDQOuS1me+U1qeUnAerF/u8UHPeLCoj785+4JIO5usFT4WOGZfTzSR4bJg
         Jl0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+EMLv0pX3sIpS9VRqQg2XXcKPnGn9gonP2t0LoKW7zE=;
        b=vinMrCNKtckoobVjwoLZ/gUdTWWqi/FAc5VrM6Sksp44OIyz1WExaOhgDxIIPxto9l
         U8RJTcF6uk3feVhbbv1zZnslmSQkG2Qre+jiD87sYM1BbD0/uiuMv/6lHoLuJF43Pr+l
         qKDqtH5P5cRrEdt7IWywj3wUmuZuwDeoD6aDeNhPmcQomaBHyx7C4Z9HekuYtUsxKpFR
         4x3xwImpwLaKxVLs4AOnZqLvjCGZp7IvhLFuA6IilGqSxVzMdWGY0xmC4VIHKNnnCaEw
         LNtOpTqpUq6ByXHqz4saynAK0+ibDD7PZ5ndjcLqYbpu0OjCLdv6YNxmd/cEgu44QIYb
         Lh9w==
X-Gm-Message-State: AOAM533FqNdi+3K6eT12v0LAPY555h8+nilbunZ9L66hw2ayX8KthkDn
        Ta9mQbW/+auBrdHFXTF+xH658Kpq8qxck0AIZ3ZFZMVtSw==
X-Google-Smtp-Source: ABdhPJzSQTH2LJ1AVXHiY2Dg4IxZT6qJ+uc62ENTXTHrD/Jf5Lsm4AzI6zU0zWX85GBY4cTy7BwAa+HPOsuBnWbZ+9M=
X-Received: by 2002:a05:6402:4309:: with SMTP id m9mr11411917edc.93.1636472432491;
 Tue, 09 Nov 2021 07:40:32 -0800 (PST)
MIME-Version: 1.0
References: <1636442582487@kroah.com> <CAHRSSEyv5j36HYKRmkBowhUN2Wu5xh5rrGHdTJW50_VUwe__Cw@mail.gmail.com>
In-Reply-To: <CAHRSSEyv5j36HYKRmkBowhUN2Wu5xh5rrGHdTJW50_VUwe__Cw@mail.gmail.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 9 Nov 2021 10:40:21 -0500
Message-ID: <CAHC9VhQTTdi69-pz86-Vd5PyqrOdxvoLev1nD4N+QUGwRJs_ng@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] binder: use euid from cred instead of
 using task" failed to apply to 4.4-stable tree
To:     Todd Kjos <tkjos@google.com>
Cc:     gregkh@linuxfoundation.org, casey@schaufler-ca.com,
        jannh@google.com, stephen.smalley.work@gmail.com,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 9, 2021 at 10:38 AM Todd Kjos <tkjos@google.com> wrote:
> Hi Greg. I'll post backports for these this week.

Thanks Todd, I was going to ping you later today to see if you were
planning to work on these.  If you run into any problems or can't get
to them let me know.

> On Mon, Nov 8, 2021 at 11:23 PM <gregkh@linuxfoundation.org> wrote:
> > The patch below does not apply to the 4.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> >
> > thanks,
> >
> > greg k-h
> >
> > ------------------ original commit in Linus's tree ------------------
> >
> > From 29bc22ac5e5bc63275e850f0c8fc549e3d0e306b Mon Sep 17 00:00:00 2001
> > From: Todd Kjos <tkjos@google.com>
> > Date: Tue, 12 Oct 2021 09:56:12 -0700
> > Subject: [PATCH] binder: use euid from cred instead of using task
> >
> > Save the 'struct cred' associated with a binder process
> > at initial open to avoid potential race conditions
> > when converting to an euid.
> >
> > Set a transaction's sender_euid from the 'struct cred'
> > saved at binder_open() instead of looking up the euid
> > from the binder proc's 'struct task'. This ensures
> > the euid is associated with the security context that
> > of the task that opened binder.
> >
> > Cc: stable@vger.kernel.org # 4.4+
> > Fixes: 457b9a6f09f0 ("Staging: android: add binder driver")
> > Signed-off-by: Todd Kjos <tkjos@google.com>
> > Suggested-by: Stephen Smalley <stephen.smalley.work@gmail.com>
> > Suggested-by: Jann Horn <jannh@google.com>
> > Acked-by: Casey Schaufler <casey@schaufler-ca.com>
> > Signed-off-by: Paul Moore <paul@paul-moore.com>

-- 
paul moore
www.paul-moore.com
