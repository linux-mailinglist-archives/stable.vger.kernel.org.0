Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F89F2A4B07
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 17:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728052AbgKCQUR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 11:20:17 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:59987 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727479AbgKCQUQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 11:20:16 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 181A2E09;
        Tue,  3 Nov 2020 11:20:16 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 11:20:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=hNhhGHGmAdlhsMrMsBrqmasyBbF
        QuMccFCHga35TAXM=; b=Ads0pJ1D74q1lkp7igry92EoEcgg/NMEhBMAOB6wwg6
        u/L+OrZtd6OVvUAl5VbMGLtI/UjVnDLLNu1QSuDsbhhQNj7poMpto+s55wf6kzxy
        NdTS5upHm1aZPlew/G8sEuSX8eScaeXyBenn0ty5I6FLbkQ/Wu/ppUa4vshXtqnK
        87eFz32N5G4amxvbOEhN9iuvA3ejaQOoV5OYtJeCZVZsqdzKc9kWgleSAxKuE3s4
        GmHXXr10ISqy7P7ElJ2ZUw7fcwLyPFEzRABRF/z9Q06b5PvG3us7Esl/Nl6xnB5i
        fUknPe4nLAz1bzRENpG9RR7Qw5Dx98bIBivS6lktEbg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=hNhhGH
        GmAdlhsMrMsBrqmasyBbFQuMccFCHga35TAXM=; b=OK3eSZ95txA+/VLRJFXXTj
        Xo90CkCItD6udt9kLxh03vIQXEf6ZWE5OsRms7oCEVGo3gZgvIrfU6owhoeXIfJQ
        rPRhnCIOSk7HvhH6iNGXrg8LUQRGfk/zNEITvhSQQvMpfgt5AGgpzcYghMxdJDND
        BdtkiOu/l9zTUmtxFQ/zxs0TsxxscGWUKmPxH+jUZD/W8zcsE+lFk/OtlJ2Qtobx
        oa0Qt2HYyDJAPReq6IiyjCeSnFQlplx5K9e0DPVI3SjFnGcBt9Jy7SCjGHUsa9PJ
        MOY09m8K5NN8cfgPmjJ04RipPRtXI2jBMJ/ZskJdlQSIfexLP5RBm70prajZZIuw
        ==
X-ME-Sender: <xms:P4OhX-hfd1LBG6mCIlWLwIIe2abeuS1nLZQhhaExrNeqHsN3VoXWTg>
    <xme:P4OhX_Bh1D4IpAMpXRF17f3hUFoxRc9YLaFkKiEAxlk3NzSlaaYLOBHfI56OMGzj2
    7MpMcteaqXuyg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgkeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:P4OhX2GrC_HZv0u6U7nEOTRiG2kSb8r2M1NYvM_lOYH5i4YbV78c8Q>
    <xmx:P4OhX3SKQH6xdZr5oJCA3qS5KanC_VudhKn-I4jaRyTQIRjl_UfvxA>
    <xmx:P4OhX7zvEjXt_A92l3qymZhD8JzkkuzFAlB27nNpF_9MwOk7VfFR-g>
    <xmx:P4OhX8viqKlsNyM6pAw1pnLAdO3tWKryZEkGskSKG7wO_0bgO1ZjGQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3148A306468E;
        Tue,  3 Nov 2020 11:20:15 -0500 (EST)
Date:   Tue, 3 Nov 2020 17:21:08 +0100
From:   Greg KH <greg@kroah.com>
To:     Juergen Gross <jgross@suse.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2 00/13] Backport of patch series for stable 5.4 branch
Message-ID: <20201103162108.GA80864@kroah.com>
References: <20201103141321.20346-1-jgross@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201103141321.20346-1-jgross@suse.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 03, 2020 at 03:13:08PM +0100, Juergen Gross wrote:
> V2: correct first patch

patch 1 updated
