Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 622CC7F511
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 12:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388033AbfHBKdv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 06:33:51 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:48201 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730143AbfHBKdv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Aug 2019 06:33:51 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id A582E400;
        Fri,  2 Aug 2019 06:33:49 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 02 Aug 2019 06:33:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=rzS6XuNYwD34+UrvpJIGC8ldeuz
        lzqnOgE995Y09X0s=; b=HAXqxdheLUb0v1xy7RsVcMERiwRQw9+/2fCE/xKL4ID
        giu2MuieuVNtOGh8l++quWR5CyMPR07Fu5Zz8UHMQHBbB+g9lH2LeXDJbsbiMIvE
        tYLXZC9Jsmg4amXKRJm2F2t6YgBiy5Wu+ZQOA6W9a43t3OdEi7A7yqsb2NRdvySP
        nTZLG0DatKAIohty5UjarljaCw2wanoYiyGiFmp3t6rIqxIwaaIggeze7RxgnkZq
        7LrBezrtqp3SeIfINycf5VhVjLyG9Ot6GuBQZhw4xSO15EX9wTT1ZUEqjK9i5M+U
        rUlZ1gK1hrlRDs449k11Weo2XONXVXsS3icqBFG8yww==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=rzS6Xu
        NYwD34+UrvpJIGC8ldeuzlzqnOgE995Y09X0s=; b=YhkceHBe2Brk8kOCIAP54v
        uZ/1MG/PvFltjRk3NgVE+4N9DdzOn55f+wei/g0tASO4lFA4PL/ta/ZbHrizHAwI
        R8TjHWpyJRhah5566j5VRB0EoSYWho25/57evwjPviiHX1ZHKKJoslrQwQMdfScL
        TGEdI4b/LIB4jwwvSOKQ3AsELNbAKM7i8VAyJVDalw6Brl0SlyfmpE9Rlt3iAjhv
        vHlSgwZwuVFo33ct29/QdqRPXh884oNTMsMLjpvWUpR8Xh91xzBqsS+6tu4Ldhlz
        Xb7IXwSytmZmAs7bhATu2cnElYzF84dEmmx1+J8q3+Yfo4I4kmt8a4PxZIowUsyA
        ==
X-ME-Sender: <xms:jBFEXXXNGhcnx20SJIrw0TDkF2sS1mQSci0A17pUzeZDV0Z5_g2S1g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrleelgddtfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucffohhmrghinhepghhithhhuhgsrd
    gtohhmnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhho
    mhepghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:jBFEXbYX_9cRUn_20MDE9utlQuGkCebgFcnLtV0dEqmYhNR7QW2A2Q>
    <xmx:jBFEXavKjxFEWVUVsHjtEK3kGjoegVtKwDueN7K_ye-gKqFu3xQFGQ>
    <xmx:jBFEXVnQfce666uwWEzS2fYezCh1ohc3lovO9XsT4C7T2ejpEII0WQ>
    <xmx:jRFEXfPKTmDnMbKKxY9zHJ_-V9-3aOVZffeOBKJISt6cHP-1I2qDbA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 84F178005C;
        Fri,  2 Aug 2019 06:33:48 -0400 (EDT)
Date:   Fri, 2 Aug 2019 12:33:46 +0200
From:   Greg KH <greg@kroah.com>
To:     Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc:     Rolf Eike Beer <eb@emlix.com>, stable@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linux 4.9.180 build fails =?utf-8?Q?wi?=
 =?utf-8?Q?th_gcc_9_and_'cleanup=5Fmodule'_specifies_less_restrictive_attr?=
 =?utf-8?Q?ibute_than_its_target_=E2=80=A6?=
Message-ID: <20190802103346.GA14255@kroah.com>
References: <259986242.BvXPX32bHu@devpool35>
 <20190606185900.GA19937@kroah.com>
 <CANiq72n2E4Ue0MU5mWitSbsscizPQKML0QQx_DBwJVni+eWMHQ@mail.gmail.com>
 <4007272.nJfEYfeqza@devpool35>
 <CANiq72=T8nH3HHkYvWF+vPMscgwXki1Ugiq6C9PhVHJUHAwDYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANiq72=T8nH3HHkYvWF+vPMscgwXki1Ugiq6C9PhVHJUHAwDYw@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 02, 2019 at 12:19:33PM +0200, Miguel Ojeda wrote:
> On Fri, Aug 2, 2019 at 10:17 AM Rolf Eike Beer <eb@emlix.com> wrote:
> >
> > Am Samstag, 8. Juni 2019, 14:00:34 CEST schrieb Miguel Ojeda:
> > > On Thu, Jun 6, 2019 at 8:59 PM Greg KH <greg@kroah.com> wrote:
> > > > "manually fixing it up" means "hacked it to pieces" to me, I have no
> > > > idea what the end result really was :)
> > > >
> > > > If someone wants to send me some patches I can actually apply, that
> > > > would be best...
> > >
> > > I will give it a go whenever I get some free time :)
> >
> > I fear this has never happened, did it?
> 
> No. Between summer, holidays and a conference I didn't get to do it.
> 
> Done the minimal approach here:
> 
>   https://github.com/ojeda/linux/commits/compiler-attributes-backport
> 
> Tested building a handful of drivers with gcc 4.6.4, 8.3.0 and 9.1.1.
> 
> Greg, I could backport the entire compiler_attributes.h, but given
> this is stable, we are supposed to minimize changes, right?
> 
> I tried to imitate what you do in other stable patches, please check
> the Cc:, Link: lines and the "commit ... upstream" just in case.

If only those 2 patches are all that is needed, nice!  I'll gladly take
them, can you send them to me (and cc: the stable list) in email so I
can queue them up for the next round of releases after this one?

thanks,

greg k-h
