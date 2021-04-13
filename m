Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 075BE35D8D0
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 09:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239140AbhDMH1o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 03:27:44 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:54863 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239156AbhDMH1n (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Apr 2021 03:27:43 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 9337F5C00F7;
        Tue, 13 Apr 2021 03:27:24 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 13 Apr 2021 03:27:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=4J/3ehRQT2bEgTvcE4z5BLkmo5c
        haGti4+KFfbMtyCA=; b=carj0jE9yL0AhZpykG26fdX63XKndBQo3AfBIgQEmwP
        cVZWJZGuffSzs3QR38d1XTBXd0fvBkunyNkkd8SU59l3fDZiKSvnKSsAXKKsiBGT
        ypQek8fLZoFHWuTUv9y3j9wpaqH/eXajus1bD9AdEj1Xedv8vj9am/r+KRCBzATq
        nSOd7Rm6nXwHbKk1OwHzu9QrjwNejoHAkTm7LBxkzBN2aI81s7FJVXSydALRS45k
        VUy3FLizTWU5lh+UZYJC0Mt1FLUYb5EDUWw0Naz1NZbEjPDuwUGlTvgmxGO4FFsS
        upCpl3zaBMYmodiIrNvST6X8OcfTbd1hUwIcMct6Cjg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=4J/3eh
        RQT2bEgTvcE4z5BLkmo5chaGti4+KFfbMtyCA=; b=D+6TCjkAZExhFYSzwuvQrn
        PnLHaXu2LYGIKeSzLufk/p9aVLlxZkgNrU9g+WxGTNffu81dSZdE8Tg7/wobkIi9
        1y6cyLhD8gCSgDuBoYFx6U4As6m3GZX9D7zmoewAHed3f+kXdf3W60LxSsopyQ8P
        6iFZ2XyjVCihpgWtZ1sGpRSOrXKYkfVD5GslkBraPgcEyokzGoUaGuz84DyyhCnG
        g6jaCQpPiZivrqR9tpvW/BUqXVgzIw3EM3VtK4havb8S07xZYd4TB4ssVyEkIwJ4
        oHfRd8RoOQ7S9bRNwyhGE9Ow36ZDKTlIbLhEoctXCC8Cv9IKUxtKB3RvviW5+IIQ
        ==
X-ME-Sender: <xms:3Ed1YIc4tv9AT8_PGopcQR6ozz_2KdRYK_aMEyMW-bJ7f-LTAn2jBw>
    <xme:3Ed1YKN3yQ1hiDG11o0cpFiUHRhlVuNs2gnyk9uNQiW45k4RMU4nD_KqZebDqWcnC
    siJuhBR6eJOoA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudekkedguddulecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfhfgggtuggjsehttd
    ertddttddvnecuhfhrohhmpefirhgvghcumffjuceoghhrvghgsehkrhhorghhrdgtohhm
    qeenucggtffrrghtthgvrhhnpeevueehjefgfffgiedvudekvdektdelleelgefhleejie
    eugeegveeuuddukedvteenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:3Ed1YJi66HuAUnbl4yzIQpKhj8Tw5hi5F-Ku5i6aOFeod4iJugx2RQ>
    <xmx:3Ed1YN9uv_IKIDtXLv-vUKK2DxFWV4mxY_vLdB1gDJZCh0nIYcHfBA>
    <xmx:3Ed1YEtT9iwxFjQMAlOphBTPKGj7s-lZeO-T7b8CdsAhnB8W15_w-A>
    <xmx:3Ed1YN7bmd-nJRMDVULsYF-H_0brlHM9I5m83Bjt9PuyD2304m7BaQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0A97A1080057;
        Tue, 13 Apr 2021 03:27:23 -0400 (EDT)
Date:   Tue, 13 Apr 2021 09:27:22 +0200
From:   Greg KH <greg@kroah.com>
To:     "Zidenberg, Tsahi" <tsahee@amazon.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 0/2] fix userspace access on arm64 for linux 5.4
Message-ID: <YHVH2uNBTVDsJ66m@kroah.com>
References: <56be4b97-8283-cf09-4dac-46d602cae97c@amazon.com>
 <YHGMWBj+DEW+EiQE@kroah.com>
 <e99e851a-07c3-ab83-0d10-fa2bb87a516d@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e99e851a-07c3-ab83-0d10-fa2bb87a516d@amazon.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 12, 2021 at 10:46:41PM +0300, Zidenberg, Tsahi wrote:
> 
> 
> On 10/04/2021 14:30, Greg KH wrote:
> > On Mon, Mar 29, 2021 at 01:56:53PM +0300, Zidenberg, Tsahi wrote:
> >> arm64 access to userspace addresses in bpf and kprobes is broken,
> >> because kernelspace address accessors are always used, and won't work
> >> for userspace.
> > What does not work exactly?
> >
> > What is broken that is fixed in these changes?  I can't seem to
> > understand that as it feels like bpf and kprobes works on 5.4.y unless
> > something broke it?
> >
> > confused,
> >
> > greg k-h
> 
> The original bug that I was working on: command line parameters don't
> appear when snooping execve using bpf on arm64.

Has this ever worked?  If not, it's not really a regression that needs
to be fixed, just use a newer kernel version, right?

> This is true using
> either osquery (with --enable_bpf_events) or bcc (execsnoop-bpfcc).
> The reason, it seems, is that in arm64 userspace addresses cannot be
> accessed with kernelspace accessors.
> This bug is fixed with Patch 1.
> 
> Since Patch 1 added ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE, I thought
> it made sense to check what else uses this config. I did not verify
> kprobes are also broken in the same way, but it seems likely, and the
> fix is very small. If only Patch 1 is merged - I'll be happy :)

But your "patch 1" is no where near what that commit is upstream so now
you have divered from what is there and created something new.  And we
don't like that for obvious reasons (no testing, maintaining over time,
etc.)

So again, if you want to do this type of thing, why not just use a newer
kernel?

thanks,

greg k-h
