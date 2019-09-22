Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55192BA174
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 10:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727835AbfIVIQl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 04:16:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:54586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727810AbfIVIQl (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 04:16:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC09020820;
        Sun, 22 Sep 2019 08:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569140201;
        bh=MtmRpoX9CuCJEjFah6WwHj2OtS+7+3xa9Gn1JfYaMig=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tWQzOjV+rV5nNhnrDEcU+8IZB01+NJAMKIA1enxAC7faR6ioVtsGfopxwlodK52FL
         8XeaOYZLRIVi2QkKiWudlYvtfwJoMVCaEX/sZb37zAUwKZB1HFnbx8cNlzEUFODewL
         StdhpMP8GRMzpvVJjMDNDIxLK/D9xEJ3rCEBxLBY=
Date:   Sun, 22 Sep 2019 10:16:38 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: Please apply commit 0f0727d971f6 ("drm/amd/display: readd -msse2
 to prevent Clang from emitting libcalls to undefined SW FP routines") to
 4.19.y
Message-ID: <20190922081638.GC2524798@kroah.com>
References: <CAKwvOdm0sWCF=PiNJvKWxt7CaTXSF13cZNuYPhKC=Kq8ooi1HA@mail.gmail.com>
 <20190820210716.GA31292@kroah.com>
 <20190820212539.GA1581@sasha-vm>
 <20190820213524.GA25049@kroah.com>
 <CAKwvOdkp8aV9VeJhd5oxshJLTmrB3i9juea4CMo5K8o9CadOfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdkp8aV9VeJhd5oxshJLTmrB3i9juea4CMo5K8o9CadOfw@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 20, 2019 at 02:41:15PM -0700, Nick Desaulniers wrote:
> On Tue, Aug 20, 2019 at 2:35 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Aug 20, 2019 at 05:25:39PM -0400, Sasha Levin wrote:
> > > On Tue, Aug 20, 2019 at 02:07:16PM -0700, Greg KH wrote:
> > > > On Tue, Aug 20, 2019 at 02:00:21PM -0700, Nick Desaulniers wrote:
> > > > > Please apply commit 0f0727d971f6 ("drm/amd/display: readd -msse2 to
> > > > > prevent Clang from emitting libcalls to undefined SW FP routines") to
> > > > > 4.19.y.
> > > > >
> > > > > It will help with AMD based chromebooks for ChromeOS.
> > > >
> > > > That commit id is not in Linus's tree, are you sure you got it correct?
> > >
> > > That's a linux-next commit.
> >
> > Great, we can wait for it to show up in Linus's tree first :)
> 
> *checks tree*
> Oh yeah, oops.  Sorry for the noise.

It's in Linus's tree now, but it does not apply to 5.2.y or 4.19.y, so
can you provide a working backport for those kernels?

thanks,

greg k-h
