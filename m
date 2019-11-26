Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 427E610A1FB
	for <lists+stable@lfdr.de>; Tue, 26 Nov 2019 17:24:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727191AbfKZQYU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Nov 2019 11:24:20 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:55259 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726983AbfKZQYU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Nov 2019 11:24:20 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 9F84F86F;
        Tue, 26 Nov 2019 11:24:19 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 26 Nov 2019 11:24:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=LSJeu8ZRySg4DIkdsMgtSzRClAv
        bHokXu0emuAP8HgU=; b=eELNAVbSjA3p5c4BPC9+3NMy7zpOAOb/fzglKOuMYTS
        DncpuSLI2uZFfCeSfC/vSKO+TufHbY1iOcgr0Q49zNvSneS1fuv3+uxJm702TalU
        Syywqn9he+N12WDes7csDJkXMH24hpkZyiFk0EugjwAEtKuHFs4yZ9kS30oOhoam
        sDOaqvBKwVsPBuR2Z7cxxl8Erg2NL4FTeGfI66ITYI5OZ+JIQHAop4FpjxSAhKvy
        nbyNruzh9oEF36U61vs35SK4uoomZ9yUKjV1VDPlC/YSTZXOB2LpyW46hOSIW+MN
        hU+YyLZ2wDANV0XD5YaifBHhdKRnXXLcJdJbLUpAReA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=LSJeu8
        ZRySg4DIkdsMgtSzRClAvbHokXu0emuAP8HgU=; b=hwRd/PS6L40BsAZ9vONP0R
        RKfErCKSw9rq7SLPxhwBJ07toQN+W1uZ9TzCCI64GSfeiEroxd8Z9AgpLZ+AkOm0
        4kBvk0mI9VO9CPtmxdDymlRPi6F2rEoVn9eUZoCmjzZUoeu+bpZ+gGByE8clW+dJ
        eU0a+Dzvrm0kUIPHIEv64+2zSgU6l5isQzjDCqxuUIypxMW+CVJbb9JqAK4vdBhF
        DzgbDpkt14cR3GHtgCja5sgAMqDmz9nzT89yAnM6pcSYYc63WaaxXzpsj4y2ubS+
        zj1VKuU6napfdy2e+7YhZI2EVI8FrVraINyRuyGDL9v3HV31DukBW461GMOzRumg
        ==
X-ME-Sender: <xms:s1HdXR6l0dJ3Zq0fjmp6EsDR6m59s6BL10xjlgK5CpSpPi5Be5HfjQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudeifedgkeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekgedrvdeguddrudelge
    drleeinecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:s1HdXbQgWCpgyg1GlLSZnLdI1oPC0UXqaUq6IkYNYdT9_LGp24sOlg>
    <xmx:s1HdXbSRwbJSuUbKvFtTfuJpyYg-Yox0PWusDC8LDhM1hmMIeY3w6A>
    <xmx:s1HdXZO3ONg_ccMFkpLTWhNxTJkBS_htTGnzRgp3-kIKVTrec_KNDg>
    <xmx:s1HdXc6bo2_tqraY2otO9MfJzIKOy6F52DFf_aJ5ok3hBy1KMEy4UA>
Received: from localhost (unknown [84.241.194.96])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9C0BE80063;
        Tue, 26 Nov 2019 11:24:18 -0500 (EST)
Date:   Tue, 26 Nov 2019 17:24:16 +0100
From:   Greg KH <greg@kroah.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 4.19 3/3] ocfs2: remove ocfs2_is_o2cb_active()
Message-ID: <20191126162416.GA1657337@kroah.com>
References: <20191126134741.12629-1-lee.jones@linaro.org>
 <20191126134741.12629-3-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191126134741.12629-3-lee.jones@linaro.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 26, 2019 at 01:47:41PM +0000, Lee Jones wrote:
> From: Gang He <ghe@suse.com>
> 
> [ Upstream commit 9d452c602f0558ec3b0aeab1040bdf4dfbc590eb ]

That's not a valid git commit id in Linus's tree :(

These series are a mess.  Can you redo them all and resend them so that
I can apply them, and so I know what branch to apply them to?  :)

I'm dropping them all from my review queue now.

thanks,

greg k-h
