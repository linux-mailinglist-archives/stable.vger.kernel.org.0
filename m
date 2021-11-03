Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30490443F89
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 10:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231757AbhKCJqV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 05:46:21 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:34505 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231721AbhKCJqU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Nov 2021 05:46:20 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 20C695C0170;
        Wed,  3 Nov 2021 05:43:44 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 03 Nov 2021 05:43:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=RTOprw3GeZ4NMj3CxN8o2LL8oqf
        Lb+L63aR1q1TEjoY=; b=kNH4AZhu/+4NXmIAE8aybGaQhPkYcFCrZ1TPsxw02BI
        V9jG52F0LYm4UsSrUenHdEcXpqOEnLvCr/7HPydiyMsP73ZoKGn70v1Jfaeyud0b
        pdJHPaLgOxKemvUuGQmGDLyvvnrp/JJkKPNhTB/pmaxdEHAiBcA2K5menClZvjEJ
        PAYXBoDBo/QjLwQJ8eAmH3kgUWo1H3cWmUBJ5+8u/30uzrXKi4l17bx3iECu23OW
        C4DhGy3YiO2Y/ARHuZCHwoTAhjFi0IUuJskBotNF4cU7AbDHbg3lox79zGKfw/cm
        KMzZOGEXUX1lLaJR4hcMbFtMtcuhw9upL19WL/x4tDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=RTOprw
        3GeZ4NMj3CxN8o2LL8oqfLb+L63aR1q1TEjoY=; b=RS5gC27zmfD3YGWfNEoqMT
        nIkocWP6k7vteGEZ0iSC1KV9sYwfAD9T38g3X1XahGXVk6koiKD1A1/s00/d/MaX
        dyFvE3c9N3LwrnyCM7IvpmaaZczaLVZLEY9J1YNuBLYT16kzTYQLhtpgUziF90kO
        M1GLdmybSAnFtpJ053kKUtoffMERNTs+i16K4mUqthW8G0H4buStQe/Bi2jKzydQ
        aGNhyxfEqVWcvTbNa48uapZvhLvB7IrG8Qhje+3tbuOVu7s5cSUsR4UJBzlbNFUu
        ACAAJtECa6gvpfSLxEygDWJb1tjtTa2aKThtwn4FHluREhs2LL7/YtbR6tK0fakg
        ==
X-ME-Sender: <xms:z1mCYcvxPcVuQ1SRbPsXUF75griIyYaWhyF7SAtUTO_WcNSL-0KBag>
    <xme:z1mCYZdxttvoceW77W57wu6op6zO5pqYcizXJoAAsghn0Mo4uyl-rSAVrmfmIQwxT
    8bfqfu1feEvVQ>
X-ME-Received: <xmr:z1mCYXxfUBcvN-KjOAwZdorUe9n7tkuLFX_TH0z5N5_jDosIGhbwp7hhpjbM2cocM0Qk4FEVKJ53UxDzBeinnRAfxwx9YEKl>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrtddvgddtjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:z1mCYfN7Nfb2V1AjyMy-vTTNfYm2X6mZt7rUDb9MqX95ekn68iVPGA>
    <xmx:z1mCYc_caRyL9Ctn1exHrerLGvV5EoSrxAo42DKKktZ2pTBgJn9z7A>
    <xmx:z1mCYXWaL8dZJxYq2za8o4LTf20sgOuYaX_N5y0IlkENUxbkmEkiDA>
    <xmx:0FmCYeIUgKFiZMOqiq-YIYUKanphI9z2pgoUmAV6gVQmt1Qwj9oh2A>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 3 Nov 2021 05:43:43 -0400 (EDT)
Date:   Wed, 3 Nov 2021 10:43:39 +0100
From:   Greg KH <greg@kroah.com>
To:     Yuiko Oshino <yuiko.oshino@microchip.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH net] net: ethernet: microchip: lan743x: Fix skb
 allocation failure
Message-ID: <YYJZy7wo0f1ePNSp@kroah.com>
References: <20211102141427.11272-1-yuiko.oshino@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211102141427.11272-1-yuiko.oshino@microchip.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 02, 2021 at 10:14:27AM -0400, Yuiko Oshino wrote:
> commit e8684db191e4164f3f5f3ad7dec04a6734c25f1c upstream.
> 
> The driver allocates skb during ndo_open with GFP_ATOMIC which has high chance of failure when there are multiple instances.
> GFP_KERNEL is enough while open and use GFP_ATOMIC only from interrupt context.
> 
> Fixes: 23f0703c125b ("lan743x: Add main source files for new lan743x driver")
> Signed-off-by: Yuiko Oshino <yuiko.oshino@microchip.com>
> cc: <stable@vger.kernel.org> # 5.4.x

Now queued up, thanks.

greg k-h
