Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6A648FBDB
	for <lists+stable@lfdr.de>; Sun, 16 Jan 2022 09:56:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231752AbiAPI43 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Jan 2022 03:56:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230421AbiAPI42 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Jan 2022 03:56:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7286BC061574
        for <stable@vger.kernel.org>; Sun, 16 Jan 2022 00:56:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A8A9B80975
        for <stable@vger.kernel.org>; Sun, 16 Jan 2022 08:56:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26844C36AE3;
        Sun, 16 Jan 2022 08:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642323385;
        bh=8Ek6OseXLVDpZDc+Ma2vT+V47aP9VXY/ZhfaGbuso9Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mO3vlw2gu5uS7oAHugx5+bOizeJCWHN+uOAPRAjJSv6nBC/uuB0cR08XLkjpW5im4
         EELwjt4autJwz7OmxtOj2BC+AxSMqyyIOWxIxZ6BnvPuyOSzF50hRcFVVZmYuchJ+B
         Js4W4srT2JcAF+lBuJxaBC4PVDdQaaPDCQZ0f8p4=
Date:   Sun, 16 Jan 2022 09:56:22 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jaegeuk Kim <jaegeuk@google.com>
Cc:     stable@vger.kernel.org, timmurray@google.com, longman@redhat.com,
        peterz@infradead.org
Subject: Re: [PATCH 0/7] rwsem enhancement patches for 5.10
Message-ID: <YePdttINqpJxzjbw@kroah.com>
References: <20220115005945.2125174-1-jaegeuk@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220115005945.2125174-1-jaegeuk@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 14, 2022 at 04:59:39PM -0800, Jaegeuk Kim wrote:
> Per discussion [1], can we merge these patches in 5.10 first?
> 
> [1] https://lore.kernel.org/linux-f2fs-devel/CAEe=Sx=6FCvrp_6x2Bqp3YTzep2s=aWdCmP29g7+sGCWkpNvkg@mail.gmail.com/T/#t

I do not understand, what "discussion" exactly is there that requires
these changes for older kernels?

What bug is this fixing?

> Peter Zijlstra (3):
>   locking/rwsem: Better collate rwsem_read_trylock()
>   locking/rwsem: Introduce rwsem_write_trylock()
>   locking/rwsem: Fold __down_{read,write}*()
> 
> Waiman Long (4):
>   locking/rwsem: Pass the current atomic count to
>     rwsem_down_read_slowpath()
>   locking/rwsem: Prevent potential lock starvation
>   locking/rwsem: Enable reader optimistic lock stealing
>   locking/rwsem: Remove reader optimistic spinning
> 
>  kernel/locking/lock_events_list.h |   6 +-
>  kernel/locking/rwsem.c            | 359 +++++++++---------------------
>  2 files changed, 106 insertions(+), 259 deletions(-)

And you are positive that there are no follow-on patches needed for
these core changes?  How were they tested?  What now works that did not
work in 5.10?  Why just 5.10?  What about all older kernels?

We need a lot more information here, sorry.

greg k-h
