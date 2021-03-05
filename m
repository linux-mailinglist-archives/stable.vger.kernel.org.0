Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11CED32E676
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 11:32:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbhCEKb2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 05:31:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:56014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229836AbhCEKa6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 05:30:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E290964F5F;
        Fri,  5 Mar 2021 10:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614940258;
        bh=cBFq+dI8PopiA7EVQoY4mmINOxhcSRe1HY1wlknFZ4c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Q0dqxEI29WOqDVx12XnoY4EOYZnW2XgtOEt3uJtjbsLsZR4ChxcSvgSmb1s4n5feG
         G6Jyx38DUAXXij/QV+X+rJ3na+a+zx9Ca4iW/ikHe8aR/RXsSLp7oULYp2vCpmVczo
         PALI1PtuWvnhJ36qOqbTurEwRCpRGOwQDKmZl8tc=
Date:   Fri, 5 Mar 2021 11:30:55 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Salvatore Bonaccorso <carnil@debian.org>,
        stable <stable@vger.kernel.org>,
        Laurent Vivier <laurent@vivier.eu>,
        YunQiang Su <ysu@wavecomp.com>, Helge Deller <deller@gmx.de>
Subject: Re: Please apply commit 2347961b11d4 ("binfmt_misc: pass binfmt_misc
 flags to the interpreter") to 5.10.y and later
Message-ID: <YEIIX4s3ERuM1+R6@kroah.com>
References: <YD42Sh5n2sjF9tNj@eldamar.lan>
 <YEFJVENyU9QaO/NK@sashalap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YEFJVENyU9QaO/NK@sashalap>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 04, 2021 at 03:55:48PM -0500, Sasha Levin wrote:
> On Tue, Mar 02, 2021 at 01:57:46PM +0100, Salvatore Bonaccorso wrote:
> > Hi
> > 
> > 2347961b11d4 ("binfmt_misc: pass binfmt_misc flags to the
> > interpreter") was applied in mainline and included in 5.12-rc1.
> > 
> > Probably you could argue here on both a bugfix or feature addition.
> > 
> > My intention is the following: In the Debian bugreport
> > https://bugs.debian.org/970460 an issue was raised with qemu-user
> > which needs to know if it has to preserve the argv[0]. As shown there
> > it is an issue with multi-call binaries.
> > 
> > So again, not sure if you want to consider it, but defintively
> > Yunqiang Su and others would appreicate. If it gets backported we will
> > pick it up automatically.
> 
> Given it needs changes in userspace too I'm not sure it qulifies as a
> fix per-se. Though as you point out, it's really borderline.
> 
> Generally I would just take it, but it affects interactions with
> userspace, so I feel less comfortable with this.

Yes, I'm not ok with taking this either at this point in time, as it
requires userspace changes.

thanks,

greg k-h
