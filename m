Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBFFD4D6ECC
	for <lists+stable@lfdr.de>; Sat, 12 Mar 2022 14:11:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbiCLNMF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Mar 2022 08:12:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiCLNME (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Mar 2022 08:12:04 -0500
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F649235875
        for <stable@vger.kernel.org>; Sat, 12 Mar 2022 05:10:58 -0800 (PST)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 001DB5C0098;
        Sat, 12 Mar 2022 08:10:54 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 12 Mar 2022 08:10:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; bh=kOtvz2k18IzVoH02/bqs/g5FdJ3leY8d1uUIsd
        FYmXk=; b=eQ3h3yW9FLQgpGuRCgv3l/DwTHulBsHfNZolPV7XVStPYejF8rpof+
        B+q57R9BW2ld1YO6HWSL6gE8TA13OpLfEpBDTm9AOnvBPnkie6MQHWYSWZap2Jzd
        Ihj4efVdh8WbpfzLIRZdBK5BZhXFCruotKWAX6tvd9CA9j3SdktwRipwLJvUecjq
        2VCNamnPZHRsiiEche1I0qYxRwT6C6k8yhmauiQgYa07Hq5wsmZn0Zu62TJYXvK7
        ygrceHLxlFOHO5LJ3VrnzUU6v4AHZk9RZ1ATBuCs1J4tnr8ttCqMF8d47pbqdBtO
        1fs0d4sR5UvdOOfM9RKXUr1aQlIpawBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=kOtvz2k18IzVoH02/
        bqs/g5FdJ3leY8d1uUIsdFYmXk=; b=dXQhJ0rploR52nngTlkkyIKfUol4elJrY
        kT4ay2WIAqBOanEcSrPVQjPZsDVHdxf8VRWA7EGylZxZZen655ZPYA9/lrh9FurA
        Yj9yEJUYmQwwmt7wTiLN3tg4a9avfHdmlPdIyYwk7xyZ+KR4Wv6e/1sgR9qDkPic
        9LuZBY4HZ7o73c6QdP6V/x0alV6f+g7eNpIbueStvaNmepMzVu8Uxz9jLODWPY59
        GEplqKkFwEljz/TB+oMCehK2K2+0o06+HVpF+eyzKGb6E3bBpvHd16aPQ2GIaQ5d
        B4Qh6YycVAZ8sgcrxYc+iKgo81r/0z2cF4NWqNfK/YphGxdE2N8oQ==
X-ME-Sender: <xms:3pssYtm8ps423gPUT4H1J2AhtkgbeTOR-e_Yr2cgBZS5vMUFqiMALg>
    <xme:3pssYo16q1gzO07WU5Mdbzxqd_FipGQOs53w4FdR1fE4FCISZV4G0GQx2xSjtJz3z
    _v39aL50MGoPA>
X-ME-Received: <xmr:3pssYjo0eggeWFmK4kfhActiEruJLEH3mMOPHURj4rCMkIXIprqgaDOlAMLhEkGBXb3VUK6yOqXIjfCWbnGCe7mfSzl-rLXR>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddruddvgedggeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:3pssYtnETx2CJHwql2u7M7etb-wNEaYueLR6NbgO9waaMX32huYrxA>
    <xmx:3pssYr2KIQic4CEfBYChzvmMJqJEPWIVVVQLaX9u535utCSZrdu-tw>
    <xmx:3pssYst8EOZbDQrc2ka_BfBGIGOqd5py4ZS7pjqLQXmXQO87N1sWww>
    <xmx:3pssYmSOhd6zcksaVpTT1d3sVMS_yg0Ux6CC88rJquh6mcFMkoKebw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 12 Mar 2022 08:10:53 -0500 (EST)
Date:   Sat, 12 Mar 2022 14:10:51 +0100
From:   Greg KH <greg@kroah.com>
To:     Sven Eckelmann <sven@narfation.org>
Cc:     stable@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [PATCH 4.9 0/2] batman-adv: Fixes for stable/linux-4.9.y
Message-ID: <Yiyb2yeRFTfFiEsc@kroah.com>
References: <20220309164542.408824-1-sven@narfation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220309164542.408824-1-sven@narfation.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 09, 2022 at 05:45:40PM +0100, Sven Eckelmann wrote:
> Hi,
> 
> following two patches were backported "automatically" applied in
> 4.14.y, 4.19.y, 5.4.y, 5.10.y, 5.5.y and 5.16.y. But they failed
> to apply cleanly in v4.9.y due to some changes in the patch context
> and one missing function in the older batman-adv version.
> 
> These problems were now fixed manually.
> 
> Kind regards,
> 	Sven
> 
> Sven Eckelmann (2):
>   batman-adv: Request iflink once in batadv-on-batadv check
>   batman-adv: Don't expect inter-netns unique iflink indices
> 
>  net/batman-adv/hard-interface.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> -- 
> 2.30.2
> 

Both now queued up, thanks.

greg k-h
