Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 598CA3215C5
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:08:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbhBVMII (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:08:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:43604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230211AbhBVMIA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:08:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68C7764E29;
        Mon, 22 Feb 2021 12:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613995637;
        bh=WKGqyeJ+H1+pIiZMC/bmOLTI3fFkMlqK6Xvp3YQ9des=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wUWWfqBr5fMMlNA5GvUr75CKZkQTV7gqgZkju16Uj/TrKKG1ozDHvaNTK7Zx2xC9p
         n6jkaB+8RPqx8WMvw/3A471XFkqK/3nCCtnhPXFwWOW904AdQYW24C0tqZEDX6Jbqr
         y88NAKbAjA4/BLTPom0hxQk42cWWShU+b6cElzwk=
Date:   Mon, 22 Feb 2021 13:07:15 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     Zheng Yejian <zhengyejian1@huawei.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, judy.chenhui@huawei.com,
        zhangjinhao2@huawei.com, tglx@linutronix.de
Subject: Re: [PATCH 4.9.257 1/1] futex: Fix OWNER_DEAD fixup
Message-ID: <YDOec1kosGKKO80g@kroah.com>
References: <20210222110542.3531596-1-zhengyejian1@huawei.com>
 <20210222110542.3531596-2-zhengyejian1@huawei.com>
 <20210222115424.GF376568@dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210222115424.GF376568@dell>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 22, 2021 at 11:54:24AM +0000, Lee Jones wrote:
> On Mon, 22 Feb 2021, Zheng Yejian wrote:
> 
> > From: Peter Zijlstra <peterz@infradead.org>
> > 
> > commit a97cb0e7b3f4c6297fd857055ae8e895f402f501 upstream.
> > 
> > Both Geert and DaveJ reported that the recent futex commit:
> > 
> >   c1e2f0eaf015 ("futex: Avoid violating the 10th rule of futex")
> > 
> > introduced a problem with setting OWNER_DEAD. We set the bit on an
> > uninitialized variable and then entirely optimize it away as a
> > dead-store.
> > 
> > Move the setting of the bit to where it is more useful.
> > 
> > Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> > Reported-by: Dave Jones <davej@codemonkey.org.uk>
> > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > Cc: Paul E. McKenney <paulmck@us.ibm.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Fixes: c1e2f0eaf015 ("futex: Avoid violating the 10th rule of futex")
> > Link: http://lkml.kernel.org/r/20180122103947.GD2228@hirez.programming.kicks-ass.net
> > Signed-off-by: Ingo Molnar <mingo@kernel.org>
> > Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
> > ---
> >  kernel/futex.c | 7 +++----
> >  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> Reviewed-by: Lee Jones <lee.jones@linaro.org>

This does not apply to the 4.9.y tree at all right now, are you all sure
you got the backport correct?

confused,

greg k-h
