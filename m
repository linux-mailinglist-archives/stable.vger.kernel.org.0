Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D78BB138BE8
	for <lists+stable@lfdr.de>; Mon, 13 Jan 2020 07:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387585AbgAMGmK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jan 2020 01:42:10 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:42383 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732311AbgAMGmJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jan 2020 01:42:09 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id CB58A21C0F;
        Mon, 13 Jan 2020 01:42:08 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 13 Jan 2020 01:42:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=Iim1hqy2gLAV6qBNMC/wiQymePB
        2a+9/hrJaoZPoT4Q=; b=EQGgZDAU1SupW7pcMsCZc44qBpVLZwtjXMTJUjAR2ZQ
        waWWcbr3IO3juosPSMIIA+5S7gKLzAXXffgAUxIK7/97YHGggescxFKaG1MyYzIT
        29hiPb/iCw3pQkrDwAmtn6mru+Bc20ivQ2rkV2s2bm+GL1pT48cyBU0qvQTpMYx2
        1Ps3j2bd7tBJslIFOkk+gFIRn4/cRGdFPgLLDmMzGAcoyd8S68hC/G6JeCSX6sDc
        nW2CAdWWouTklF/Jr59DLahu5faYpFOEF0a8ZJCIPZqxeDNQQY34MI5K2UyYkSqz
        jiOhTnoOpzHGB4QAcwtZT1VUDCWMFdluWxrauT/lvyg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Iim1hq
        y2gLAV6qBNMC/wiQymePB2a+9/hrJaoZPoT4Q=; b=fznaOysydYEyp1y041eE7U
        uP8VyyoT/BUfdQOyd2Fa6/SgvHhAZpIuL1zOTatRRedLXWOlEsSJpFRAbfNJtd3s
        o/ki2kXkAY6UzDy2qfVzxhkpviw5kyJwMdS1X/9GQ+Tq8iEltF7QJc463cmfuaoc
        7KSqXs9dCxejhp6/1rJGLhCQR8CZqUENW5sypdPthreAtIaz6ZWeGQRhWEdrA7UK
        yueYr/Sd66CtSv8OTaPhyp2u4BzmNyKzq5Ve8ZVGhPSS3kpZwIWppTG3Ywsm/7bM
        gBdn1xjYBjzaW12xS5tGpij97yO0cEv6HPAqj0SUeFZ+v+iaiJCaTwHOUSGvuWXA
        ==
X-ME-Sender: <xms:QBEcXsiO_fpI5r27BLoWEA_BxVXlBG-45XZeseLsxaPuimPTA1kC4Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdeiledgleelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucffohhmrghinhepkhgvrhhnvghlrd
    horhhgnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhho
    mhepghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:QBEcXkbS0X09AhzihgXzhGqeY2TjOvo90nBa4nw4GJRw4yDVTzAjfg>
    <xmx:QBEcXmrYomN4cmhRRv1W0dt6DbStNSDQZ9eIHqXL9HyjK1sgT-Qg2A>
    <xmx:QBEcXucl3VQbz3aL2MqL4qkS9gAXQnfBAUS3xa_a_geJaaRi7qNMHQ>
    <xmx:QBEcXvc_fdVQpVfRpGFiadogAnh9m1Td0G-FLtNx2LIWZPnXHNPbUQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 03E0030602DB;
        Mon, 13 Jan 2020 01:42:07 -0500 (EST)
Date:   Mon, 13 Jan 2020 07:42:02 +0100
From:   Greg KH <greg@kroah.com>
To:     Jari Ruusu <jari.ruusu@gmail.com>
Cc:     Borislav Petkov <bp@alien8.de>, Fenghua Yu <fenghua.yu@intel.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Fix built-in early-load Intel microcode alignment
Message-ID: <20200113064202.GA1976120@kroah.com>
References: <CACMCwJK-2DHZDA_F5Z3wsEUEKJSc3uOwwPD4HRoYGW7A+kA75w@mail.gmail.com>
 <CACMCwJ+FE8yD10VF07ci6tTqiBA8aBejKQT0EwyayQQOrLGUKQ@mail.gmail.com>
 <20200112140218.GA902610@kroah.com>
 <CACMCwJL7uqMtp7Jg8GdrRpJkk7jeMrxksr4EXQq86Agw9Zme+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACMCwJL7uqMtp7Jg8GdrRpJkk7jeMrxksr4EXQq86Agw9Zme+A@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 13, 2020 at 08:30:27AM +0200, Jari Ruusu wrote:
> On 1/12/20, Greg KH <greg@kroah.com> wrote:
> > On Sun, Jan 12, 2020 at 03:03:44PM +0200, Jari Ruusu wrote:
> >> Backport of "Fix built-in early-load Intel microcode alignment"
> >> for linux-4.19 and older stable kernels.
> >
> > Any hint as to what that git commit id is?
> 
> It is not in mainline yet.
> You have far better chances of pushing it to mainline than I do.

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
