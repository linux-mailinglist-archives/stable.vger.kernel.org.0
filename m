Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AFE814D11D
	for <lists+stable@lfdr.de>; Wed, 29 Jan 2020 20:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727500AbgA2TQc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jan 2020 14:16:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:34300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726171AbgA2TQc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 Jan 2020 14:16:32 -0500
Received: from localhost (unknown [155.52.187.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 597C9205F4;
        Wed, 29 Jan 2020 19:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580325391;
        bh=Ekd69VFmcvzzOaQfJ4W2iTm/PHo/WIelF4vBgCoenhY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZqNsHe6IV2v+dHIO2tPi3OWU1HHdep3RIn5JOXAtfMHf7cROBCtYeh194e4qoRCe+
         ganRLXo8YwbV9PZeRjBUx4//sHNFNG5g33GZH5zdfao247N1j4v+bVjj27NVOEKoC2
         RBNd/23hvjyH0twMFMy8/TDd0siuyeYKr35qdYz0=
Date:   Wed, 29 Jan 2020 14:16:30 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Jeremy Linton <jeremy.linton@arm.com>, stable@vger.kernel.org,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: Request to backport "Documentation: Document arm64 kpti control"
Message-ID: <20200129191630.GB2896@sasha-vm>
References: <520fee3a-4d14-9a78-e542-cce98acae9f6@gmail.com>
 <20200126135233.GB11467@sasha-vm>
 <20200127155106.GA668073@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200127155106.GA668073@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 27, 2020 at 04:51:06PM +0100, Greg Kroah-Hartman wrote:
>On Sun, Jan 26, 2020 at 08:52:33AM -0500, Sasha Levin wrote:
>> On Sat, Jan 25, 2020 at 08:03:25PM -0800, Florian Fainelli wrote:
>> > Hi Greg, Sasha,
>> >
>> > Could you backport upstream commit
>> > de19055564c8f8f9d366f8db3395836da0b2176c ("Documentation: Document arm64
>> > kpti control") to the stable 4.9, 4.14 and 4.19 kernels since they all
>> > support the command line parameter.
>>
>> Hey Florian,
>>
>> We don't normally take documentation patches into stable trees.
>
>Normally we do not, but this is simple enough I've queued it up for 4.19
>and 4.14.  Are you sure it is ok for 4.9?  If so, Florian, can you
>provide a backported version of it?

My objection to taking documentation patches is either that we take all
of them, or we take none. If we take only select documentation fixes it
makes a frankenstein Documentation/ directory that might cause more harm
than benefit.

Let's say I'm looking for netfilter documentation on 4.19, can I trust
linux-4.19.y or do I look upstream? Right now I know I have to look
upstream, but if we tell people it's okay to trust the linux-4.19.y docs
then we might be causing harm to our users when some fixes were
backported but corresponding documentation fixes weren't.

-- 
Thanks,
Sasha
