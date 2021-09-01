Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C19CD3FD71D
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 11:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243772AbhIAJpN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 05:45:13 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:38227 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243771AbhIAJpM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Sep 2021 05:45:12 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 050495C014F;
        Wed,  1 Sep 2021 05:44:16 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Wed, 01 Sep 2021 05:44:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=K48GccfGE3NcSINZVCcEgNweUt1
        RF0CUikiM5vT03sA=; b=RR+sog9R6E8wmSRioepiGz6F2cul/mrzAyllNAQlH0I
        D18u1/W/EUrqRNCplzMS7L0whbLKigvaOiqWV0Q2EgT1fSKh2gmxma5/Fdbkz3Xd
        zL4mPU/txWnrTyOcsTPjeEpOlQANtqGzgp0OOtbi1EmsKLmqjOW+DGZfEfTE2UaS
        mOMKQ51msGvPl5ztOMVaqDSjSWw1b6FKQjdNFyuYeC5Nu6lKGVn0IY29XQuP6NWe
        6XgO5z636PnpqZeWD9flUvpdBL+1tT5MQBGyZYDYi4vx9xN8JCi8FM9QkyicSujT
        tQrOSL/OO1y9841JKYXwtwwAZ3PinfD8NPIusZfQgDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=K48Gcc
        fGE3NcSINZVCcEgNweUt1RF0CUikiM5vT03sA=; b=SD1prwCdPhmQQpw1tTnojT
        XCXcDZ9gkhoULc3hHXCYF8DHPnDKvdBLP+gw5YwYdoYWhIS4JY9k+FVDRicfFuPi
        gb7KHcJpdMTezeRqWW0cFmPdTObpbHDCzFeBRcDBY1AfRCBbU+WjZmX6TkpUjz1V
        JrBGI7XeWFRIhvhCBSvmahu2xxLq+kpdCBfoEgALOl0EWftIzsfJPSminy6DIroD
        Yq7gfeoPFn1oK/PxyKllt1TBRplC9H4oLI9gFL8k6tuunQhbX2GK/uYm3gT98W5z
        ND5d4/RjUJ9tgnqDqMKxLLvul2eh8eg3i3bk0F/yS18i/Wxq+A2QKsLR9dOHDtrg
        ==
X-ME-Sender: <xms:b0svYUg1Rbxg0OLTVYFzDzTatrgGfIQvzDYu-V4PRwcvZAfiuv6AFA>
    <xme:b0svYdB7rC26lGuJxGr2H3gxyLrH5V6GY1wIGYLrvqTxFL2Z587iea3xuezbG6PD0
    7F9ETn3hE0onA>
X-ME-Received: <xmr:b0svYcHvzeTKLx4wZgAI8zlRK7bCx0Jixvl2pOmN2tpPEDCnlIv2zpvdYCb2uTac8OCWHqv6uYP9qambadWaVKGKNLlFpI3f>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddvfedgudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeuleeltd
    ehkeeltefhleduuddvhfffuedvffduveegheekgeeiffevheegfeetgfenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:b0svYVTn5RnOfGIbawc3zICB82laGFi2lcdSbEFtGX5YczwOyI4wWw>
    <xmx:b0svYRy7bOrtg2GzD4wW9PZ7Cs6BeDXeqlHOTAfIQ1eaS11pVRIvlQ>
    <xmx:b0svYT5vHce1GHKN6JRhoHS8StPIgvNyGrmPzdNqnJPrH95ZvWqVtg>
    <xmx:cEsvYTsjcqBHRRHFfqbaC5RH-eCbvK1JxitjeVSnB3PQ3ttexnz6Tw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 1 Sep 2021 05:44:14 -0400 (EDT)
Date:   Wed, 1 Sep 2021 11:44:11 +0200
From:   Greg KH <greg@kroah.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     stable@vger.kernel.org, bugzilla.kernel.org@e3q.eu
Subject: Re: [PATCH] kthread: Fix PF_KTHREAD vs to_kthread() race
Message-ID: <YS9La4mrykpcTDXz@kroah.com>
References: <YSy7lOd+qB7LXq1n@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YSy7lOd+qB7LXq1n@zn.tnic>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 30, 2021 at 01:05:56PM +0200, Borislav Petkov wrote:
> Hi stable folks,
> 
> please queue for 5.10-stable.
> 
> See https://bugzilla.kernel.org/show_bug.cgi?id=214159 for more info.

Now queued up, thanks.

greg k-h
