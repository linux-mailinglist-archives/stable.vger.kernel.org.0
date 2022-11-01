Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 613416143FC
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 05:50:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbiKAEuk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 00:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiKAEuj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 00:50:39 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0283A17420
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 21:50:37 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 880AC5C01A7;
        Tue,  1 Nov 2022 00:50:33 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 01 Nov 2022 00:50:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1667278233; x=1667364633; bh=necyt3nwDL
        vTwl9KKoA02pBpRH0x3ywJDFpNKq7tjOE=; b=oSRf/RbYvWYu9RrUKx0bGcZtB+
        iAR5ckk8RZDRTmaIwstpioP6uU6ia1pibTqgkzykyRMx+8dxJOAkRmr7Phzk2Rlp
        wFW2cK4XsQG0/qBqwmAow8/AGo05cLRhObxfawl2x5Ie/HS7/oeVBjBjHSQsCo2d
        jqyYxtka/fkLtBSXzrTkkXjJt+/RoSLDctiYAh7KC2rnYRA/MMNPKRRl/2vk2roM
        Hq+n6S+UITWrakErggrJ5P+s3haeB41ur5OS6FX9xdfRyxt/MaGT6byEz/kzcxS8
        3Xhsl2w7wIMHkngw/5QboNBQI6/Cf14wH3P0w8OYiL2tx8lSqE3hFxIalonw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1667278233; x=1667364633; bh=necyt3nwDLvTwl9KKoA02pBpRH0x
        3ywJDFpNKq7tjOE=; b=bleGiVas/AE9N+s4B/vKbCc2kNL4sf/xk7v3RaMdJ72J
        N0Dzrz7HEzqK8/TUfWiKMhTSb+5SSeLhaYjXDT87TFKMvpn+8XiYp60PNxJeazAN
        /wyTuz8KEw7IrfQCtmFSkeQbCa+8m+fEV3P04Ujxgo7MBM/rgyFQsLq9NLoHnwgL
        dO2vWaWInkoD6H3/7e+s+3vOcaYyqSi+uh1Xg8PTX2mMRYhzOYEPHNIdWT+icU8P
        xYtdtvJ6PakRHY+DAtCoNYxbUUzOcZS7QgV6QwrP7/UFApc1kjCVcu9fj4BTlcxr
        nvmPSM+KF/7id69KAtL2tiBtrUv/ZshTgqjkfoTyBA==
X-ME-Sender: <xms:mKVgYw3cEDXA7c0eeJcXRt5TJKvf2QkSCt7C5opvHFdG4ZK0TGb_mg>
    <xme:mKVgY7F70ydfNDQSMisRdBPQdBKC4N1zIT4tT__C81kTJbiV-S-G4osWG_4mvAIy_
    XwjqeaV-Ip_NA>
X-ME-Received: <xmr:mKVgY44IuXIQ0Dzvvt7p5Jz7ek6rF7glBTPus622YulrZNPQNFaI8HmG7j3jlw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrudeggdejkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeehgedvve
    dvleejuefgtdduudfhkeeltdeihfevjeekjeeuhfdtueefhffgheekteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:maVgY52kQ2KySRRhKRPFIOe-lEPwZoDASnLbndloJK6DlBbLxiJc0w>
    <xmx:maVgYzHpsb_as2JF92Fn7Cbjyhx6pqWRq2Akhrua8cteYxdJc9tERw>
    <xmx:maVgYy_sVG7q1WRei0XjYAP_qdE1I_tYcKLHGnJTmo2pLxsEXvX6rA>
    <xmx:maVgY4SLpBWPpxtwcwG3a2QkkzjfDfA9t_e6883s53eAy5GsFhUgyg>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 1 Nov 2022 00:50:30 -0400 (EDT)
Date:   Tue, 1 Nov 2022 05:51:21 +0100
From:   Greg KH <greg@kroah.com>
To:     Nils Freydank <nils.freydank@posteo.de>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] platform/x86/amd: pmc: remove CONFIG_DEBUG_FS checks
Message-ID: <Y2ClyVc7J0g6pdFS@kroah.com>
References: <20221031223652.17717-1-nils.freydank@posteo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221031223652.17717-1-nils.freydank@posteo.de>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 31, 2022 at 10:36:53PM +0000, Nils Freydank wrote:
> commit b37fe34c83099ba5105115f8287c5546af1f0a05 upstream.
> 
> This fixes a compilation bug introduced in commit
> e9847175b266f12365160e124a207907da3dbe8e (platform/x86/amd: pmc: Read SMU
> version during suspend on Cezanne systems).
> 
> Signed-off-by: Nils Freydank <nils.freydank@posteo.de>
> ---
> 
>  Backport patch applies and compiles with linux 6.0.6.

This is already in the 6.0.y queue, but thanks for sending it again.

Next time, be sure you keep the original changelog text _AND_ authorship
and signed-off-by lines, and cc: those developers as well.  Stripping
that off is a bit rude of them, don't you think?

thanks,

greg k-h
