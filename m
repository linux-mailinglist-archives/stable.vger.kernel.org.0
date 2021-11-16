Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8389C453376
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 15:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237015AbhKPODh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 09:03:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57208 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237014AbhKPODd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 09:03:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637071235;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AQWT9RsItIh3/PVThc0IzK61qGCHH7mYKsvmzbBvIIU=;
        b=ipFEV9z+5N0l7ZXte9d/sXOnmSuRcgq/ckodIqCApH7lSVfsWgvkzM/c2h32VWj9jjX0MT
        A8TadtOAJV5BGUDWCBSZNWgIbNihCk46KC8zNr9QFSN7iwzVuT4cIwUgjvRxrSTF7uIxAx
        x2ZG2gd9/XsZQeg5JzW1DaozKWgsWzk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-236-vH2yZ52hNnOpfPTO4-4EaA-1; Tue, 16 Nov 2021 09:00:34 -0500
X-MC-Unique: vH2yZ52hNnOpfPTO4-4EaA-1
Received: by mail-wm1-f70.google.com with SMTP id b145-20020a1c8097000000b003335872db8dso6797313wmd.2
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 06:00:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AQWT9RsItIh3/PVThc0IzK61qGCHH7mYKsvmzbBvIIU=;
        b=B8RWJzC83j/hGTCk84ATR0cpK5diJfao2Zck3CkEQQMz8/YY0OP+TQ/+jJ62AF0q6P
         X0KC/MPxSlaavOhdgvBOkQIeg7CnVbDXrO5gB5iGvdDP3e1u8keHuPNpwdBIkpAwieEQ
         +cPpisY/X2em8dKQCmpcZTJ4sEHfSdUD7LU9+0tYmCCCErPqXce8f/07rfRzhrWr6FuS
         6UZQuKjKC2+EPqGcNiSf+GWmz4SHhNbdk0hgKRwkpq/kY3SiUvdjy2aqbX9QZvLZ3jzT
         v7SWhLjgxLpUZqs5HE1+vqmABBhg1inJEHR6FLx7XJPpZiibJwAXmjGgQ4vA2Bi8/FOU
         PrCg==
X-Gm-Message-State: AOAM530y0yFgHSx0zfZs7zwWkpDG1HG+X8S+LUFz+kSD0M3qIN0OHU5u
        CtZcNNFLRdYKa+rBQhpRcOCh8/fN80rNPUktwNI8rBowTI29BqC8Fz+6dEJJrTOYq0I2QExW6Wt
        uE9QA8SabsWmrSYg4jusN+da4eKFdDf6T
X-Received: by 2002:a1c:ed1a:: with SMTP id l26mr71507144wmh.19.1637071231358;
        Tue, 16 Nov 2021 06:00:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyrxhf6z7sBAJvOpOOUlfL2JU/LuAMJYJ+PkN53D7lmXU6CXnBwDHswetyBwnxBUgS4/QIsBFAXBYWEfbCCjFQ=
X-Received: by 2002:a1c:ed1a:: with SMTP id l26mr71507103wmh.19.1637071231144;
 Tue, 16 Nov 2021 06:00:31 -0800 (PST)
MIME-Version: 1.0
References: <20211115165313.549179499@linuxfoundation.org> <20211115165315.847107930@linuxfoundation.org>
 <CAHc6FU7a+gTDCZMCE6gOH1EDUW5SghPbQbsbeVtdg4tV1VdGxg@mail.gmail.com>
 <YZMBVdDZzjE6Pziq@sashalap> <CAHc6FU4cgAXc2GxYw+N=RACPG0xc=urrrqw8Gc3X1Rpr4255pg@mail.gmail.com>
 <YZO4wIfpjxnzZjuh@kroah.com>
In-Reply-To: <YZO4wIfpjxnzZjuh@kroah.com>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Tue, 16 Nov 2021 15:00:19 +0100
Message-ID: <CAHc6FU7BU2-B2x=JV0HtLci6=mGy2XxLNNGh1f4DGtVbeJFcVA@mail.gmail.com>
Subject: Re: [PATCH 5.4 063/355] powerpc/kvm: Fix kvm_use_magic_page
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Mathieu Malaterre <malat@debian.org>,
        Paul Mackerras <paulus@ozlabs.org>, kvm-ppc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 16, 2021 at 2:57 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Tue, Nov 16, 2021 at 02:54:10PM +0100, Andreas Gruenbacher wrote:
> > On Tue, Nov 16, 2021 at 1:54 AM Sasha Levin <sashal@kernel.org> wrote:
> > > On Mon, Nov 15, 2021 at 06:47:41PM +0100, Andreas Gruenbacher wrote:
> > > >Greg,
> > > >
> > > >On Mon, Nov 15, 2021 at 6:10 PM Greg Kroah-Hartman
> > > ><gregkh@linuxfoundation.org> wrote:
> > > >> From: Andreas Gruenbacher <agruenba@redhat.com>
> > > >>
> > > >> commit 0c8eb2884a42d992c7726539328b7d3568f22143 upstream.
> > > >>
> > > >> When switching from __get_user to fault_in_pages_readable, commit
> > > >> 9f9eae5ce717 broke kvm_use_magic_page: like __get_user,
> > > >> fault_in_pages_readable returns 0 on success.
> > > >
> > > >I've not heard back from the maintainers about this patch so far, so
> > > >it would probably be safer to leave it out of stable for now.
> > >
> > > What do you mean exactly? It's upstream.
> >
> > Mathieu Malaterre broke this test in 2018 (commit 9f9eae5ce717) but
> > that wasn't noticed until now (commit 0c8eb2884a42). This means that
> > this fix probably isn't critical, so I shouldn't be backported.
>
> Then why did you tag it to be explicitly backported to all stable
> kernels newer than 4.18?

Well, sorry for that. What else do you expect me to do in addition to
pointing out the mistake?

Thanks,
Andreas

