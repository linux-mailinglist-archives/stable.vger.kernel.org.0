Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85382187FB
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 11:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbfEIJt1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 05:49:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:39064 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725826AbfEIJt0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 05:49:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id ECD89ABD5;
        Thu,  9 May 2019 09:49:24 +0000 (UTC)
Date:   Thu, 9 May 2019 11:49:23 +0200
From:   Michal =?UTF-8?B?U3VjaMOhbmVr?= <msuchanek@suse.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org
Subject: Re: Build failure in v4.4.y.queue (ppc:allmodconfig)
Message-ID: <20190509114923.696222cb@naga>
In-Reply-To: <20190509065324.GA3864@kroah.com>
References: <20190508202642.GA28212@roeck-us.net>
        <20190509065324.GA3864@kroah.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 9 May 2019 08:53:24 +0200
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> On Wed, May 08, 2019 at 01:26:42PM -0700, Guenter Roeck wrote:
> > I see multiple instances of:
> > 
> > arch/powerpc/kernel/exceptions-64s.S:839: Error:
> > 	attempt to move .org backwards
> > 
> > in v4.4.y.queue (v4.4.179-143-gc4db218e9451).
> > 
> > This is due to commit 9b2d4e06d7f1 ("powerpc/64s: Add support for a store
> > forwarding barrier at kernel entry/exit"), which is part of a large patch
> > series and can not easily be reverted.
> > 
> > Guess I'll stop doing ppc:allmodconfig builds in v4.4.y ?  
> 
> Michael, I thought this patch series was supposed to fix ppc issues, not
> add to them :)
> 
> Any ideas on what to do here?

What exact code do you build?

In my source there the SLB relon handler starts just above this line and
a lot of out-ouf-line are handlers before. Moving some out-of-line
handlers below the parts with fixed location should fix the build error.

Thanks

Michal
