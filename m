Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36EDC17D51B
	for <lists+stable@lfdr.de>; Sun,  8 Mar 2020 18:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbgCHRHy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Mar 2020 13:07:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56146 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbgCHRHy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Mar 2020 13:07:54 -0400
Received: from ip5f5bf7ec.dynamic.kabel-deutschland.de ([95.91.247.236] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1jAzP5-0006ws-FF; Sun, 08 Mar 2020 17:07:51 +0000
Date:   Sun, 8 Mar 2020 18:07:50 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Corey Minyard <cminyard@mvista.com>
Cc:     minyard@acm.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Adrian Reber <areber@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Andrei Vagin <avagin@gmail.com>
Subject: Re: [PATCH v2] pid: Fix error return value in some cases
Message-ID: <20200308170750.jhl5rxyy4ek5tl7l@wittgenstein>
References: <20200306172314.12232-1-minyard@acm.org>
 <20200307110007.fmtaaqt2udsgohtp@wittgenstein>
 <20200307131136.GD2847@minyard.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200307131136.GD2847@minyard.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 07, 2020 at 07:11:36AM -0600, Corey Minyard wrote:
> On Sat, Mar 07, 2020 at 12:00:07PM +0100, Christian Brauner wrote:
> > On Fri, Mar 06, 2020 at 11:23:14AM -0600, minyard@acm.org wrote:
> > > From: Corey Minyard <cminyard@mvista.com>
> > > 
> > > Recent changes to alloc_pid() allow the pid number to be specified on
> > > the command line.  If set_tid_size is set, then the code scanning the
> > > levels will hard-set retval to -EPERM, overriding it's previous -ENOMEM
> > > value.
> > > 
> > > After the code scanning the levels, there are error returns that do not
> > > set retval, assuming it is still set to -ENOMEM.
> > > 
> > > So set retval back to -ENOMEM after scanning the levels.
> > > 
> > > Fixes: 49cb2fc42ce4 "fork: extend clone3() to support setting a PID"
> > > Signed-off-by: Corey Minyard <cminyard@mvista.com>
> > > Cc: <stable@vger.kernel.org> # 5.5
> > > Cc: Adrian Reber <areber@redhat.com>
> > > Cc: Christian Brauner <christian.brauner@ubuntu.com>
> > > Cc: Oleg Nesterov <oleg@redhat.com>
> > > Cc: Dmitry Safonov <0x7f454c46@gmail.com>
> > > Cc: Andrei Vagin <avagin@gmail.com>
> > 
> > Thanks! I've pulled the patch now and applied.

Applied as:
https://git.kernel.org/pub/scm/linux/kernel/git/brauner/linux.git/commit/?h=fixes&id=b26ebfe12f34f372cf041c6f801fa49c3fb382c5

Should show up in -next around Monday and I'll target it for rc6. Should
then be backported to v5.5 rather soon!

Thanks!
