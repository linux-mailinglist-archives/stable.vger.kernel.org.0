Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7E88478CCF
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 14:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236859AbhLQNwR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 08:52:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233098AbhLQNwP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 08:52:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C531C061574
        for <stable@vger.kernel.org>; Fri, 17 Dec 2021 05:52:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25417B82829
        for <stable@vger.kernel.org>; Fri, 17 Dec 2021 13:52:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EFABC36AE7;
        Fri, 17 Dec 2021 13:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639749133;
        bh=+orTszM7C0llVhhPoXQ91wJ1KN45A+z72JBISFqqj20=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V2QMwLkRpWqml7MG0iXAVTfqBAdvaPXxAZjX8vfShoNFkarxaTVPdjufGeHXVtmZb
         QzrUny/IfhA7rRYwG+RO63x+BCl2FLs0pFyjSSz990Oilcc4tYZd62OFpkq10xif2k
         /ckW94axpem1bhwvJ1nFBs8cKvBtji9LGwTC9YDE=
Date:   Fri, 17 Dec 2021 14:52:10 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Bruce Fields <bfields@redhat.com>
Cc:     Salvatore Bonaccorso <carnil@debian.org>, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] nfsd: fix use-after-free due to
 delegation race" failed to apply to 4.19-stable tree
Message-ID: <YbyWCuLez/dfPAtn@kroah.com>
References: <1639314690415@kroah.com>
 <Ybub/RYZeQkEBGcI@eldamar.lan>
 <CAPL3RVHXmJrnkcUK1YYv4XD3JvE6su5tuH4kyVCnZ+ukGF+rUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPL3RVHXmJrnkcUK1YYv4XD3JvE6su5tuH4kyVCnZ+ukGF+rUg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 16, 2021 at 09:42:26PM -0500, Bruce Fields wrote:
> On Thu, Dec 16, 2021 at 3:05 PM Salvatore Bonaccorso <carnil@debian.org> wrote:
> > On Sun, Dec 12, 2021 at 02:11:30PM +0100, gregkh@linuxfoundation.org wrote:
> > > The patch below does not apply to the 4.19-stable tree.
> > > If someone wants it applied there, or to any other stable or longterm
> > > tree, then please email the backport, including the original git commit
> > > id to <stable@vger.kernel.org>.
> >
> > Unless I'm completely wrong this only does not apply to the older
> > series because in 5.6-rc1 we had 20b7d86f29d3 ("nfsd: use boottime for
> > lease expiry calculation") soe there is a minor context change in one
> > hunk.
> >
> > Attached is a patch accounting for that, Bruce is this okay?
> 
> Yes, this looks fine to me.  Thank you!

Now queued up, thanks.

greg k-h
