Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1F0302C0A
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 20:55:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732205AbhAYTyE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 14:54:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:33320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732214AbhAYTx4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 14:53:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B90B220708;
        Mon, 25 Jan 2021 19:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611604395;
        bh=b7b8HnwRMNSmkwv2X1D1C040e/89bPbr7u1MusywbRk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ux0iTyK4z3AUKvokzJ2yLa7Ff1FprPB56XVQ1sfPw72Y/e/+h41VxVysGCGkjZk+3
         5Q5Ew5MmSQKkwk6XyMzLWI3S0t3jLRmLnXJrdI4w1b/I06d5pYNS6F8k73NvZzRZTk
         owNZAHmMz20iQdoJ9Vw3PcmUmnWb6wdT058bZ/diRyOG9Mk9rCiowsYgm36/+0/kKz
         UQoE9nOHn7Ah1As1uX0dV8GSAUBxCsgi8LyN3y1sYHngnS8Lu1KYRk3NEP2jNNLO3/
         ujBlhzVDFuejqWwXqMOwZHAZa0XiZ9uYrFwHqG1H89Gz1RIgjUTEmUI3G7X3lkz5+Z
         5XZBoW0uaG6+w==
Date:   Mon, 25 Jan 2021 11:53:13 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     hch@lst.de, jack@suse.cz, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] fs: fix lazytime expiration handling in"
 failed to apply to 5.4-stable tree
Message-ID: <YA8hqepbaWfDZehy@sol.localdomain>
References: <1611494580155241@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1611494580155241@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 24, 2021 at 02:23:00PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
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
> >From 1e249cb5b7fc09ff216aa5a12f6c302e434e88f9 Mon Sep 17 00:00:00 2001
> From: Eric Biggers <ebiggers@google.com>
> Date: Tue, 12 Jan 2021 11:02:43 -0800
> Subject: [PATCH] fs: fix lazytime expiration handling in
>  __writeback_single_inode()
> 

Hi Greg, for 5.4 can you take commit 5fcd57505c00 ("writeback: Drop
I_DIRTY_TIME_EXPIRE") first?  Then this commit will cherry-pick cleanly.

For 4.19 and earlier there are conflicts, so I'll send out the patches for
those.

- Eric
