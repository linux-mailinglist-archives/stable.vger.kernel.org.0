Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0A6FB8215
	for <lists+stable@lfdr.de>; Thu, 19 Sep 2019 22:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404553AbfISUCU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 16:02:20 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:44773 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404551AbfISUCU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Sep 2019 16:02:20 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 6FF3021B10;
        Thu, 19 Sep 2019 16:02:19 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 19 Sep 2019 16:02:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=kvapmU7DHnYiNPT22Gz4c9jylOa
        Goo+HY1DFacBlknA=; b=mCorCM+S7uXwwMI3gwY6BIX7HnN2WhfnBIABY6vJ2pp
        Gvf+AhTrbP4MdEWI9h1rrpwSMfmxT92tVc+cE4SdbYUYesLCMYbZps4Is/0YYzrw
        X30tFaV9QaEFUE8oViuAt84JD3E5tyRtSuUXigqGDQyvR8p7VS7so3GIy/xA682n
        BMn1BCGadSlSF+GHt98VFBnVbzTw1UDLq9lnFLBna5dmtuBntzOcwixxWFfJvuFL
        F+JgQqQyeNIGo6Gts8Prf7/4ORCd1xzqXhOiJMwmy+9oOrdbFQZdqh5o+qkPNeDf
        ScEgkDG54UUP6i6Mu5Kwk5zTKJEHz+iK0fir/bu1wdg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=kvapmU
        7DHnYiNPT22Gz4c9jylOaGoo+HY1DFacBlknA=; b=1HbJg6zH9xMqfHRBL4BKg7
        DZ4LHCUeLCwT73r1gmsQrhzS1kuBjvwWGYzL6IEPGWbjkqacpCLIkx2c3gvL6TMh
        5HXxGw5+D+84WBiTJPCZrVjRDqxoM3ZNPfziUhK4h+wElldtWt8ZCBZKFjsqi8F0
        aD7gWKN3LYiuMvAoORGIzSKfk0rYZx5NJSqRKn2e9jAF1xB7qcGjteV2GExFRdDD
        Vr1+z5VH+3gF1ThMFKMLBVIVWw3+9OshzBymVJuszJedNO8kUgMsjcTNVZI8Obav
        TH0sevVA4yRLVe5pKFL59ttR1iJkityiuxTnyUAWuLu+lN3FncXyXN5mB3TFPSTg
        ==
X-ME-Sender: <xms:y96DXVbRf6AwXUbqmn2jFQBcMXjRLO42g8Y0DgXSmr4xXQ2fDdRwPw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddtgddugeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:y96DXTrSoH3NTbbhLpILRcvx_EO_gQJzU5qUtFcTFlhJCOABv_hSVg>
    <xmx:y96DXXdjMUBu_udC8uFtFF0n4nNR3gto0FrG7A0W2CKeWAHheDtIpQ>
    <xmx:y96DXczLeaQKQ0imMLMGsW6qQFX16Hb3IQNjpq9dtfr-Auc0xBR5lw>
    <xmx:y96DXfT6_E23fWVxtgPUG4PcMiSKpCtsVWUjpUh6kG-q-F01WC8ZGg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id B7A6F8005C;
        Thu, 19 Sep 2019 16:02:18 -0400 (EDT)
Date:   Thu, 19 Sep 2019 22:02:16 +0200
From:   Greg KH <greg@kroah.com>
To:     Frank van der Linden <fllinden@amazon.com>
Cc:     stable@vger.kernel.org
Subject: Re: binfmt_elf patch [4.14, 4.19]
Message-ID: <20190919200216.GA250963@kroah.com>
References: <20190919192552.GA7060@dev-dsk-fllinden-2c-c1893d73.us-west-2.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190919192552.GA7060@dev-dsk-fllinden-2c-c1893d73.us-west-2.amazon.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 19, 2019 at 07:25:52PM +0000, Frank van der Linden wrote:
> Hi,
> 
> Please include the following patch in 4.14 and 4.19, where it applies
> cleanly and has been tested by us.
> 
> commit bbdc6076d2e5d07db44e74c11b01a3e27ab90b32 upstream
> 
> ("binfmt_elf: move brk out of mmap when doing direct loader exec")

Nice catch, now queued up, thanks.

greg k-h
