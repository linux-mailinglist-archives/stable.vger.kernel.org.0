Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C5932AB1F0
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 08:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729705AbgKIHzD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 02:55:03 -0500
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:46949 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728904AbgKIHzD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 02:55:03 -0500
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 0A97sANl013929;
        Mon, 9 Nov 2020 08:54:10 +0100
Date:   Mon, 9 Nov 2020 08:54:10 +0100
From:   Willy Tarreau <w@1wt.eu>
To:     Amit Klein <aksecurity@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
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
Message-ID: <20201109075410.GA13916@1wt.eu>
References: <20201027135450.497324313@linuxfoundation.org>
 <20201027135520.535662993@linuxfoundation.org>
 <CANEQ_++-8QMfvLCQtFLOy8dF1LP_+UUOkRTG2y8Jn5bteS3B8Q@mail.gmail.com>
 <20201109062012.GA48368@kroah.com>
 <CANEQ_+JcddE9SxzppH07A1ewvyjXHnsKUYpoYx=9Zk7gPe-Fxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANEQ_+JcddE9SxzppH07A1ewvyjXHnsKUYpoYx=9Zk7gPe-Fxg@mail.gmail.com>
User-Agent: Mutt/1.6.1 (2016-04-27)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 09, 2020 at 08:54:13AM +0200, Amit Klein wrote:
> Unfortunately, I'm just a security researcher, not a kernel developer...
> 
> Does that mean you don't plan to back-port the patch?

I could possibly have a look, but quite frankly I'm not convinced that we
need to backport this at all. I think that what we've done is mostly to be
future-proof and that the likelihood of practical attacks against live
systems with the previous fix are close to zero.

Cheers,
Willy
