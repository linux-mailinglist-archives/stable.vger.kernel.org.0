Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8129254E185
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 15:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233490AbiFPNLV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 09:11:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231831AbiFPNLU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 09:11:20 -0400
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C032726113
        for <stable@vger.kernel.org>; Thu, 16 Jun 2022 06:11:19 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 45EB83200258;
        Thu, 16 Jun 2022 09:11:17 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Thu, 16 Jun 2022 09:11:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1655385076; x=1655471476; bh=g6XgrVZ4JF
        Lv29quC7i4nwzI7t3eE6Qsx69VliMbyo0=; b=V3Ls3oEKIuXEURKVDEi/JjEVyz
        eF11yNpXRkKKX8YJT4oS0Opf/fYnOBiuBVle5DCJWHLAdeXb7qw11BpPVDLkUXVp
        seZMEO2qkXuKZ/ZevNyVKZoSYDLfnmR0YnDmLs7NC6KyD+msSMf4Yq9U1hnrUHwE
        2W90TtiowSsv2oRZigGVnWb7xxiDj/kSjYY9fCw0HJ3HM3h5IwhFzUvxwmHuW+g4
        L+0oZd3XvNiuxHPesk4f6XlMVcfUVymYZIg6ElvREBPnlkiMNkB9oQC2N9uRqN7i
        d6GH/fiqF+08bwL9Pp9AdL/xAyTKi6Yc3wk4/iMdwW6yVx9EJqwAL6SLcXWg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1655385076; x=1655471476; bh=g6XgrVZ4JFLv29quC7i4nwzI7t3e
        E6Qsx69VliMbyo0=; b=dh4JLJQoyBKOfM+Oi7/w1QF2etht7UV4y1Mv01Zbh3vU
        tq4uH6RIUk7LSS/gtHlLAX71PlTAYKOBy7s1G1ZhDEwbRnOMXAZQwEvhP1OBIlEM
        j7SYlIJe5v4Npl2fcwi2C3avWhs9RPO2rTnFiL32BhG/cfvGIb8tHvjeQ72S4/fR
        fC3M8romtPS8Dkhr646kb1mHsch3fUXAcGkux9vUAvRw8Fr9rIPkCbXd9ZX40Edi
        s18+J6M2GdXZNkMlGE1FvRkMwjijl/sQ5lQdNncxENqq+le3pGBqV3j/z2GDOSFh
        MSE9GsWtyjkjp8UvYafgWhEyMFBnEoIG5EKzJPlgKQ==
X-ME-Sender: <xms:9CurYjdIGckwDpzn-juBhKUYn7qYRo-tp0wEMRjh_nJ44BDqSnfO-w>
    <xme:9CurYpNFT-OaUAQXZRsIXWVqz6GQY3yf5doIcJNYx-_2plWGtEE2wy3yWS6TttAzd
    iKNQsXVqUaH6g>
X-ME-Received: <xmr:9CurYsgJJ5ZtEl4CIT66oiGHxrv3q3mnX97ub3BS1SKfrJHZPiz0AUryL76yjw6KuZ5hDfy9UR0NLUEOBT6ag5pKCAIoKfdL>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedruddvfedgheeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepheegvd
    evvdeljeeugfdtudduhfekledtiefhveejkeejuefhtdeufefhgfehkeetnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:9CurYk9GrLreg4MBKm0kBkI_SUvsyE2OWoJtZeBox89lprRAV_5Npw>
    <xmx:9CurYvutnNGpO8Y5rgRc6zVzEv0iW9UN-_noCvdVphTDs4lFcO8wng>
    <xmx:9CurYjEyUJJM3wUnwksTLC934Gs6M8hVcn6uRDjwyjWQ3Ddq-mSVGQ>
    <xmx:9CurYo5fUxxXRD9eAFf3nZixq-zZLuGhnL_AAwWDDXZttovVbxkQLg>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 16 Jun 2022 09:11:16 -0400 (EDT)
Date:   Thu, 16 Jun 2022 15:11:14 +0200
From:   Greg KH <greg@kroah.com>
To:     Adam Ford <aford173@gmail.com>
Cc:     stable <stable@vger.kernel.org>
Subject: Re: arm64: dts: imx8mn-beacon: Enable RTS-CTS on UART3
Message-ID: <Yqsr8rjeREYvdJiz@kroah.com>
References: <CAHCN7x+8dcUkE_n+EEtYnKU=3=VMQ7kXSBB8vWZ-JP1KeiUe9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHCN7x+8dcUkE_n+EEtYnKU=3=VMQ7kXSBB8vWZ-JP1KeiUe9Q@mail.gmail.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 13, 2022 at 08:59:34AM -0500, Adam Ford wrote:
> Please backport 5446ff1a6716 ("arm64: dts: imx8mn-beacon: Enable
> RTS-CTS on UART3") to 5.15+
> 
> This fixes an issue where attempting to use hardware handshaking on
> the DB9 port fails.

Now queued up, thanks.

greg k-h
