Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA8A31C3B1
	for <lists+stable@lfdr.de>; Tue, 14 May 2019 09:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726229AbfENHPD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 May 2019 03:15:03 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:40731 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725946AbfENHPD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 May 2019 03:15:03 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45388P0nqRz9sCJ;
        Tue, 14 May 2019 17:15:00 +1000 (AEST)
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: Build failure in v4.4.y.queue (ppc:allmodconfig)
In-Reply-To: <20190509162340.GB24493@roeck-us.net>
References: <20190508202642.GA28212@roeck-us.net> <20190509065324.GA3864@kroah.com> <87zhnvvgwm.fsf@concordia.ellerman.id.au> <20190509162340.GB24493@roeck-us.net>
Date:   Tue, 14 May 2019 17:15:00 +1000
Message-ID: <871s11tsln.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Guenter Roeck <linux@roeck-us.net> writes:
> On Fri, May 10, 2019 at 12:31:05AM +1000, Michael Ellerman wrote:
>> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
>> > On Wed, May 08, 2019 at 01:26:42PM -0700, Guenter Roeck wrote:
>> >> I see multiple instances of:
>> >> 
>> >> arch/powerpc/kernel/exceptions-64s.S:839: Error:
>> >> 	attempt to move .org backwards
>> >> 
>> >> in v4.4.y.queue (v4.4.179-143-gc4db218e9451).
>> >> 
>> >> This is due to commit 9b2d4e06d7f1 ("powerpc/64s: Add support for a store
>> >> forwarding barrier at kernel entry/exit"), which is part of a large patch
>> >> series and can not easily be reverted.
>> >> 
>> >> Guess I'll stop doing ppc:allmodconfig builds in v4.4.y ?
>> >
>> > Michael, I thought this patch series was supposed to fix ppc issues, not
>> > add to them :)
>> 
>> Well it fixes some, but creates others :}
>> 
>> > Any ideas on what to do here?
>> 
>> Turning off CONFIG_CBE_RAS (obscure IBM Cell Blade RAS features) is
>> sufficient to get it building. Is that an option for your build tests
>> Guenter?
>> 
> I could turn it off unconditionally, meaning it would affect all other
> branches. I would rather stop building ppc:allmodconfig for v4.4.y.

Yeah fine by me. No one actually runs allmodconfig anyway.

cheers
