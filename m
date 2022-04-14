Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99BD9500B43
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 12:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbiDNKjy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 06:39:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbiDNKjx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 06:39:53 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE93C75219
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 03:37:28 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 82C5C3200E1A;
        Thu, 14 Apr 2022 06:37:27 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 14 Apr 2022 06:37:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1649932646; x=1650019046; bh=vTYhs0jR7B
        8XW+1JEAKGyPbwD0+qjEkJywpMqVSKmTE=; b=OzlSxBDnw3j8j8VXGDQ7JPhrl7
        AYAd8/RVylkpF9cp5kVeI2zfijuer8ccuMGD9CUwuTeA9YfCLjaZYQInQ3PbhZNI
        Qiz3mqDXTGNqjJz40CPx/HOi1wKx4vHiuXawawOQPgBCnPLYI+nzfEY2mHCrs1cd
        QNjz7cSkMvq1+NDssQsxTExdOtvWSuCarmDdtXBiEbZeyFGL6/o6p4jtqXtYCSbt
        zu06+dpOFo3YHC0xO921GzPNPs5cK+Q4z6I1QCtp2c2/nXljKgAU/QgleXJF+/M/
        Ogs+R3u33082wwIHVi1eNNHbeVrI5mGXc4jro774eYMrYBm9kfnpGlZGj+xA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1649932646; x=
        1650019046; bh=vTYhs0jR7B8XW+1JEAKGyPbwD0+qjEkJywpMqVSKmTE=; b=o
        EdGMyj6qCnf0HdwAe5VfaDHo+i8WK6p2peeZ8vignHyAU/csHLiTIQfwHwaRCfsV
        xIOZlyrs4tbHv2Bs64XIBF0HAKmpp1J8epoqwuJKU0xiYegsmhof28wujYZwK3MJ
        rN+xM5rXGFOgcBk6Z/3JSwrZOkl1DVqwZOqAX2Rim/ok5WonojpgcS6fRGzk+9x3
        VpQ3br2NCIQ862ikIvz5E2s5+GKmX5p6aoYS4z6gKe69ahxBvbwrbLoYWCEG6l1h
        mCaclFAXqA2/D//LZZLiy88fR06gm2/Fq64nhClFKzZABBUW784ZrASEdw05w4cv
        neGwwJeMVaLlHifHVGlSQ==
X-ME-Sender: <xms:ZvlXYgYkfid3J746hHx2WY5tcrD1wTf_oc8RF4VYcBnZ3jKeYAoNfg>
    <xme:ZvlXYrbWkNbH3OzYm0iYSllRRLaRe8d5s-zgtDyoftXt1Y4KTp9aq_vwxig9gCCmo
    ORvF1HC7o2NYg>
X-ME-Received: <xmr:ZvlXYq9HuzcmWjYPby6tEGno17VqNgfbnz2qkTGD94NmFWorCpo9LQ1G>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudelfedgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucevlhhushht
    vghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:ZvlXYqorXBmwCo-1ANowTP_p1B6GMnneMKTgVknSJ5c4vNE-FI7vNQ>
    <xmx:ZvlXYroXdYSspbj-Nv_XAmaRPQvl3Nvjt3lYl8GRNNp6EM0riBFSHw>
    <xmx:ZvlXYoTSikXOvZRm8XikBEWWd6fARV2qJuZRg3KsY8pgErs3LSVSlg>
    <xmx:ZvlXYvd5F_B96fjDOfSg4pigjpdoNYlewtQwXsjmUkDUjKZUiQDYIQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 14 Apr 2022 06:37:25 -0400 (EDT)
Date:   Thu, 14 Apr 2022 12:37:14 +0200
From:   Greg KH <greg@kroah.com>
To:     Tobias Brunner <tobias@strongswan.org>
Cc:     stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Xin Long <lucien.xin@gmail.com>
Subject: Re: [PATCH 4.19] xfrm: policy: match with both mark and mask on user
 interfaces
Message-ID: <Ylf5WkjP7AclOR05@kroah.com>
References: <9376197f-55d6-d450-4b51-a86aae21feb2@strongswan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9376197f-55d6-d450-4b51-a86aae21feb2@strongswan.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 12, 2022 at 09:33:58AM +0200, Tobias Brunner wrote:
> From: Xin Long <lucien.xin@gmail.com>
> 
> commit 4f47e8ab6ab796b5380f74866fa5287aca4dcc58 upstream.
> 
> In commit ed17b8d377ea ("xfrm: fix a warning in xfrm_policy_insert_list"),
> it would take 'priority' to make a policy unique, and allow duplicated
> policies with different 'priority' to be added, which is not expected
> by userland, as Tobias reported in strongswan.
> 
> To fix this duplicated policies issue, and also fix the issue in
> commit ed17b8d377ea ("xfrm: fix a warning in xfrm_policy_insert_list"),
> when doing add/del/get/update on user interfaces, this patch is to change
> to look up a policy with both mark and mask by doing:
> 
>   mark.v == pol->mark.v && mark.m == pol->mark.m
> 
> and leave the check:
> 
>   (mark & pol->mark.m) == pol->mark.v
> 
> for tx/rx path only.
> 
> As the userland expects an exact mark and mask match to manage policies.
> 
> v1->v2:
>   - make xfrm_policy_mark_match inline and fix the changelog as
>     Tobias suggested.
> 
> Cc: <stable@vger.kernel.org> # 4.19.x
> Fixes: 295fae568885 ("xfrm: Allow user space manipulation of SPD mark")
> Fixes: ed17b8d377ea ("xfrm: fix a warning in xfrm_policy_insert_list")
> Reported-by: Tobias Brunner <tobias@strongswan.org>
> Tested-by: Tobias Brunner <tobias@strongswan.org>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
> ---
> This is a backport to 4.19.x of a fix that has already been applied
> to newer stable kernels.  However, due to conflicts it was never
> included in the 4.x trees, which all contain backports of the
> problematic commit referenced above (ed17b8d377ea).  So they all are
> prone to creating duplicate IPsec policies with priority updates.

All 3 now queued up, thanks.

greg k-h
