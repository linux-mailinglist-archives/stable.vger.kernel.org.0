Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07FD0ABF63
	for <lists+stable@lfdr.de>; Fri,  6 Sep 2019 20:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391944AbfIFS3V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Sep 2019 14:29:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:53954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391371AbfIFS3V (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Sep 2019 14:29:21 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E1932082C;
        Fri,  6 Sep 2019 18:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567794560;
        bh=le0ALQaDnlgcqarLRMQtu/QI4EFwGOH5PX4ms/GeKIc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X1CemnEOLlGMFFQA8Axyn/In8fCt0xMKu+fHtjxyvyRkv17mkIZ32vkPn6sc0p9sl
         y+W1f89QWROdrPTlEACr0WRKklhLUYVQdmmxZ2E1Xzja+B7SBIEEy/hNZD8WWk9TpG
         qcJL9GwDQb2T9LCQXUJk57JUC5gHQa48AcfIXOoc=
Date:   Fri, 6 Sep 2019 14:29:17 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Ricard Wanderlof <ricard.wanderlof@axis.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: revert: ASoC: Fail card instantiation if DAI format setup fails
Message-ID: <20190906182917.GA1528@sasha-vm>
References: <alpine.DEB.2.20.1909061658580.3985@lnxricardw1.se.axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1909061658580.3985@lnxricardw1.se.axis.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 06, 2019 at 05:00:28PM +0200, Ricard Wanderlof wrote:
>
>Sorry for the repost, I relized I stupidly got Greg's email adress wrong
>first time around.
>
>> > On Tue, Aug 27, 2019 at 12:00:14PM +0100, Mark Brown wrote:
>> > > On Sun, Aug 25, 2019 at 09:35:15PM -0400, Sasha Levin wrote:
>> > > > On Wed, Aug 14, 2019 at 10:22:13AM +0100, Mark Brown wrote:
>> > >
>> > > > > > If the DAI format setup fails, there is no valid communication format
>> > > > > > between CPU and CODEC, so fail card instantiation, rather than
>> > > > continue
>> > > > > > with a card that will most likely not function properly.
>> > >
>> > > > > This is another one where if nobody noticed a problem already and things
>> > > > > just happened to be working this might break things, it's vanishingly
>> > > > > unlikely to fix anything that was broken.
>> > >
>> > > > Same as the other patch: this patch suggests it fixes a real bug, and if
>> > > > this patch is broken let's fix it.
>> > >
>> > > If anyone ran into this on the older kernel and fixed or worked
>> > > around it locally there's a reasonable chance this will then
>> > > break what they're doing.  The patch itself is perfectly fine but
>
>(Sorry about the mangled subject line, I'd accidentally deleted the
>original message from my inbox.)
>
>I'm a bit bewildered here. As the author of the original patch I'm of
>course biased, and I can certainly understand the patch being dropped from
>existing release branches, since as Mark correctly states, it does not fix
>any broken behavior and might even break things that happen to work by
>chance.
>
>But is this being dropped from the master branch as well? To me it makes
>the kernel behave in an inconsistent way, first reporting a failure to
>instantiate a specific sound card in the kernel log, but then seemingly
>bringing it up anyway.

Hi Richard,

This patch is only dropped from the stable branches, it still remains in
the mainline branch.

--
Thanks,
Sasha
