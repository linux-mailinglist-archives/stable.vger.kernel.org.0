Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB599545B81
	for <lists+stable@lfdr.de>; Fri, 10 Jun 2022 07:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237145AbiFJFPo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jun 2022 01:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235342AbiFJFPn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jun 2022 01:15:43 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A51DBD1
        for <stable@vger.kernel.org>; Thu,  9 Jun 2022 22:15:42 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 5BA495C0069;
        Fri, 10 Jun 2022 01:15:41 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 10 Jun 2022 01:15:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1654838141; x=1654924541; bh=ZS9sUOrf2b
        gcfU1L6mOfxXPHxq1jRrCvEYfAc0GlTus=; b=tWTrr4ppzdTv+b0P0D1swzeA+A
        9e6XotdI08SJ2EXWblDaTAuwcRQuYFvGtP+l8uUZxz4W5Dcan0gPnQWAPlvQRZFp
        W5x/zeTMqy5OW08Sd1qVPmjzY4riHjHph13ehpiRrOhP2G60F+fcZ73wUonkMGgM
        Yj6xVToimg8yNuHDXIDOCbJTi4MrLYet4B5xlJI65O4xxWHg2/x8qsx1NfaYSlEm
        swFkTU8tTRF+RBPDMrnSwtr/Fvhp+X8L7YkbkwNOd/WYxIXKc1oONV5q4D0UsrY8
        lZqM+3n+s6Fp3Q0c0nXzh0/x29J3ogVj+Qvpb9XFZjl0YRSBJ+8++2qZ1OLg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1654838141; x=1654924541; bh=ZS9sUOrf2bgcfU1L6mOfxXPHxq1j
        RrCvEYfAc0GlTus=; b=HgGAPrypzvtzn0LMJHSdnw+xz/a7TqOkAX9dBtkvYO5s
        um9M0vYjufJUoD3IDpEraQhM1OnNrF38j/5BzFAM2VcftULT9maaMbu7sc2+tVu6
        a0Fy78HHp8wi896Q6Gva6/p+r7G4Pp90PgxVu3Hc+K0/PD1ewvwEci/ordU/q448
        WGfoOpGzFUQYkDGqdvI17ANGUpL82Hqt+/8MJLhHQwcqVISJlxHGMBC2sG6afdK8
        oquRfF5skFBy+5896n0vbqQrJ3DrBI/MHhi2to7v8oECm2vcpbi5ycmpLx6EUjzb
        W0vYGEYEpaCVYSTHmwJhEFr1ftXsWgN1g6p4uGrkYA==
X-ME-Sender: <xms:fdOiYmPCnodQ7sXvMSygA7A1p9PnpMWvwfmbWS8RH0RWm8Yb-Rac1Q>
    <xme:fdOiYk_Sd7YuOyxcs5ueQHkpSHwmDB-e4WYBk7FptaqUECi4K2mlmCzE0LNWixbLr
    Lbkl3s11dzTnw>
X-ME-Received: <xmr:fdOiYtTdK7J5LHWwY8uQEWQRCNva41Tt2_t6uldN0FaGM9_SUfLFtpla9Gg4_gBKBQl2hU5TKIL0V1NR3A7_HAzoLc99Z4MB>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedruddutddgleduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepheegvd
    evvdeljeeugfdtudduhfekledtiefhveejkeejuefhtdeufefhgfehkeetnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:fdOiYmtXTeKNaYI5dXP472cA-C421rgg4Xveeiukh1OCGy9g5Wl3Dw>
    <xmx:fdOiYuceYHQJJ2PQlIXEQlrL_L-EGCO7fbBCMTsy_EHa3tK477R66w>
    <xmx:fdOiYq1OizgtJ_bboVj_ymicsObpDsuvfAcPjE9PA0mINB8d0uCdAA>
    <xmx:fdOiYvqBw2AHtTU1vGSZC8NkitaplrTn-J10t2Run9KT1hPVjTmC_w>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 10 Jun 2022 01:15:40 -0400 (EDT)
Date:   Fri, 10 Jun 2022 07:15:37 +0200
From:   Greg KH <greg@kroah.com>
To:     Jason Self <jason@bluehome.net>
Cc:     stable@vger.kernel.org
Subject: Re: Build error on openrisc with CONFIG_CRYPTO_LIB_CURVE25519
Message-ID: <YqLTecx7MGFPOvhw@kroah.com>
References: <20220609162943.6e3bba4f@valencia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220609162943.6e3bba4f@valencia>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 09, 2022 at 04:29:43PM -0700, Jason Self wrote:
> In building 5.15.46 & 5.10.121 with CRYPTO_LIB_CURVE25519=m I get the
> following. My workaround is to leave it as CRYPTO_LIB_CURVE25519=n
> for now.
> 
> CONFIG_OR1K_1200=y
> CONFIG_OPENRISC_BUILTIN_DTB="or1ksim"
> 
>   sed 's/\.ko$/\.o/' modules.order | scripts/mod/modpost    -o
>   modules-only.symvers -i vmlinux.symvers   -T - ERROR: modpost:
>   "__crypto_memneq" [lib/crypto/libcurve25519.ko] undefined! make[1]:
>   *** [scripts/Makefile.modpost:134: modules-only.symvers] Error 1
>   make[1]: *** Deleting file 'modules-only.symvers' make: ***
>   [Makefile:1783: modules] Error 2


Is this a new problem, or has it always been there for these kernel
trees?

thanks,

greg k-h
