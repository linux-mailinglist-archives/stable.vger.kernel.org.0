Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 691CC2D4643
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 17:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727559AbgLIQDT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 11:03:19 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:58393 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726757AbgLIQDT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 11:03:19 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 7D9575C0412;
        Wed,  9 Dec 2020 06:07:47 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 09 Dec 2020 06:07:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm2; bh=i
        QSDJHuAYEPZ2d6gcdeLBad2Du35PMKQ+BUI0XkFr6Q=; b=W8JBwHRXJLsJ41R0y
        VhbxI/inp/EXCyKFGhBTL4en2qnXfAp3anvx/9SHErN6m5MFtkjXJ6a1g3v1dW8Q
        yzclnxvkYUlXyQdZ2qeo3di70el07jyywxYP8H+wBwK8yYJZkQ1GRqr5dr/nomnm
        241uqOeMMdd/Xd2JjIyLcVA+/KA4+MTpQnQcxNo2YKusc8rRH3flljucmM2KmKw0
        bUZKFpvPdaEwPS591zD5/V/LeCTqlc48BWO7jpMA0pUkT7StprDO9DflY08gIFGe
        dodNLwraCzsJaHNMNipzW/a4Gg5+Whke1LDu87KGazOMGQ6SRNvBVwDAVwbL33xv
        1ym/Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=iQSDJHuAYEPZ2d6gcdeLBad2Du35PMKQ+BUI0XkFr
        6Q=; b=cRpY1MgFGrud44CfOQiIVfbKBibS8EysaQ2PWH7ozgtWqTkHzWPku20Ds
        HEkkGs05AIUxgbAOc/r5ygLGGQ/gniniW6bxu+s2OWrU5kbqjnvwje0np9Sgpl13
        AHl3jYUzhaYCEDikL6BO09G2TOelZjLl8WJTii+7lKeueuprpHgh6kAH2nUIelMg
        foWGfC9zrL5MKomTmeHGLgy8dd52mbXVL9jl90Gp43A0WfVP6bWVPSZNLXKvI2OC
        WDtBl39ZvBFgHrVz/yNolZyW0vHtrfDMbgslGcHdDT7lqExtLkWiiIajfRqgj09x
        lYJpV3QfjGzweOwxJGBCq+JprWyeA==
X-ME-Sender: <xms:ArDQX9UVWZP-iT3Aqs4T3GOyKV_QDCW9NlO9T6-x7W3AAR92Epaz-g>
    <xme:ArDQX9nF3eQDInmDECycVzD-Hph93Q9rc0t2SZuNWKnXofAQDg_NbbZLNLaehz9kC
    An3FalJGRWlBw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudejkedgvdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtudenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepvedtie
    elueetgeeggfeufefhvefgtdetgfetgfdtvdegjeehieduvddtkeffheffnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:ArDQX5aLmjvteKTTrFkcRyiP1jNLtBW6Yqxjvusg_qwZL8C3qzKVog>
    <xmx:ArDQXwWfYUEZ8rHfHd-mun3B6Ps9_pf7d5utwHzk_aCylshoivp7CA>
    <xmx:ArDQX3n3TrZTMx4NXIKJNAYYJvaWiPW_xmdnjbm7J5Hec4SaB9B8pg>
    <xmx:A7DQX9R6mQ3UpmyFgUrtM8aQgAtdFkz4QCXuDBlIGVgCfiHHGgIxXA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 640D324005C;
        Wed,  9 Dec 2020 06:07:46 -0500 (EST)
Date:   Wed, 9 Dec 2020 12:09:04 +0100
From:   Greg KH <greg@kroah.com>
To:     Samuel Thibault <samuel.thibault@ens-lyon.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH for 4.19] speakup: Reject setting the speakup line
 discipline outside of speakup
Message-ID: <X9CwUD+SB1HIaV0i@kroah.com>
References: <20201209102640.yn7mdn52sm7bfbgm@function>
 <X9Cs/hMXQ4grRDql@kroah.com>
 <20201209110324.lnx7jmnm456jovim@function>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201209110324.lnx7jmnm456jovim@function>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 09, 2020 at 12:03:24PM +0100, Samuel Thibault wrote:
> Greg KH, le mer. 09 déc. 2020 11:54:54 +0100, a ecrit:
> > This, and the 4.14.y backport, fail to apply:
> > 
> > patching file drivers/staging/speakup/spk_ttyio.c
> > Hunk #1 FAILED at 47.
> > Hunk #2 succeeded at 187 (offset -4 lines).
> > 1 out of 2 hunks FAILED -- rejects in file drivers/staging/speakup/spk_ttyio.c
> > 
> > What tree(s) did you make the patch against?
> 
> I used 4.19.162 and 4.14.211 tarballs. But now I realize that I used
> patch -l, without it there are small whitespace differences. Can you
> apply them with -l, or should I fix the whitespacing?

Can you fix the whitespace please?  quilt and git don't like applying
patches with messed up whitespace from what I can tell :(

thanks,

greg k-h
