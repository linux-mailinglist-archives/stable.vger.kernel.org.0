Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7971E6094
	for <lists+stable@lfdr.de>; Thu, 28 May 2020 14:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389087AbgE1MVt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 08:21:49 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:48711 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388938AbgE1MVt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 May 2020 08:21:49 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id EE97690C;
        Thu, 28 May 2020 08:21:47 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 28 May 2020 08:21:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=46BTCqHNwtSw+/sDvIDk1SbqLDR
        eP4bA2IlbMw/pCwc=; b=OVkGg9H1k9+EE7guqhDXP/BRE/aX9EWoU3sxnjutYFI
        VqgzL5Wpx/N9aAcnU8PoEg/qJ+lv48vBiUIkmH+IhGKUM8Hdu2yRvlYJq6h9zKz7
        QL3hwWDEQDAee0yBXn85cAX4G4rX0kA7i2GkpJTfLS3B7lLLkMsi665oOim5tPgf
        YQPHMjyURmDLQw/nZ4ciyJZDhvuK9CU7uiwz2wSHDO2G3ccEkD4DB5flJ/TYWW0K
        SGOMHH+fHjVxOzXHxnKfkPCP77q6H+R1ekezOnU+x7yVjPBu8AIyEy1E++OyQfq7
        Kj9PFuP4gTAZ1Het4V+MGVxppYry9gGxtIp6Qecr7Zg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=46BTCq
        HNwtSw+/sDvIDk1SbqLDReP4bA2IlbMw/pCwc=; b=iuzADoc09WRQxYInOo/dis
        dpnrbI7+p1kS+0idsB5/kWDhejGIOiUAcb/0lQved2QdEZgI6eRpbNkG9BEyw5Gm
        C/HITci0Q6hOtj9p1jWvJOhcyZtpsRgRtBl8vfdc/YxkzpZeLH552ddkQDZoCnpS
        TdvG7k9jzWN6BKIYszbIrcZY/KkrHrgKQrYVh7c4Km1Gg820oYRk77eHOSjgMUkz
        l1tb8vys9A2+cWwssLtarqX+Y5oUT37dMraubgyIndFYFLwdV4qm0gnOieOfNJJS
        BN2YwI5yf3lXeEfTfxUzLpUMWvLqrukthv9W+z0MhR226aso/6MFWHzaTq3ZKDiA
        ==
X-ME-Sender: <xms:26zPXvbBBzTQapdeDY9A8siJYFVIKNzRKzN5xzpvHwrtnEnnl1vdXQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddviedgvdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:26zPXua1Topr_mBdasgcotMGhJABMrp4fUBbYp5gTs56pPVmxbxm2w>
    <xmx:26zPXh9vWLYp-Ya5XbSqccNWXmJsRtP6DN2Gzg7UBgR_ULsRMswPcQ>
    <xmx:26zPXlqW9K5JnCQCqN5G23tHFYlsWVQmeM_Ba2DS-HDTz3uG1SGPBw>
    <xmx:26zPXn01VuWw-hpcyj2gI4DHiGvdUPeGg3bf9VnmMkD1fWHaCE582w>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D8C2D328005D;
        Thu, 28 May 2020 08:21:46 -0400 (EDT)
Date:   Thu, 28 May 2020 14:21:43 +0200
From:   Greg KH <greg@kroah.com>
To:     David Miller <davem@davemloft.net>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCHES] Networking
Message-ID: <20200528122143.GA3257044@kroah.com>
References: <20200526.231652.280818104196261017.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526.231652.280818104196261017.davem@davemloft.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 26, 2020 at 11:16:52PM -0700, David Miller wrote:
> 
> Please queue up the following networking bug fixes for v5.4 and
> v5.6 -stable, respectively.

All queued up now, thanks!

greg k-h
