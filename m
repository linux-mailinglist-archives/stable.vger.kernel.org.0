Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60B7D3B5DE8
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 14:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232833AbhF1MYP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 08:24:15 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:50269 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233004AbhF1MYO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Jun 2021 08:24:14 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 4505032004F8;
        Mon, 28 Jun 2021 08:21:47 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 28 Jun 2021 08:21:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=U75yfYDIU5UGi1O4O8hzvm7xdVq
        clF7dFX1N7NwpQE4=; b=C+WmLxZjj4SFLfpuTLQ+21fd8nezqZ6UkVdKh6x4KyM
        RsVyS7jdgSkMWbKkO/3W0qrbGkxasDutJ7zkGBT0552uUZQjI0laR6BQRCb64XvF
        0KEc3FLlYj6f4ym78f4NbbtMnpO2W+fz0Kqg/xuOrrQ0JXkcIyYfestPN8AKGnHm
        SHO98Cy8+k4YanbSaE+evUuDzf+r4da0VZ9JiSV9QUric6gmd6eXTBpZttYekYOX
        HbHLrEQsPJe6nz9CfIc59G6Gf5OtaiFWzBZFYfICTYhNM2UumNr387WvxXEzLsfa
        DPVSAEy5oT08kntZeYY/lIo5PtMMqG+10DHFPoF3o6w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=U75yfY
        DIU5UGi1O4O8hzvm7xdVqclF7dFX1N7NwpQE4=; b=I/4dv70DEijolmFn5Xw1j9
        VJX8kzEqo3sUYoGhI01Jo6t71150R9GzusyoFZwlh2pOa4hfQoP2PCzqc4zYpNNC
        3Q9RIPNTXcAXhHZInXZ/p1r0nUL8LQqCA+7a7IhMKi7XcHYw2p0sfAJ54ontKdEm
        gZYl48DA73wMmVb022ALwUZ1FI9EzKJZw8XaYp3loMqgMK7QQQxhBxfI91CtBQVI
        BqECJHdJJRoU2e7lz8Y/SRRbcdxGpRBR4idCIlbFSQoE255WG1WGm2J6LhIZq4/y
        5LosrUtfp7xKvRZpX7HKH1ZrqvkenZhf5uk0jTB2vCMK0rsjTpeuX1e2jsnUVBbg
        ==
X-ME-Sender: <xms:2r7ZYFOggCOJqdj9w3XIAQ9R-sNq1y6f2ElsDZn7w107KhMFvj6ATg>
    <xme:2r7ZYH_xSLwwQz38HtA5qus1iWs5iDGyDgaouZVac2F8bi3ubZFehQ5cQWIO_sUo2
    1wDpBygKl_ycg>
X-ME-Received: <xmr:2r7ZYERFe25G2j1s1Ke6YOjYDSA-DMp62HEHvLq6CbNWrqhF2QWEn6HV7rLkU6d8-2-4aBkxvZ54251xNAyTNZXN1sr66ei8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeehgedghedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:2r7ZYBsCS-KOPnobFUIgSvKxODwENjmRYfYXeGlckBqoXQoJirVVWA>
    <xmx:2r7ZYNfr-1R8e50fyjIS23txNZnEnzNeitQxO-DJ43efhF24CfVXHg>
    <xmx:2r7ZYN0wQeLATiPYi7dgBoUENUjOCtPuHccR_XJp2WRe1L6N_Z8-kg>
    <xmx:2r7ZYFTA8nUNs33FxcvmEMufZePRoXqbJj9FUbKspQZNNUD-MLHQxg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Jun 2021 08:21:46 -0400 (EDT)
Date:   Mon, 28 Jun 2021 14:21:44 +0200
From:   Greg KH <greg@kroah.com>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     stable@vger.kernel.org, dhowells@redhat.com,
        Andrew W Elble <aweits@rit.edu>
Subject: Re: [PATCH][RESEND] ceph: fix test for whether we can skip read when
 writing beyond EOF
Message-ID: <YNm+2KlzX2oLOx4p@kroah.com>
References: <20210627163929.15768-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210627163929.15768-1-jlayton@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jun 27, 2021 at 12:39:29PM -0400, Jeff Layton wrote:
> It's not sufficient to skip reading when the pos is beyond the EOF.
> There may be data at the head of the page that we need to fill in
> before the write.
> 
> Add a new helper function that corrects and clarifies the logic of
> when we can skip reads, and have it only zero out the part of the page
> that won't have data copied in for the write.
> 
> [ Note: this fix is commit 827a746f405d in mainline kernels. The
> 	original bug was in ceph, but got lifted into the fs/netfs
> 	library for v5.13. This backport should apply to stable
> 	kernels v5.10 though v5.12. ]
> 

That helped, thanks for resending this.  Now queued up.

greg k-h
