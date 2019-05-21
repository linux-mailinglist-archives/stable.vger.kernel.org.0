Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF6F25590
	for <lists+stable@lfdr.de>; Tue, 21 May 2019 18:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727999AbfEUQaP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 May 2019 12:30:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:57024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726900AbfEUQaP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 May 2019 12:30:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D5B9208C3;
        Tue, 21 May 2019 16:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558456214;
        bh=80+x1wYVzAInFNDmRNx1g3qJ61uzzAjRrmAnmhXxVE8=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=VutVlFFQQf6IyVI5F/Zq8qBoJwND7QXZ7Au/VhzYHcBIEcPdm8XXtAcTQndIE3Ras
         +v0lPXJvXOrXJc8S7hphCCPou69Yey2QE6+/4713gs7ulQmDLrXWtQN80LXbL4rGLN
         dsxGHznezLYFHbvdFxlfAdrh6Ag6tHPQLIGiVi5w=
Date:   Tue, 21 May 2019 18:30:12 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Theodore Ts'o <tytso@mit.edu>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        linux-ext4@vger.kernel.org,
        Arthur Marsh <arthur.marsh@internode.on.net>,
        Richard Weinberger <richard.weinberger@gmail.com>
Subject: Re: ext4 regression (was Re: [PATCH 4.19 000/105] 4.19.45-stable
 review)
Message-ID: <20190521163012.GA19986@kroah.com>
References: <20190520115247.060821231@linuxfoundation.org>
 <20190520222342.wtsjx227c6qbkuua@xps.therub.org>
 <20190521085956.GC31445@kroah.com>
 <CA+G9fYvHmUimtwszwo=9fDQLn+MNh8Vq3UGPaPUdhH=dEKzqxg@mail.gmail.com>
 <20190521093849.GA9806@kroah.com>
 <CA+G9fYveeg_FMsL31aunJ2A9XLYk908Y1nSFw4kwkFk3h3uEiA@mail.gmail.com>
 <20190521162142.GA2591@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190521162142.GA2591@mit.edu>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 21, 2019 at 12:21:42PM -0400, Theodore Ts'o wrote:
> On Tue, May 21, 2019 at 03:58:15PM +0530, Naresh Kamboju wrote:
> > > Ted, any ideas here?  Should I drop this from the stable trees, and you
> > > revert it from Linus's?  Or something else?
> 
> It's safe to drop this from the stable trees while we investigate.  It
> was always borderline for stable anyway.  (See below).

Ok, will go drop both of these now, thanks.

greg k-h
