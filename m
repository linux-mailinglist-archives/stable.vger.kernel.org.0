Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6E515481B5
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 10:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231834AbiFMIGL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 04:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239527AbiFMIFh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 04:05:37 -0400
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEECB17060
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 01:05:36 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 3EE5D320090F;
        Mon, 13 Jun 2022 04:05:35 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 13 Jun 2022 04:05:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1655107534; x=1655193934; bh=r2RTjEcckc
        nWqKEjhGLF1yKxOPAvHrhSFELGPyOSJY8=; b=YC2zpKwfx9Fr4CD+lRXVfIATTZ
        mAUTe2SSFwt1hoqLgTuEKa21kKtSoPrvl2gVz39EfqgSUH1PDyT84oHnMbbv6pVT
        9Ql5Jd8zmiKiFEbR3bxGd990hpsIWmSS/8GSp/1f4H6UEMEvcRQzMH1jZTjrYV4z
        HbykfiGQ06uywExg4a8AEmtvNWLOtvEsf7/quL/ACcogRq+0nCXJ86IqLJ4qe45l
        Ml2U+RmYyeH4KzFuAIqjAERoXblFmRmp/6nnrNcPeiVNm3WRxjxgdOcekR/3QRtb
        gHIUUHxrsu75QGLgQbylv1yx7mcoxX5EL2IDlD5j0rwFo75oR6PA3UYRwfsg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1655107534; x=1655193934; bh=r2RTjEcckcnWqKEjhGLF1yKxOPAv
        HrhSFELGPyOSJY8=; b=onTKzwxh2CMCDXoGr+pyQXDw/V+UNfuMHZCw+w+SSOGI
        SYeuDzqyjlKFDQV62dHBCz2XIWNnoQ7n9pbqPzNSCdJfD9V2o1Drd4lvH/EwLEJw
        MN3/eiLFHhiIu8BDwztLN/xiZIfyz87iYC0vI1a2rmiCnhczGtbh8XW6Ep32h+KC
        m7zWviCtRP5gTru/y5c+ysv6kwgPy5OTDGaQfsJHAG3hWAQcGeXPL8Wp0QB60dVN
        2djM/4rUgRT59ZeJD0bbF8PdLMVtc7X9nOPAVUxY456588FoNX5O5ThXL/G4hPik
        x27Axz48ZtnUlwzQkX7SC61iuR8g5sjR1hW4m4CyyQ==
X-ME-Sender: <xms:zu-mYrMelwaWEF_aFmhlqOOjW7vJ1-AV3yckJxq6IhIO6c2LKoYCIA>
    <xme:zu-mYl8A52KNPvZm7LlKileEir6R6mCGIIaTsFq2ZY19itHCpyZ2UkFFwJ5C3DMHB
    4D9CeAo20JbvA>
X-ME-Received: <xmr:zu-mYqTapFcAmueTHO4OhkA7Ze15jxkUN2DXEoV898E0Q1KgSUSbMx1xndPRtahpa_w-Xj5q9Wa_XsP1nlTDMwRtbTXtBlOT>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudduiedguddvvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeehge
    dvvedvleejuefgtdduudfhkeeltdeihfevjeekjeeuhfdtueefhffgheekteenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:zu-mYvvbs3mwc5aXW6XK8HAGmT8UE1q5ylRglafN8GKRA8NsG01K2g>
    <xmx:zu-mYjfw3xq_-Ngjov3Kn81KK8PPathGfBYpVNM3kwEKGqKN90xzWA>
    <xmx:zu-mYr1NxUiD1l2rD8y20TtG4eHwX0FfGcAbl9K9hNPW3FCsOmSGgQ>
    <xmx:zu-mYkX-DpxaMxnjaUBZdnxVRQEy3fEwM0QG6qf7SlTS8D-iMRM28g>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 13 Jun 2022 04:05:33 -0400 (EDT)
Date:   Mon, 13 Jun 2022 10:05:31 +0200
From:   Greg KH <greg@kroah.com>
To:     Thomas Zimmermann <tzimmermann@suse.de>
Cc:     airlied@redhat.com, kuohsiang_chou@aspeedtech.com,
        jfalempe@redhat.com, stable@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 0/1] For stable: "drm/ast: Create threshold values for
 AST2600"
Message-ID: <Yqbvyx+oh2iIBwUI@kroah.com>
References: <20220609072242.11721-1-tzimmermann@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220609072242.11721-1-tzimmermann@suse.de>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 09, 2022 at 09:22:41AM +0200, Thomas Zimmermann wrote:
> Mainline commit bcc77411e8a6 ("drm/ast: Create threshold values for
> AST2600") needs backporting into older Linux kernels. The earliest
> affected version is v5.11.
> 
> KuoHsiang Chou (1):
>   drm/ast: Create threshold values for AST2600
> 
>  drivers/gpu/drm/ast/ast_mode.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> -- 
> 2.36.1
> 

Now queued up, thanks.

greg k-h
