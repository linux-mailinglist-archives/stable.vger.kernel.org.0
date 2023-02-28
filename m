Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1C9A6A5CB6
	for <lists+stable@lfdr.de>; Tue, 28 Feb 2023 17:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbjB1QDe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Feb 2023 11:03:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbjB1QDd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Feb 2023 11:03:33 -0500
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C0261E5F3
        for <stable@vger.kernel.org>; Tue, 28 Feb 2023 08:03:32 -0800 (PST)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 6A8583200916;
        Tue, 28 Feb 2023 11:03:29 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 28 Feb 2023 11:03:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; t=1677600209; x=
        1677686609; bh=B9xLnA3Jtg9bXfo0iFjLBZj7Lxupdjzu8QDL2nu3z8s=; b=O
        36SPoFigi6Jd5/MLOvBpkLrZjl9b2JPwMcl3yTUezEGBC3bJyNvF9K4ufAlyHCe/
        U28afWJAV4gZ4cszjqQ7jOk1kM9LOjZB3TlVluUggLnb4bqSTB9k7qxaDsNjCbLY
        8nAamDKDBX4aDtWDloccCeXMLxcIAGGdO/dSRiIDenGGkpS+dPsVF2CK/sIQnqEV
        Rc92v0lw+QZ8kEsgiLmNrIq21qJW3Mu2ah2hk5AvC6/DiLQx4vCk3iFqNlvMGGJB
        MSB8M2hmRzKIRDm04tnUuCu+jP+XvpHMpsZ7Fithqz7XmT222EgJt7E14BBm0Alo
        bD0vFvtOSyAEH1Hms1uUw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1677600209; x=
        1677686609; bh=B9xLnA3Jtg9bXfo0iFjLBZj7Lxupdjzu8QDL2nu3z8s=; b=d
        76TQljbXTXrU0LUhhTPXK2/+Bfq+Ko6yMMkz+GUtlrBtYZZ3iRfuSSAmI3SjDr/S
        W126Topm0fyw1ar9IRSGheMy104uIwpLWAfVVWoPuSv6RCPVIEY1fx7M3l+WCTgm
        wiz1Ip9HYlmvWUuRqBU7VhJXQSatkIDPPHtIp/ghQkveb1KWsvcd4SZXOcLtUe2H
        D1Qs3tRxeV6UGr1bvvTHkfDF3JDsS62XJKCU0VvRn/i3AsAWPCLTWzU2Vm20T2ZY
        IGeK4GPjP4O9FIwhNE8NPG9ZncYj+AFHeLb6Okdmi8wDJ6f1uBujuINjcAXKwzuS
        3q2zW9QLr/Mme6eyBnVnQ==
X-ME-Sender: <xms:0CX-Y595yClfSC8FTDB32tpGQTmOhovXHgJpcTdTqZNjE9k7VCXywQ>
    <xme:0CX-Y9u-KjByPcWsJDK0zqffVE9i0Ezg_uZDsk99Q4_FFiySydpeLBS1uOdDIRNsU
    wQYKfKM2jyq2Q>
X-ME-Received: <xmr:0CX-Y3Bd8Lww0-2ijuhhG_3CmOsGNIrHmtUb36gEdMLalHKMXQDOxiF9QH774eg1T5XC5TOcZ0FXjvuYmzGz4gIkMBB3pgpOXenaKg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudelfedgvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggugfgjsehtkeertddttdejnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpefgke
    ffieefieevkeelteejvdetvddtledugfdvhfetjeejieduledtfefffedvieenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:0CX-Y9fUbe7woC0PRHJCzAxnzYWDtWG4VRWyyGio8LBUAEL1H7v41Q>
    <xmx:0CX-Y-ONdBad4GrWyaMogJyiqr9gxbjdULEySwEZB4ZZv6YtGlRNrQ>
    <xmx:0CX-Y_n3RG-9hesfl1F3RmOCCbakQrLI7Scvvz_JlMzblwslJVusSA>
    <xmx:0SX-Y6CEU5T1QFyoU9dFN6Uoy09asRHTYN4NzAOOohbX2nllyjK7Rg>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 28 Feb 2023 11:03:27 -0500 (EST)
Date:   Tue, 28 Feb 2023 17:03:25 +0100
From:   Greg KH <greg@kroah.com>
To:     Sergio Paracuellos <sergio.paracuellos@gmail.com>
Cc:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        stable@vger.kernel.org, erkin.bozoglu@xeront.com
Subject: Re: Please apply efbc7bd90f60 to 5.15
Message-ID: <Y/4lzbkLITqAzUMR@kroah.com>
References: <f260225d-2a03-8d41-58d8-da278a790a95@arinc9.com>
 <CAMhs-H-zGy3Nde_pUPE4aFJgg81+QH2NERo7yBkjQEwB2g3vDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMhs-H-zGy3Nde_pUPE4aFJgg81+QH2NERo7yBkjQEwB2g3vDQ@mail.gmail.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 28, 2023 at 04:58:25PM +0100, Sergio Paracuellos wrote:
> Hi,
> 
> On Sat, Feb 11, 2023 at 4:55 PM Arınç ÜNAL <arinc.unal@arinc9.com> wrote:
> >
> > commit efbc7bd90f60c71b8e786ee767952bc22fc3666d upstream.
> >
> > Please apply ("staging: mt7621-dts: change palmbus address to lower
> > case") to 5.15. It solves the duplicate label error caused by the node
> > name being uppercase on gbpc1.dts, but lowercase on mt7621.dtsi.
> >
> > drivers/staging/mt7621-dts/gbpc1.dts:22.28-26.4: ERROR
> > (duplicate_label): /palmbus@1E000000: Duplicate label 'palmbus' on
> > /palmbus@1E000000 and /palmbus@1e000000
> > ERROR: Input tree has errors, aborting (use -f to force output)
> >
> > Arınç
> 
> It looks like this commit is not backported to 5.15 yet? I guess the
> mail got lost somewhere...

Sorry, didn't get to it yet, now queued up, thanks.

greg k-h
