Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 562CF9BFEE
	for <lists+stable@lfdr.de>; Sat, 24 Aug 2019 21:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727353AbfHXT5w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Aug 2019 15:57:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:39392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727019AbfHXT5w (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 24 Aug 2019 15:57:52 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D27962082E;
        Sat, 24 Aug 2019 19:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566676671;
        bh=MarEzIq7oHZK8s3g0cjP9atdboVj3SRVugsL5q1dspM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=xop1Vb8otLQ94HJ3aLg5YMDZc4cHNe23khfk5bWHO7WxQXhU3bXn9Tu/kTumbnWyv
         GTFo16QqVwqvgVc2DG6/bsuH6Onrm/3Rs6XxCg0K1TPgROEevte596+voBLEpcw3X/
         vcH/yzOFOug/xKPlGIL/RF+PkouyRD9maJIZsYpA=
Date:   Sat, 24 Aug 2019 12:57:50 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Roman Gushchin <guro@fb.com>
Cc:     Greg KH <greg@kroah.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Michal Hocko <mhocko@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Yafang Shao <laoar.shao@gmail.com>
Subject: Re: [PATCH] Partially revert
 "mm/memcontrol.c: keep local VM counters in sync with the hierarchical ones"
Message-Id: <20190824125750.da9f0aac47cc0a362208f9ff@linux-foundation.org>
In-Reply-To: <20190817191518.GB11125@castle>
References: <20190817004726.2530670-1-guro@fb.com>
        <20190817063616.GA11747@kroah.com>
        <20190817191518.GB11125@castle>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 17 Aug 2019 19:15:23 +0000 Roman Gushchin <guro@fb.com> wrote:

> > > Fixes: 766a4c19d880 ("mm/memcontrol.c: keep local VM counters in sync with the hierarchical ones")
> > > Signed-off-by: Roman Gushchin <guro@fb.com>
> > > Cc: Yafang Shao <laoar.shao@gmail.com>
> > > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > > ---
> > >  mm/memcontrol.c | 8 +++-----
> > >  1 file changed, 3 insertions(+), 5 deletions(-)
> > 
> > <formletter>
> > 
> > This is not the correct way to submit patches for inclusion in the
> > stable kernel tree.  Please read:
> >     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> > for how to do this properly.
> 
> Oh, I'm sorry, will read and follow next time. Thanks!

766a4c19d880 is not present in 5.2 so no -stable backport is needed, yes?
