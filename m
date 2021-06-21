Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48C763AEC3E
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 17:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbhFUP0F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 11:26:05 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:53255 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230290AbhFUP0F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Jun 2021 11:26:05 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 0233B58085E;
        Mon, 21 Jun 2021 11:23:51 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 21 Jun 2021 11:23:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=9K3u2Ll8ef7lXqXfO5YF59Gk1Vi
        Je+PDxvFbDXwXxtQ=; b=yebfp9yeoY21SFGD5LE170uZbwnlZJ0dji95uyz2NKp
        jpHtDrBfRsOtkHAlHXYiT2QCfacEl3geh0kqZOXs8Vrf7tjqUvI6OxpSHgZXfuTF
        PdR2Q+JGQ9QdOtzy3THAiEEXcpSuoaZGopZ4yQTdNEr9lyDNPmt9zfRrgbApb5hg
        A3oaWGfHKH81sUD0lNrn8yy2xvhaywvqKtDmdqEL87yIs2vnwHZoOqT+wn5/Xz1r
        6oQkQNs4+x7M2yNYPIYU2rm2inEP7qd7AHlzjA1v6nlbLzntpTFcUUOZn1d291hE
        dG0hh/H8DypJ+iPn8cr7Tngqzsq8d601BzbVCho3FQA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=9K3u2L
        l8ef7lXqXfO5YF59Gk1ViJe+PDxvFbDXwXxtQ=; b=dFfApVLdvFrcIX7MX9a4VW
        ldDHW8yNGPjzdXBqtJTuAYXPI2tDjF1IoM7qNk2EOJy0NfoIhSA42pzIsW+2F61/
        EWgqV5q4FTIF0YIgMJw3J+KwV5RR/xE7rQ44n6ERaeb6amFVpPkbOfc8IxK35NyF
        5KVSaZPlG4tiFBL5RE1y+tl8OlHyD4J8mFVgdQ/3zLj7ejQbU/Gb9h1ZepIn/Agb
        KQ+pkVVj2/0UwNTV6TOK0T+0FqNbVCYSremmO+gHko7oY/TmfTvGPLOAt2KLmW3R
        GzWV3cSFZ0FMefHa7y9r5OcqxKYYZuH0gXuUAJWQ2FGawG6QAqO5AOhe9GTUgEXw
        ==
X-ME-Sender: <xms:Bq_QYOpP6Z7kLX35bmHnoKYpsF2Tc25pDxVa-CJocLWOFFhFaHuTDw>
    <xme:Bq_QYMpe0SaZL9vx2mqhg7SCdIo2C6YB05ekoJmyfBPpfu6ISM8HDEy8RCP1OUpQ1
    1_3-0D_Qh0Dhw>
X-ME-Received: <xmr:Bq_QYDMw5yd8o5K0T9guxB-V1L2VZhZ2QLXMTwmCr-uZfVJEaFY_2HKC7lr9NXxpFjZZkMvK8hMgBHkOdDJeYMp5bLVDF6Zl>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeefledgkeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeuleeltd
    ehkeeltefhleduuddvhfffuedvffduveegheekgeeiffevheegfeetgfenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:Bq_QYN7DpKCpDeoTuc9ll7qeNlLgZaZq2zu8f9mO2P73xNnan_6X_w>
    <xmx:Bq_QYN6dDL_YUMzZYs1vCjgcpSFBbUgfM4OxWjj0ktDPI_gb7naR5g>
    <xmx:Bq_QYNhHwzvF75IckUaN0aBH6Edt8nr67ldslzF9DVxGvirwxvU7Jg>
    <xmx:Bq_QYKxjbvQts28nBm8P8cWOenVy56YZxj4UM5oRGlVV23ek2UQClQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 21 Jun 2021 11:23:50 -0400 (EDT)
Date:   Mon, 21 Jun 2021 17:23:47 +0200
From:   Greg KH <greg@kroah.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     eric.auger.pro@gmail.com, stable@vger.kernel.org, maz@kernel.org,
        linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH for-stable-5.4] KVM: arm/arm64: Fix
 KVM_VGIC_V3_ADDR_TYPE_REDIST read
Message-ID: <YNCvA4qDuc2Tlmi0@kroah.com>
References: <20210621124232.793383-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210621124232.793383-1-eric.auger@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 21, 2021 at 02:42:32PM +0200, Eric Auger wrote:
> When reading the base address of the a REDIST region
> through KVM_VGIC_V3_ADDR_TYPE_REDIST we expect the
> redistributor region list to be populated with a single
> element.
> 
> However list_first_entry() expects the list to be non empty.
> Instead we should use list_first_entry_or_null which effectively
> returns NULL if the list is empty.
> 
> Fixes: dbd9733ab674 ("KVM: arm/arm64: Replace the single rdist region by a list")
> Cc: <Stable@vger.kernel.org> # v5.4
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Reported-by: Gavin Shan <gshan@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/r/20210412150034.29185-1-eric.auger@redhat.com
> ---
>  virt/kvm/arm/vgic/vgic-kvm-device.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Both now queued up, thanks.

Next time, give us a hint as to what the upstream commit id is, so that
we do not have to dig it up ourselves :)

thanks,

greg k-h
