Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB4045AA7DC
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 08:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233931AbiIBGNv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 02:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231732AbiIBGNv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 02:13:51 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 304B5B9FAC
        for <stable@vger.kernel.org>; Thu,  1 Sep 2022 23:13:50 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id CEDC95C013C;
        Fri,  2 Sep 2022 02:13:47 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 02 Sep 2022 02:13:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1662099227; x=1662185627; bh=igbSEWoJk3
        85irJARP4OB7rQIjzRiHAiGUuUYivesNY=; b=OrG0zDTpXDQg+jeXEGqeTBwoON
        Yv0KaYgUOZKMKWlKDiXoRy8fi3Ggvm0PgAZ4mVg2PpRX78zKEq/ki9CLfSbyIJeq
        zAVYkXs+yhkvlMCUo9TKoVD9xVBscq4R0sTgGDJa6oeSu1M1Xbo53eSy5lx8xJML
        k1E4832dXMjx0/p08vhe82OU2DAsyn/dKILk/rXebl24hSqMMV/lN6m9rWy7fubW
        TaiaaP4rN2LpkZ+VpRm2L1rG83aZHXYdAE2c87Vx+k/7LY2Ekwqfk/FPxcIl5GMt
        Fj+qtdMnOriAFPnsTygQ1l2rPveQDkhnzK8Br1TgowSpHvPuBxYayiURU7IQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1662099227; x=1662185627; bh=igbSEWoJk385irJARP4OB7rQIjzR
        iHAiGUuUYivesNY=; b=fNF9weSoO5lhevAKrS7VKvohuPi0OrVFeUVfY5wKTGCg
        4CsG7wyQrkiE2aflYhrosiRwhG0R+nht9xFDbuUW0CrwAVW/lCroh/YEw2H2/Bj9
        /Kp6X1ch0jsW48QNas6/vR4c9UIrAVrtWpRleQCxImJE8qLZcVzaBD+remx2CQ01
        K/xg1Z3z69nH/eC9nNiYO8npzGmCv5Oz2vO28htXbFMGLM9jITg8iymXxprZmCGf
        2tVZwDDOe+GSeqNWfGpjweBtstYc4BZGpS0lJw6rEpAFoZbgbBQEfwYKfod5Pw7X
        6XNLg4OPuWizdU3oCnHfNoMTmbZes0quPnInH9hwfg==
X-ME-Sender: <xms:G58RY8y-3UXvXPME_t8epHBWBQxI47HdXPP6aFfhAtTb1gr_RgAIcg>
    <xme:G58RYwSh2wwKhpxuCt_B2TbvBP_jnkij1OgUzziwwOqL5NIyA-nnnU75hmogN1Smo
    B8_hvaZtp3pXA>
X-ME-Received: <xmr:G58RY-V-Paseic57F65xsUYdNx519bux9dcE4CCSGeFbhtGP7-bCsLCYgP8kAW3izVWR3vDG4Lsevl7CgW2sgx_yvopbDbKa>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdekledguddthecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeehge
    dvvedvleejuefgtdduudfhkeeltdeihfevjeekjeeuhfdtueefhffgheekteenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:G58RY6gxMP_9A4aBQSp95L1WuC_vZw1_hiLpIn8wNeh_GYGrbXg9WQ>
    <xmx:G58RY-DYRadgcT_2MAOaUM_KRjhWPbkcYQLioU3l1CMihMVDFxElzQ>
    <xmx:G58RY7Iz_ahOzGTQ68kmPJ3T2gvGk8KoU8Ms64XdZgt_w3Ur46RbZQ>
    <xmx:G58RYx_J-W9aHWYV7RVO7NMNiVzZS97FIkofGPZalZFLmqr0pLf9gg>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 2 Sep 2022 02:13:47 -0400 (EDT)
Date:   Fri, 2 Sep 2022 08:13:43 +0200
From:   Greg KH <greg@kroah.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH stable-5.10 1/1] io_uring: disable polling pollfree files
Message-ID: <YxGfF7hQOGa6lKMt@kroah.com>
References: <4f4668f469baa8f1387e746fd2533ec662500f3a.1662042761.git.asml.silence@gmail.com>
 <756d8d67-7a63-62a1-51e4-1e966f40610d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <756d8d67-7a63-62a1-51e4-1e966f40610d@gmail.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 01, 2022 at 04:25:46PM +0100, Pavel Begunkov wrote:
> On 9/1/22 16:16, Pavel Begunkov wrote:
> > Older kernels lack io_uring POLLFREE handling. As only affected files
> > are signalfd and android binder the safest option would be to disable
> > polling those files via io_uring and hope there are no users.
> 
> It differs from how it's fixed upstream, but IMHO porting is too
> difficult to be reliable enough, this one is quick and simple.
> The upstream fix:
> 
> commit 791f3465c4afde02d7f16cf7424ca87070b69396
> Author: Pavel Begunkov <asml.silence@gmail.com>
> Date:   Fri Jan 14 11:59:10 2022 +0000
> 
>     io_uring: fix UAF due to missing POLLFREE handling
> 
> 
> I also forgot Fixes tag if required:
> 
> Fixes: 221c5eb233823 ("io_uring: add support for IORING_OP_POLL")

I'll go add it by hand, all now queued up, thanks!

greg k-h
