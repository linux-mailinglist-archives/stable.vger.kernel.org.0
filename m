Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 405EF3FE8B3
	for <lists+stable@lfdr.de>; Thu,  2 Sep 2021 07:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbhIBF3o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Sep 2021 01:29:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:44190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231324AbhIBF3o (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Sep 2021 01:29:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 58A406069E;
        Thu,  2 Sep 2021 05:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630560526;
        bh=wuT0NIH9bYCekekfs5fpv2mHqVTwUkRu69rjXCvQtJg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FSDLJms0TcbJRGfXzZu2wSx7UxKotuijKflZgk9kwx2u7Ot1SwnkaqjZ3DnWCuDUw
         dz8g6EpsMKkx9+B0lC092ZFfLytcywnF8UHIlVL33tr46HcMYgGU7TpiExB3uK+pS0
         dUTkQ0RqxbnB4Gi7cvTFZjFGxjIJ399mmI/67ZDE=
Date:   Thu, 2 Sep 2021 07:28:40 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dongliang Mu <mudongliangabcd@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Subject: Re: Linux kernel 4.19 and below misses the patch - "fbmem: add
 margin check to fb_check_caps()"
Message-ID: <YTBhCPBu/5UhEsxF@kroah.com>
References: <CAD-N9QUhebBrJ1fZG-i09PSKjC9Vat3Ym5VHoOrXGAO_tKQdpQ@mail.gmail.com>
 <YS8bvAc4XbaxSssu@kroah.com>
 <CAD-N9QXikdSxPnTnEsU3KUYkjXsOpKR14JQ_-+B7OEzMOnjTSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD-N9QXikdSxPnTnEsU3KUYkjXsOpKR14JQ_-+B7OEzMOnjTSA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 02, 2021 at 09:32:32AM +0800, Dongliang Mu wrote:
> On Wed, Sep 1, 2021 at 2:20 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Aug 31, 2021 at 02:47:22PM +0800, Dongliang Mu wrote:
> > > Hi stable maintainers,
> > >
> > > It seems that Linux kernel 4.19 and below miss the patch - "fbmem: add
> > > margin check to fb_check_caps()" [1]. Linux kernel 5.4 and up is
> > > already merged this patch[2].
> > >
> > > Are there any special issues about this patch? Why do maintainers miss
> > > such a patch?
> >
> > Because it does not apply to those older kernels.  If you feel it should
> > be included there, can you please provide a working backport of the
> > patch so that we can apply it?
> 
> Sure, I will do that. Which mailing list or maintainers should I send to?

Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.
