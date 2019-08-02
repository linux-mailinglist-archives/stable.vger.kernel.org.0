Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1CA57F5F3
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 13:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732175AbfHBL0Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 07:26:16 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:39537 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726626AbfHBL0Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Aug 2019 07:26:16 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 11B9131F;
        Fri,  2 Aug 2019 07:26:14 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 02 Aug 2019 07:26:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=OOLhpOhNrbMFYRNxaoCSvVoVp7P
        GZ9QF6eInTqUctgs=; b=lpwXyVUYCs+cnlWZC+pOgF74UCQVg+1n25ka9G6JIGc
        CCFM3Hs3SAm2vfOzNFZS0W9hf7+a/Hw3tP/1VnAKXYrpMTMS4CityiKI02h+29PX
        TlGCk1/WV1SfA4gZvoLBUjECAAnrP6znM9rb6HO/SA474VGxPliNOByx2L0SWATY
        rvGnQSvQhSfq60bvifs6rdXkMGL72wtH/pt8jmVL0aLH5fn2vDbZ01G48I3M2oW3
        97oW7oEYsSacxPFBzhvqJhcVd6lng5knnjHgikKjWrUDz2pd+X6zCAeEwxOVR+7S
        tLssidnJ4HT+eJjjKH7V0dDUxb+a8PvsvIwTSMxm0GA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=OOLhpO
        hNrbMFYRNxaoCSvVoVp7PGZ9QF6eInTqUctgs=; b=I5dkvgFDtQKJ9QJEKX3qkz
        twcg5S4/XUOiIvlmf9aTbinEy0ZmjP9YCORbvywsh8SRbiNIEYzFoibPk4MYPzXC
        gDUqYYotuNaThVT5JG1P3FWrN5UCJOf7cqDPIfU7/RYJ7lSzJqJg4bTgfsGl+BNx
        mQcyqOvTpO4rS1RA6Ab8xK9Ay56T88y+OuaPZuVpBwFkwrSi+oYtX8UJTjwiDuzn
        QIm+36N2lK/7jcUZuwqXS721h0ERvEc1eD6yHFRO7/AnnMtjTB4iKtpa3wdnwUlQ
        I4s8Qj7qVG4XEgrIWTxq+W5iyHZxMDEPz/KYfLmZqh4t/K97TBNnBkIZq1Lr/S8g
        ==
X-ME-Sender: <xms:1h1EXTN8Z_gdzxA95qrxM6BeyntjhBRsUcn3MovdM7suZ3-2SYf8Uw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrleelgddugecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucffohhmrghinhepghhithhhuhgsrd
    gtohhmnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhho
    mhepghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:1h1EXZbF8nU5HJ-8fSNEPxzK6v4MmWEp_MJVVMYpHLTAuDfsKGjh1g>
    <xmx:1h1EXQ8LHOC5EdSp-vFHYtTHvZOwSl3zkRFhWpLCDmGfruLiReBL1w>
    <xmx:1h1EXU1eViqDb1lAxpENqDjUVYrXZLffHL42VSNU-fMHlh5XZPCMgw>
    <xmx:1h1EXY0cM9b8FMriPs0CxK9IrE4FTs5UQbM3PivEElKX9LamBFMbkg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id BC57680061;
        Fri,  2 Aug 2019 07:26:13 -0400 (EDT)
Date:   Fri, 2 Aug 2019 13:26:12 +0200
From:   Greg KH <greg@kroah.com>
To:     Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc:     Rolf Eike Beer <eb@emlix.com>, stable@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linux 4.9.180 build fails =?utf-8?Q?wi?=
 =?utf-8?Q?th_gcc_9_and_'cleanup=5Fmodule'_specifies_less_restrictive_attr?=
 =?utf-8?Q?ibute_than_its_target_=E2=80=A6?=
Message-ID: <20190802112612.GB29534@kroah.com>
References: <259986242.BvXPX32bHu@devpool35>
 <20190606185900.GA19937@kroah.com>
 <CANiq72n2E4Ue0MU5mWitSbsscizPQKML0QQx_DBwJVni+eWMHQ@mail.gmail.com>
 <4007272.nJfEYfeqza@devpool35>
 <CANiq72=T8nH3HHkYvWF+vPMscgwXki1Ugiq6C9PhVHJUHAwDYw@mail.gmail.com>
 <20190802103346.GA14255@kroah.com>
 <CANiq72neLZLB5dKsqK8y=_JDNf=Ea07b_jYutBXJ8Y=kse1q8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANiq72neLZLB5dKsqK8y=_JDNf=Ea07b_jYutBXJ8Y=kse1q8A@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 02, 2019 at 12:39:38PM +0200, Miguel Ojeda wrote:
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
> Done! Please double check, since I am not used to send to stable.

Yes, got them, thanks!  I'll queue them up next week for the next round
of releases and let you know if I have any problems with them.

thanks again,

greg k-h
