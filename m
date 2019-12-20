Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCD68127EAD
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 15:49:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727565AbfLTOso (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 09:48:44 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:36386 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727749AbfLTOsk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Dec 2019 09:48:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=AOOOoCg9ol7+3vA6+5XlhPuq3fd9liI3dXnfBk0teUM=; b=bJHiZTizdT/XVFZPIT30O1q2g
        uZy/EjVxrxU8zVxsdADlO9Tn6J1uYtZdWDQndWSjUkuHWzlD6sP/IZVlgirQ6xugzOWCLiqIbbTIa
        sBIScHhQdSXqQ24hEMkNbIMFYQ1sJ/I4jah0gL35Z+fhkfC4KtcE3bQ4FMG4tImDvvM7r8NEA896a
        3TbJh8hwblpFZqhfUjTwSjGcMjN3GxNBih8T6OanSKb4iCifMN5mj3IpqZjLY7tZ3pYIhvKf7apbQ
        CKVfza83lsNJWyUCWatfuYJ7f/K3UxqxzBRc8nOn8GjwuMsGqHAgogBWg8tqOJMZu7LqT1hJNbCDp
        X6gr5NnEA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iiJZt-00057Z-II; Fri, 20 Dec 2019 14:48:29 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id CA508304D00;
        Fri, 20 Dec 2019 15:47:03 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 950E52026176B; Fri, 20 Dec 2019 15:48:27 +0100 (CET)
Date:   Fri, 20 Dec 2019 15:48:27 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "Paul E . McKenney" <paulmck@linux.ibm.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Paul Turner <pjt@google.com>,
        linux-api@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH for 5.5 0/3] Restartable Sequences Fixes
Message-ID: <20191220144827.GJ2844@hirez.programming.kicks-ass.net>
References: <20191211161713.4490-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211161713.4490-1-mathieu.desnoyers@efficios.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 11, 2019 at 11:17:10AM -0500, Mathieu Desnoyers wrote:
> Hi,
> 
> Here is a repost of a small set of rseq fixes which was initially posted
> in September 2019. It now targets kernel 5.5. Those should be backported
> to stable kernels >= 4.18.
> 
> Thanks,
> 
> Mathieu
> 
> Mathieu Desnoyers (3):
>   rseq: Fix: Reject unknown flags on rseq unregister
>   rseq: Fix: Unregister rseq for clone CLONE_VM
>   rseq/selftests: Fix: Namespace gettid() for compatibility with glibc
>     2.30

I've picked up the first two patches, thanks!
