Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31D4D3695E2
	for <lists+stable@lfdr.de>; Fri, 23 Apr 2021 17:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbhDWPO6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Apr 2021 11:14:58 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:59963 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230470AbhDWPO5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Apr 2021 11:14:57 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id ED4E35C01C6;
        Fri, 23 Apr 2021 11:14:20 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 23 Apr 2021 11:14:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=16wN/jkdXOhB2Qv50Rj4wzhke1a
        camhUUODlMup47wE=; b=QjqG0OxtWLeYtWmY8wX4D6A9Nso31fxoBbA8g0Sb1ul
        tE3iabGKEYnU5ck4VOpNgZk5sxI8lGuF5G6vCv5dnN/ncxHSnpGK/MFytsJZLYMC
        zJHs1jNXmEM9aEQKIli2dYaxZ7Dcn/zeGySG+oMlLNoIOxPcyaDUx6+qZmv7wDDC
        9dtyV5yZpXXvhDpRwlPwLmSk0CNmvUee8h43lveX0+htaH9yI2yvaBix1f507EYC
        TO1YU7Xc95dG0CKeXdU4DR7RsVXiTCy/bViA5JgMBEG+MxEpqc/gFiRRYOOPiAFa
        4VAq6E8Ch08rulpNUp+L2Yk89Vn/4KBLZXi8kzQdTSw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=16wN/j
        kdXOhB2Qv50Rj4wzhke1acamhUUODlMup47wE=; b=vgJLBXgSZujv/8vrKkr+ev
        GbND0lNsI5i1bG0eoRjDxlLYFbbKleyKW6sFQrzCYBzeI6DHT4W1ZWA9M+YuiZi8
        S7bDl+26j0mJjydn/20R8QpOWDgWdbxBJonfXK3Ja0BPjyBzJrk12BvI4xqPT8UD
        uQsduMq9h9Lji7ApFKLO88ByAHnvf8g/41Q+KL+cknygTrL1qFFoe8958XmLkLa/
        mrZRiQg2u7nIilLIToZBZF9uZb6v2fHnmTJfnOstHoiZPy/cXWyziJw99lHRLABG
        oE/rbe7w7oECYYfMFSBI+/NNbh5uQjM5RICg+0uRIPpZUi4myNJw5EEJybVUHFBg
        ==
X-ME-Sender: <xms:TOSCYDdEFU3oirWqkQK86V1wJRltjdEtJfvHExuN_w-zWEYWCjpeUg>
    <xme:TOSCYJORAcravfQHARarHPboPqf6Bhnf2dZInXK2Uhkg37HFNnZ1qQy3NS-JfkS_y
    lEHIObqNGvGxw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdduvddgkeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpedvjeeuje
    efgeevkeejfffgffevjeelueffgeelvefgudduhfffhfeggfevtdetfeenucffohhmrghi
    nhepshgvthhuphhsrdhhohifnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghh
    rdgtohhm
X-ME-Proxy: <xmx:TOSCYMhlWRB0MLg2wRBD4aKHmRqzBOd51tDIWpnAzdwhRTopKZvlnw>
    <xmx:TOSCYE9yxdDQjtTsLSWQoHBVYZfwdoTP824_nCGDT4bvbJMHM8fJog>
    <xmx:TOSCYPtp3Ge-PjSt_VfCtymmjpmySacALe8OgedbYmlz1_NR_SrBLQ>
    <xmx:TOSCYM5DocpA2Kvn4MIaM8EuI45ihnHBNkkqce5fD9Sbr_8ssxRf9A>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 67E271080067;
        Fri, 23 Apr 2021 11:14:20 -0400 (EDT)
Date:   Fri, 23 Apr 2021 17:14:18 +0200
From:   Greg KH <greg@kroah.com>
To:     Jianxiong Gao <jxgao@google.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v5.10 0/8] preserve DMA offsets when using swiotlb
Message-ID: <YILkSsR4ejv5CraF@kroah.com>
References: <20210405210230.1707074-1-jxgao@google.com>
 <YG2q6Tm58tWRBtmK@kroah.com>
 <CAMGD6P1OEhOXfFV5JpPfTjWPhjjr8KCGTEhVzB74zpnmdLb4sw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMGD6P1OEhOXfFV5JpPfTjWPhjjr8KCGTEhVzB74zpnmdLb4sw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 20, 2021 at 04:38:13PM -0700, Jianxiong Gao wrote:
> On Wed, Apr 7, 2021 at 5:51 AM Greg KH <greg@kroah.com> wrote:
> >
> > On Mon, Apr 05, 2021 at 09:02:22PM +0000, Jianxiong Gao wrote:
> > > Hi all,
> > >
> > > This series of backports fixes the SWIOTLB library to maintain the
> > > page offset when mapping a DMA address. The bug that motivated this
> > > patch series manifested when running a 5.4 kernel as a SEV guest with
> > > an NVMe device. However, any device that infers information from the
> > > page offset and is accessed through the SWIOTLB will benefit from this
> > > bug fix.
> >
> > But this is 5.10, not 5.4, why mention 5.4 here?
> Oops. The cover letter shouldn't mention the kernel version. The bug
> is present in both 5.4 and 5.10. Sorry for the confusion.>
> > And you are backporting a 5.12-rc feature to 5.10, what happened to
> > 5.11?
> No. The goal is to backport a bug fix to the LTS releases.
> > Why not just use 5.12 to get this new feature instead of using an older
> > kernel?  It's not like this has ever worked before, right?
> >
> It's true, that a new feature (SEV virtualization) is what motivated
> the bug fix. However, I still think this makes sense to backport to
> the LTS releases because it does fix a pre-existing bug that may be
> impacting pre-existing setups.

How?  Anything that installed 5.10 when it was released never had this
working, they had to move to 5.12 to get that to work.

> In particular, while working on these patches, I got the following feedback:
> "There are plenty of other hardware designs that rely on dma mapping
> not adding offsets that did not exist, e.g. ahci and various RDMA
> NICs."

I do not understand that statement, how does that pertain to this patch
set?

confused,

greg k-h
