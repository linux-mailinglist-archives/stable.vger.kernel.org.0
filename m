Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0D26A5EE5
	for <lists+stable@lfdr.de>; Tue, 28 Feb 2023 19:41:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbjB1Sla (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Feb 2023 13:41:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbjB1Sl3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Feb 2023 13:41:29 -0500
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E85423657
        for <stable@vger.kernel.org>; Tue, 28 Feb 2023 10:41:29 -0800 (PST)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id C3D355C00B5;
        Tue, 28 Feb 2023 13:41:26 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 28 Feb 2023 13:41:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; t=1677609686; x=
        1677696086; bh=G1vnL45eHH/4Xvh4DJyxo8geS2ZNKD9HU+pu4UhnnWY=; b=k
        38IRtY93qWoSxA46vc/Q0Jw0KCgOvA80t3eNwBSFA86wtGP1t0vGCFArY9Gdvyt2
        SKQyJmlch7JHf9xMIqhvUzhblNJ7/BTpjLyQFHsSGUfITH21aQqQZUrlxpFj/XSM
        i8PKIpxikIeg5VKEWuz/SCnGkxRhzjtZAGN9aFGKKFRQJbCRBPpmBET8GFew0cdc
        3Fidm6cJKVDghq9mtP8pXvSTuXZ9p2XmVbOkBaq3w6d/Kmj2Qv2DGGvhMLDnB37N
        cP8ZIfV6U5vwaO7keVHETpxilzDfttm6416KrPpJ5qRgC9YXpfEi0SaaTZwCH3Wz
        TH3uUSHq6ucDT82YmVxMg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1677609686; x=
        1677696086; bh=G1vnL45eHH/4Xvh4DJyxo8geS2ZNKD9HU+pu4UhnnWY=; b=T
        9RSA8ytqF7Mir0RRmGhR4DFoO3n4JuErw4hytf/iWEubBWhlrp7pUJjRWCLlhCcQ
        grnDxpSacbLQvmWi9wfb4JCk1o8vrRiqNYtH7ej9PfT2Chb9iHN+cpg2STNHE+uk
        BAklcdIqLAAE/xByNL0C6WolFL6dV1Ly5q1iLDyAcjjZpLHb9784SDPT9ZyHmrxk
        9jCdgTeh/1ycgx6glC7qTQYq+Q9y3V2xZBSccCvim2t8ugIabTD88jLh6ZdLcnil
        lVCPWRAxdNKHNo4TN6Ji8ys1bidh+nDdX7MAi1j3maZVti2bpnh6PPwh85VqonjK
        5B6DmTYg3jnaLv41MyP+A==
X-ME-Sender: <xms:1kr-Y-SvQ8LvR-S2qAvfHkE47lzvz47zaNPR1bhFhmx0fq-va6GnEQ>
    <xme:1kr-YzzY_qyqMAo-Pz4USBqIDFc7_E07c61J4s_xNwKTrSE_d6elqkvfBEayRW3Q2
    3YStYlHNB--aw>
X-ME-Received: <xmr:1kr-Y71RePUzb8wewtxAezYd7yhJ1vyDVSCKmu7mwOtsPIFo7IqskckFNPB5Tu4vHg-GRtqFgv1bgE2MQDh9wbNDu8Q2okepKZjsrg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudelfedgheefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggugfgjsehtkeertddttdejnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpefgke
    ffieefieevkeelteejvdetvddtledugfdvhfetjeejieduledtfefffedvieenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:1kr-Y6AHyiKkSoftnCBpzgnHZiF-sA4Q1Z2plMeFiFzPpnWL5qXBvw>
    <xmx:1kr-Y3jDolbb3E3H9S5QhM5QcBxLKcjHLnnrpE8H8Cq6RmjGtrD8WQ>
    <xmx:1kr-Y2qmceIsHCectEoiBz11HAvMhA1SKuqSeDgkAIUggYdQqJNHjQ>
    <xmx:1kr-Y3eky8-DbhgYarijrdn9B2bEZybjRL4E6WUZhqEFUQE_Jb-1wg>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 28 Feb 2023 13:41:26 -0500 (EST)
Date:   Tue, 28 Feb 2023 19:41:23 +0100
From:   Greg KH <greg@kroah.com>
To:     "Limonciello, Mario" <mario.limonciello@amd.com>
Cc:     Stable <stable@vger.kernel.org>,
        "Wang, Chao-kai (Stylon)" <Stylon.Wang@amd.com>
Subject: Re: USB4 DPIA fixups for 6.1.y/6.2
Message-ID: <Y/5K04GK2SfZ+4xu@kroah.com>
References: <9694aea7-5019-f446-3795-a5cfbe2a634e@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9694aea7-5019-f446-3795-a5cfbe2a634e@amd.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 27, 2023 at 10:35:44PM -0600, Limonciello, Mario wrote:
> Hi,
> 
> The following two commits help with initialization of DPIA which is used for
> DP tunneling over USB4 within amdgpu.
> 
> Needed for both 6.1.y and 6.2.y:
> ead08b95fa50 ("drm/amd/display: Fix race condition in DPIA AUX transfer")
> 0cf8307adbc6 ("drm/amd/display: Properly reuse completion structure")
> 
> Needed just for 6.2:
> 0cf8307adbc6 ("drm/amd/display: Properly reuse completion structure")
> 
> 0cf8307adbc6  was actually already tagged to go stable but it doesn’t apply
> cleanly to 6.1.y
> because of the above mentioned dependency so it didn’t come back.
> 
> Can you please bring them back as requested above?

All now queued up, thanks

greg k-h
