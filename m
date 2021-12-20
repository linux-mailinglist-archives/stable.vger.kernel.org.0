Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FBF347B2E0
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 19:31:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233719AbhLTSbo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 13:31:44 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47744 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233646AbhLTSbn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 13:31:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8CE7B8106F;
        Mon, 20 Dec 2021 18:31:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87798C36AE7;
        Mon, 20 Dec 2021 18:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640025100;
        bh=KGNV7U4GAQPgh3cAdBu1IzpAaKnQDCNQUZ6JGcdeR3w=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=NYvqsBZ8UfsFVpl2/gvC/8zU9TSPPwgDXZ9u4FDRn/nET+lQBaphA0fZZcH9CRqC6
         AdN+DWfwZpg5VroYGWqIm4qdzT1tA5z3rAmB2Te24fbbY9NmToqc1xhLcJqO73z4YH
         /wC853lhaH/9yiBjFut6Tt8xmklWlqgr5M2F11cTq6tYkqFfRLfxSX7Kn45nrLL5S1
         uIm9in1isrxt5DL1UNw69z1D4Ox9LvyItsR8GcOHdiUdcEcaVbZIRgC4QMYaPcbtfQ
         ewQVs/GQdDQVkuGXPgdMhKTVZ8DdLTqWiWQoZlyexcihtGZ5w74o4fEvaHOX0AFvVR
         vmPp6bTAufgpw==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 4AB2E5C1610; Mon, 20 Dec 2021 10:31:40 -0800 (PST)
Date:   Mon, 20 Dec 2021 10:31:40 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Eric Biggers <ebiggers@kernel.org>, Theodore Ts'o <tytso@mit.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH RESEND] random: use correct memory barriers for
 crng_node_pool
Message-ID: <20211220183140.GC641268@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20211219025139.31085-1-ebiggers@kernel.org>
 <CAHmME9pQ4vp0jHpOyQXHRbJ-xQKYapQUsWPrLouK=dMO56y1zA@mail.gmail.com>
 <20211220181115.GZ641268@paulmck-ThinkPad-P17-Gen-1>
 <CAHmME9qZDNz2uxPa13ZtBMT2RR+sP1OU=b73tcZ9BTD1T_MJOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9qZDNz2uxPa13ZtBMT2RR+sP1OU=b73tcZ9BTD1T_MJOg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 20, 2021 at 07:16:48PM +0100, Jason A. Donenfeld wrote:
> On Mon, Dec 20, 2021 at 7:11 PM Paul E. McKenney <paulmck@kernel.org> wrote:
> > First I would want
> 
> It looks like you've answered my question with four other questions,
> which seem certainly technically warranted, but also indicates we're
> probably not going to get to the nice easy resting place of, "it is
> safe; go for it" that I was hoping for. In light of that, it seems
> like merging Eric's patch is reasonable.

My hope would be that the questions can be quickly answered by the
developers and maintainers.  But yes, hope springs eternal.

							Thanx, Paul
