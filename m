Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6792C31C2
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 21:14:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730378AbgKXUMo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Nov 2020 15:12:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:55110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730374AbgKXUMo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Nov 2020 15:12:44 -0500
Received: from localhost (82-217-20-185.cable.dynamic.v4.ziggo.nl [82.217.20.185])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 863502067D;
        Tue, 24 Nov 2020 20:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606248763;
        bh=5TYfcvnFUiyh+LyvW754Bv72A9suVLV+8VyJ1FtozTQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g1vhBSKxDZ4jWku4fHTxwF3C2s9zUfak8qyjECz+Erp+L8OQ7gqPs4QNuc38Lpwac
         gRg5qnq284K+B5GZosZChB7AgI6675A4rpftZpareEDRepa+Wewvp97tQ/uC9xCMSW
         XXEMq5DNjd1CoqsTGlz4TZhJLZJaY0ti12mXIYeM=
Date:   Tue, 24 Nov 2020 21:12:40 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     Lukas Wunner <lukas@wunner.de>, Mark Brown <broonie@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, kdasu.kdev@gmail.com,
        Stable <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] spi: bcm-qspi: Fix use-after-free on
 unbind" failed to apply to 5.4-stable tree
Message-ID: <X71pOJT1L4M9iIRh@kroah.com>
References: <160612300715987@kroah.com>
 <20201124134123.ie5jvzygygayajo5@debian>
 <X71Lv314xaqrtn9B@kroah.com>
 <CADVatmMFEYRSKcq4mkZqs0feVPSWX9miG49ffbCR0utLtFSgfA@mail.gmail.com>
 <CADVatmNVjKBAZPh2voCHaFdAaU3pz2fs0sdL58eLSD4d-W8LQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADVatmNVjKBAZPh2voCHaFdAaU3pz2fs0sdL58eLSD4d-W8LQg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 24, 2020 at 07:28:44PM +0000, Sudip Mukherjee wrote:
> On Tue, Nov 24, 2020 at 6:53 PM Sudip Mukherjee
> <sudipm.mukherjee@gmail.com> wrote:
> >
> > Hi Greg,
> >
> > On Tue, Nov 24, 2020 at 6:06 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Tue, Nov 24, 2020 at 01:41:23PM +0000, Sudip Mukherjee wrote:
> > > > Hi Greg,
> > > >
> > > > On Mon, Nov 23, 2020 at 10:16:47AM +0100, gregkh@linuxfoundation.org wrote:
> > > > >
> > > > > The patch below does not apply to the 5.4-stable tree.
> > > > > If someone wants it applied there, or to any other stable or longterm
> > > > > tree, then please email the backport, including the original git commit
> > > > > id to <stable@vger.kernel.org>.
> > > >
> > > > Here is the backport for all the stable tree from v4.9.y to v5.4.y.
> > >
> > > THis didn't apply to 4.9.y, are you sure you tried that?
> > >
> > > Anyway, queued up for all other branches, thanks!
> >
> > I was modifying one of my script which pulls in the stablerc and
> > stable-queue and I have completely messed up today  :(
> > Please drop this from v4.14.y. It will fail to build there. I had been
> > working on the version for v4.14.y and v4.9.y, but I will keep it
> > aside for today.
> > Really sorry for the confusion.
> 
> v4.19.y also. :(
> I have rechecked and only v5.4.y is ok.

Now dropped from both trees, my CI testing also just hit this :)

thanks,

gre gk-h
