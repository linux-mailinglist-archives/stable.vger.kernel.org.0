Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C28C45342F
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 15:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230478AbhKPOdu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 09:33:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55185 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229644AbhKPOdt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 09:33:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637073052;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yGLlb2K1KnZJ8ryHE7dGxeg/3e8ozhLXbMUxWhBTJfg=;
        b=UudBm6wdgmJ4kALlTz63qQNkziF7kXOINDvQI1UAJwgKuUpPKp8UCT0V4j/208G1BFQYTW
        ax78ilIVQMdNz0vuXFytnkXa5A4NGB85TQ9m4IjovDiFA9Aa7Gqz8prrUSZtpFcM158iHf
        ORwfLxA83hvoBIdQKV3VvPNhSyCRc88=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-539-cUTo8ktjPlC0jfRFhptNsA-1; Tue, 16 Nov 2021 09:30:51 -0500
X-MC-Unique: cUTo8ktjPlC0jfRFhptNsA-1
Received: by mail-wm1-f70.google.com with SMTP id 144-20020a1c0496000000b003305ac0e03aso1291339wme.8
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 06:30:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yGLlb2K1KnZJ8ryHE7dGxeg/3e8ozhLXbMUxWhBTJfg=;
        b=GPtI8Gz5XuDK74rAGj9/WvU21J2CZhxOWlita6I4Oy+J1MHRTr1rHmNSKK0lnMYmga
         fSNCWlf+i89J2BKEv/OJgyofvqwPb/9fCkl0m3UIgFIYpS9qV0tmm6V46I8d/TjpDRAF
         ws1TrtAg1NZ/lq1zBVXqFHk4K9ldi1tSNOZquhqFU0oAQA6QVLsbPt8vSc0leqfi9w4F
         o90Ynt/+xpaT2iVhpOuHl4Ahz3vLzbgpPRxODlMXJMANvTUqgIeV068PTwp+tEVyFZq2
         t55LppObIVTgHxJgrIiCWjTxyaVVapLN4mT8h0Jkx3lyg4mtTmD6WiJhM+lvRfOilGPd
         675g==
X-Gm-Message-State: AOAM532erwt7UCp+7MLTN9G6+SlnYmN/7cl9SMBafOA3NiuTG0HHFePI
        SBscuWSqkcwRGFupv4bGHRfSlzhBfSgirjfB6egWE+/2/fqpk/5bWp172ctB4VVI4rt/NifXWnF
        XaLl/InOcQKCV4wKlo3ZTrTsuVGZ/+okc
X-Received: by 2002:a5d:628f:: with SMTP id k15mr10058475wru.363.1637073048897;
        Tue, 16 Nov 2021 06:30:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwwQ9c1DU7hDbd1YcLisoG+/tIlG+wgenks4qBRCL9wz5r2a/gmGwOMoiIhDt4fczvM+rVPkw3QVsAVHXwsGUM=
X-Received: by 2002:a5d:628f:: with SMTP id k15mr10058457wru.363.1637073048723;
 Tue, 16 Nov 2021 06:30:48 -0800 (PST)
MIME-Version: 1.0
References: <20211115165313.549179499@linuxfoundation.org> <20211115165315.847107930@linuxfoundation.org>
 <CAHc6FU7a+gTDCZMCE6gOH1EDUW5SghPbQbsbeVtdg4tV1VdGxg@mail.gmail.com>
 <YZMBVdDZzjE6Pziq@sashalap> <CAHc6FU4cgAXc2GxYw+N=RACPG0xc=urrrqw8Gc3X1Rpr4255pg@mail.gmail.com>
 <YZO4wIfpjxnzZjuh@kroah.com> <CAHc6FU7BU2-B2x=JV0HtLci6=mGy2XxLNNGh1f4DGtVbeJFcVA@mail.gmail.com>
 <YZO9Bv3yJC5P92c8@kroah.com>
In-Reply-To: <YZO9Bv3yJC5P92c8@kroah.com>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Tue, 16 Nov 2021 15:30:37 +0100
Message-ID: <CAHc6FU74ih7Sk7tWmvMy9OsyO2=f0cO7fUoBREKnFQSKf+zyig@mail.gmail.com>
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

On Tue, Nov 16, 2021 at 3:15 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Tue, Nov 16, 2021 at 03:00:19PM +0100, Andreas Gruenbacher wrote:
> > On Tue, Nov 16, 2021 at 2:57 PM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > > On Tue, Nov 16, 2021 at 02:54:10PM +0100, Andreas Gruenbacher wrote:
> > > > On Tue, Nov 16, 2021 at 1:54 AM Sasha Levin <sashal@kernel.org> wrote:
> > > > > On Mon, Nov 15, 2021 at 06:47:41PM +0100, Andreas Gruenbacher wrote:
> > > > > >Greg,
> > > > > >
> > > > > >On Mon, Nov 15, 2021 at 6:10 PM Greg Kroah-Hartman
> > > > > ><gregkh@linuxfoundation.org> wrote:
> > > > > >> From: Andreas Gruenbacher <agruenba@redhat.com>
> > > > > >>
> > > > > >> commit 0c8eb2884a42d992c7726539328b7d3568f22143 upstream.
> > > > > >>
> > > > > >> When switching from __get_user to fault_in_pages_readable, commit
> > > > > >> 9f9eae5ce717 broke kvm_use_magic_page: like __get_user,
> > > > > >> fault_in_pages_readable returns 0 on success.
> > > > > >
> > > > > >I've not heard back from the maintainers about this patch so far, so
> > > > > >it would probably be safer to leave it out of stable for now.
> > > > >
> > > > > What do you mean exactly? It's upstream.
> > > >
> > > > Mathieu Malaterre broke this test in 2018 (commit 9f9eae5ce717) but
> > > > that wasn't noticed until now (commit 0c8eb2884a42). This means that
> > > > this fix probably isn't critical, so I shouldn't be backported.
> > >
> > > Then why did you tag it to be explicitly backported to all stable
> > > kernels newer than 4.18?
> >
> > Well, sorry for that. What else do you expect me to do in addition to
> > pointing out the mistake?
>
> Ah, I think we are misunderstanding each other here.  I will go drop it,
> but in the future maybe "hey, I didn't mean to mark this for stable, can
> you please drop it?" might be a bit more direct and to the point.

Yes, the stable Cc was an accident on my side (caused by a script that
takes a SHA1 and spits out Fixes: and Cc: tags). Sorry and thanks for
dropping the patch.

Andreas

