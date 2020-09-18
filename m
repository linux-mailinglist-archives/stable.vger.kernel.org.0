Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA4CC26F59D
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 08:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725886AbgIRGEG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Sep 2020 02:04:06 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:40659 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725882AbgIRGEF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Sep 2020 02:04:05 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 5B5A75C0976;
        Fri, 18 Sep 2020 02:04:04 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 18 Sep 2020 02:04:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=tO8sfYfyaMGPwY+gdcAPKVHFv/X
        3WFOA+xB/VRYT8OU=; b=k70brCoNl3dxJWxNKWz+bk18FWo8Pm97i2viBzOJndO
        TSor2LNxpRHPmpN+iuQi7dqdBhvHCwGwd7YdI4EMywWL297SFB65jGNVafGLJBZC
        ml3aCSdwjvKEsxKvs/b6EEwvEr2Ni4hb6HE0qv2OepgnLtYNtbZEXDWHqDnwVw3x
        nfoSs+lgIlH4Y8yEB0Xmmkj14mXXwJVUzzj7YR5LWoqhf+F15N0Hyu/HPRzgqtCa
        bn+x2Ipvi/v4uMMIg64wGiQ+Ml4xhiVA2EiG+eZ/j2yrRzLco2TgtoeyO+6dBmkK
        aj/AOm+IPH066pQa1b2P3+I3c4ZjnUdc9F+RCUgLNDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=tO8sfY
        fyaMGPwY+gdcAPKVHFv/X3WFOA+xB/VRYT8OU=; b=IV3Aswkvo83ZppYC3FWsV7
        bol+flk+84aaDARaLEy7zWFk3OKOr/JunEeeArI4Ywr1wRy07p5krHr+hI97+Iuj
        5XmrmPbW6rRLw6irSmlYmjatSnz0OWakY8qYYAskN2bAbkxNLFxI890bozrq5UsM
        P8PkqVMNiZ1JW3eZwA4AkQ49hXbbvkbC03t1kVGK5ru3mDZpH2DStOixS84MYrCV
        rEgXQD432aSWqsfoGj3sakTvasE/89I84g48ZddaHPGxH5Qrqw+N69SxrLFoPWCb
        s11OVny4xq7vQEnQUQ8LLpKm2NUuuMuICluHPtHPydOlibNiRR3h2ZzrjBGF8tpA
        ==
X-ME-Sender: <xms:001kX9hDJsoOmPHWlqREdHla9R_3LsMbdrjZ4gXKA5BUMDTmSIbGKA>
    <xme:001kXyAPVZYCf-aE8uiLIQ6VuU3cKL1urdk9JwC4nL3Att9cHkgjkhVpi3-AJ3GIf
    AO358qO4EO4ZA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrtdehgddutdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:001kX9GIrhYKQnsqsyoQ424zlQhYGZN4eXhKOxko3HA0KnYpsUcNhA>
    <xmx:001kXyRzyxouK5ceJiRRdStB7IJFQf3CjV3NBj-7C2o_r4Av7TtFig>
    <xmx:001kX6wihst8KcOlWhdWND0OP8C4Nta5CgWtXDdcneXi-h3MdsAslA>
    <xmx:1E1kX-9w9idjMpvDbo33iKtOepQ2z3ZxxBh1sYgeNAVB0qQQWDYmgw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 84B793280059;
        Fri, 18 Sep 2020 02:04:03 -0400 (EDT)
Date:   Fri, 18 Sep 2020 08:04:00 +0200
From:   Greg KH <greg@kroah.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] scsi: Fix handling of host-aware ZBC disks
Message-ID: <20200918060400.GA58093@kroah.com>
References: <20200915073347.832424-2-damien.lemoal@wdc.com>
 <20200917155335.19CBF21D24@mail.kernel.org>
 <CY4PR04MB3751FEC907B8C0FD50B53624E73E0@CY4PR04MB3751.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CY4PR04MB3751FEC907B8C0FD50B53624E73E0@CY4PR04MB3751.namprd04.prod.outlook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 17, 2020 at 11:50:44PM +0000, Damien Le Moal wrote:
> On 2020/09/18 0:53, Sasha Levin wrote:
> > Hi
> > 
> > [This is an automated email]
> > 
> > This commit has been processed because it contains a "Fixes:" tag
> > fixing commit: b72053072c0b ("block: allow partitions on host aware zone devices").
> > 
> > The bot has tested the following trees: v5.8.9.
> > 
> > v5.8.9: Failed to apply! Possible dependencies:
> >     a3d8a2573687 ("scsi: sd_zbc: Improve zone revalidation")
> > 
> > 
> > NOTE: The patch will not be queued to stable trees until it is upstream.
> > 
> > How should we proceed with this patch?
> > 
> 
> Usually, I wait for Greg's bots to ping me and then I send a fixed up backported
> patch for stable. Would that work ? I can backport now if needed.

That works, no worries, thanks.

greg k-h
