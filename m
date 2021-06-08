Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF4439FD50
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 19:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233194AbhFHRP3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 13:15:29 -0400
Received: from wnew4-smtp.messagingengine.com ([64.147.123.18]:42699 "EHLO
        wnew4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232007AbhFHRP2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 13:15:28 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.west.internal (Postfix) with ESMTP id CC07D19BA;
        Tue,  8 Jun 2021 13:13:33 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 08 Jun 2021 13:13:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=6vYs1FekSaLU/NR94dq997W5qKb
        ucRormr0hpxnvxo0=; b=BGi0/rbsDbHhV5HE5hjkXxGA9OKkXLribHDF5JHkmFf
        3Ns90tQ9/TSgVoB6E0uKyY5jzcmcnfMfs+bwdA86Lf0fBsD+aYEMS0WII9ecrV8O
        KOBBECKZYSXON/odArA6SIs5RqDEmIjy424Erb7TjQxmppDb7H3VrW5ZDGm7ONmI
        349dF0Ek5LpdPqSOyfG4apzc0XF6sCbVgxkWsAHFRdxLhlt146MMg3sV+xIGk2xS
        l5Q2K6ERUa9Awl/pBLza81djXYD63NOZFO8khTWayksmmj5SIfzCdnG3ce70509x
        m8U60Ifhg7ZOdh7wP1NRqnjhOgkmBZPfJJrUIsKmdbw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=6vYs1F
        ekSaLU/NR94dq997W5qKbucRormr0hpxnvxo0=; b=tjd3BL8J5f6GqArkJT9bfS
        fck1kQCf36OT53MxPoKnMvW6W8wKyn8Lepd7RvKuzt/R8ESaKqZR5CvOn8TuD8uk
        9iDm52u5Uvqt0pkomU1cPU83zCaArtqciu82d2rmljkLqO9iUP0k5+ryK2jbLRGt
        9K335zAcFX31nTcow/kjnEK3tUcgP8P1oJE3tueSELMQWWjMxtS2pFVnLgX05Sct
        0/icvbG6NUqNSYxbva60b/D785mF6RoHHr+KOl8GNOfALsg8NEA6lNEneI4dezLJ
        B1BHD0T9q4VEV6ulKFH03Qoj3gh92ieAwW7o0ujAGTahagtHY5pFNDnYtdZT66CQ
        ==
X-ME-Sender: <xms:PKW_YAAv3w-Plpnx0CgoPiB_7JBfDTQtHVYWTPUmakTe778FUaCtpw>
    <xme:PKW_YCgfN-K_QuOu8bjKf2dtXYvQjFv48mElfoVtA-LAeZ2mll11iQ1B08ZotsTG7
    7NwirbDDPTRtA>
X-ME-Received: <xmr:PKW_YDmMtjdn8NC8rFR1osimwuBwPBXP26ZzAIBSo3wShBHUezRScMbB38g7eVUqvb0DJAUbEX196lFS2R5Loi43L_hhan49>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedtledgleehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:PKW_YGxWJLJJlDwEWfY0k-oG9x2mYeCqQ4K_EonHPDEd-xVniWhV-g>
    <xmx:PKW_YFSY8Q7R0Zx5fCFtfJVHApjUZuR9shh7vvNJYsKqHwbfZs7ZPg>
    <xmx:PKW_YBbwDzLNuasOCwCjg0mVPgUuCU61yCSomIM6s5FHDHggSOYf5w>
    <xmx:PKW_YEIQIIHrgRk4LaobEWcTG8FwQjNSgP14eW4aenevW_wWEYyX071g4To>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Jun 2021 13:13:31 -0400 (EDT)
Date:   Tue, 8 Jun 2021 19:13:30 +0200
From:   Greg KH <greg@kroah.com>
To:     Tony Lindgren <tony@atomide.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Keerthy <j-keerthy@ti.com>, Tero Kristo <kristo@kernel.org>
Subject: Re: [Backport for linux-5.4.y PATCH 2/4] ARM: OMAP2+: Prepare timer
 code to backport dra7 timer wrap errata i940
Message-ID: <YL+lOumPYQ1fNoYw@kroah.com>
References: <20210602104625.6079-1-tony@atomide.com>
 <20210602104625.6079-2-tony@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210602104625.6079-2-tony@atomide.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 02, 2021 at 01:46:23PM +0300, Tony Lindgren wrote:
> Prepare linux-5.4.y to backport upstream timer wrap errata commit
> 3efe7a878a11c13b5297057bfc1e5639ce1241ce and commit
> 25de4ce5ed02994aea8bc111d133308f6fd62566. Earlier kernels still use
> mach-omap2/timer instead of drivers/clocksource as these kernels still
> depend on legacy platform code for timers. Note that earlier stable
> kernels need also additional patches and will be posted separately.

I do not understand this paragraph.

What upstream commit is this?  And "posted separately" shouldn't show up
in a changelog text, right?

Can you fix this up to make this obvious what is happening here and make
a patch series that I can take without editing changelog text?

thanks,

greg k-h
