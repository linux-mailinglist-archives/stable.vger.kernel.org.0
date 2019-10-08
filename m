Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 663B8CFC3E
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 16:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbfJHOUp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 10:20:45 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35228 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725795AbfJHOUp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 10:20:45 -0400
Received: by mail-wr1-f65.google.com with SMTP id v8so19655761wrt.2;
        Tue, 08 Oct 2019 07:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jGk4MWMZkTAIeXYuDbRwhGcphWqWu107D+eHL9NFn3g=;
        b=InzhK1nLbMGYUei3X0D3rLlwU60tfmfvgVRQZsqB8Deg7Cy0csosomUPXmqTj+imVy
         igtXMAV2IAjGFF6u02l/cBsCagUB52DbTrK+x9bWKKQgwEa26XNK+Eos7HG5+8w8HDIf
         693w/nnvyf5+kBpYlOb4qE2Ym/oRQ0047SAUGNcfDTc7JQp3GmPMWM8H9a0JY1l89Fyi
         4CqHxOTZ5dLogj5/VuPRdrCWEkNNNuTleBH5mEL89x0uuXbu/+BNsGmhirPKvthjUbEI
         ZaSVCG0ZCn8GzBvLQWUQU9qzjTtHh0A/otWE4V97kbUjH6AE//wHnRsl6VQ3queneAb6
         vh4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jGk4MWMZkTAIeXYuDbRwhGcphWqWu107D+eHL9NFn3g=;
        b=L2JrkF7baKuwpl3jqmIKMn/80CE5ZqQylS7KClh270R9kTe3lw3r3LE6AI7p00BrBY
         pFEHtNNfggtUzb4vNf3ronUna+BY/0H+CaVV6N8ZA2eox5E4U9i2+IZblu4qDHJ7egKj
         z+z9a2Ae6g7g2jbM4Bs/UfTVB7IRJvhvIHTI3EVcp7Woe+zebELxpOjOTyCPWMmz5G2I
         PEOngH/AsXY1nA8OfML+6eDtgWQ9DDM+O1QHsMtqqMMlN6MkHQiIi1IxVMosjpIcmCy7
         Xm8XjQoTdKDy6yBU6bFxgbYMXfkniUDfu6OqLcSHRPQYlUOxHj2damLCqV3q/K2d/LcP
         9+3w==
X-Gm-Message-State: APjAAAX/7VTf7qmw3U7R74lCQTihP8L6iGHeF21Dj4b/ENbnnCQdErkn
        EHS14R/s4AvSXqjc0KW2xZI=
X-Google-Smtp-Source: APXvYqyeT+VLXbtw4Q5jruAq2+vrr36ZPYGxIF4WvsOT8/YF013qqikXYbUhUxfoHYKOk6NidLg/Cw==
X-Received: by 2002:a5d:6a90:: with SMTP id s16mr27268223wru.284.1570544441329;
        Tue, 08 Oct 2019 07:20:41 -0700 (PDT)
Received: from andrea.guest.corp.microsoft.com (userh394.uk.uudial.com. [194.69.102.21])
        by smtp.gmail.com with ESMTPSA id h7sm19467307wrs.15.2019.10.08.07.20.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 07:20:40 -0700 (PDT)
Date:   Tue, 8 Oct 2019 16:20:35 +0200
From:   Andrea Parri <parri.andrea@gmail.com>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        bsingharora@gmail.com, Marco Elver <elver@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        syzbot <syzbot+c5d03165a1bd1dead0c1@syzkaller.appspotmail.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] taskstats: fix data-race
Message-ID: <20191008142035.GA13564@andrea.guest.corp.microsoft.com>
References: <20191007104039.GA16085@andrea.guest.corp.microsoft.com>
 <20191007110117.1096-1-christian.brauner@ubuntu.com>
 <20191007131804.GA19242@andrea.guest.corp.microsoft.com>
 <CACT4Y+YG23qbL16MYH3GTK4hOPsM9tDfbLzrTZ7k_ocR2ABa6A@mail.gmail.com>
 <20191007141432.GA22083@andrea.guest.corp.microsoft.com>
 <CACT4Y+avbYvtF9mHiX=R8Y2=YsP1_QsN6i_FpjLM7UxCKv6vxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+avbYvtF9mHiX=R8Y2=YsP1_QsN6i_FpjLM7UxCKv6vxA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 07, 2019 at 04:18:26PM +0200, Dmitry Vyukov wrote:
> On Mon, Oct 7, 2019 at 4:14 PM Andrea Parri <parri.andrea@gmail.com> wrote:
> >
> > > > >  static struct taskstats *taskstats_tgid_alloc(struct task_struct *tsk)
> > > > >  {
> > > > >       struct signal_struct *sig = tsk->signal;
> > > > > -     struct taskstats *stats;
> > > > > +     struct taskstats *stats_new, *stats;
> > > > >
> > > > > -     if (sig->stats || thread_group_empty(tsk))
> > > > > -             goto ret;
> > > > > +     /* Pairs with smp_store_release() below. */
> > > > > +     stats = READ_ONCE(sig->stats);
> > > >
> > > > This pairing suggests that the READ_ONCE() is heading an address
> > > > dependency, but I fail to identify it: what is the target memory
> > > > access of such a (putative) dependency?
> > >
> > > I would assume callers of this function access *stats. So the
> > > dependency is between loading stats and accessing *stats.
> >
> > AFAICT, the only caller of the function in 5.4-rc2 is taskstats_exit(),
> > which 'casts' the return value to a boolean (so I really don't see how
> > any address dependency could be carried over/relied upon here).
> 
> This does not make sense.
> 
> But later taskstats_exit does:
> 
> memcpy(stats, tsk->signal->stats, sizeof(*stats));
> 
> Perhaps it's supposed to use stats returned by taskstats_tgid_alloc?

Seems reasonable to me.  If so, replacing the READ_ONCE() in question
with an smp_load_acquire() might be the solution.  Thoughts?

  Andrea
