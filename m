Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D77033B2E8
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 13:39:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbhCOMi4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 08:38:56 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:42831 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229540AbhCOMiq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Mar 2021 08:38:46 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 4D7EB31E;
        Mon, 15 Mar 2021 08:38:46 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 15 Mar 2021 08:38:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=eXSo/rrpfJdFFM4H2VHIthFijyS
        ureLWt5N+YGNHuMw=; b=UHrMejKxlIIie1tATu++mw7TqyBbljWh789guHmmw+P
        sbyFYICai+MP3P5vjASiA0exmqOaPIZdth6lrx7dUaitQGfIAV9gVAnqyCPOmqdi
        bZ7xjGmOL/XRHwTbarPCYwUqecX8Z+ESf30rPHBnJcQ4P7O6ro/+w8Br81jwYTvk
        h7BW/fgorknJ3XRfjGg0iUBGNtD05FqPwNiMC8L5Zis+BdSst5aX67H0CRoG9QGd
        BBlH6wNUBTGx/SJEZfQFAyUU3wdqOdHo+X4KwPHZSaYCInLclWygYpGXeHeShw1j
        gJmGDv7ya/ABwxEspjikjxvq3UjpgbpIVKBFEWqGNjg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=eXSo/r
        rpfJdFFM4H2VHIthFijySureLWt5N+YGNHuMw=; b=ZYDVl3BgRw37jdjp9smX9y
        MVBq0a55wmnIOCjbX2z9ramOR04X4KQP9NbeKa16B+Ca9tr9/onaWDNPBvFWue+R
        Q43ijYr/2GcTZxY/oXxlJEQWz88pnZDwjlQ7rbeQDNhQ/Ld7IfD5aCl2L7fD8Kar
        +dDpTBBtHPVEhBpxghDSaNvIgnvPU77iqprvGs4ZK6G6IV0FM2l20C8cZeICU6Hv
        EaFjS79irrna1emYa1DXp3VwySuO69Ufd4ZG6QyUg7xttCG4NZyZOM2ubquwudZl
        ap4cjqt6lOB+HOrTfs9/gk/rQsbavmi+P5nzBQGz089yld4GjaCBiVee7kGrcIwQ
        ==
X-ME-Sender: <xms:VVVPYP87VEKZNSIW7zLIML98Y7PvkczFf-JHy9fhDfJnqaTu_j9Sxw>
    <xme:VVVPYLvBzqQRNlqzEeRzQHh5i-P6QzVzDTgOIjPcvlpsdLdwAUVTzJSYb0n3Mo15b
    euFNTHZT1nHew>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvledggeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeuleeltd
    ehkeeltefhleduuddvhfffuedvffduveegheekgeeiffevheegfeetgfenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghh
    rdgtohhm
X-ME-Proxy: <xmx:VVVPYNDW2qewxQlntNNy5uU38tXm8Ut-lY2zYw68TQr4ySZnfJ5CPA>
    <xmx:VVVPYLfCz8EpBW4Ak7d4c0sYvOuvISjBZu_OPzFSZXCmik2T6JBWxA>
    <xmx:VVVPYEMWXp3uDDhJYoPVQp3zOBYTrVvwMrgNmNCSIAixTZhfRvXdKA>
    <xmx:VVVPYNaIbkpPe6kfuIKgtCi9H89u-Ecc4Vkdb6HtyL6fVf6_t31fXg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 326B724005C;
        Mon, 15 Mar 2021 08:38:45 -0400 (EDT)
Date:   Mon, 15 Mar 2021 13:38:42 +0100
From:   Greg KH <greg@kroah.com>
To:     Andrew Scull <ascull@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, maz@kernel.org,
        kernel-team@android.com, stable@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Fix nVHE hyp panic host context restore
Message-ID: <YE9VUpzspfRD24fV@kroah.com>
References: <20210315122136.1687370-1-ascull@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210315122136.1687370-1-ascull@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 15, 2021 at 12:21:36PM +0000, Andrew Scull wrote:
> Commit c4b000c3928d4f20acef79dccf3a65ae3795e0b0 upstream.
> 
> When panicking from the nVHE hyp and restoring the host context, x29 is
> expected to hold a pointer to the host context. This wasn't being done
> so fix it to make sure there's a valid pointer the host context being
> used.
> 
> Rather than passing a boolean indicating whether or not the host context
> should be restored, instead pass the pointer to the host context. NULL
> is passed to indicate that no context should be restored.
> 
> Fixes: a2e102e20fd6 ("KVM: arm64: nVHE: Handle hyp panics")
> Cc: stable@vger.kernel.org # 5.11.y only
> Signed-off-by: Andrew Scull <ascull@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/r/20210219122406.1337626-1-ascull@google.com
> ---
>  arch/arm64/include/asm/kvm_hyp.h |  3 ++-
>  arch/arm64/kvm/hyp/nvhe/host.S   | 20 ++++++++++----------
>  arch/arm64/kvm/hyp/nvhe/switch.c |  3 +--
>  3 files changed, 13 insertions(+), 13 deletions(-)

Both backports now queued up, thanks.

greg k-h
