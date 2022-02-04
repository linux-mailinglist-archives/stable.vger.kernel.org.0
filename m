Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B52004AA362
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 23:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352223AbiBDWof (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 17:44:35 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42460 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234792AbiBDWoe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 17:44:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93DEBB83954;
        Fri,  4 Feb 2022 22:44:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AFD5C004E1;
        Fri,  4 Feb 2022 22:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644014672;
        bh=pyYNY1Bq0ypF78uQDHSBS1tHlqG7MtbC5GqmbFlxxGw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QemKoY3hr/lcbvj0MhK6HnCVSa5ayyzM4RHXEOy97I22apRoNvw2fCBg23X8uTC66
         WVL3dlBIbwSM5CuA2JPiJVSvaHyBhRoyMWC4U/xChuVPLHZ1rf9d7mddGQP/rGPs/n
         M3TwOexL9ABXmwoPBbEIzS4h/HxJ+Z+VAFW26raE=
Date:   Fri, 4 Feb 2022 14:44:31 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Jann Horn <jannh@google.com>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org,
        Bill Messmer <wmessmer@microsoft.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Randy Dunlap <rdunlap@infradead.org>, stable@vger.kernel.org,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] coredump: Also dump first pages of non-executable ELF
 libraries
Message-Id: <20220204144431.b5d2b40d22bd5c458846b008@linux-foundation.org>
In-Reply-To: <CAG48ez1RzO8KrbAv_9kwRCyjS7E3K+adJzdqV6uLqKPoyQmPnw@mail.gmail.com>
References: <20220126025739.2014888-1-jannh@google.com>
        <87czk5l2i6.fsf@email.froward.int.ebiederm.org>
        <CAG48ez3byq=Cn4xGt5HmLBy9fWBapX9RdF-9JOaAus=rDR2TYQ@mail.gmail.com>
        <CAG48ez1RzO8KrbAv_9kwRCyjS7E3K+adJzdqV6uLqKPoyQmPnw@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 4 Feb 2022 00:59:59 +0100 Jann Horn <jannh@google.com> wrote:

> > > I looked in the history and the code was filtering for ELF headers
> > > there already.  I am just thinking this feels like a good idea
> > > regardless of the file format to help verify the file on-disk
> > > is the file we think was mapped.
> >
> > Yeah, I guess that's reasonable. The main difference will probably be
> > that the starting pages of some font files, locale files and python
> > libraries will also be logged.
> 
> Are you planning to turn that into a proper patch and take it through
> your tree, or something like that? If so, we should tell akpm to take
> this one back out...

I have
coredump-also-dump-first-pages-of-non-executable-elf-libraries.patch on
hold, pending outcome of this discussion.

