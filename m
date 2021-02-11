Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53D1931938B
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 20:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231470AbhBKTz7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 14:55:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:38198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229821AbhBKTzh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 14:55:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56F1464E44;
        Thu, 11 Feb 2021 19:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613073296;
        bh=9MXJnMV6HZWowwOqtYbKmzD1gSmJW/7s/uiR/gK9awg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cp+MbtcL+uN4luj29jM+XmeSt4dhK9iWc1KxZa+8ynx5kCHHcomXVOg+P4j0y2pno
         8/RB1M06a6gLnZuOghT3hy3mqBUic0dnOgFO6+n2bDOKvzTvRN8ZDrTDaG6tGMS/+m
         gb3SpD1HCCiOij4D12lzn999cjGoM4uLXCfTZXKA=
Date:   Thu, 11 Feb 2021 20:54:52 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     David Michael <fedora.dm0@gmail.com>
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        stable@vger.kernel.org, mpe@ellerman.id.au
Subject: Re: Reporting stable build failure from commit bca9ca
Message-ID: <YCWLjLhdVSIk1hUX@kroah.com>
References: <CAEvUa7mYi9J6qUbnUJi9=_+AXeXOopYJkZb+Z4CD9enGEQaFBQ@mail.gmail.com>
 <YCI39srMrc8dmL+p@kroah.com>
 <CAEvUa7nBGwManydNPKFqVXQUugsDzx19nPv4Y2BaxrEqe6jFww@mail.gmail.com>
 <90159c33-4ba7-038d-48d7-2722e5a6513a@csgroup.eu>
 <CAEvUa7nbRnNXy6vSLybZqe6pr+MAqBCfBMbLuo0EZhbNCAuRvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEvUa7nbRnNXy6vSLybZqe6pr+MAqBCfBMbLuo0EZhbNCAuRvA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 11, 2021 at 02:41:48PM -0500, David Michael wrote:
> On Thu, Feb 11, 2021 at 2:28 PM Christophe Leroy
> <christophe.leroy@csgroup.eu> wrote:
> > Le 11/02/2021 à 19:18, David Michael a écrit :
> > > On Tue, Feb 9, 2021 at 2:21 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> > >> On Mon, Feb 08, 2021 at 04:14:44PM -0500, David Michael wrote:
> > >>> Commit bca9ca[0] causes a build failure while building for a G4 system
> > >>> since 5.10.8:
> > >>>
> > >>> arch/powerpc/kernel/head_book3s_32.S: Assembler messages:
> > >>> arch/powerpc/kernel/head_book3s_32.S:296: Error: attempt to move .org backwards
> > >>> make[2]: *** [scripts/Makefile.build:360:
> > >>> arch/powerpc/kernel/head_book3s_32.o] Error 1
> > >>>
> > >>> Reverting the commit allows it to build.  I've uploaded the config[1],
> > >>> but let me know if you need other information.
> > >>
> > >> Do you also have the same build failure in Linus's tree with this commit
> > >> in it?  And why not cc: the authors of the offending patch?
> > >
> > > No, 5.11-rc7 builds correctly with the same
> > > https://dpaste.com/7SZMWCU89.txt olddefconfiged.  I've CCed the commit
> > > authors.
> >
> > Should be fixed by following commit:
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux.git/commit/?h=next&id=3642eb21256a317ac14e9ed560242c6d20cf06d9
> 
> Yes, that fixed the build after editing it to apply to head_32.h in
> the 5.10 branch.

Can you provide a working backport?

thanks,

greg k-h
