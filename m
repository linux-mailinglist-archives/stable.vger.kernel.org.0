Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7B8E1400A9
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 01:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729650AbgAQAOw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 19:14:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54539 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbgAQAOw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jan 2020 19:14:52 -0500
Received: from ip5f5bd663.dynamic.kabel-deutschland.de ([95.91.214.99] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1isFHc-00012t-UB; Fri, 17 Jan 2020 00:14:41 +0000
Date:   Fri, 17 Jan 2020 01:14:40 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Richard Weinberger <richard.weinberger@gmail.com>
Cc:     Amanieu d'Antras <amanieu@gmail.com>,
        Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        stable <stable@vger.kernel.org>,
        linux-um <linux-um@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH] um: Implement copy_thread_tls
Message-ID: <20200117001439.zshbw3anlzx3yzqd@wittgenstein>
References: <20200102172413.654385-1-amanieu@gmail.com>
 <20200104123928.1048822-1-amanieu@gmail.com>
 <20200105151928.qrmhnwer3r5ffc77@wittgenstein>
 <20200107123548.5fzu4v6czrlhrhmh@wittgenstein>
 <CAFLxGvzG4DJH5a7cAV6U+wPBqHUOJ6XQmy-u2ibawM3jsQXQBw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAFLxGvzG4DJH5a7cAV6U+wPBqHUOJ6XQmy-u2ibawM3jsQXQBw@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 17, 2020 at 01:12:31AM +0100, Richard Weinberger wrote:
> On Tue, Jan 7, 2020 at 1:36 PM Christian Brauner
> <christian.brauner@ubuntu.com> wrote:
> >
> > On Sun, Jan 05, 2020 at 04:19:28PM +0100, Christian Brauner wrote:
> > > On Sat, Jan 04, 2020 at 01:39:30PM +0100, Amanieu d'Antras wrote:
> > > > This is required for clone3 which passes the TLS value through a
> > > > struct rather than a register.
> > > >
> > > > Signed-off-by: Amanieu d'Antras <amanieu@gmail.com>
> > > > Cc: linux-um@lists.infradead.org
> > > > Cc: <stable@vger.kernel.org> # 5.3.x
> > >
> > > Thanks. I'm picking this up as part of the copy_thread_tls() series.
> > > (Leaving the patch in tact so people can Ack right here if they want to.)
> > > If I could get an Ack from one of the maintainers that would be great;
> > > see
> > > https://lore.kernel.org/lkml/20200102172413.654385-1-amanieu@gmail.com
> > > for more context.
> > >
> > > Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
> >
> > I've this up as part of the series link in above ^^ and moved it into
> > https://git.kernel.org/pub/scm/linux/kernel/git/brauner/linux.git/log/?h=clone3_tls
> >
> > If I hear no objections I'll merge into into my fixes tree today or
> > tomorrow.
> >
> > An Ack from one of the maintainers would still be appreciated.
> 
> For sure too late, but better than nothing? ;-)
> 
> Acked-by: Richard Weinberger <richard@nod.at>

Still worth having it. :)

Thanks!
Christian
