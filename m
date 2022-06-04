Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 917C353D659
	for <lists+stable@lfdr.de>; Sat,  4 Jun 2022 12:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234522AbiFDKBV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Jun 2022 06:01:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232888AbiFDKBV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Jun 2022 06:01:21 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A2A125EAC
        for <stable@vger.kernel.org>; Sat,  4 Jun 2022 03:01:20 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id AF12A5C00FF;
        Sat,  4 Jun 2022 06:01:19 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Sat, 04 Jun 2022 06:01:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1654336879; x=1654423279; bh=h0LFWV5cCs
        MmmSyNqrcx65G9D+AAK0uLBFS0ncxarXU=; b=KE4/HHLs0U7h/UMa/XGQm//49v
        0uVqm/D1C4CaTWafRWKkCeW3mepy2U769bnsLwUb7Bh7nKOsN6gq/Dkz4+iWBFPZ
        PTqwUBhjaBF/Tsx2l0WajFR/5msNhRcNZZsfcvXSp3JCdDyTZ8MXVCRQyBVSPLdE
        uenZkJtoIyyzkpUXVGJwf7kZLII+XJ+qhZcM/VeBlBGovPfVVQ0aYgzvqPCPfDsy
        aWQUW50e8gSCuyNf02mK8LdUbDz0BGcXtv+x5WHeAjXsmiI40xoKOMCPM/Gn0+UD
        diZfbwsK2E8U9kbQI8swpLziKtlXdzFEHgLY8vtbTbqhgXHEVVrRtaLrlEfA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1654336879; x=1654423279; bh=h0LFWV5cCsMmmSyNqrcx65G9D+AA
        K0uLBFS0ncxarXU=; b=nj0rw+fFZ4ecEMTSovCmiY53wVNcpQ5IEFb+QS203/NA
        buvHiP735+EEHhmuL9yVSsS7Ag4VcJq8ICB83IS5feeKG5c8bKKU6uIwVATxlR4d
        7Zd/T3PBXfcHC1s85pPvQk8z9ie6daJ8lmtrTtxhdrsiI4NUUuNZds/g+LFh9Lk1
        DUjcopXLbbg9FxSa6++U61Z0Eo0KW9E0QX6G8mjK3dfg4iuJiSXFGupZU5LdFg47
        CJSCiZXyxG0ZZW9R/S5o8CcEpOGAEoYWxGj4NJTGW+MSLTZ/krrMstI2t5sM3I+j
        jtNm+K5IUNBG0BbSthW2ZPMn5WhiTcgMGTF9uABh8A==
X-ME-Sender: <xms:by2bYqISMEFJzVRkhjFmRZZhKHbDsXdkD92EgEv9RvbG_xbQ9yyF1A>
    <xme:by2bYiKXg-MlD6u9TFlYb5mOD8v7zGjhEo_ZpnBQMB7qjwNOTTNJz8Wcwxq17pNHZ
    6ubcj-X0kS-sw>
X-ME-Received: <xmr:by2bYqs9iN_4Ft37TLVsW8FQ9oOkFyCcglAgxpFyEVs62m9V6iWz-mcO7-oHy_aBSggixc3ASCxoJ0_qAdJJXzM5FXpJLPIR>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrleekgddvvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeehgedvve
    dvleejuefgtdduudfhkeeltdeihfevjeekjeeuhfdtueefhffgheekteenucevlhhushht
    vghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:by2bYvZP8fyL7dHm-wfbFBgE_eGrnqUiMK3aPUgP2P5GoAy-lOLAhA>
    <xmx:by2bYhbUocf8VkNtW7F6VkH4Ufs714wn1LqGlZflhsNC9WTYEju5nA>
    <xmx:by2bYrCtoX1K_X8IeXoN-NSYw_sEFIHV5NtZMfA59WkTSyfaQ_tVUw>
    <xmx:by2bYgUtmTgD5PC1uD3lgeMjPW4TsXdhdjZriky6eD6GN324fI-oCw>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 4 Jun 2022 06:01:18 -0400 (EDT)
Date:   Sat, 4 Jun 2022 12:01:17 +0200
From:   Greg KH <greg@kroah.com>
To:     Wang Yugui <wangyugui@e16-tech.com>
Cc:     stable@vger.kernel.org, Yuezhang.Mo@sony.com
Subject: Re: drop
 'exfat-fix-referencing-wrong-parent-directory-information-after-renaming.patch'
 please
Message-ID: <YpstbdUo+TNhSU1B@kroah.com>
References: <20220604091001.D570.409509F4@e16-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220604091001.D570.409509F4@e16-tech.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jun 04, 2022 at 09:10:02AM +0800, Wang Yugui wrote:
> Hi,
> 
> drop 'exfat-fix-referencing-wrong-parent-directory-information-after-renaming.patch' please.
> 
> When this patch is applied, the flowing xfstests/exfat become to fail.
> - generic/011
> - generic/013
> - generic/028
> - generic/035
> and more.

Is there a fix for this in Linus's tree as well?

I'll go drop this from the stable trees now, thanks.

greg k-h
