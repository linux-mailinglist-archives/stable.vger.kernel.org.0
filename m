Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3347D5E8
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 08:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbfHAG5H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 02:57:07 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:48561 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725804AbfHAG5H (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 02:57:07 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 041D25BB6;
        Thu,  1 Aug 2019 02:57:04 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 01 Aug 2019 02:57:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=ziX9TasyJG34aiMd0XTcR9BKI6Y
        Cl2wv3Wv8+6ivClg=; b=lpG4H3dIVrZsJvhwhyVWpQhwIUCjOzffV6tWcfUy4Qr
        slcP7ZHBS+S6cqN1BuSxVq8AHI/RRmXRZhQthClNQnkhhZZTJbG6SiRVocYqhv3l
        wCtGL01OYPe7Isn8Is7ml7YTnprdigX55adjBrYWYtMy9OoG7SOaGuTy5b2GlUFd
        9rIUZZN7MafOeGXFZLWS0WvtvNSFRpWvCzsGJ3rvr0rXVB86kra8mdu3HgpRIzfy
        YhIqvIwuYMi3dz0Ws5SGJ9VxK0urJV8SVYNLkTEfb8ViHeNxYfIeXbaTEx7sRO5p
        rvziCoeHyKy/p8cwMqg0+zqZdMwpFILpPSZP71SNlig==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ziX9Ta
        syJG34aiMd0XTcR9BKI6YCl2wv3Wv8+6ivClg=; b=gVOc1LzU+ZaNh7hBUNe3xI
        xs9nYzaiCKKY5sr872lphstNaiP6tmwYFqjf3Jse/VSBq28xQZSmuiEMyharfV3V
        4Z4jxbnxDBGH2Ldl4jc+lZ0nuarqEh41f6TGs+MyqXmNd69UInsd95tO5Ik0tuKv
        9IEJGe77hDg99jf/xiLbENgHxFlOWDkfp/vjgspD8RBxk1yZ74sZY6m95f1doIaX
        P1gSPWR/OtkD5N4ywoSAomed6sZN5313SJ3eJeTwn9zV1riVE7HY0e0TPOEtguAv
        LuASdZHS/ThL4mDKu5YaXBOt39JnUmSbkteKxdSKu841vzR3aS8tLv+5lIiz+6vg
        ==
X-ME-Sender: <xms:P41CXaLYqXjWkT1kk30hL1uKTJZjN5z12mHaLD5rFuR2QWS0HOnpeQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrleeigdduudduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:P41CXQ_VEXwd0G3GxsRFspz-nhvtlmWi1Wbau07mZ9jgSXwZuBkwdA>
    <xmx:P41CXVasyrEnXMR6f-DMLTc8oVqduKP_5WoDx7X3k0UzQyN36Ldtgg>
    <xmx:P41CXWcXwzw6y_kDW8KnLInT1NfXChdlS48LAvGU4cNi5hu_RmKcgw>
    <xmx:P41CXT6g-qIGiBwAnOwUuQKqJrEI40jqV2d-ZlH3f7KoICLFIjDF_Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9AB4C80061;
        Thu,  1 Aug 2019 02:57:02 -0400 (EDT)
Date:   Thu, 1 Aug 2019 08:57:00 +0200
From:   Greg KH <greg@kroah.com>
To:     Viresh Kumar <viresh.kumar@linaro.org>
Cc:     Julien Thierry <julien.thierry@arm.com>, stable@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com, julien.thierry.kdev@gmail.com
Subject: Re: [PATCH v4.4 V2 25/43] arm64: Move BP hardening to
 check_and_switch_context
Message-ID: <20190801065700.GA17391@kroah.com>
References: <cover.1562908074.git.viresh.kumar@linaro.org>
 <f655aaa158af070d45a2bd4965852b0c97a08838.1562908075.git.viresh.kumar@linaro.org>
 <59b252cf-9cb7-128b-4887-c21a8b9b92a9@arm.com>
 <20190801050940.h65crfawrdifsrgg@vireshk-i7>
 <86354576-fc54-a8b7-4dc9-bc613d59fb17@arm.com>
 <20190801063544.ruw444isj5uojjdx@vireshk-i7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190801063544.ruw444isj5uojjdx@vireshk-i7>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 01, 2019 at 12:05:44PM +0530, Viresh Kumar wrote:
> On 01-08-19, 07:30, Julien Thierry wrote:
> > I must admit I am not familiar with backport/stable process enough. But
> > personally I think the your suggestion seems more sensible than
> > backporting 4 patches.
> > 
> > Or you can maybe ignore patch 25 and say in patch 24 that among the
> > changes made for the 4.4 codebase, the call arm64_apply_bp_hardening()
> > was moved from post_ttbr_update_workaround as it doesn't exist and
> > placed in check_and_switch_context() as it is its final destination.
> 
> Done that and dropped the other two patches.
> 
> > However, I really don't know what's the best way to proceed according to
> > existing practices. So input from someone else would be welcome.
> 
> Lets see if someone comes up and ask me to do something else :)

Keeping the same patches that upstream has is almost always the better
thing to do in the long-run.

thanks,

greg k-h
