Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE2DD652690
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 19:49:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233255AbiLTSrh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Dec 2022 13:47:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233948AbiLTSrc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Dec 2022 13:47:32 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 833C4AC;
        Tue, 20 Dec 2022 10:47:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=dYyvYAGOdcnUds1h4RkJHQsDRENimICfASD3zlmnD5Q=; b=bomXsWtZ9s97dnCXTM2BGAfHGh
        arVoq/JDHmfHf7dVZ7KwVdnF4jEd78btvGQ2vT9vt4Jr+lDiaXnyvHlkM0auPZSBMGrGeVZGX6Ei8
        XUyjHNHYl3XnJDRAL7ainXMYrEFT+Af8yT/erlSiQz9A91TYCa1CTaZUkCpWhZYmoT7dNMhrh8fS5
        7rCkNUURGoBHVxD50boSHb7p493JqfXTYpfbcFLoDW1XXoAnzCKlfQlI5+2I12HfVyWJCWM/YAMN6
        KdeRndcDiiILDe9EgGabKKLlJ8JSu3KuBYaLE3lJrBCFtRErAuQBj5NIEF0NtHpv19U5/hVTRYVwz
        rUfCjM5A==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p7he7-002nx1-Od; Tue, 20 Dec 2022 18:47:23 +0000
Date:   Tue, 20 Dec 2022 10:47:23 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Allen Webb <allenwebb@google.com>,
        Nick Alcock <nick.alcock@oracle.com>,
        Masahiro Yamada <masahiroy@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-modules@vger.kernel.org" <linux-modules@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>, stable@vger.kernel.org,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v9 02/10] rockchip-mailbox: Fix typo
Message-ID: <Y6IDOwxOxZpsdtiu@bombadil.infradead.org>
References: <20221219191855.2010466-1-allenwebb@google.com>
 <20221219204619.2205248-1-allenwebb@google.com>
 <20221219204619.2205248-3-allenwebb@google.com>
 <Y6FaUynXTrYD6OYT@kroah.com>
 <CAJzde04Hbd2+s-Bqog2V81dBEeZD7WWaFCf2BkesQS4yUAKiNA@mail.gmail.com>
 <Y6H6/U0w96Z4kpDn@bombadil.infradead.org>
 <CAJzde04igO0LJ46Hsbcm-hJBFtPdqJC6svaoMkb3WBG0e1fGBw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJzde04igO0LJ46Hsbcm-hJBFtPdqJC6svaoMkb3WBG0e1fGBw@mail.gmail.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 20, 2022 at 12:19:49PM -0600, Allen Webb wrote:
> On Tue, Dec 20, 2022 at 12:12 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
> >
> > On Tue, Dec 20, 2022 at 08:58:36AM -0600, Allen Webb wrote:
> > > As mentioned in a different sub-thread this cannot be built as a
> > > module so I updated the commit message to:
> > >
> > > imx: Fix typo
> > >
> > > A one character difference in the name supplied to MODULE_DEVICE_TABLE
> > > breaks compilation for SOC_IMX8M after built-in modules can generate
> > > match-id based module aliases, so fix the typo.
> >
> > Are you saying that it is a typo *now* only, and fixing it does not fix
> > compilation now, but that fixing the typo will fix a future compilation
> > issue once your patches get merged for built-in module aliases?
> 
> It was always a typo, it just doesn't affect the build because
> MODULE_DEVICE_TABLE is not doing anything for built-in modules before
> this patch series.
> 
> >
> > > This was not caught earlier because SOC_IMX8M can not be built as a
> > > module and MODULE_DEVICE_TABLE is a no-op for built-in modules.
> >
> > Odd, so why did it use MODULE_DEVICE_TABLE then? What was the reason for
> > the driver having MODULE_DEVICE_TABLE if it was a no-op?
> 
> That is a good question. I can only speculate as to the answer

You can use git blame to trace back to the original commit that added
it, then  use git blame foo.c commit-id~1  on the file to keep going
back until you get to the first commit that added that entry, check out
that as a branch and see if the driver was still not a module then
(tristate). If so then your speculation is very likely accurate and
can be spelled out in the commit log message.

It begs the inverse question too though, you are finding uses of
built-in-always code (never tristate) which uses MODULE_DEVICE_TABLE().
Although today that's a no-op, after your changes this becomes useful
information, so do you need to scrape to see what built-in-aways code
*do* not use MODULE_DEVICE_TABLE() where after your patches it would
have become useful?

Determing if there is value to that endeavour should be easily grasped by
reading the description you are adding to MODULE_DEVICE_TABLE() --
in your patch 5 "module.h: MODULE_DEVICE_TABLE for built-in modules".
Driver developers for built-in-always code should read that description
and be able to decide if they should use it or not. But even your latest
replies to Greg do not make that clear, *I personally gather* rather that
this would in no way shape or form be useful. But is that true?

So why not just remove MODULE_DEVICE_TABLE() from code we know is
built-in-always code instead of fixing a typo just to fix a future
compile issue?

Then your commit log is not about "fix typo", but rather remove a no-op
macro as the driver is always built-in and keeping that macro would not
help built-in code.

> but it
> is plausible people copied a common pattern and since no breakage was
> noticed left it as is.

This level of clarity is important to spell out in the commit log
message, specially if you are suggesting it is just a typo fix. Because
I will take it for granted that it is just that.

If it fixes a future use case where the typo would be more of an issue,
you can mention that in a secondary paragraph or sentence.

> It also raises the question how many modules have device tables, but
> do not call MODULE_DEVICE_TABLE since they are only ever built-in.
> Maybe there should be some build time enforcement mechanism to make
> sure that these are consistent.

Definitely, Nick Alcock is doing some related work where the semantics
of built-in modules needs to be clearer, he for instance is now removing
a few MODULE_() macros for things which *are never* modules, and this is
because after commit 8b41fc4454e ("kbuild: create modules.builtin
without Makefile.modbuiltin or tristate.conf") we rely on the module
license tag to generate the modules.builtin file. Without that commit
we end up traversing the source tree twice. Nick's work builds on
that work and futher clarifies these semantics by adding tooling which
complains when something which is *never* capable of being a module
uses module macros. The macro you are extending, MODULE_DEVICE_TABLE(),
today is a no-op for built-in, but you are adding support to extend it
for built-in stuff. Nick's work will help with clarifying symbol locality
and so he may be interested in your association for the data in
MODULE_DEVICE_TABLE and how you associate to a respective would-be
module. His work is useful for making tracing more accurate with respect
to symbol associations, so the data in MODULE_DEVICE_TABLE() may be
useful as well to him.

You folks may want to Cc each other on your patches.

If we know for certain things *will never* be used or *should not be
used*, as in the case of the module license tag, we should certainly
have tooling to pick up on that crap to help us tidy it up. 

If you determine MODULE_DEVICE_TABLE() *should* not be used for built-in
always code (never tristate) then you and Nick likely have overlap of
macros to tidy up and tooling to share to spot these sort of issues.

  Luis
