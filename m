Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E611B33B0CF
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 12:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbhCOLRP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 07:17:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:46800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229956AbhCOLQq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 07:16:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31B8864E61;
        Mon, 15 Mar 2021 11:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615807005;
        bh=PVePHmoVGgm67KqUanl5H3W7nskv25xsO2QLvC7MVy8=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=I+oabP4Hd6b6kCLCD6brJJ6olTQXeYUs4Psur8riB2zU03j1DBmszxjkHzRUjL1pe
         ve9OWmDvN0IbKWivkOSbNOa9KILcrKQkip19CQo1WVI/1oPbdu+lpwULRR1fccdrXW
         5MoZNTgD7gkvbEKIv0rwbC/ObAdQfi5uzahm/78s=
Date:   Mon, 15 Mar 2021 12:16:43 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     surenb@google.com, akpm@linux-foundation.org, fweimer@redhat.com,
        jannh@google.com, jeffv@google.com, jmorris@namei.org,
        keescook@chromium.org, mhocko@suse.com, minchan@kernel.org,
        oleg@redhat.com, rientjes@google.com, shakeelb@google.com,
        stable@vger.kernel.org, timmurray@google.com,
        torvalds@linux-foundation.org
Subject: Re: FAILED: patch "[PATCH] mm/madvise: replace ptrace attach
 requirement for" failed to apply to 5.10-stable tree
Message-ID: <YE9CG2S+ufk7YsmG@kroah.com>
References: <1615806428159123@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1615806428159123@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 15, 2021 at 12:07:08PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> >From 96cfe2c0fd23ea7c2368d14f769d287e7ae1082e Mon Sep 17 00:00:00 2001
> From: Suren Baghdasaryan <surenb@google.com>
> Date: Fri, 12 Mar 2021 21:08:06 -0800
> Subject: [PATCH] mm/madvise: replace ptrace attach requirement for
>  process_madvise

No, sorry, wrong commit, this one works fine in 5.10-stable, my fault...

greg k-h
