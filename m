Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35C8418A86
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 15:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726195AbfEIN0w convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 9 May 2019 09:26:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:42030 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726192AbfEIN0w (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 09:26:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 110F2AC5C;
        Thu,  9 May 2019 13:26:51 +0000 (UTC)
Date:   Thu, 9 May 2019 15:26:49 +0200
From:   Michal =?UTF-8?B?U3VjaMOhbmVr?= <msuchanek@suse.de>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org
Subject: Re: Build failure in v4.4.y.queue (ppc:allmodconfig)
Message-ID: <20190509152649.2e3ef94d@kitsune.suse.cz>
In-Reply-To: <e8aa590e-a02f-19de-96df-6728ded7aab3@roeck-us.net>
References: <20190508202642.GA28212@roeck-us.net>
        <20190509065324.GA3864@kroah.com>
        <20190509114923.696222cb@naga>
        <e8aa590e-a02f-19de-96df-6728ded7aab3@roeck-us.net>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.31; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 9 May 2019 06:07:31 -0700
Guenter Roeck <linux@roeck-us.net> wrote:

> On 5/9/19 2:49 AM, Michal Suchánek wrote:
> > On Thu, 9 May 2019 08:53:24 +0200
> > Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> >   
> >> On Wed, May 08, 2019 at 01:26:42PM -0700, Guenter Roeck wrote:  
> >>> I see multiple instances of:
> >>>
> >>> arch/powerpc/kernel/exceptions-64s.S:839: Error:
> >>> 	attempt to move .org backwards
> >>>
> >>> in v4.4.y.queue (v4.4.179-143-gc4db218e9451).
> >>>
> >>> This is due to commit 9b2d4e06d7f1 ("powerpc/64s: Add support for a store
> >>> forwarding barrier at kernel entry/exit"), which is part of a large patch
> >>> series and can not easily be reverted.
> >>>
> >>> Guess I'll stop doing ppc:allmodconfig builds in v4.4.y ?  
> >>
> >> Michael, I thought this patch series was supposed to fix ppc issues, not
> >> add to them :)
> >>
> >> Any ideas on what to do here?  
> > 
> > What exact code do you build?
> >  
> $ make ARCH=powerpc CROSS_COMPILE=powerpc64-linux- allmodconfig
> $ powerpc64-linux-gcc --version
> powerpc64-linux-gcc (GCC) 8.3.0
>

Gcc should not see this file. I am asking because I do not see an .org
directive at line 839 of 4.4.179. I probably need some different repo
or extra patches to see the same code as you do.

Thanks

Michal
