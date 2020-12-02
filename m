Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39D492CBEC3
	for <lists+stable@lfdr.de>; Wed,  2 Dec 2020 14:54:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbgLBNxf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Dec 2020 08:53:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:58562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726828AbgLBNxe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Dec 2020 08:53:34 -0500
Date:   Wed, 2 Dec 2020 08:52:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606917174;
        bh=XoTqkyOnuVg8HpNdvuGD83rFYjABvTKLsBNEJ6NZteE=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=tPpaWrQ3dJTwskCY/56qUbgy+9tH8zCKhcUbfxZ0tpKQ88DuZjzz5VTpkG4ftYItF
         9MhlhrJpcxN5psa1pw0e6F/GoxY+xnQH8Y/scMJcHQvN1oDVzcG6NvOBpLEaOMgrLG
         ur5Li3JIPz9mxkhZhg1z2LvRMes/t0QItF4ovQFQ=
From:   Sasha Levin <sashal@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Vincent Guittot <vincent.guittot@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Guilherme G. Piccoli" <gpiccoli@canonical.com>,
        Ben Segall <bsegall@google.com>,
        Ingo Molnar <mingo@redhat.com>, Phil Auld <pauld@redhat.com>,
        Tao Zhou <zohooouoto@zoho.com.cn>,
        "# v4 . 16+" <stable@vger.kernel.org>,
        Gavin Guo <gavin.guo@canonical.com>,
        nivedita.singhvi@canonical.com, halves@canonical.com,
        Jay Vosburgh <jay.vosburgh@canonical.com>
Subject: Re: FAILED: patch "[PATCH] sched/fair: Fix unthrottle_cfs_rq() for
 leaf_cfs_rq list" failed to apply to 5.4-stable tree
Message-ID: <20201202135252.GW643756@sasha-vm>
References: <d3188913-ddb8-7198-8483-47d3031b01fe@canonical.com>
 <e87e517b-7f97-66ba-4f17-718330910a7b@canonical.com>
 <X8dHZP78hCVlb3n9@kroah.com>
 <CAKfTPtDTQsaQbB3OrAD5Q=0d5oULu6TD18+WQ1b-S05n46WeyQ@mail.gmail.com>
 <20201202094428.GC3040@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201202094428.GC3040@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 02, 2020 at 10:44:28AM +0100, Peter Zijlstra wrote:
>On Wed, Dec 02, 2020 at 09:21:19AM +0100, Vincent Guittot wrote:
>> On Wed, 2 Dec 2020 at 08:49, Greg KH <gregkh@linuxfoundation.org> wrote:
>> >
>> > On Tue, Dec 01, 2020 at 12:03:18PM -0300, Guilherme G. Piccoli wrote:
>> > > Hey Sasha, sorry to annoy again, but maybe Peter is very busy - wouldn't
>> > > be possible maybe to get that merged after a review from Ben or Ingo? I
>> > > see them in the MAINTAINERS file, specially Ben as CONFIG_CFS_BANDWIDTH
>> > > maintainer.
>> > >
>> > > I understand the confidence in this patch is relatively high, since it's
>> > > a backport from the author, right?
>> >
>> > I still want to see an ack from the maintainer please.
>>
>> SCHEDULER
>
>> M: Vincent Guittot <vincent.guittot@linaro.org> (SCHED_NORMAL)
>
>Vincent is also the one that knows that leaf code best, he did the
>backport, you're not going to get better than that.

So I've asked for someone else to review this because the backport is
somehat different from the upstream commit. Ideally we want these types
of backports to be peer reviewed, just like any other commit that lands
upstream.

If the sched folks feel good about that backport (as indicated above...)
I'll happily merge it in.

-- 
Thanks,
Sasha
