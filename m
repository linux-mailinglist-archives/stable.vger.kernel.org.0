Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E695763F9CA
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 22:28:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbiLAV2C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 16:28:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbiLAV2A (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 16:28:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFDA7442F1
        for <stable@vger.kernel.org>; Thu,  1 Dec 2022 13:27:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7BCE5B81F90
        for <stable@vger.kernel.org>; Thu,  1 Dec 2022 21:27:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB88FC433B5;
        Thu,  1 Dec 2022 21:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669930077;
        bh=+DN+P/rKB/9tSIZAc6i0bxDS167JyMagYuQTQ8imLrI=;
        h=In-Reply-To:References:Date:From:To:Cc:Subject:From;
        b=HWIMBRMTvgpa4xRBLIH019mTRMLpYqyOsNDlenKP2X9VnV1T0JX7kK+6EKzfFTi2k
         jQxH0o/xhvjFFPUd4siCgjEOfFavIDyf1D4hbzF024Uz9TxR/iexqBwgUoXQgG5NED
         yeWwFuS8AJ9UENypjQ3w4fbe9bGVxopeZCs9thxWFWqP6frhM7AlAP+itHm28TefoL
         ZBLHCjTdoz9A2aAO81S57nxvWf+oBPhXh/4K9CxW1FP9IwnGVSe9hj9ndOSbno9se5
         i9c38SxL4GVJq2M+Kthu06InSUX85IiXI2nHMib8qTanAj43R9Og85lp0yMQ9XIZml
         vYUGtCZaLHxvQ==
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailauth.nyi.internal (Postfix) with ESMTP id 8A80727C0054;
        Thu,  1 Dec 2022 16:27:55 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Thu, 01 Dec 2022 16:27:55 -0500
X-ME-Sender: <xms:WhyJY56bY9F_MYFxv7DaioKPBJHJxAo0Fv98h9FAnoD_QfY89srmBA>
    <xme:WhyJY25S12Ycs-orXZS5gVWcTnneBahCIouBH5bKrpPz_0xCSU7M-VYtRlImKMbjM
    6dJs_nLem9NhUmhlzU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrtdehgdduhedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusehkvghrnhgvlhdrohhrgheqnecuggftrf
    grthhtvghrnhepvdeviefgtedugeevieelvdfgveeuvdfgteegfeeiieejjeffgeeghedu
    gedtveehnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    eprghrnhguodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduvdekhedujedt
    vdegqddvkeejtddtvdeigedqrghrnhgupeepkhgvrhhnvghlrdhorhhgsegrrhhnuggsrd
    guvg
X-ME-Proxy: <xmx:WhyJYwdFhZYwNTJEhjA3iEa-0lKweK4UrtEn7GUmniukcOgyJrrWpA>
    <xmx:WhyJYyIaGsyihW68Uz2LeO1u-ncg-PKppdRDl1e0bZlBmqR6C3NA2w>
    <xmx:WhyJY9JwMyoeO3Z661IObk96bEKAtdmHD6O9TT3p157Vql2qf5o4iw>
    <xmx:WxyJY6FVIpHTCYek0JcdB1j1xlCUc9smfmHtm_cu792257_b04rcIA>
Feedback-ID: i36794607:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id E3357B60086; Thu,  1 Dec 2022 16:27:54 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-1115-g8b801eadce-fm-20221102.001-g8b801ead
Mime-Version: 1.0
Message-Id: <c88afa91-72a9-4905-a710-90655f97831d@app.fastmail.com>
In-Reply-To: <7e5f86c0-04b3-aa68-565a-7b86f1e1553d@infradead.org>
References: <20221201204310.142039-1-arnd@kernel.org>
 <7e5f86c0-04b3-aa68-565a-7b86f1e1553d@infradead.org>
Date:   Thu, 01 Dec 2022 22:27:34 +0100
From:   "Arnd Bergmann" <arnd@kernel.org>
To:     "Randy Dunlap" <rdunlap@infradead.org>,
        "Damien Le Moal" <damien.lemoal@opensource.wdc.com>
Cc:     linux-kernel@vger.kernel.org, "Arnd Bergmann" <arnd@arndb.de>,
        "Luis Machado" <luis.machado@arm.com>, linux-ide@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] ata: ahci: fix enum constants for gcc-13
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 1, 2022, at 21:48, Randy Dunlap wrote:
> On 12/1/22 12:43, Arnd Bergmann wrote:
>> From: Arnd Bergmann <arnd@arndb.de>
>> 
>> gcc-13 slightly changes the type of constant expressions that are deifined
>
>                                                                     defined

fixed

>> ---
>>  drivers/ata/ahci.h | 234 ++++++++++++++++++++++-----------------------
>>  1 file changed, 117 insertions(+), 117 deletions(-)
>
> What #include <linux/bits.h> ?
> or is it just done indirectly?

Good point. It survived a build test, and it's one of the headers that
is almost always included from somewhere, but you are correct that
there should be an explicit include here as well.

I also found that PORT_CMD_ICC_MASK is still a negative number
that needs to be changed:

@@ -178,10 +178,10 @@ enum {
        PORT_CMD_SPIN_UP        = BIT(1),  /* Spin up device */
        PORT_CMD_START          = BIT(0),  /* Enable port DMA engine */
 
-       PORT_CMD_ICC_MASK       = (0xf << 28), /* i/f ICC state mask */
-       PORT_CMD_ICC_ACTIVE     = (0x1 << 28), /* Put i/f in active state */
-       PORT_CMD_ICC_PARTIAL    = (0x2 << 28), /* Put i/f in partial state */
-       PORT_CMD_ICC_SLUMBER    = (0x6 << 28), /* Put i/f in slumber state */
+       PORT_CMD_ICC_MASK       = (0xfu << 28), /* i/f ICC state mask */
+       PORT_CMD_ICC_ACTIVE     = (0x1u << 28), /* Put i/f in active state */
+       PORT_CMD_ICC_PARTIAL    = (0x2u << 28), /* Put i/f in partial state */
+       PORT_CMD_ICC_SLUMBER    = (0x6u << 28), /* Put i/f in slumber state */
 
        /* PORT_CMD capabilities mask */
        PORT_CMD_CAP            = PORT_CMD_HPCP | PORT_CMD_MPSP |


I've addressed all three issues now, will send a v2 after Luis is
able to validate that this fixes the problem.

    Arnd
