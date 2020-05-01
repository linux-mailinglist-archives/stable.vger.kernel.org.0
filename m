Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D05D1C0DE7
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 07:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728184AbgEAFxb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 01:53:31 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:37399 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726452AbgEAFxb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 May 2020 01:53:31 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 30979480;
        Fri,  1 May 2020 01:53:30 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 01 May 2020 01:53:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=aL2xoRvlH3KhRZsuUB+rD3AmlYc
        cUb/P3zhe/y/AnQk=; b=cDeOnyzkS1pzz4RvdQSYaflaxsfqWUym5u/eIbYN7wW
        E+z2iG1Co+7V3e8Eo1o+kaPL/s8hieocH4YjrovsbwuWiAp1F90biJT28tqYfM0I
        CIJrxv/RavUAT2fwPpCWfu5EU6dHGTVKTa1ko2sulSMg1AI8mEIUzROMP3gBRzfi
        w9OUxv4dcC67AIMM0E42ITeo4R0MVvCCG05/kxWDW3Wm3WFA+jh5RILn4oFY3mKr
        R28EJXYI2jwwqbEFaOSnKGmDjYR6l5Y0MLg0Hccx4ng8BxuNfUojMNoiR9Mpv4hh
        Ga/sKFYHarvxTkBArruPADQOeMderQ+muzDsqQAgu2w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=aL2xoR
        vlH3KhRZsuUB+rD3AmlYccUb/P3zhe/y/AnQk=; b=n2FRkI87xDtyzVITcDIe66
        Maq38f389+E2/oPtOW1ZbPBQUrOiaS7scgKxUfEol5cHREy6nEPyS6SX3w9bZ2Vc
        uplXixOOms8BfYxgnHijyS0yaXWObax8FugqHlg1/enP60OiE7x5kuwWp/84KgRN
        B9dDnvRBhdCF0S6PqHi7lyQ25MvWCr48kVPj1hKV2KzmMwkXaVQZ1O/dkGWBhncR
        VXnIYXqCVh02nLpxpP/nx+V2gOH1FGUfy2agwUcnjsQ2K3BJCcmsr63W2EhNfP6J
        4bAi3fSyJSeOPY4askKlhK0d2wVlqT0buqAc2rb991cy8QBdnZVDkaFsXutFjNyg
        ==
X-ME-Sender: <xms:WbmrXhC4_OFEtN-UaXJRuFnZF143MliT8_bPlUdDeLlXDquqEs1Y5Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrieeigdelkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepueelledthe
    ekleethfeludduvdfhffeuvdffudevgeehkeegieffveehgeeftefgnecuffhomhgrihhn
    pehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghh
    rdgtohhm
X-ME-Proxy: <xmx:WbmrXgxEWYrRFQmoF_9pNMMGYKJ65htZkISsWyZHMT9MACDrGmI3iA>
    <xmx:WbmrXuVl_uSB_vsI4-gKarrfWdjU8mRJSmJpdDWj-Di1FBhw87Vhjg>
    <xmx:WbmrXlN5duXHpV6UBoXyZO1xvgjlbNAz9E67FXR0oJUa4Y4VJZULlA>
    <xmx:WbmrXoLqh7rQPNCi7c3l-USjght9IDL9Z58MFtHX-oVSTeQ--BNgRA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 62CE63280059;
        Fri,  1 May 2020 01:53:29 -0400 (EDT)
Date:   Fri, 1 May 2020 07:53:26 +0200
From:   Greg KH <greg@kroah.com>
To:     rananta@codeaurora.org
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Subject: Re: Request to backport a patch onto 5.4.y stable
Message-ID: <20200501055326.GA805178@kroah.com>
References: <b8f451c80fe1cd57bdd4fea74d21e8cd@codeaurora.org>
 <20200430233357.GA13035@sasha-vm>
 <ba319dc2e66986c7cc594f88ce98621c@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ba319dc2e66986c7cc594f88ce98621c@codeaurora.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 30, 2020 at 08:23:54PM -0700, rananta@codeaurora.org wrote:
> On 2020-04-30 16:33, Sasha Levin wrote:
> > On Thu, Apr 30, 2020 at 01:36:45PM -0700, rananta@codeaurora.org wrote:
> > > Hi,
> > > 
> > > I need help to backport the patch with the following details onto
> > > the 5.4.y stable branch:
> > > Subject: [PATCH] tty: hvc: Fix data abort due to race in hvc_open
> > > commit-id: e2bd1dcbe1aa34ff5570b3427c530e4332ecf0fe
> > > Reason: The issue addressed in the patch was discovered on 5.4.y
> > > branch
> > 
> > Is it in Linus's tree?
> It's on linux-next tree:
> https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/drivers/tty/hvc/hvc_console.c?id=e2bd1dcbe1aa34ff5570b3427c530e4332ecf0fe

As per the rules documented at:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
a patch has to be in Linus's tree before it can be included in a stable
kernel.

Please work with the tty developer to get this into Linus's tree if you
feel it should be needed there.  As it is, it is only scheduled to be
sent to him for 5.8-rc1 as your patch description did not make it seem
very urgent or relevant for 5.7-final.

thanks,

greg k-h
