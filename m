Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 879DF4EE7CB
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 07:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242933AbiDAFea (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 01:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239652AbiDAFe3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 01:34:29 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B38EB19B07F
        for <stable@vger.kernel.org>; Thu, 31 Mar 2022 22:32:40 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id CAC025C010C;
        Fri,  1 Apr 2022 01:32:36 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Fri, 01 Apr 2022 01:32:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; bh=tcUHCZ53Jdbxt3XM3m9APQ4wP6taL9tWKdFazA
        nsE1Q=; b=Lue6a5fIOhtXTvibHIoKWvyT6sMWrVpliC95XrdDAeppnfZ82pRiHU
        AU5/kB9TVENGQabsg+JJVD7Op5gq17upMEkP4STGcgbHbGccqp8DBi5xj6neK6YQ
        qhuk1XmJpzGZg2C6VCm8kN9CBoXUyBUtsCxi7z4ek5qiAgVNNePG9ptJ9V4/dxoK
        DsqtDmiEvOYs4sl6Rk5iLquB/U7HsJ3Q9oCuNfHHk3RiUVs5GlpVQ3cnLEqAqjCx
        j/jak3A1AuVOVrzmx3MianLsLISxPgJpYyxyeMbb4NDyeCYhE1Lr95KMjH3F3RYZ
        RQX+SOH2xK760EAGUqveBJYSbuGSiHGA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=tcUHCZ53Jdbxt3XM3
        m9APQ4wP6taL9tWKdFazAnsE1Q=; b=d1OQ0D7XlkBmMglXdGmsdBW0pKb+/QJX0
        pfMYhJqNDAzzxkCswKkOWbyWc04rr5D9sVYljH6GSdfCALbtS2B7m/Q7iBXiFroW
        dT7Bz6XGNJOkY8ErSDsEnud15flCghu82Rgn9m/GxlLaFSSLk5kVdUvcMjNMoRXA
        9uTtSh4PAKnywvUW3UsY3pDSIcI28qSsJI0OL6sJQBNHDsYlXrmmJND9McGZH4QV
        AP9Tx46QpC0fhd5Ettx8dVg/vTGc0/y+VnjfnvfLaRvOqa5DCRdpkFNn9cknwsU9
        UMcsvSFHSbKMIzgg5Z5dPrr+w/TLilnQJ/rMPSD8pULXbydticJCg==
X-ME-Sender: <xms:dI5GYvGL5-Jz3BouWt2ofkTeL-huLEN66QRNswd2qUbBfBsO865LYw>
    <xme:dI5GYsU3c-zksf0OjnIz3O4wJF0DDRRvqpNaf3_SRtqzIbdStBvEzMLa-Tez27Fgf
    ASGmz28gA3OtQ>
X-ME-Received: <xmr:dI5GYhIVJmj94LcTB9_mCXwFKAiCu6UJCEkib3Sbn_jD3lpx8d9-VtypEeWhTfZXPgYCuayQUiBAm1ck3lIRwgCEGpUORIlr>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudeihedgleeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:dI5GYtGQoNwSY_maumNVMli20onPtcxp6oFBGcC6fWXeLnTuSYDkzw>
    <xmx:dI5GYlUzaS2DaGEzdr2VNE_xZHL7tHqjgFOBX_jfVwPBajm5lt5WdQ>
    <xmx:dI5GYoPVK2NIgy6YY5v8AIaHQtDgL-OSI4MZEvS22PNhv7tC_nYUvw>
    <xmx:dI5GYrwXW0TnHwBr6kqudu1Vd7YLL6b4K1Fg4m3_bGSneX-TgUmAxA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 1 Apr 2022 01:32:36 -0400 (EDT)
Date:   Fri, 1 Apr 2022 07:32:34 +0200
From:   Greg KH <greg@kroah.com>
To:     Vitaly Chikunov <vt@altlinux.org>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Subject: Re: Why rolling trees aren't updated last week?
Message-ID: <YkaOcsf8Ua0ubdb5@kroah.com>
References: <20220401025038.d4hpgzpl6jnxkyyw@altlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220401025038.d4hpgzpl6jnxkyyw@altlinux.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 01, 2022 at 05:50:38AM +0300, Vitaly Chikunov wrote:
> Hello,
> 
> Why linux-rolling-lts and linux-rolling-stable trees aren't updated last
> week and stay on the previous lts and stable releases?

We forgot, I'll go update them in a bit, thanks.

greg k-h
