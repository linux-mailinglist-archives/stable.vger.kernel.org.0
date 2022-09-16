Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB16F5BACAB
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 13:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbiIPLpq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 07:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbiIPLpo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 07:45:44 -0400
Received: from new2-smtp.messagingengine.com (new2-smtp.messagingengine.com [66.111.4.224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B1364E62B;
        Fri, 16 Sep 2022 04:45:41 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id A086A580A5C;
        Fri, 16 Sep 2022 07:45:39 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute3.internal (MEProxy); Fri, 16 Sep 2022 07:45:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1663328739; x=1663332339; bh=eM0zkrYKkb
        R1hHKUibwuksFexdGqU5ZZzCGObF1lj10=; b=aRC0gB+jlHnZIwJHvjm4H8il/A
        gXfQ7KHQTRCm52vJyltXqZYxZYeYdPKbby5RerDJ0Ox/lB+4hs6NIse59JY9WCvP
        /3peHYH8Uw1dMerZoJABUIbDYK4EJ2ylcydd109ofUXH90ncF6k1EqhZR5hrI3Xd
        0z5g3jIEGTSKAOjHlCGn00kUg3EQ7M5X3DShg9Q2MKMYjibk3+yeOunpR3LpQY2d
        rsDSjqt8Ge1AYvivgckhDRTMH/bfOLa/GrfHyhprKTctqfIyN8YkliDRcetqbP63
        R5lbQ0usBF8lCF+Ow+uKBzvQFYCvoKZyNnq4/KQ/jUtdUoGB8tpOpLtTGGJg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1663328739; x=1663332339; bh=eM0zkrYKkbR1hHKUibwuksFexdGq
        U5ZZzCGObF1lj10=; b=CWVkr1e0IseTqGS4lGkkC4NJjvyK6Hz35gN9o1vvIThM
        z7cMxLTIQMl3fqFyieZHHtnQ2hhifyzAsts+OBE3MGWRbTJZk4I0K/5g9sj7cQIo
        iFThSIXeVRmqXP8QAoSP96+OaTzAEVaZ5TGVfAnIztSuMaD5cMvXuDo25Mr7x9ro
        hlI3iG3UgRgInMh+OnoKJI/C9ShWhvgVtT1WB6ihrVSOUC3bKgdsBUzhzx2Nofan
        agTudrwcnw3m7dLeD9sthMwwWUo6Qf5xTOvCwpqBJRkhA8zOnQoUVdf+QhUuafLU
        qpvcnGb/ATs8FNOSmJKfNAAbuPMp9EwbDEqQrgawsw==
X-ME-Sender: <xms:42EkYy4BoFbsuqGxgexhyDOd8zPHx1pF9aL4VVxi5aH443HTmpnnnA>
    <xme:42EkY77wjeXNDFm0ZaZrteGP0LrB7X2exmSC2_L2ynSnP6WIQJXLOb4nalNk7wcH6
    MQz9fLQLFCuE8qTBac>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfedvtddggeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhepffehueegteeihfegtefhjefgtdeugfegjeelheejueethfefgeeghfektdek
    teffnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:42EkYxeNQu5wtCN-yTKSohy42A2Q7ZTnCtzjLODiDkQceW4cT7UfrA>
    <xmx:42EkY_IoMIWXfhzVi3LUl2Za_sVqfJreBElPWnwKZpHFip4BIzhFGw>
    <xmx:42EkY2KfptFlhY08pbiyzM12U0JquQRMmDb79jmaO-nhX_dg4jLInA>
    <xmx:42EkY1_pGspje9SQ6daHcyZbVpK1E6VzQgLzC30aJmUk0EWq5d66Ng>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 183F5B60086; Fri, 16 Sep 2022 07:45:39 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-935-ge4ccd4c47b-fm-20220914.001-ge4ccd4c4
Mime-Version: 1.0
Message-Id: <c243fd70-782c-4663-b08d-99f44ae55fc3@www.fastmail.com>
In-Reply-To: <632455db.df0a0220.9684.aafc@mx.google.com>
References: <20220916001038.11147-1-ansuelsmth@gmail.com>
 <4dcb0e76-b965-42da-b637-751d2f8e1c51@www.fastmail.com>
 <632455db.df0a0220.9684.aafc@mx.google.com>
Date:   Fri, 16 Sep 2022 13:45:17 +0200
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Christian Marangi" <ansuelsmth@gmail.com>
Cc:     "Manivannan Sadhasivam" <mani@kernel.org>,
        "Miquel Raynal" <miquel.raynal@bootlin.com>,
        "Richard Weinberger" <richard@nod.at>,
        "Vignesh Raghavendra" <vigneshr@ti.com>,
        "Vinod Koul" <vkoul@kernel.org>, "Mark Brown" <broonie@kernel.org>,
        linux-mtd@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mtd: nand: raw: qcom_nandc: handle error pointer from adm
 prep_slave_sg
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 16, 2022, at 5:11 AM, Christian Marangi wrote:
> On Fri, Sep 16, 2022 at 11:01:11AM +0200, Arnd Bergmann wrote:
>
> Thanks for the review and the clarification!
> (Also extra point the fixes tag will match the driver)

Regarding the fixes tag, how did you actually get to my patch?
While it's possible that it caused the regression, it did not
introduce the ERR_PTR() usage that was already there in
5c9f8c2dbdbe ("dmaengine: qcom: Add ADM driver").

Maybe there is another bug that needs to be addressed in this
driver?

      Arnd
