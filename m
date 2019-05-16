Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80FDD20ECF
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 20:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbfEPSju (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 14:39:50 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:36957 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726546AbfEPSju (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 14:39:50 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 4E29C250C3;
        Thu, 16 May 2019 14:39:49 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 16 May 2019 14:39:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=POHz2NoF6aSMxg1f8AaGhK214rD
        wUhBISWJ4ubMrIpM=; b=mmqstdaIGKmzgco935nuuIeWgs9JECF/b5zC32nKqG8
        M/dLTSDyoNvnYxq2/+PVj8lu+XFUAczTEH7BgZx/4EhbPqoPma+Jc1gYla0xDJm5
        Ih3MGthg/+n9qjZ/+ZTcjnvebxDqLTaPaRn7I5n10bIaiDO0kmln2/7gGjlKeGpW
        2DCTylr/y0mzt3j4ZKoJT4bQMO3Ouk1B1AWJODTBQKi9mrIaLsMSrrUwkF0C9OYC
        2KtIW93o/roI5IulHB2UgFmNF7wDxpmjvKThkOSi9rRM/aVqhGG26vT1AN0Aed7V
        o7ZWqXfvSVb36+U+FtVTSC/Aa2QQrp7jypglTM2oX9w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=POHz2N
        oF6aSMxg1f8AaGhK214rDwUhBISWJ4ubMrIpM=; b=vtB7uLy9JmvTwxd7RIGskp
        pr062duYfDJ/Uzd2gUjQr/jDM8dco8dM+jrV74LWiffN2JxdyyfJolsaK+jSyhQJ
        g2eusJAvzjDOZlJWpQdoQVvs7RUQzCOgVESMivJkPWiv+v+yYJo6Z8a5CJPN0K1x
        XHErjfqA9+usXiadtMxWZyTyf2TKdu3hyNiKn9Hhd0pbY6a6sxaH++LcyVfCJkFI
        b3kLY0NVqaixNRo+0bfOeJR0v/5Jsom68rlsH1scV2cWB/GzJT+ndIxe2cwzQPNi
        wWkSzeubdQymryGiHRPWIfig3Gf/euELe558ZXw9kqPlAqNVz3VP2v4JMi9lHQ5A
        ==
X-ME-Sender: <xms:dK7dXEHWPZqhSYJBvYfa5rcm7DN8tNGxCj-biKJrPzcFENoaY_9kyQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddttddguddvgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:dK7dXNHKjbH1tYYxqBwXEUfDH25-yYwzMV5Qi-uEnCwTjKfe2YYMjw>
    <xmx:dK7dXArFipAFzPJNnu6GE2p_4wDOWD7ABqWI25atra01qM74kq3BzQ>
    <xmx:dK7dXFbj-l__0fgqKfIXHN01snvb9h4LJs2a9-AVhD2IfBJIMzBlqA>
    <xmx:da7dXKgTGCmrE2NxhPMCmb-Z8_R7NFQqWSUFCx5_Ifeo5aEwcIWMpQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id B901180063;
        Thu, 16 May 2019 14:39:47 -0400 (EDT)
Date:   Thu, 16 May 2019 20:39:45 +0200
From:   Greg KH <greg@kroah.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Ingo Molnar <mingo@kernel.org>, stable <stable@vger.kernel.org>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] locking fix
Message-ID: <20190516183945.GA6659@kroah.com>
References: <20190516160135.GA45760@gmail.com>
 <CAHk-=wgtHi5mT7y=0ij-AksQQOBQJqV1apk2bRaH2tfRTxyFcg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgtHi5mT7y=0ij-AksQQOBQJqV1apk2bRaH2tfRTxyFcg@mail.gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 16, 2019 at 10:57:53AM -0700, Linus Torvalds wrote:
> On Thu, May 16, 2019 at 9:01 AM Ingo Molnar <mingo@kernel.org> wrote:
> >
> > A single rwsem fix.
> 
> Side note, this one isn't marked for stable, but I'm hoping stable
> picks it up just from the "Fixes" tag.
> 
> Stable people, we're talking about
> 
>     a9e9bcb45b15 ("locking/rwsem: Prevent decrement of reader count
> before increment")
> 
> that I just pulled into my tree, and needs to go in 4.9 and later.

Thanks, I'll work on that later tonight...


greg k-h
