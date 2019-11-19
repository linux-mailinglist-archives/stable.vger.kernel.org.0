Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0C1102DA7
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 21:40:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbfKSUkx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 15:40:53 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:46468 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726711AbfKSUkx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 15:40:53 -0500
Received: by mail-pl1-f193.google.com with SMTP id l4so12456912plt.13;
        Tue, 19 Nov 2019 12:40:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=CSaSjdFx+v8TgqrKNkfnWp7nAv6SAOOTZ17l4vlUo0A=;
        b=aJYoIoZo4QrycytU5Yl3xmbMDv1vOxs2Mh3otchnoI4oDPu8VAJgOdYhgnq2GH0N2o
         uALAu4Z1r142+V8LFJ2vOm0bxbtBbpR3BNFH8BdExAK1d/736Cm7OIBw8dBwLzb2eQCp
         nrnnaEpSJD3lq0FWy+1Li3bq6wStpqGL9xbQG1so/goyttNLtjo5wO02/XhueNG9H7bY
         jfIpVYgHKcKNnOe0KSCBN+wWOyFlWoL08SkUPvAv7R16DY7RKc0sqAB7+r0BBEW22uR0
         YGJPINP3M1FEkycEwKf4hYizyRn418KRHU6LyPFdBSGkS97gKXxZLuWwj6Ts5uIlsCN+
         l83A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=CSaSjdFx+v8TgqrKNkfnWp7nAv6SAOOTZ17l4vlUo0A=;
        b=DmJcX6btwKKEDmwVSsdLAhtmnH71mF+I0MczOOxmPe2KfUqaKMGDTWsZaR5hxvM2Ci
         NXZIP+xGvi2h9ryftksszEkZB7kmaDxiseGHm8EQYwFEb8Ul6m690il9huP1+aSQ3oGm
         P0DHkHxici1cAXssYgzGhHUm1IBwyihQMiwTbKdgPgNFowBSzSg3lQhskNcVPJFNO53h
         3BTVvVNn1PR08wqYXvVe7K0hBoAdk2RWYz1itPX/fXmDV2dbzSLZ8mkghkjT/C2ZoQXS
         J7u81UZUqKFn8vrgRir6yyKmHDbCm7Wq8itgfsshsi/DO2gBqnV4nSwLAXixIsmFVViN
         msxQ==
X-Gm-Message-State: APjAAAUE7SuwWZpQ74X5pXumxZFUl7747Hy6+hFntAXEbpXpn64Up5R0
        Id39rC4OLZqCcw+WxAmLP18aSEyX
X-Google-Smtp-Source: APXvYqz5aaftKLhMq3XwHsDL6DPu4M/T0DcRhsAeCdvGD/dzTZxwJuRAZb2EaSKvm4fsVHhq6RqKpA==
X-Received: by 2002:a17:90a:326b:: with SMTP id k98mr8957149pjb.50.1574196051134;
        Tue, 19 Nov 2019 12:40:51 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a6sm24793197pgc.4.2019.11.19.12.40.50
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 19 Nov 2019 12:40:50 -0800 (PST)
Date:   Tue, 19 Nov 2019 12:40:49 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Denis Kirjanov <kda@linux-powerpc.org>
Subject: Re: [PATCH 3.16 000/132] 3.16.74-rc1 review
Message-ID: <20191119204049.GD14938@roeck-us.net>
References: <lsq.1568989414.954567518@decadent.org.uk>
 <20190920200423.GA26056@roeck-us.net>
 <8dbced01558cd8d4a1d4f058010e7d63e5f6810e.camel@decadent.org.uk>
 <CANiq72mYYzH1oS4h9GTODMP1ckZn2GnGTGirue1VLU1aw+Qo2A@mail.gmail.com>
 <13b0e0ced6e9420dc91242dbe85cdf96c06fb645.camel@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13b0e0ced6e9420dc91242dbe85cdf96c06fb645.camel@decadent.org.uk>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 19, 2019 at 02:58:58PM +0000, Ben Hutchings wrote:
> On Sun, 2019-09-22 at 21:26 +0200, Miguel Ojeda wrote:
> > On Sun, Sep 22, 2019 at 9:04 PM Ben Hutchings <ben@decadent.org.uk> wrote:
> > > It looks like this is triggered by you switching arm builds from gcc 8
> > > to 9, rather than by any code change.
> > > 
> > > Does it actually make sense to try to support building Linux 3.16 with
> > > gcc 9?  If so, I suppose I'll need to add:
> > > 
> > > commit edc966de8725f9186cc9358214da89d335f0e0bd
> > > Author: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
> > > Date:   Fri Aug 2 12:37:56 2019 +0200
> > > 
> > >     Backport minimal compiler_attributes.h to support GCC 9
> > > 
> > > commit a6e60d84989fa0e91db7f236eda40453b0e44afa
> > > Author: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
> > > Date:   Sat Jan 19 20:59:34 2019 +0100
> > > 
> > >     include/linux/module.h: copy __init/__exit attrs to init/cleanup_module
> > 
> > Yeah, those should fix it.
> 
> A week or two back I tried building 3.16 for x86_64 with gcc 8, which
> produced some warnings but did succeed (and I know Guenter successfully
> build-tests 3.16 with gcc 8 for many architectures).  However, the
> kernel didn't boot on a test system, while the same code built with gcc
> 4.9 (if I remember correctly) did boot.
> 
> While I'm not about to remove support for gcc 8, this makes me think
> that there are some not-so-obvious fixes required to make 3.16 properly
> compatible with recent gcc versions.  So I would rather not continue
> adding superficial support for them, that may lead to people wasting
> time building broken kernels.
> 

I kind of agree. It would make my life easier since I'd be able to drop
older compilers, but on the other side anyone actually using 3.16 kernels
will very likely not update their compilers for the same reason they don't
update the kernel.

Guenter
