Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E32C1463115
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 11:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233088AbhK3Khg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 05:37:36 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:34070 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233339AbhK3Khg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 05:37:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5AFB3CE1753
        for <stable@vger.kernel.org>; Tue, 30 Nov 2021 10:34:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08857C53FC7;
        Tue, 30 Nov 2021 10:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638268454;
        bh=LGmdby9RfTZX7imGnet5UEMoDDTC1kImjaTKPwOx2g0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TXV0CSHvol5kwaOhKgWu87gWbOsAOu2BYSHWAa2TSa/upJqvg41+Vgeuso/umG4EO
         Y7trBTr/BVQyOXUeucaIP1IWzsA5NEaMBWTXHHQq1hT5kKXBO8hvVarMc8sSpBioqO
         Y2lW0YRhkimkCGsod8ocZYYsuWePNildXL8mZkww=
Date:   Tue, 30 Nov 2021 11:34:12 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Cc:     Manfred Spraul <manfred@colorfullife.com>, stable@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Andrei Vagin <avagin@gmail.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        Vasily Averin <vvs@virtuozzo.com>
Subject: Re: [PATCH] shm: extend forced shm destroy to support objects from
 several IPC nses
Message-ID: <YaX+JPpOFKDVhdxf@kroah.com>
References: <163758370064179@kroah.com>
 <20211129164300.789517-1-alexander.mikhalitsyn@virtuozzo.com>
 <YaUNb9NyKVio+bQ6@kroah.com>
 <2b9bf5cd-7e65-a532-afbf-9f94c3ebb45c@colorfullife.com>
 <20211129232218.216a2dc322685f4516ac980b@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211129232218.216a2dc322685f4516ac980b@virtuozzo.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 29, 2021 at 11:22:18PM +0300, Alexander Mikhalitsyn wrote:
> On Mon, 29 Nov 2021 21:12:01 +0100
> Manfred Spraul <manfred@colorfullife.com> wrote:
> 
> > Hello together,
> 
> Hello!
> 
> > 
> > On 11/29/21 18:27, Greg KH wrote:
> > > On Mon, Nov 29, 2021 at 07:43:00PM +0300, Alexander Mikhalitsyn wrote:
> > >> For 4.4.y:
> > >>
> > >> Upstream commit 85b6d24646e4 ("shm: extend forced shm destroy to support objects from several IPC nses")
> > > We need versions of this for 4.9.y, 4.14.y, and 4.19.y before I can take
> > > this for 4.4.y.
> > 
> > We have tried to be too clever: I had start top down, Alexander bottom 
> > up, ...
> > 
> > 
> > @Alexander: I've sent 4.19.y around an hour ago. Could you create the 
> > change for 4.9. and 4.14?
> 
> Yeah. I've sent changes for 4.14 and 4.9 about 20 minutes ago ;)
> 
> > 
> > 
> > For the 4.4.y:
> > 
> > Tested: With the patch applied the crash is resolved, no observed 
> > regressions.
> 
> Fantastic. Huge thanks!

Wonderful, all now queued up except for the 4.19 version which I will
apply after this next round of kernels are released.

thanks,

greg k-h
