Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BDE24533EF
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 15:17:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237334AbhKPOSy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 09:18:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:39566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237135AbhKPOSh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Nov 2021 09:18:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D745661C15;
        Tue, 16 Nov 2021 14:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637072137;
        bh=ARYZ/KAk+Sx6/zGZBiU8VPwpSlxLHxlxlM4y0Rsa1Lo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hx5Eqn1ufpAwBFR0hl+jBrXdoy+l6JZhrbrqKpU8O8BzrxjhJK81R1Tg2ZypIfNQr
         D0JSJpCdSZNA73cMsHLwof056uh6mCJ4DLZORD/YVAe8aNFDGzCxxmIIZ5s3dfxLQ6
         GAdemop4nd257CerWGEKMgbard0yzz9mHyBKx798=
Date:   Tue, 16 Nov 2021 15:15:34 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Andreas Gruenbacher <agruenba@redhat.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Mathieu Malaterre <malat@debian.org>,
        Paul Mackerras <paulus@ozlabs.org>, kvm-ppc@vger.kernel.org
Subject: Re: [PATCH 5.4 063/355] powerpc/kvm: Fix kvm_use_magic_page
Message-ID: <YZO9Bv3yJC5P92c8@kroah.com>
References: <20211115165313.549179499@linuxfoundation.org>
 <20211115165315.847107930@linuxfoundation.org>
 <CAHc6FU7a+gTDCZMCE6gOH1EDUW5SghPbQbsbeVtdg4tV1VdGxg@mail.gmail.com>
 <YZMBVdDZzjE6Pziq@sashalap>
 <CAHc6FU4cgAXc2GxYw+N=RACPG0xc=urrrqw8Gc3X1Rpr4255pg@mail.gmail.com>
 <YZO4wIfpjxnzZjuh@kroah.com>
 <CAHc6FU7BU2-B2x=JV0HtLci6=mGy2XxLNNGh1f4DGtVbeJFcVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHc6FU7BU2-B2x=JV0HtLci6=mGy2XxLNNGh1f4DGtVbeJFcVA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 16, 2021 at 03:00:19PM +0100, Andreas Gruenbacher wrote:
> On Tue, Nov 16, 2021 at 2:57 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Tue, Nov 16, 2021 at 02:54:10PM +0100, Andreas Gruenbacher wrote:
> > > On Tue, Nov 16, 2021 at 1:54 AM Sasha Levin <sashal@kernel.org> wrote:
> > > > On Mon, Nov 15, 2021 at 06:47:41PM +0100, Andreas Gruenbacher wrote:
> > > > >Greg,
> > > > >
> > > > >On Mon, Nov 15, 2021 at 6:10 PM Greg Kroah-Hartman
> > > > ><gregkh@linuxfoundation.org> wrote:
> > > > >> From: Andreas Gruenbacher <agruenba@redhat.com>
> > > > >>
> > > > >> commit 0c8eb2884a42d992c7726539328b7d3568f22143 upstream.
> > > > >>
> > > > >> When switching from __get_user to fault_in_pages_readable, commit
> > > > >> 9f9eae5ce717 broke kvm_use_magic_page: like __get_user,
> > > > >> fault_in_pages_readable returns 0 on success.
> > > > >
> > > > >I've not heard back from the maintainers about this patch so far, so
> > > > >it would probably be safer to leave it out of stable for now.
> > > >
> > > > What do you mean exactly? It's upstream.
> > >
> > > Mathieu Malaterre broke this test in 2018 (commit 9f9eae5ce717) but
> > > that wasn't noticed until now (commit 0c8eb2884a42). This means that
> > > this fix probably isn't critical, so I shouldn't be backported.
> >
> > Then why did you tag it to be explicitly backported to all stable
> > kernels newer than 4.18?
> 
> Well, sorry for that. What else do you expect me to do in addition to
> pointing out the mistake?

Ah, I think we are misunderstanding each other here.  I will go drop it,
but in the future maybe "hey, I didn't mean to mark this for stable, can
you please drop it?" might be a bit more direct and too the point.
Otherwise we are all confused here...

thanks,

greg k-h
