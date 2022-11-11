Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FFDE625685
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 10:21:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232749AbiKKJVv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Nov 2022 04:21:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233280AbiKKJVu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Nov 2022 04:21:50 -0500
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EA3F663C3;
        Fri, 11 Nov 2022 01:21:49 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id A458C5C00E3;
        Fri, 11 Nov 2022 04:21:48 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute3.internal (MEProxy); Fri, 11 Nov 2022 04:21:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1668158508; x=1668244908; bh=BHZ1+VScMm
        25ZZpPefjngCwhunJO9ptSzHXuSUCXbV4=; b=CDsu9knAdSvGuue23k7UkZuRfV
        9Qad3FfgK9QBi2uiUA8Slanyd0mmmCowwqOCcpG6PuB0MuGDvfkaeEo7K7P2pVtU
        z1w9a3WpmQZXCx5YxFLCGuW/w8kXnADU/xumuBh/ZZCPE66f554K44bKzjO1wPIa
        wpmHMYndwCuzIzdRxe1bqNr96ilY+6OMRM90V4x0xzErWvpEeSBS+NEu8iYdmvVL
        2AwFJqbzuCXVeYXOGkeaMlFG0qfG33oyTiDDaK/7C80lgcnmI8J7QVUnpSk0KhFJ
        Plu+5GFZ7BKFOUj66MpyTRw455FZMfjFHTDZPwN4N5nCQWIX7i0Rg96C/plA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1668158508; x=1668244908; bh=BHZ1+VScMm25ZZpPefjngCwhunJO
        9ptSzHXuSUCXbV4=; b=whLsfJipd5vH9PCsrI7T27DSaN+TGRe7gywgMxK7A/mr
        Ai2QKtPx4Y2qwiRTqjdIB1H028+gz1klnTSs0oAvWcmARYQkCCxKdTh0xueyhl5V
        avs0wjxWpe9oWD2XWfFTBaJ6237mCa+FeLs4QDIAyedliU8oCyvIydje+7N4fU3Z
        cK6MtLBIb7h6lPhnIxtQPAYeflmnaU9Utja0TXkXEalSJ+3zb9DWQVnRg5H231G+
        4kz3kKXpDTh40SarPgztBalUwUfoSfhNxY5WYygDmlztHA9uGfCr+CuSKIr3r8ue
        e2faTV/Zs4BpGIocUpk5LzqB7frNCTV2iFZ+LgruOg==
X-ME-Sender: <xms:LBRuY8HmgMjX-_RfULz5PhckA63R-IEmq_TsmigwMcbAIbu4ibpTUQ>
    <xme:LBRuY1XCFY72y7lSwDsS2BI1OkA8_BHlAY6E49rPwsf8FZrk9PNOu15mM-gPhz8q3
    xCNjb1ELgjsRokh5zE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrfeeigddtfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdetrhhn
    ugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrghtth
    gvrhhnpeffheeugeetiefhgeethfejgfdtuefggeejleehjeeutefhfeeggefhkedtkeet
    ffenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrh
    hnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:LBRuY2J0mN8hOJKz7ftOsvoOnOfUPh1h2sVr2pzpKDlLXi0mSb2GqA>
    <xmx:LBRuY-EFtbcaakgIyqgSJiQWFWKe2uuXJNhZ7CzWBCR2nyUYbhO4Gg>
    <xmx:LBRuYyVrC6E7DDk4rpEG5-Dr-nixFPL_9NJXLoxxTQXpAHp7Vt5Axg>
    <xmx:LBRuY2o5taqLxrr3bItx11onqOLqUvcmX3xDh7oG2Q4BX-nISP-AuA>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 7576BB60086; Fri, 11 Nov 2022 04:21:48 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-1115-g8b801eadce-fm-20221102.001-g8b801ead
Mime-Version: 1.0
Message-Id: <8affcbf6-d3f5-4eb8-9a12-302f881dae98@app.fastmail.com>
In-Reply-To: <CAKdAkRTOanSFKzmDgJc9oi1CM9D5D97+_oz31-MM0ADOtY6A4Q@mail.gmail.com>
References: <CA+G9fYt49jY+sAqHXYwpJtF0oa-jL8t8nArY6W1_zui0sKFipA@mail.gmail.com>
 <29824864-f076-401f-bfb4-bc105bb2d38f@app.fastmail.com>
 <96a99291-7caa-429c-9bbd-29721a2b5637@app.fastmail.com>
 <CAKdAkRTOanSFKzmDgJc9oi1CM9D5D97+_oz31-MM0ADOtY6A4Q@mail.gmail.com>
Date:   Fri, 11 Nov 2022 10:21:28 +0100
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Cc:     "Naresh Kamboju" <naresh.kamboju@linaro.org>,
        linux-stable <stable@vger.kernel.org>,
        "open list" <linux-kernel@vger.kernel.org>,
        "Linux ARM" <linux-arm-kernel@lists.infradead.org>,
        lkft-triage@lists.linaro.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Sasha Levin" <sashal@kernel.org>,
        "Linus Walleij" <linus.walleij@linaro.org>,
        "Mark Brown" <broonie@kernel.org>,
        "Liam Girdwood" <lgirdwood@gmail.com>
Subject: Re: arm: TI BeagleBoard X15 : Unable to handle kernel NULL pointer dereference
 at virtual address 00000369 - Internal error: Oops: 5 [#1] SMP ARM
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 11, 2022, at 01:48, Dmitry Torokhov wrote:
> On Wed, Nov 9, 2022 at 2:20 PM Arnd Bergmann <arnd@arndb.de> wrote:
>>
>> On Wed, Nov 9, 2022, at 13:57, Arnd Bergmann wrote:
>> >
>> > One thing that sticks out is the print_constraints_debug() function
>> > in the regulator framework, which uses a larger-than-average stack
>> > to hold a string buffer, and then calls into the low-level
>> > driver to get the actual data (regulator_get_voltage_rdev,
>> > _regulator_is_enabled). Splitting the device access out into a
>> > different function from the string handling might reduce the
>> > stack usage enough to stay just under the 8KB limit, though it's
>> > probably not a complete fix. I added the regulator maintainers
>> > to Cc for thoughts on this.
>>
>> I checked the stack usage for each of the 147 functions in the
>> backtrace, and as I was guessing print_constraints_debug() is
>> the largest, but it's still only 168 bytes, and everything else
>> is smaller, so no point hacking this.
>
> You mentioned that we are doing probing of a device 6 levels deep.
> Could one of the parent devices be marked for an asynchronous probe
> thus breaking the chain?

Ah right, I forgot that we already have a per-driver flag for this,
thanks a lot for the suggestion!

This means it might be as easy as this oneliner, picking
one of the drivers in the middle of the call chain that is
not shared across too many other systems:

diff --git a/drivers/mfd/palmas.c b/drivers/mfd/palmas.c
index 8b7429bd2e3e..f4a96eb98eea 100644
--- a/drivers/mfd/palmas.c
+++ b/drivers/mfd/palmas.c
@@ -731,6 +731,7 @@ static struct i2c_driver palmas_i2c_driver = {
        .driver = {
                   .name = "palmas",
                   .of_match_table = of_palmas_match_tbl,
+                  .probe_type = PROBE_PREFER_ASYNCHRONOUS,
        },
        .probe = palmas_i2c_probe,
        .remove = palmas_i2c_remove,

There is still a small regression risk for other OMAP platforms
that may rely on probe ordering, but it should reliably fix
the issue.

There is a related idea that I'll try to take another look
at: since the bug only happens sometimes, and not at all on
mainline kernels with IRQ_STACK, I had the idea of making the
kernel stack size runtime configurable on mainline kernels, by
reserving a fixed amount of the 8KB total. This should make it
possible to narrow down the actual maximum stack usage before
a guaranteed crash, and then validate that a fix correctly
addresses it.

    Arnd
