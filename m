Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF3EB49831C
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 16:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235234AbiAXPIN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 10:08:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233197AbiAXPIN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 10:08:13 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD134C06173B
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 07:08:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 476A3CE1188
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 15:08:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38F66C340E1;
        Mon, 24 Jan 2022 15:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643036889;
        bh=LAGoS95SdOBkHmcZBZ/t9/iUocbXGvJxYGYKJA8RswM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u+7yRXsRQLAafiPZNz77ZXEP52dz5JARVQiK6HJgyOEVgHU+egK1IyFLVL27geUgC
         WpwF1ux9js006fbw3J5pSTPbEFjHloc5SWC4tiRlI+Mxw1cj83QD+QyQefXJod4c+i
         tgCbqXV3kMxXn/MjTUWUkNX8GQEnpw/3k89dyFNs=
Date:   Mon, 24 Jan 2022 16:08:06 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jaegeuk Kim <jaegeuk@google.com>
Cc:     stable@vger.kernel.org, timmurray@google.com, longman@redhat.com,
        peterz@infradead.org
Subject: Re: [PATCH 0/7] rwsem enhancement patches for 5.10
Message-ID: <Ye7A1rzKwD0DIqKI@kroah.com>
References: <20220115005945.2125174-1-jaegeuk@google.com>
 <YePdttINqpJxzjbw@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YePdttINqpJxzjbw@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 16, 2022 at 09:56:22AM +0100, Greg KH wrote:
> On Fri, Jan 14, 2022 at 04:59:39PM -0800, Jaegeuk Kim wrote:
> > Per discussion [1], can we merge these patches in 5.10 first?
> > 
> > [1] https://lore.kernel.org/linux-f2fs-devel/CAEe=Sx=6FCvrp_6x2Bqp3YTzep2s=aWdCmP29g7+sGCWkpNvkg@mail.gmail.com/T/#t
> 
> I do not understand, what "discussion" exactly is there that requires
> these changes for older kernels?
> 
> What bug is this fixing?
> 
> > Peter Zijlstra (3):
> >   locking/rwsem: Better collate rwsem_read_trylock()
> >   locking/rwsem: Introduce rwsem_write_trylock()
> >   locking/rwsem: Fold __down_{read,write}*()
> > 
> > Waiman Long (4):
> >   locking/rwsem: Pass the current atomic count to
> >     rwsem_down_read_slowpath()
> >   locking/rwsem: Prevent potential lock starvation
> >   locking/rwsem: Enable reader optimistic lock stealing
> >   locking/rwsem: Remove reader optimistic spinning
> > 
> >  kernel/locking/lock_events_list.h |   6 +-
> >  kernel/locking/rwsem.c            | 359 +++++++++---------------------
> >  2 files changed, 106 insertions(+), 259 deletions(-)
> 
> And you are positive that there are no follow-on patches needed for
> these core changes?  How were they tested?  What now works that did not
> work in 5.10?  Why just 5.10?  What about all older kernels?
> 
> We need a lot more information here, sorry.

Given a lack of response, I'm dropping this from my "to review" queue.
If you want these added to a stable kernel, please resend with the
requested information.

thanks,

greg k-h
