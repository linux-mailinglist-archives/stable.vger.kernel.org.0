Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4C882F75B6
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 10:45:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbhAOJon (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 04:44:43 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:49165 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727075AbhAOJom (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 04:44:42 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id C7C8C5C00EA;
        Fri, 15 Jan 2021 04:43:44 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 15 Jan 2021 04:43:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm2; bh=e
        Nlz7bK9A2KX+Dk0L/2QS85o1QuJzFp3iP8o65/8GVg=; b=Y047ImiXybksdtby8
        Bszz2aqOsuJB3fIX9hHhYoXnh2rAqJL9j36drse6vAdd6wUB/PMuSFf93xIdRAh9
        xKmALum7EyTQudMyd1I2ENQf9XzbvbTiN0c93Z+h7Zpe9nIXCR0TJ76lrCGeS8hT
        mfWpe5U90NXtQvwUhIO6AuUeldTnjDfFumXpSUbLI4mSd+rOEOfogdsc42hnaH6z
        cZ5fBNoVwzxhsLSV5xl+BT1G8RgqXz02lF7I1QY4uIo65ZFwS5mWdzRffspaV4wI
        Ze47OWY2BxPoL4hcsm2G2SIotikmDJ6A2zFpbLay5TLlLN4fRVFIABb/DdV/bp6E
        OZ48w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=eNlz7bK9A2KX+Dk0L/2QS85o1QuJzFp3iP8o65/8G
        Vg=; b=Ly733MIr0nJfUrDXQdq3kfT2nc7BvQSmN7HIE+HbIMcp+NXlolxq0qihW
        g5tqXVH8OgCqInBPr1Ob8jl5gnowhdwhJ8SVI/azd0RO1JuXF7P5I+4hGco0Cj5L
        g7V0YTWLRENc/JlvO6LboLBeuc2AqNQsjioCi72X2aHUJCZ3uGveq/Km0XoFVgyX
        UonR/3SwhIvEg0ixLqzb4vnPtbuZFx3WJs95Ho2uqUPWjUpLpoZOe+DyhTOt1N8/
        WnSupH3g9BHi4gbs533xbgJsFD5KVEjJ9UXV3ayCLl1nV+URF7S5Kqjp4OAsbv0o
        c66N23OrF48bCAD+FTDB45hANY6rw==
X-ME-Sender: <xms:0GMBYFr6Krl22TBxhH8MC2prTgL2jNk8Hljb7MpKBYhAlW-L65RMuQ>
    <xme:0GMBYHqQJ5NWlkfRQjg9EvACakA9E5Jf-RgX6TzLQtRwbV0jBoOtaZ-VXYf5ldFOM
    CclGq3Hk5WRlQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtddugddufeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtjeenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepkeetge
    ekieevleeuuddvhfetieevjefhtdeikeejfffgfedvuefgieekhfduudetnecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghdplhgruhhntghhphgrugdrnhgvthenucfkphepkeefrd
    ekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhl
    fhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:0GMBYCN4fieVt0jbLbSRyVNsjyfW7MV_lmjbWYw-K27NGrbXGlGX0w>
    <xmx:0GMBYA4F8M-mUWSRGepzyUKgB0C3w5fc0QCOsI9cjUmAnTLIMEUAcw>
    <xmx:0GMBYE5_6DZk2AZ23GNOYfCfIW8bjk7YelIlMHBxHUikn56Nor6Lxw>
    <xmx:0GMBYJhWR-aPkUdVmf_UaNhK6CnO5WmKtN3Pi1dBolBy7GBFxNjsmw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 246CC24005A;
        Fri, 15 Jan 2021 04:43:44 -0500 (EST)
Date:   Fri, 15 Jan 2021 10:43:42 +0100
From:   Greg KH <greg@kroah.com>
To:     Valdis =?utf-8?Q?Kl=C4=93tnieks?= <valdis.kletnieks@vt.edu>
Cc:     arpad.mueller@uni-bonn.de, stable@vger.kernel.org
Subject: Re: [PATCH] For 5.4 stable exfat: Month timestamp metadata
 accidentally incremented
Message-ID: <YAFjzvqX1EtpovTP@kroah.com>
References: <6161.1610696299@turing-police>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6161.1610696299@turing-police>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 15, 2021 at 02:38:19AM -0500, Valdis Klētnieks wrote:
> The staging/exfat driver has departed, but a lot of distros are still tracking
> 5.4-stable, so we should fix this.
> 
> There was an 0/1 offset error in month handling for file metadata, causing
> the month to get incremented on each reference to the file.
> 
> Thanks to Sebastian Gurtler for troubleshooting this, and Arpad Mueller
> for bringing it to my attention.
> 
> Relevant discussions:
> https://bugzilla.kernel.org/show_bug.cgi?id=210997
> https://bugs.launchpad.net/ubuntu/+source/ubuntu-meta/+bug/1872504
> 
> Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>

Now queued up, thanks.

greg k-h
