Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3D6C2AFF8B
	for <lists+stable@lfdr.de>; Thu, 12 Nov 2020 07:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725966AbgKLGPr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Nov 2020 01:15:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:42014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725290AbgKLGPr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Nov 2020 01:15:47 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D35C52084C;
        Thu, 12 Nov 2020 06:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605161746;
        bh=SeJAIDjN2EwG5IkbmmLw8JQkt43PYoeaK0Bx6QxzIcA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NAzkoDePtnZgIUiARfVggEuAVUQ3zNhrXlbIVgLmmJCHodxGKhZyZJf8aaDUDPbOE
         K0iYytWBJ2uMYsofAIqd2ucpiJeI3Vr6GTtWAHnPZOVh2GqoVwv1MUAJXqQlEjOVt0
         H4rKVzf4KOOoGhWcUlMRUg8ti+vT7OYwt5x0tmdY=
Date:   Thu, 12 Nov 2020 07:15:42 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Anand K. Mistry" <amistry@google.com>
Cc:     stable@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: Requesting stable merge for commit
 1978b3a53a74e3230cd46932b149c6e62e832e9a
Message-ID: <X6zTDralvod85Z9t@kroah.com>
References: <CAATStaPeE+SEXGNU0kcrsNgqRZgg6+9j1fw5KqLPUoCGjUP=qQ@mail.gmail.com>
 <X6vX7rJmlgjQqvlA@kroah.com>
 <CAATStaMd772bg8vBBNhb-zTyx-OmvPuNoVfDLtqj6QGcL_RfxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAATStaMd772bg8vBBNhb-zTyx-OmvPuNoVfDLtqj6QGcL_RfxA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 12, 2020 at 10:12:01AM +1100, Anand K. Mistry wrote:
> On Wed, 11 Nov 2020 at 23:23, Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Wed, Nov 11, 2020 at 11:09:13PM +1100, Anand K. Mistry wrote:
> > > Hi,
> > >
> > > I'm requesting a stable merge for commit
> > > 1978b3a53a74e3230cd46932b149c6e62e832e9a
> > > ("x86/speculation: Allow IBPB to be conditionally enabled on CPUs with
> > > always-on STIBP")
> > > into the stable branch for 5.4. Note, the commit is already queued for
> > > inclusion into the next 5.9 stable release
> > > (https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/queue-5.9/x86-speculation-allow-ibpb-to-be-conditionally-enabl.patch).
> > >
> > > The patch fixes an issue where a Spectre-v2-user mitigation could not
> > > be enabled via prctl() on certain AMD CPUs. The issue was introduced
> > > in commit 21998a351512eba4ed5969006f0c55882d995ada
> > > ("x86/speculation: Avoid force-disabling IBPB based on STIBP and
> > > enhanced IBRS.")
> > > which was merged into the 5.4 stable branch as commit
> > > 6d60d5462a91eb46fb88b016508edfa8ee0bc7c8. This commit also exists in
> > > 4.19, 4.14, 4.9, and 4.4, so those kernels are also likely affected by
> > > this bug.
> >
> > As I asked when I sent out a "FAILED:" message for this patch, if
> > someone wants it backported to older kernels, they will need to provide
> > the backported versions of it, as the patch does not apply cleanly
> > as-is.
> >
> > Can you please do that?
> 
> Oh, I didn't get that message. I'll prepare a backport.

You didn't have to get the email, but I would assume that you at least
tested the backport if you asked for it to happen, right?  :)

thanks,

greg k-h
