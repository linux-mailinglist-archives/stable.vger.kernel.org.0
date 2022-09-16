Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3405BA908
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 11:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbiIPJKw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 05:10:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230181AbiIPJKu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 05:10:50 -0400
X-Greylist: delayed 555 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 16 Sep 2022 02:10:49 PDT
Received: from new3-smtp.messagingengine.com (new3-smtp.messagingengine.com [66.111.4.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 672535C362;
        Fri, 16 Sep 2022 02:10:48 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 916DE580E9B;
        Fri, 16 Sep 2022 05:01:32 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute3.internal (MEProxy); Fri, 16 Sep 2022 05:01:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1663318892; x=1663322492; bh=eSy6TVmDPq
        cwPJ8Iryb7Xwdk6oM2vvcqIdcjswH4P9E=; b=rHo2dTf9SE9S0gj2sOVe8pVO0W
        Td7NhKdEevcRMSDxrlt5f6VZe80+19QkGriim8Fmm6LnbygI6ZZlbqmXF562LBK/
        0RlGKgsVwYBRMFQfSYn6mu/yXAv7+PGopEYhS0kdjBDCR6koWscqVFJbqhfJaFD9
        eTr1x7iI2tcXcAvVVYKlHK3BOfCeurroaxfrSFGsKecX6j6L+kNKbzF4E/9kYNcc
        EtBzTcyPTiieH3falT3odzwFJflCJRGX+1WkFUE0eMWiaIWYOYssobHpWxbhHzMi
        IuIDW39V4eJmcivJzq8bZ+ij/N+mVSTk8IWTYIkq1Z+Kz8hPWpy/Pq+VTCXw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1663318892; x=1663322492; bh=eSy6TVmDPqcwPJ8Iryb7Xwdk6oM2
        vvcqIdcjswH4P9E=; b=rYMcLawC1WVkZQ5ZsW2j7sIZ7s2vguyxJM6ld7kKlR1o
        O3igcFxjFQ9aQ+XQH5sV3A7mw1uTWU6slKTdbBmXIGBs725N/yVP5DMR/vXS4Psp
        kG8iNsh0q2wqBe6FX83eGCCLZdZxn0jddAgIGuOuxTljuz5XMLbJR65jlGtnf7yD
        y22IS59O3cvlQVxXJ0s8TDNMhE+TDJBVtZ/aJHVzt/7BI5FkEcqbsfBzn9reOtFz
        r8/w4irSp0HGH5jban+7wZauToQ3uRRt/WeXKg8Gxz/X32L33nsSrHxT3FVfJdof
        Tc+VK5S51J43zho/10TtaTLW/fYTnf+51hICEdiEFA==
X-ME-Sender: <xms:bDskYzJ8ujs6qb8cpws1p2sQdxdIUNBVebt7AGW8awR-x1TPHGMwaA>
    <xme:bDskY3LpCRzh8rHB-CiHP6350nPWwIqjnZqjbL5rVMLqf_z_LRVU4L_dmpc77rMpL
    N1bB1bu0us_ErcE71I>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfedvtddguddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhepffehueegteeihfegtefhjefgtdeugfegjeelheejueethfefgeeghfektdek
    teffnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:bDskY7spbeCsSuJuDUkb7m3M8dfKgweKqqDMsV4lMlElBnxGZxTY9g>
    <xmx:bDskY8YyQImQsG7U0ohA7BcYMs6KtM05Ap7DIzCnvrcc30Htx7JtJA>
    <xmx:bDskY6ZGv9z8vadTzXkJtkoIExr5VRBYMZ6rhHNCBUaMlUbLGOIAxg>
    <xmx:bDskYwP3dRa-ntBz4APv2sLSWGgP6GwdMsyCVym_q3hR00_zoQxASw>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 274D0B60086; Fri, 16 Sep 2022 05:01:32 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-935-ge4ccd4c47b-fm-20220914.001-ge4ccd4c4
Mime-Version: 1.0
Message-Id: <4dcb0e76-b965-42da-b637-751d2f8e1c51@www.fastmail.com>
In-Reply-To: <20220916001038.11147-1-ansuelsmth@gmail.com>
References: <20220916001038.11147-1-ansuelsmth@gmail.com>
Date:   Fri, 16 Sep 2022 11:01:11 +0200
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Christian Marangi" <ansuelsmth@gmail.com>,
        "Manivannan Sadhasivam" <mani@kernel.org>,
        "Miquel Raynal" <miquel.raynal@bootlin.com>,
        "Richard Weinberger" <richard@nod.at>,
        "Vignesh Raghavendra" <vigneshr@ti.com>,
        "Vinod Koul" <vkoul@kernel.org>, "Mark Brown" <broonie@kernel.org>,
        linux-mtd@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] mtd: nand: raw: qcom_nandc: handle error pointer from adm
 prep_slave_sg
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 16, 2022, at 2:10 AM, Christian Marangi wrote:
> ADM dma engine has changed to also provide error pointer instaed of
> plain NULL pointer on invalid configuration of prep_slave_sg function.
> Currently this is not handled and an error pointer is detected as a
> valid dma_desc. This cause kernel panic as the driver doesn't fail
> with an invalid dma engine configuration.
>
> Correctly handle this case by checking if dma_desc is NULL or IS_ERR.

Using IS_ERR_OR_NULL() is almost never a correct solution. I think
in this case the problem is the adm_prep_slave_sg() function
that returns an invalid error code.

While error pointers are often better than NULL pointers for
passing information to the caller, a driver can't just change
the calling conventions on its own. If we want to change
the dmaengine_prep_slave_sg() API, I would suggest coming
up with a new name for a replacement interface that uses
error pointers instead of NULL first, and then changing
all callers to the new interface.

       Arnd
