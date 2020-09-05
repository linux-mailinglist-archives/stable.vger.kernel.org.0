Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 303F325E5E7
	for <lists+stable@lfdr.de>; Sat,  5 Sep 2020 09:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726065AbgIEHJv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Sep 2020 03:09:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:53318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725818AbgIEHJv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 5 Sep 2020 03:09:51 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FA42206B5;
        Sat,  5 Sep 2020 07:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599289790;
        bh=Wg3+Qu6Tcoap3P4f6Mve+MDrXT+Vqw3r0BLXGotNuvA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a7elA0glWjabA83LJIx3SWddHmwLgkwcjYHOoeFCD8lspJz9H+rb5+ITni5qa25qQ
         g4S4gWuRdBJA+4ib2kdTGtcsLfcLe7cFhnbUEdK6s+d+HX39RqfxqwT+c0HkQfslxn
         Ud5QaRPThKenDjNquYXMA0lVZVlGTsgRPdkr9MTY=
Date:   Sat, 5 Sep 2020 09:09:46 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     SeongJae Park <sjpark@amazon.com>
Cc:     Muchun Song <songmuchun@bytedance.com>,
        Filipe Manana <fdmanana@suse.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Alexander Tsoy <alexander@tsoy.me>,
        Takashi Iwai <tiwai@suse.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Taehee Yoo <ap420073@gmail.com>,
        Fabio Estevam <festevam@gmail.com>, Jan Kara <jack@suse.cz>,
        Dongli Zhang <dongli.zhang@oracle.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>,
        Adam Ford <aford173@gmail.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Xiaochen Shen <xiaochen.shen@intel.com>, sashal@kernel.org,
        amit@kernel.org, sj38.park@gmail.com, stable@vger.kernel.org
Subject: Re: [5.4.y] Found 27 commits that might missed
Message-ID: <20200905070946.GA184702@kroah.com>
References: <20200904114935.GE2831752@kroah.com>
 <20200904141748.3658-1-sjpark@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200904141748.3658-1-sjpark@amazon.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 04, 2020 at 04:17:48PM +0200, SeongJae Park wrote:
> > <snip>
> > 
> > Stopping right here, if you have fixes that will not cleanly apply, and
> > you think they should be applied, please fix them and send the proper
> > backport.  I don't have the cycles to do these on my own.
> > 
> > Same for anything else here that you think should be applied but does
> > not cleanly build/apply.
> 
> Totally agreed.  Actually, I posted a similar report[1] before and received
> similar response.  I promised to back-port some of those by myself.  That's
> still in my TODO list, but I was unable to get a time to revisit it quite long
> time.  From this, I realized that it wouldn't be easy to review, test, and
> backport all of the such suspicious things by myself.  Scaling up to multiple
> stable series (the tool says there are 152 fixes and 147 mentions for 4.9.y)
> seems impossible.
> 
> For the reason, I updated the tool to make the report to be sent to not only
> the stable maintainers but also the authors of the suspicious commits, because
> the review / test / backport of their own commits would be much easier that
> others.  As a result, we were able to find one suspended commit:
> https://lore.kernel.org/stable/CAKfTPtAkOes+HmVabRazhCBBUo0M+QW38q3Zzj_O3O+Ghvc1pA@mail.gmail.com/

That work had already been done before your email was sent.

I too can write a tool that sends out "this patch might be for stable,
will you do the work for it!" emails, but that's a bit rude to ask
others to do your work for you, don't you agree?  By asking me and
others to dig through this list, when you said you don't have the time
to do so, feels very odd to me.

And if you have only 152 "fixes" for 4.9.y, that's great, should be easy
to work through.  I do know that most of the "easy" backports are
already done, so what is left are the ones that take real work, or do
not make any sense, as your list shows.

So I don't think this report actually helped anyone here, do you?

Again, if you can do the backporting, that will help out greatly.

thanks,

greg k-h
