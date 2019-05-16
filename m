Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4322111D
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 01:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbfEPXz4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 19:55:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:41136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726523AbfEPXzz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 May 2019 19:55:55 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BEE32064B;
        Thu, 16 May 2019 23:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558050955;
        bh=LOb1V0NSN/qXeAr6wEFc4k7XLWaIPEVK/TlvCmkOeBE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jlPOU62QPBew1clHT6zxvIiuE0v5or7LJZBpeEuPEanTA65rtUEYz5Z+Y6PctANaU
         lxeKiA5yOXiWA9Xkultl4t4dU6vtAsOKJ3d/YjUTKt0KCZ7d4NvNf2qUXOJdn6i6E7
         SYx9lqzi+4MhJxEoB95Sgw/2ZwEthaqn0aoXIKYo=
Date:   Thu, 16 May 2019 19:55:53 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Greg KH <greg@kroah.com>, Ingo Molnar <mingo@kernel.org>,
        stable <stable@vger.kernel.org>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] locking fix
Message-ID: <20190516235553.GU11972@sasha-vm>
References: <20190516160135.GA45760@gmail.com>
 <CAHk-=wgtHi5mT7y=0ij-AksQQOBQJqV1apk2bRaH2tfRTxyFcg@mail.gmail.com>
 <20190516183945.GA6659@kroah.com>
 <CAHk-=wgNFabppzpSQQgt7ajrYqmFjtkn2D3n=RvSEDryCLO+=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAHk-=wgNFabppzpSQQgt7ajrYqmFjtkn2D3n=RvSEDryCLO+=g@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 16, 2019 at 11:42:58AM -0700, Linus Torvalds wrote:
>On Thu, May 16, 2019 at 11:39 AM Greg KH <greg@kroah.com> wrote:
>>
>> Thanks, I'll work on that later tonight...
>
>Note that it probably is almost entirely impossible to trigger the
>problem in practice, so it's not like this is a particularly important
>stable back-port.
>
>I just happened to look at it and go "hmm, it's not _marked_ for stable".

I've addressed a missing a8654596f03 ("locking/rwsem: Enable lock event
counting") and queued up a backport for 5.1-4.9.

--
Thanks,
Sasha
