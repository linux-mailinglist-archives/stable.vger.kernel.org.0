Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA2C72499B1
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 11:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbgHSJzU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 05:55:20 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:57671 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726495AbgHSJzQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 05:55:16 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 2DCBA5C0111;
        Wed, 19 Aug 2020 05:55:15 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 05:55:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=pg7glpPPDuybi76xnQKEB7g05jv
        pE6U3rJ1twwDz2FY=; b=lFY1Ylsg3/TjvZZY0f4pxDETxVT1oO1IOfMaKsf389X
        DK+o3MDXFSmHV8mOYMBhJsDZU6EgSukC62ha2kTp/o1Y2FYLYQ9N/pWxk+nXh7yL
        q74d9CKmDbQwePwjH8QiHthPxC00bVHCqpd92QXPPWToh8/iMyehRTEbQP00mv6c
        pkpb51j9Kq677hKWT6xuEDWWy6hyJ8+3HugHmrUWBewUU1QOztW6Tm7CXp1P3JVg
        F+W9GgZbCbIGNKZUtMMBpUugtU+NKchluvsjLArfqtRB8y4poQ3jTuf7L1832i4N
        T8HHdYJO456Y33Sn2IVufBoTnagISP+xnlTvRHxVyNg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=pg7glp
        PPDuybi76xnQKEB7g05jvpE6U3rJ1twwDz2FY=; b=scGh2NhUnn5EtGSzcQtaAK
        r04WNmy9U4AdBbjURI9wggVSsDkkVaGWKGOP1/HWAZQJSSiHXfNdx6FX3bM7dms0
        kxqNHRUT0n1Ukg5IvRjY1piGhgCBlrfOzKbmwykkSqbGiF/nsrEKnQya5Ls4oOHJ
        X+KPuabXIhvkVtpHjG9rriuxKyIp5MHzt8Sdl3jgFXHRQUBRZSJD9Yojudn5Ycq0
        7YhOWZurmYwhx0hlLNehwUwnA9a7NuRnXaQhwbmhz4PEEiXaLYji8LghOXB6LMbo
        2hWhUyGNxRWjgHovTPDon4cRnb58BGwxunv1pt9r7zFi4okO3Rdg1UYQosPN3O+Q
        ==
X-ME-Sender: <xms:A_c8XzellnAUvO11c1eF6jdht2vWyTtJoQJLsLxiZrZfyrL2paCizg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedgudekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:A_c8X5PePZFAIB5TGh2pO5wr2k5Cnmvo6BzIMQrFEMPlOGnXrgiaGA>
    <xmx:A_c8X8guNA5hFRVruSUqJeS9phyTMW9q63b4glCeZVEpOj49_N8e6w>
    <xmx:A_c8X08Hg8N6J-wfBO5PhmC0YSw0lLcEs4qAf-sp-My8qF-y0z-X4Q>
    <xmx:A_c8X97fS6rMn8I7y_UkOih1cxXKyRmjnLzX71SPxkm5wQ67zNAUiA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id BCFF33280065;
        Wed, 19 Aug 2020 05:55:14 -0400 (EDT)
Date:   Wed, 19 Aug 2020 11:55:37 +0200
From:   Greg KH <greg@kroah.com>
To:     Frank van der Linden <fllinden@amazon.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 4.14 1/2] genirq/affinity: Handle affinity setting on
 inactive interrupts correctly
Message-ID: <20200819095537.GB2558675@kroah.com>
References: <20200810201144.20618-1-fllinden@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200810201144.20618-1-fllinden@amazon.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 10, 2020 at 08:11:43PM +0000, Frank van der Linden wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
> 
> commit baedb87d1b53532f81b4bd0387f83b05d4f7eb9a upstream.
> 
> Setting interrupt affinity on inactive interrupts is inconsistent when
> hierarchical irq domains are enabled. The core code should just store the
> affinity and not call into the irq chip driver for inactive interrupts
> because the chip drivers may not be in a state to handle such requests.
> 
> X86 has a hacky workaround for that but all other irq chips have not which
> causes problems e.g. on GIC V3 ITS.
> 
> Instead of adding more ugly hacks all over the place, solve the problem in
> the core code. If the affinity is set on an inactive interrupt then:
> 
>     - Store it in the irq descriptors affinity mask
>     - Update the effective affinity to reflect that so user space has
>       a consistent view
>     - Don't call into the irq chip driver
> 
> This is the core equivalent of the X86 workaround and works correctly
> because the affinity setting is established in the irq chip when the
> interrupt is activated later on.
> 
> Note, that this is only effective when hierarchical irq domains are enabled
> by the architecture. Doing it unconditionally would break legacy irq chip
> implementations.
> 
> For hierarchial irq domains this works correctly as none of the drivers can
> have a dependency on affinity setting in inactive state by design.
> 
> Remove the X86 workaround as it is not longer required.
> 
> Fixes: 02edee152d6e ("x86/apic/vector: Ignore set_affinity call for inactive interrupts")

Why is this needed for 4.14.y, when this "Fixes:" tag says a commit that
showed up in 4.15?

thanks,

greg k-h
