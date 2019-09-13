Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3605B1E30
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387784AbfIMNGw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:06:52 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:59877 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387443AbfIMNGv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Sep 2019 09:06:51 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 9668F497;
        Fri, 13 Sep 2019 09:06:50 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 13 Sep 2019 09:06:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=kctfxVA8o8ay9amERd1+UDzk1oH
        GgByJTGaMoSxGwZM=; b=QtfAJeIzi32ERHcHNzYMcM18vhFff/Y2qrPmtxoZWYA
        1evBf25JjaAok+Ghjl9ZCh3xJsfVEd3uzNU6j2hHuPGCOK9SkejTY9Qmv54SGpU5
        YlFgjyM+Qyd3Hf/aptvYvZOrl1ZayGMy52n0jYDaqwq5zmSO8jzXBny8nE7i5OZD
        AAfTfOyDROb0KBpd/v38IgP3ShEF4pU+ZQZMlT/evGyBotwbHm/zxhgJFNXuzebn
        7jt/aQBhleyfhgY1FbujRSJfikiFLonYGUV1KB9kOzWZWR7oXKfX8Pb9VureYgJL
        2nI6ivORoKtphv4fg3jB1Y7orBPSNenZImor0caxE/w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=kctfxV
        A8o8ay9amERd1+UDzk1oHGgByJTGaMoSxGwZM=; b=NNr+3LcnjOOzp/187es/Zw
        0QXOqrhBkgrRRO+pqPJ2Uf7v2ef4/bJsXLW3DEzkBnRsblX2yai+D7ocdbW1oxBo
        FaGGbqCXGpZ8P30bXSrzG1WMvPFC9P41uRFxmwLWo9jlsE6fMTCn2Z4sPtZTv+WX
        l3ZvVmsxNlmf81uRlqQ/NCZ9GqtHGyx+CkQACYksJoHRo9idipJUpdIyrDQiCB39
        kFbHFqotYYR4W8XVfOR1az5LVcjF+skOwAni1dVTfpaQ9L4nBHCA9B/OTTazCLhO
        yppZZ0yaHv40s4xH/ayuoBDhsm6xw1DbpHKPtwAPFXjc+sgV3EqYZdupuA8xq6tQ
        ==
X-ME-Sender: <xms:aZR7XajT3M_aD6cM6T4EvSQAmd5EcTAg8QEPjgiAVe_tZ7G4EQjkhw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrtdejgdehlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepuddtgedrudefvddrgeehrd
    elleenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:aZR7XVoBoRawfplob42ncZM4GbRxBJxR6c7OHwJDGkh047WuF4AMfg>
    <xmx:aZR7XeH7DnywiB3lvkGPQWjCXaF08fVkbz9MuIeZJ0ZPJWuVHJV_DA>
    <xmx:aZR7XTgy1Gyz1Hl6mPoCfFr-BRMFndqee3axEfvblAFrU1lyIHigVg>
    <xmx:apR7XQT9Vse1PeQqSdw_HGIlnlw_IsaJh2UdGl_Na51Xu2lCj9noxg>
Received: from localhost (unknown [104.132.45.99])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8EF5D8006D;
        Fri, 13 Sep 2019 09:06:49 -0400 (EDT)
Date:   Fri, 13 Sep 2019 13:59:14 +0100
From:   Greg KH <greg@kroah.com>
To:     Johannes Thumshirn <jthumshirn@suse.de>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH for-4.19.x ] btrfs: correctly validate compression type
Message-ID: <20190913125914.GA403359@kroah.com>
References: <20190912100259.7784-1-jthumshirn@suse.de>
 <20190912105215.GC1546@sasha-vm>
 <20190913115305.GA292815@kroah.com>
 <995a104d-3854-5b77-f25d-e058eeb900cc@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <995a104d-3854-5b77-f25d-e058eeb900cc@suse.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 13, 2019 at 01:55:08PM +0200, Johannes Thumshirn wrote:
> On 13/09/2019 13:53, Greg KH wrote:
> [...]
> > We also need this for 4.14.y, let me see if it is easy to backport...
> 
> Haven't had a look at it. If you need help just ping me (or tell me
> right away I should do the backport).

I need help with the backport as it is not "obvious".  I think there's a
prerequesite patch that is needed and I don't have the time at the
moment to dig it up :(

So yes, sending this fixed up as a patch series would be great, thanks!

greg k-h
