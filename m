Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCAB2AB4BA
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 11:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729218AbgKIKWe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 05:22:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:39398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726176AbgKIKWe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 05:22:34 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF43F20684;
        Mon,  9 Nov 2020 10:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604917353;
        bh=2NBCd6A2JIzLWswGTiCjKldGV0vbypL7zXi3OCpO+yY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=deau0sRgGk7q68v7JpgeSVISW7vSHf7O51GU1dkOV6lhqfE2VuIgi+kCCCzh+BEDk
         Ep4/GHIi/bIkK0u10yBNZBU7jdunBBIuBaJU4oVkfaMYoRDfE1JZIx46wqr8twqqDz
         fFVHt/o8jul8BCOa7CJn1O2y++8k++rm6IYGjFv8=
Date:   Mon, 9 Nov 2020 11:23:33 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Amit Klein <aksecurity@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Willy Tarreau <w@1wt.eu>, Eric Dumazet <edumazet@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andy Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, tytso@mit.edu,
        Florian Westphal <fw@strlen.de>,
        Marc Plumb <lkml.mplumb@gmail.com>,
        George Spelvin <lkml@sdf.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.9 639/757] random32: make prandom_u32() output
 unpredictable
Message-ID: <20201109102333.GC1238638@kroah.com>
References: <20201027135450.497324313@linuxfoundation.org>
 <20201027135520.535662993@linuxfoundation.org>
 <CANEQ_++-8QMfvLCQtFLOy8dF1LP_+UUOkRTG2y8Jn5bteS3B8Q@mail.gmail.com>
 <20201109062012.GA48368@kroah.com>
 <CANEQ_+JcddE9SxzppH07A1ewvyjXHnsKUYpoYx=9Zk7gPe-Fxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANEQ_+JcddE9SxzppH07A1ewvyjXHnsKUYpoYx=9Zk7gPe-Fxg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 09, 2020 at 08:54:13AM +0200, Amit Klein wrote:
> Unfortunately, I'm just a security researcher, not a kernel developer...
> 
> Does that mean you don't plan to back-port the patch?

At this point in time, unless someone else does the work for me, no, I
do not, sorry.  See Willy's response for why :)

thanks,

greg k-h
