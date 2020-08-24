Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD4B62501C3
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 18:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726570AbgHXQKf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 12:10:35 -0400
Received: from wnew1-smtp.messagingengine.com ([64.147.123.26]:41179 "EHLO
        wnew1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725958AbgHXQKf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 12:10:35 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.west.internal (Postfix) with ESMTP id EABCC10C7;
        Mon, 24 Aug 2020 12:10:32 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 24 Aug 2020 12:10:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=ro+rwv7AObJQS7gsI/+u11qWbHt
        zXSw24/6H9jgVM/Q=; b=iUUhlZoU5mGQP+5qTazZWAsMBmoLTM6JMYP5/klFgi4
        xoRUtVS95yWZA1Exb117Gn6FLb6nPPrHJbwZ5N6lTf11vATzIeaDCKfW/LWAGPuh
        kaA6R1eBFiZoxHxcrvRVF8KaSIODGqKc9hk7YlD3jyhf6YwuikJsnInbA7JBtcyo
        BdgvHRpsNEcqJWOpq1KkfxBsZ1v89P2xugpvkGtZNoXwP48mdP9WkfOhZmtKxB7L
        28PLimpFogUYiM/d1d0WFqJB1OSU/DZiMNrFvlurltxBj3YRqeSx+U+RdkUbMnkC
        fligHiZSK8HyF0NIglrLEfHq6ci9Ru71NafI9AJ94hg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ro+rwv
        7AObJQS7gsI/+u11qWbHtzXSw24/6H9jgVM/Q=; b=Njs+/a++23hWyavD9D7I83
        5keNeyBat0iIAmhOQ7mUL/jR/hHCPXW4lXuzaRtdM1MYBq6LBfkKkd7jrAqCAiJs
        duE/jmUDzB1d1Keu/YaGs3KiA5Q8ku1RsEQzFG5qVjoVBEyZiOCtHn27NjqxRLJa
        xu2V9Dt9RgXJ39Jk4NOqwaqGq9BewABR4awDtXbSNOYN4BQm/ZDNf0VEV6f6BBqy
        G31bypDHbdgJG6Qj6doeCyLiZOslM+60ahOEF7FVI2Y593rCXGjF88xsElJ6TvnM
        EiFdq+GH9/ILt3H/EO6JLD3JxhXUuFEltJUBjFD96/friMcHU5GtXdwxe1mEtjYA
        ==
X-ME-Sender: <xms:d-ZDX58ngR626vRUNYiOoxJpvqyyQNUbGbBstYXU_FF_T5DaH0FZ-Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddukedghedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:d-ZDX9vUILdMGvs7U55PP0EI2gDKz7YvKsTP4XOCu99xljvJK4Yw_w>
    <xmx:d-ZDX3C7e5PlQ7C8ilhMxIrSQJboXqlkao6VHnSz_O-005fq62l5Jg>
    <xmx:d-ZDX9faOCYGkaUDluvpTY1xWRaC3DjvsjDw-tpUcKXGzDqcRCWjDw>
    <xmx:eOZDX9dLpUZmUk_77I6dNPnEdifo0KX8tBQDflbCP-YYkpfsIe8JeySltpo>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7456530600B1;
        Mon, 24 Aug 2020 12:10:31 -0400 (EDT)
Date:   Mon, 24 Aug 2020 18:10:49 +0200
From:   Greg KH <greg@kroah.com>
To:     Viresh Kumar <viresh.kumar@linaro.org>
Cc:     stable@vger.kernel.org, Viresh Kumar <vireshk@kernel.org>,
        Nishanth Menon <nm@ti.com>, Stephen Boyd <sboyd@kernel.org>,
        Rajendra Nayak <rnayak@codeaurora.org>,
        Sajida Bhanu <sbhanu@codeaurora.org>,
        Sibi Sankar <sibis@codeaurora.org>,
        Matthias Kaehlcke <mka@chromium.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH - stable v5.4 and v5.7] opp: Enable resources again if
 they were disabled earlier
Message-ID: <20200824161049.GE435319@kroah.com>
References: <31f315cf2b0c4afd60b07b7121058dcaa6e4afa1.1598260882.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31f315cf2b0c4afd60b07b7121058dcaa6e4afa1.1598260882.git.viresh.kumar@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 24, 2020 at 02:52:23PM +0530, Viresh Kumar wrote:
> From: Rajendra Nayak <rnayak@codeaurora.org>
> 
> commit a4501bac0e553bed117b7e1b166d49731caf7260 upstream.
> 
> dev_pm_opp_set_rate() can now be called with freq = 0 in order
> to either drop performance or bandwidth votes or to disable
> regulators on platforms which support them.
> 
> In such cases, a subsequent call to dev_pm_opp_set_rate() with
> the same frequency ends up returning early because 'old_freq == freq'
> 
> Instead make it fall through and put back the dropped performance
> and bandwidth votes and/or enable back the regulators.
> 
> Cc: v5.3+ <stable@vger.kernel.org> # v5.3+
> Fixes: cd7ea582866f ("opp: Make dev_pm_opp_set_rate() handle freq = 0 to drop performance votes")
> Reported-by: Sajida Bhanu <sbhanu@codeaurora.org>
> Reviewed-by: Sibi Sankar <sibis@codeaurora.org>
> Reported-by: Matthias Kaehlcke <mka@chromium.org>
> Tested-by: Matthias Kaehlcke <mka@chromium.org>
> Reviewed-by: Stephen Boyd <sboyd@kernel.org>
> Signed-off-by: Rajendra Nayak <rnayak@codeaurora.org>
> [ Viresh: Don't skip clk_set_rate() and massaged changelog ]
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> [ Viresh: Updated the patch to apply to v5.4 ]
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/opp/core.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)

This too is already in the 5.7 and 5.4 queues, why add it again?

thanks,

greg k-h
