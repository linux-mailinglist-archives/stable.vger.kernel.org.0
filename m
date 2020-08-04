Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDD5A23B32A
	for <lists+stable@lfdr.de>; Tue,  4 Aug 2020 05:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbgHDDHe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 23:07:34 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:39357 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725975AbgHDDHe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 23:07:34 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 07436bNa016624;
        Tue, 4 Aug 2020 05:06:37 +0200
Date:   Tue, 4 Aug 2020 05:06:37 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Amit Klein <aksecurity@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Dumazet <edumazet@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andy Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 5.7 021/120] random32: update the net random state on
 interrupt and activity
Message-ID: <20200804030637.GA16602@1wt.eu>
References: <20200803121902.860751811@linuxfoundation.org>
 <20200803121903.882259078@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200803121903.882259078@linuxfoundation.org>
User-Agent: Mutt/1.6.1 (2016-04-27)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Aug 03, 2020 at 02:17:59PM +0200, Greg Kroah-Hartman wrote:
> From: Willy Tarreau <w@1wt.eu>
> 
> commit f227e3ec3b5cad859ad15666874405e8c1bbc1d4 upstream.
> 
> This modifies the first 32 bits out of the 128 bits of a random CPU's
> net_rand_state on interrupt or CPU activity to complicate remote
> observations that could lead to guessing the network RNG's internal
> state.
(...)

Stephen reported at least one powerpc build breakage with this one,
and Michael suggested a yet unmerged fix. Thus I'm wondering if we
shouldn't postpone inclusion of these 3 random32 backports to stable
to give some time to stabilize them and avoid breaking setups.

Just my two cents,
Willy
