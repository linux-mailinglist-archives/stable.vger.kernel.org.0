Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0094241884F
	for <lists+stable@lfdr.de>; Sun, 26 Sep 2021 13:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbhIZL0Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Sep 2021 07:26:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:59758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230128AbhIZL0Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 26 Sep 2021 07:26:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF6B661038;
        Sun, 26 Sep 2021 11:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632655488;
        bh=hdC5CmMWTPJC2kSEAz1gAv00CBNEWwCqk0q4xy1IrYU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fRzSfChAc5cYckrtuAZPBZZdKh60R+DA5L3cyiVlKNUcC3cSY9L5Y0jvsLZ8m+b0c
         jSBXOKs5fTtkDmKlPcFDFytzN02ESfMum6ZxrVLu4xK583mOKFBtz5Ak2XInZ02LOM
         CWWpvo97YbLn5cfsuNBrQA6eoab2cDu1mDvlnKik=
Date:   Sun, 26 Sep 2021 13:24:45 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jari Ruusu <jariruusu@protonmail.com>
Cc:     Salvatore Bonaccorso <carnil@debian.org>,
        Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Jiri Slaby <jirislaby@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Aurelien Jarno <aurelien@aurel32.net>
Subject: Re: glibc VETO for kernel version SUBLEVEL >= 255
Message-ID: <YVBYfQY94j7K39qc@kroah.com>
References: <qscod31lyVG7t-CW63o_pnsara-v9Wf6qXz9eSfUZnxtHk2AkeJ73yvER1XYO_311Wxo2wC8L2JuTdLJm8vgvhVVaGa5fdumXx5iHWarqwA=@protonmail.com>
 <YVAhOlTsb0NK0BVi@kroah.com>
 <YVArDZSq9oaTFakz@eldamar.lan>
 <YVA9l9svFyDgLPJy@kroah.com>
 <xxvm9EznCQoQ_-YYhxhEknGTxHEnVW584ypJShT__L09eV-JOfFtr-K4M33xRa3VTL5tNgOGvJSUqWthW-El4IwTi6Vt4B_XZA-xMB6vOEY=@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xxvm9EznCQoQ_-YYhxhEknGTxHEnVW584ypJShT__L09eV-JOfFtr-K4M33xRa3VTL5tNgOGvJSUqWthW-El4IwTi6Vt4B_XZA-xMB6vOEY=@protonmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Sep 26, 2021 at 10:58:59AM +0000, Jari Ruusu wrote:
> On Sunday, September 26th, 2021 at 12:29, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > On Sun, Sep 26, 2021 at 10:10:53AM +0200, Salvatore Bonaccorso wrote:
> > > Recently prompted due to https://bugs.debian.org/987266 the check was
> > > removed in the postinst script of libc in Debian:
> > > https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=987266 .
> >
> > Wonderful, thanks for pointing this out!
> > Jari, try asking whatever distro you are getting these rebuilt packages
> > from to update their scripts and all should be good.
> 
> It is/was mostly self-inflicted pain, using Rasbian distro userland and
> self-compiled kernel.org kernel.

Why use an older kernel tree on this device?  Rasbian seems to be on
4.19.y at the least right now, is there something in those older kernel
trees that you need?

thanks,

greg k-h
