Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73FA33DC41F
	for <lists+stable@lfdr.de>; Sat, 31 Jul 2021 08:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232090AbhGaGo4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Jul 2021 02:44:56 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:36213 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232079AbhGaGoz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Jul 2021 02:44:55 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id 13444320069B;
        Sat, 31 Jul 2021 02:44:49 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Sat, 31 Jul 2021 02:44:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=Xno7pN/bu/SGnAHXr6d7yt65uNI
        mXev0rVH6lvzDklo=; b=XOgHkgAWgpSuBwD/yU1rT+NNGaaQP+lMJxKsPGrHVpn
        Uny2zqqqje/wI3Hx0C66ikzl0h0zkZ7WFUF2Yo4MWJjgt0m8bfdyUN/BKJFC4gzH
        +1bty82tnv86vh+oj/Dbgc5Xi85F4ESyQqAUhXmLRM4fUl/B8fROv4h5BNeKV9Nu
        JLMAAULSn3ORVvHRIcjduOfEaOgKPtIN3aNgq+5GKRUBRC+yRjZV9xpbzxRu/kmB
        8KfDSpDKh5tfG9DKucIxyBbDNXLC/QcB//+wXg3HQ9JQDPPvOUVMTknzYF040tmQ
        Va6vg6MO0ivR7gNWOUAOHd8ACOJcfuQUD7Nrf1iX31g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Xno7pN
        /bu/SGnAHXr6d7yt65uNImXev0rVH6lvzDklo=; b=wDJnGHUzUmUCk6eZQlLQuq
        9ZyfqY2cKWxDNhCv28ds6oVlFBCOKKlBcvrUXqzc3Sr5HHIBygpkAwexQXBBLZRG
        pX9qOGsUom3hulYoZDxAm5ctcPreqkD2MZb/2YJfKtTVrB36ZPIvYhpvmyglZ45N
        rcBbJOB9toZyKwq2Og5lHyxjgNRT96IrNOliM7tey8S8s70siCA6Bf0vsnu5Hpg9
        lztRkbXlVIsmDS5/ZnTqQvzzdo0wC9fEQMTDDbOZzf+4nXWML0YTM0XqJVA2Gkoi
        GkUhZ4ybqcucC8PZIVFmr4KRXxt9aMyuTk2jbeUmY3dJ33HH4JLnk9KaZosXQYEg
        ==
X-ME-Sender: <xms:X_EEYcYebhs4K3Y6MMhwqobXeeg3HqALKMRyU5OL8snmYpe6ABTxvA>
    <xme:X_EEYXYaB_ihHpMylvQbptATlZIjK0QO0o4J8iu5qnw_bmAxW0bM9hoY1ZFanNAWg
    9hthie1IXsvSQ>
X-ME-Received: <xmr:X_EEYW-g9Ky9mwsoQp83upWBX3HY1GLUvoCaIPM4ZtbvmhuCU5lHkcei8StsasGsNxs6GJtAoAW1tWV-DYqNACTomTBx4yGY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrheeigddutdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:X_EEYWp1g9mpqudWk6-0O3m-UV6t7xWB2_hg1riCjQSkMhZfKSfK3g>
    <xmx:X_EEYXr-cR5If4xAiOgeIkiU70pgtSuNJrIy2ht9JPEHXtYwS2N3Fg>
    <xmx:X_EEYUSSiUZQqBJuIroNCtkZ2Kh8YKz7ccNry_s1gBkZU8R_5M-cAg>
    <xmx:YPEEYbeCWF393l639HnWRGUmzHGy9M6rzXD22iiRohDX_6wfSXk6gQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 31 Jul 2021 02:44:47 -0400 (EDT)
Date:   Sat, 31 Jul 2021 08:44:45 +0200
From:   Greg KH <greg@kroah.com>
To:     Jason Ekstrand <jason@jlekstrand.net>
Cc:     stable@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Jon Bloomfield <jon.bloomfield@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [PATCH] drm/i915: Revert "drm/i915/gem: Asynchronous cmdparser"
Message-ID: <YQTxXYk8ORBYxWCe@kroah.com>
References: <20210727163024.3536962-1-jason@jlekstrand.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727163024.3536962-1-jason@jlekstrand.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 27, 2021 at 11:30:23AM -0500, Jason Ekstrand wrote:
> commit c9d9fdbc108af8915d3f497bbdf3898bf8f321b8 upstream.  This version
> applies to the 5.10 tree.

<snip>

I don't know if you noticed the other failure messages, but there were
other patches in this area that we had to drop from pending stable
releases.

So if you could please review all of them, and resubmit all missing
patches as a series, so that we can apply them to the needed 5.10.y and
5.13.y trees, that would be wonderful.  As it is, I can not take just
this one, because it depends on other patches in the series from what I
can tell.

thanks,

greg k-h
