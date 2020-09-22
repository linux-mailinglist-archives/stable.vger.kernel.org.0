Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95ADA2741D8
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 14:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbgIVML4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 08:11:56 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:50927 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726505AbgIVML4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Sep 2020 08:11:56 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 29D70D19;
        Tue, 22 Sep 2020 08:11:55 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 22 Sep 2020 08:11:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm1; bh=7
        Y+h0lmLvRAG/NRPpOhCcA+uWMu44/QeCmDOIjJOY1I=; b=hWM8AMXbUIvJeAqOn
        O6f8Az1MzuFyAet/vVdi1W2zLNIUzQVzILknl2dSr+LCXAFwEwVtHLjdmp76HymD
        nz6h/x2YfDF+nDGClhkv5jAWARQY166UUifbi5CknaTdSsMAc8wjfE68TywvKxE1
        71jKVxGyIirZWuTwnFHsCMQmG8rMXIGVuADqhQXWNn1IJIl7tdmeZjn84pytsDIq
        /sbxOWz0olhRLNgE/k3LCIvYPNvARcU5lqoQTWhZfx5BcX0lMKvlWKaWDop+MCTP
        JUzAYnqiYpHWOKd2YV2b+qU4rMwc7e18smrS+a1sN+oNEj+6USo1ORq//crXkrBC
        PsOOw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=7Y+h0lmLvRAG/NRPpOhCcA+uWMu44/QeCmDOIjJOY
        1I=; b=m7QOgkCgG8T5EjTM61cHh45AoeBOqTUwj+viHXiEVvqqtEZ1yyS/GUCCZ
        IAlExkYMElsDPgXkHUrGtgltP5ZOBeOPYVqplVCtPwq1yiL/Y5ZmpLdJhueDSX3r
        DKTF65B+UmR+IgiK7B8Z4HWnhi1WzJB4Supe6cJv8b49HxaD5K5WciuTukgk9va+
        1LB3T/GU4Uu0nKaCxCaCuHBnrISPRovLQLAXkQzhjFeGSuq3/ZDa3PrObuIBoZYG
        uJlw+pCKkNRIlgyNejttCFLazy6UNQqSvR55LBZVk/57kVSEP4ONEZ54A6mQkv87
        wP0+WPf+hsNcb5TZO33HuylZPX5wQ==
X-ME-Sender: <xms:CuppX3P-FbdqXxRhCd3y407pdb3qKe4XSZ4wD0JO-XZMwyCKEO9POw>
    <xme:CuppXx_F8kqDJz72D7HmrLF2rHehef3e3p5lkL3JlbLHkork8kE9gIwOUGoxh8rL_
    g2Rcxp9q1_YxQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudeggdehtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggugfgjsehtkeertddttdejnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeegieejue
    dvffeuvdfftdetfeeuhfekhefgueffjeevtedtlefgueduffffteeftdenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghh
    rdgtohhm
X-ME-Proxy: <xmx:CuppX2QgbJhCoErscEaxViLhP8Af8Lwp6iiEopGP4T3qbAjGTCXIag>
    <xmx:CuppX7sON-QmbXbiaNWkEJq5nvjhVhHYhfXjUjkjheEakfo6xf2xdw>
    <xmx:CuppX_cLVZ1m19lWZpTrT-m9HgyEwzzATx7DxPv9B5mjqNEmJpVXeQ>
    <xmx:CuppX3EWnf5kIczLUsGSpEpGawTipqsnjm4j9hRPL0-NwOR0f6wVgQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5793E3064684;
        Tue, 22 Sep 2020 08:11:53 -0400 (EDT)
Date:   Tue, 22 Sep 2020 14:12:14 +0200
From:   Greg KH <greg@kroah.com>
To:     Haiwei Li <lihaiwei.kernel@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "stable-commits@vger.kernel.org" <stable-commits@vger.kernel.org>
Subject: Re: Patch "KVM: Check the allocation of pv cpu mask" has been added
 to the 5.8-stable tree
Message-ID: <20200922121214.GB2244437@kroah.com>
References: <20200921104234.9C539216C4@mail.kernel.org>
 <EE2DABCA-2B97-4D46-8AFB-7F94DED675F8@tencent.com>
 <20200921132850.GM2431@sasha-vm>
 <E0D58EE6-0CA2-4594-877B-FDE2C1806272@tencent.com>
 <20200921142807.GA643426@kroah.com>
 <601A8297-7002-43E1-93AB-DB29F7E3BA92@tencent.com>
 <CAB5KdObZ2PZZRF56xb0YT4i0Mt=_mz36fE9U-D2GOhuUVX5ujg@mail.gmail.com>
 <1da91e3b-4fa8-6e24-50b2-932e8085f598@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1da91e3b-4fa8-6e24-50b2-932e8085f598@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 22, 2020 at 08:52:58AM +0800, Haiwei Li wrote:
> 
> 
> On 20/9/21 23:08, Haiwei Li wrote:
> > > On Sep 21, 2020, at 22:28, Greg KH <greg@kroah.com> wrote:
> > > 
> > > On Mon, Sep 21, 2020 at 02:14:41PM +0000, lihaiwei(李海伟) wrote:
> > > 
> > > 
> > > On Sep 21, 2020, at 21:28, Sasha Levin <sashal@kernel.org> wrote:
> > > 
> > > On Mon, Sep 21, 2020 at 10:54:38AM +0000, lihaiwei(李海伟) wrote:
> > > 
> > > 
> > > On Sep 21, 2020, at 18:42, Sasha Levin <sashal@kernel.org> wrote:
> > > 
> > > This is a note to let you know that I've just added the patch titled
> > > 
> > >   KVM: Check the allocation of pv cpu mask
> > > 
> > > to the 5.8-stable tree which can be found at:
> > >   http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> > > 
> > > The filename of the patch is:
> > >    kvm-check-the-allocation-of-pv-cpu-mask.patch
> > > and it can be found in the queue-5.8 subdirectory.
> > > 
> > > If you, or anyone else, feels it should not be added to the stable tree,
> > > please let <stable@vger.kernel.org> know about it.
> > > 
> > > 
> > > This patch is not a correct version, so please don’t add this to the stable tree, thanks.
> > > 
> > > 
> > > What's wrong with it? That's what landed upstream.
> > > 
> > > 
> > > The patch landed upstream is the v1 version. There are some mistakes and shortcomings. The message discussed is
> > > 
> > > https://lore.kernel.org/kvm/d59f05df-e6d3-3d31-a036-cc25a2b2f33f@gmail.com/
> > > 
> > > Then, a revert commit was pushed. Here,
> > > 
> > > https://lore.kernel.org/kvm/CAB5KdObJ4_0oJf+rwGXWNk6MsKm1j0dqrcGQkzQ63ek1LY=zMQ@mail.gmail.com/
> > > 
> > > 
> > > What is the git commit id of the revert in Linus's tree?
> > > 
> The revert commit was pushed. I am sorry I just saw this commit.
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=7d1f8691ccffe88cec70a6e4044adf1b9bbd8a7c

Thanks for this, I've dropped it from the 5.8.y queue now.

greg k-h
