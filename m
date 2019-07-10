Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B031164D81
	for <lists+stable@lfdr.de>; Wed, 10 Jul 2019 22:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727268AbfGJU1N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jul 2019 16:27:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:34132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727197AbfGJU1N (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Jul 2019 16:27:13 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3815E208C4;
        Wed, 10 Jul 2019 20:27:11 +0000 (UTC)
Date:   Wed, 10 Jul 2019 16:27:09 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Juergen Gross <jgross@suse.com>,
        LKML <linux-kernel@vger.kernel.org>,
        He Zhe <zhe.he@windriver.com>,
        Joel Fernandes <joel@joelfernandes.org>, devel@etsukata.com,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH v2 5/7] x86/mm, tracing: Fix CR2 corruption
Message-ID: <20190710162709.1c306f8a@gandalf.local.home>
In-Reply-To: <CAHk-=wh+J7ts6OrzzscMj5FONd3TRAwAKPZ=BQmEb2E8_-RXTA@mail.gmail.com>
References: <20190704195555.580363209@infradead.org>
        <20190704200050.534802824@infradead.org>
        <CALCETrXvTvFBaQB-kEe4cRTCXUyTbWLbcveWsH-kX4j915c_=w@mail.gmail.com>
        <CALCETrUzP4Wb=WNhGvc7k4oX7QQz1JXZ3-O8PQhs39kmZid0nw@mail.gmail.com>
        <CAHk-=wh+J7ts6OrzzscMj5FONd3TRAwAKPZ=BQmEb2E8_-RXTA@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


[ added stable folks ]

On Sun, 7 Jul 2019 11:17:09 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sun, Jul 7, 2019 at 8:11 AM Andy Lutomirski <luto@kernel.org> wrote:
> >
> > FWIW, I'm leaning toward suggesting that we apply the trivial tracing
> > fix and backport *that*.  Then, in -tip, we could revert it and apply
> > this patch instead.  
> 
> You don't have to have the same fix in stable as in -tip.
> 
> It's fine to send something to stable that says "Fixed differently by
> commit XYZ upstream". The main thing is to make sure that stable
> doesn't have fixes that then get lost upstream (which we used to have
> long long ago).
> 

But isn't it easier for them to just pull the quick fix in, if it is in
your tree? That is, it shouldn't be too hard to make the "quick fix"
that gets backported on your tree (and probably better testing), and
then add the proper fix on top of it. The stable folks will then just
use the commit sha to know what to take, and feel more confident about
taking it.

-- Steve
