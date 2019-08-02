Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E97E7F5F1
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 13:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729125AbfHBLZq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 07:25:46 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:39613 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726626AbfHBLZq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Aug 2019 07:25:46 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 659A640A;
        Fri,  2 Aug 2019 07:25:45 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 02 Aug 2019 07:25:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=Ux/SSLzm70zAXQcCzmf+pfPz1OX
        DFyZddlkc33KjE7Y=; b=WFQGR81dor7POR821qbY95pBzPW4EHIi/MQTxLdLvkg
        tmzqfwkarYLjAhNYN8t5WyRgAH1PywxgAsBUu2GorZaMRUFZHjvtdVje1g/II0kL
        oyaiDYg3X6rYTIKH2BGaaLtmbn8Q/08znhWbO6LGTL/h+0TrLN6sVtKd+so91Dsj
        jfNErCRLLhhqPA/kB20O3sw1CQQDFbyJFW0wy8XS3BuEswS/Azqq6MRKHJvXEqkF
        BcQyg/hikleLRudoDz++QiiMrcxSQiCjzGFavzlv7ZlmL+wNYQsi7TbbgDWyYhr+
        8uAj+z9C0S6/Uw2JpHUzQX4K1+zauB14ozQilm/G8mg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Ux/SSL
        zm70zAXQcCzmf+pfPz1OXDFyZddlkc33KjE7Y=; b=IS/7bF+BZQp+wNgIMgbs4P
        Hw8KtC3sokkyFmq+b9DLAo9h39KATWqAvqD1+FYIAR+6KszCINIvkh7OGA45e4Sb
        DQK42SHWQJso9FMQAALXZRR0YkVClc9tCRPF0YjjUhZUmBbfiO+t0XcKUt2a3Z3M
        TrwYavgHtBjJJYvRcXD62I9phi5duUVxBW13taEKmYvXwA9OrCkvp0XgwtCuO33+
        0aAT5jWyMmnxdN6jRXhWv+F/qZDRn369osKOdc4mHJrH+oxcQM1CHU6vkOPt4yQv
        qCutdS157sFLS5txycoyhF1lNsn1ACaASPqWsDUSZSmLi5HHysWiWCke7a+F/7Sg
        ==
X-ME-Sender: <xms:uB1EXaHmDuRik5od-9fbMKz4_IO-QuDAid51c6L8-m_uSVvONboQmA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrleelgddugecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucffohhmrghinhepghhithhhuhgsrd
    gtohhmnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhho
    mhepghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:uB1EXfnNHVlNtqjRmnTBIaitEIJlBQwYYqu0kJ2KOSdlQOcYSCIWhg>
    <xmx:uB1EXfJV9UmmvZILe2JwEnIURtvLn_3XaADiDRpGaPaZHwe3ZnhfBw>
    <xmx:uB1EXYYNxA6w5-jcS-JYNkNpOTizTNFf1lR1ETTRC-RRrxlQ5Nzq_A>
    <xmx:uR1EXe2Toyor378gHG_1Rh0B8qSDm0YNRHQHig8bgNIOrkchNjkHcg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3C1E080059;
        Fri,  2 Aug 2019 07:25:44 -0400 (EDT)
Date:   Fri, 2 Aug 2019 13:25:42 +0200
From:   Greg KH <greg@kroah.com>
To:     Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc:     Rolf Eike Beer <eb@emlix.com>, stable@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linux 4.9.180 build fails =?utf-8?Q?wi?=
 =?utf-8?Q?th_gcc_9_and_'cleanup=5Fmodule'_specifies_less_restrictive_attr?=
 =?utf-8?Q?ibute_than_its_target_=E2=80=A6?=
Message-ID: <20190802112542.GA29534@kroah.com>
References: <259986242.BvXPX32bHu@devpool35>
 <20190606185900.GA19937@kroah.com>
 <CANiq72n2E4Ue0MU5mWitSbsscizPQKML0QQx_DBwJVni+eWMHQ@mail.gmail.com>
 <4007272.nJfEYfeqza@devpool35>
 <CANiq72=T8nH3HHkYvWF+vPMscgwXki1Ugiq6C9PhVHJUHAwDYw@mail.gmail.com>
 <20190802103346.GA14255@kroah.com>
 <CANiq72kcZZwp2MRVF5Ls+drXCzVbCfZ7wZ8Y+rU93oGohVAGsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANiq72kcZZwp2MRVF5Ls+drXCzVbCfZ7wZ8Y+rU93oGohVAGsQ@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 02, 2019 at 01:00:30PM +0200, Miguel Ojeda wrote:
> On Fri, Aug 2, 2019 at 12:33 PM Greg KH <greg@kroah.com> wrote:
> >
> > On Fri, Aug 02, 2019 at 12:19:33PM +0200, Miguel Ojeda wrote:
> > > On Fri, Aug 2, 2019 at 10:17 AM Rolf Eike Beer <eb@emlix.com> wrote:
> > > >
> > > > Am Samstag, 8. Juni 2019, 14:00:34 CEST schrieb Miguel Ojeda:
> > > > > On Thu, Jun 6, 2019 at 8:59 PM Greg KH <greg@kroah.com> wrote:
> > > > > > "manually fixing it up" means "hacked it to pieces" to me, I have no
> > > > > > idea what the end result really was :)
> > > > > >
> > > > > > If someone wants to send me some patches I can actually apply, that
> > > > > > would be best...
> > > > >
> > > > > I will give it a go whenever I get some free time :)
> > > >
> > > > I fear this has never happened, did it?
> > >
> > > No. Between summer, holidays and a conference I didn't get to do it.
> > >
> > > Done the minimal approach here:
> > >
> > >   https://github.com/ojeda/linux/commits/compiler-attributes-backport
> > >
> > > Tested building a handful of drivers with gcc 4.6.4, 8.3.0 and 9.1.1.
> > >
> > > Greg, I could backport the entire compiler_attributes.h, but given
> > > this is stable, we are supposed to minimize changes, right?
> > >
> > > I tried to imitate what you do in other stable patches, please check
> > > the Cc:, Link: lines and the "commit ... upstream" just in case.
> >
> > If only those 2 patches are all that is needed, nice!  I'll gladly take
> > them, can you send them to me (and cc: the stable list) in email so I
> > can queue them up for the next round of releases after this one?
> 
> At least for that particular problem, yeah -- I haven't done a full allmod.
> 
> By the way, I just checked 4.14.y and I noticed you had already
> backported it, although going for another solution:
> 
> +#if GCC_VERSION >= 90100
> +#define __copy(symbol)                 __attribute__((__copy__(symbol)))
> +#endif
> 
> and then:
> 
> +#ifndef __copy
> +# define __copy(symbol)
> +#endif

But it still doesn't work for 4.14.y and 4.19.y, so we are probably
missing something there.  So if you want to fix that up, I'd appreciate
patches to do so :)

thanks,

greg k-h
