Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8503F18DF2F
	for <lists+stable@lfdr.de>; Sat, 21 Mar 2020 10:36:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbgCUJgy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Mar 2020 05:36:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:53740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726995AbgCUJgy (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 21 Mar 2020 05:36:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C16F20739;
        Sat, 21 Mar 2020 09:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584783414;
        bh=oBQIeImAjoieiPxUEttTfq6rn8iyKTxXUC2pUPHKw0o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UM4KwfqZVtsNW8Tr7JdyuIYcobhpNDDPUeaIwewhxryvMKuDnZZOO5G5NTE5oA8EY
         9xkkMNN0F74qYLsPB6uAIaNyC5ob9PgtxM0uTC4nrBziZKlftvsMvH07n9e5EXWDTc
         Kb2jmiE2i32PGQwHHpxRfjjOqEQIBVREMVmLVi5Y=
Date:   Sat, 21 Mar 2020 10:36:51 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Faiz Abbas <faiz_abbas@ti.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH 5.5 00/64] 5.5.11-rc2 review
Message-ID: <20200321093651.GA951429@kroah.com>
References: <20200319150225.148464084@linuxfoundation.org>
 <CA+G9fYvOQ=oibqFZ=zffqj-c5mcjW2Bew2rVHg=FPs2mHxb_ug@mail.gmail.com>
 <20200321071046.GC850676@kroah.com>
 <CA+G9fYtVW7n=Zc2sXayYR0a6U-2womo54CW4ebhz8XU=N9uZNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYtVW7n=Zc2sXayYR0a6U-2womo54CW4ebhz8XU=N9uZNA@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 21, 2020 at 03:03:51PM +0530, Naresh Kamboju wrote:
> On Sat, 21 Mar 2020 at 12:40, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Fri, Mar 20, 2020 at 12:16:11PM +0530, Naresh Kamboju wrote:
> > >
> > > Results from Linaro’s test farm.
> > > No regressions on arm64, arm, x86_64, and i386.
> > >
> > > NOTE:
> > > The arm64 dragonboard-410c and arm beagleboard x15 device running
> > > stable rc 4.19.112-rc1, 5.4.27-rc1 and 5.5.11-rc2 kernel popping up
> > > the following messages on console log continuously. [Ref]
> >
> > That should have been resolved by now :(
> 
> The reported problem resolved now.

Wonderful,t hanks for letting me know.

greg k-h
