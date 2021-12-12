Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73F2D4719F5
	for <lists+stable@lfdr.de>; Sun, 12 Dec 2021 13:14:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbhLLMOa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Dec 2021 07:14:30 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:59146 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbhLLMOa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Dec 2021 07:14:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 79698CE0B3D;
        Sun, 12 Dec 2021 12:14:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B30EC341C6;
        Sun, 12 Dec 2021 12:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639311266;
        bh=hknMhBt24Z8n+4QgL4lp5vpenugnq1/0LJDFsbiomrI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DG30JzAEB00XYHhtc0jvRl4bnN8gmFnkFJutHbqasIm5kBtFzh4tK9uU50bplrDRK
         jY0qZIbj/YbFAqbkIg3dNGlgK6z4gxPOF2bPc854wXYMTONu3tnPt0F/LvckSwqyBC
         r8LEvyu8JyVO/7SgrgRPKDb2E8IM7cdEyqjyrTDI=
Date:   Sun, 12 Dec 2021 13:14:23 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     SeongJae Park <sj@kernel.org>
Cc:     stable@vger.kernel.org, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-v5.15.x 0/2] mm/damon/core: Fix fake load reports due
 to uninterruptible sleeps
Message-ID: <YbXnnwnqqjTPHMM3@kroah.com>
References: <20211212082831.26988-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211212082831.26988-1-sj@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 12, 2021 at 08:28:28AM +0000, SeongJae Park wrote:
> This patchset is a backport of DAMON fixes that merged in the mainline,
> for v5.15.x stable series.
> 
> SeongJae Park (2):
>   timers: implement usleep_idle_range()
>   mm/damon/core: fix fake load reports due to uninterruptible sleeps
> 
>  include/linux/delay.h | 14 +++++++++++++-
>  kernel/time/timer.c   | 16 +++++++++-------
>  mm/damon/core.c       | 14 +++++++++++---
>  3 files changed, 33 insertions(+), 11 deletions(-)
> 
> -- 
> 2.17.1
> 

All now queued up, thanks!

greg k-h
