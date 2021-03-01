Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65A9A327A5B
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 10:06:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233530AbhCAJFO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 04:05:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:37668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233399AbhCAJE6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 04:04:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABABD64DD0;
        Mon,  1 Mar 2021 09:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614589455;
        bh=/Bv2eaMC1tr34WPMfmXTqLwWjNThz+303TYI+gL905I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ycHTev7rlqnUgnXvQ+AgAtHS+2Abe/3YKDUHJqqN39TWIAsMV1vlMbt//Z6ab1IFI
         lqd3DRumP0+eGWVzMJ+PyElbIsj8k7F1Odumww9kfQ4WeLq0JrSPwIRK7IXEGgeNOR
         n0MaqunZHoqffXL/WQmSZwoL/sNEJd54Qz8VlOoM=
Date:   Mon, 1 Mar 2021 10:04:12 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Peng Tao <tao.peng@linux.alibaba.com>
Cc:     alikernel-developer@linux.alibaba.com,
        Liu Bo <bo.liu@linux.alibaba.com>,
        Ma Jie Yue <majieyue@linux.alibaba.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Eryu Guan <eguan@linux.alibaba.com>,
        Miklos Szeredi <mszeredi@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH CK 4.19 1/4] fuse: fix page dereference after free
Message-ID: <YDyuDFlWKUL8127m@kroah.com>
References: <1614569779-12114-1-git-send-email-tao.peng@linux.alibaba.com>
 <1614569779-12114-2-git-send-email-tao.peng@linux.alibaba.com>
 <YDygOH7MGVOAYk+H@kroah.com>
 <c9807ed1-dcaa-4e9f-476e-4bcedf0745c4@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c9807ed1-dcaa-4e9f-476e-4bcedf0745c4@linux.alibaba.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 01, 2021 at 04:52:03PM +0800, Peng Tao wrote:
> 
> On 2021/3/1 16:05, Greg Kroah-Hartman wrote:
> > On Mon, Mar 01, 2021 at 11:36:16AM +0800, Peng Tao wrote:
> > > From: Miklos Szeredi <mszeredi@redhat.com>
> > > 
> > > commit d78092e4937de9ce55edcb4ee4c5e3c707be0190 upstream.
> > > 
> > > fix #32833505
> > 
> > What does this mean?
> > 
> > And why are you all backporting random stable kernel patches to your
> > tree and not just taking all of them with a simple merge?
> > 
> > By selectivly cherry-picking patches like this, you are guaranteed to be
> > doing more work, and have a much more insecure and buggy kernel.  The
> > opposite of what your end goal should be, correct?
> > 
> 
> Hi Greg,
> 
> My apology for the noise. It was due to a mistake in my git config. And
> thanks for your suggestions. Our tree is actually a mixture of stable
> backports and feature backports. I guess that's why the cherry-picking
> method was chosen, since a simple merge creates too many conflicts and it is
> error prone to fix them in one shoot.

A "simple merge" will cause initial problems, but after you have
resolved them the first time, all should be good.

As proof that this can work, see the android common kernel trees, which
receive a "simple merge" into all of the different branches within a day
or two of a stable release, with no problems at all.

You need to take all stable patches, doing this cherry-picking will
cause you problems and in the end, takes more time and effort!

good luck,

greg k-h
