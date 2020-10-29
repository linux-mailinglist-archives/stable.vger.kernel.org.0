Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D15D29F4C7
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 20:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725928AbgJ2TSp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 15:18:45 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:44009 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726120AbgJ2TSf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 15:18:35 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 641415C0154;
        Thu, 29 Oct 2020 15:18:34 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 29 Oct 2020 15:18:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=A+tR7LRyNOp7mORAAFKltvWRx4+
        z/NkLgTl5JCNqOrQ=; b=WoQGeX6a9UmmWtoIYxbPYLwkElQgA2rQf7p0UxN2SW0
        6aIEF3VBOo5fUoCJazXh5tWWfOfwLfjZnWawXiJeqwihoqoPFmbNdO2zf7/Vyko2
        QbHfSXvT1npC7/JLulR8q7pnem4XVfNSH6m9o35qNzsrsI7s31YxlHjUKLVszjtt
        FPxOuBQtb3P0K+EkqAQm/sIqd0wvsogvwb1Swo1IxvXzXh0TEAa4yYVcuHoEfJwS
        H31YGOwn8Ze+mVtM3QS+oFJl0XpR4BHMiVi3CIQkoiXDhv6yd0XIJL2jA+1psw2C
        L1QZik+SEXp8xZAqqPFapJoxsQvCckZxxmtcr7ghS0A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=A+tR7L
        RyNOp7mORAAFKltvWRx4+z/NkLgTl5JCNqOrQ=; b=NRIQsjY9U5stD901XHVuZZ
        UAqgB0h3bTPC9+LfPpfL3D/j0kXkxnrUCPMlZUhJrosMquKhqNxIeeGbhiDobxXc
        SnMLc/h9o+fc0k9UHM1vsfMJ89FHfSRhw/pC3SqFYjsG3muE2Ett///8WFa6EbAF
        V/N8sFkx9PSK809RPhUysI7IUEXKusb2pJ2ZIKJ/s+hZQ2e4g2bnDYBMSJZYp2ae
        dRQYirWRAE4YLXVu4tfhPrlggzH508ZpVMFlmIpWnCXRBVQ/h3+6hiCWodJlQKze
        ovl3Pi6wB70uGrgjC24LRXoiXsdOfChifytAOY1OiFeeP8OS0Dlpcy6+H/s/Rw+g
        ==
X-ME-Sender: <xms:iRWbX1-29BIccNVjIvpDoEiUQPEcgTlkmPe1tNeBru3XB2yPwsrXDw>
    <xme:iRWbX5sclbe0ROffc5GRkAAxl8roy2dqjqX6208W85hH7Z-9fSmbkXw8ng4ZIfcq0
    QCtI-tC088fag>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrleefgdduvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeuleeltd
    ehkeeltefhleduuddvhfffuedvffduveegheekgeeiffevheegfeetgfenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghh
    rdgtohhm
X-ME-Proxy: <xmx:iRWbXzDIdOI4HGzSmqeQXVAU_5XXHSpRNMnGRSm4GpWn2TmTd7yvyw>
    <xmx:iRWbX5fIt8jvM1UarnRHyRKsNco1rVxreTpsQ1yF3nzNIjVNJQocZg>
    <xmx:iRWbX6PW761BdDogqYOkL9rbCnvs2M5qftdf5jqCGpxTrcnTeBmNew>
    <xmx:ihWbX3rAg10n0y6bOLTiAPjR66xNtTo7Ux6uCZfIhDdpQZtGyQ4zkA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8315E328005D;
        Thu, 29 Oct 2020 15:18:33 -0400 (EDT)
Date:   Thu, 29 Oct 2020 20:19:23 +0100
From:   Greg KH <greg@kroah.com>
To:     dann frazier <dann.frazier@canonical.com>
Cc:     stable@vger.kernel.org, Michael Schaller <misch@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Jeremy Kerr <jk@ozlabs.org>, linux-efi@vger.kernel.org
Subject: Re: [PATCH 4.4-5.9] efivarfs: Replace invalid slashes with
 exclamation marks in dentries.
Message-ID: <20201029191923.GB988039@kroah.com>
References: <20201029175442.564282-1-dann.frazier@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201029175442.564282-1-dann.frazier@canonical.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 29, 2020 at 11:54:42AM -0600, dann frazier wrote:
> From: Michael Schaller <misch@google.com>
> 
> commit 336af6a4686d885a067ecea8c3c3dd129ba4fc75 upstream
> 
> Without this patch efivarfs_alloc_dentry creates dentries with slashes in
> their name if the respective EFI variable has slashes in its name. This in
> turn causes EIO on getdents64, which prevents a complete directory listing
> of /sys/firmware/efi/efivars/.
> 
> This patch replaces the invalid shlashes with exclamation marks like
> kobject_set_name_vargs does for /sys/firmware/efi/vars/ to have consistently
> named dentries under /sys/firmware/efi/vars/ and /sys/firmware/efi/efivars/.
> 
> Signed-off-by: Michael Schaller <misch@google.com>
> Link: https://lore.kernel.org/r/20200925074502.150448-1-misch@google.com
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Any reason you are not signing off on this?

:(

