Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30288623644
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 23:03:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbiKIWDc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 17:03:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbiKIWDb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 17:03:31 -0500
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E625E19;
        Wed,  9 Nov 2022 14:03:30 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id E194F5C016D;
        Wed,  9 Nov 2022 17:03:26 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute3.internal (MEProxy); Wed, 09 Nov 2022 17:03:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1668031406; x=1668117806; bh=90Q4t0I3AS
        O4wxuMFa7atJdc376IIEHg3Latfar0VBs=; b=f//EK1j6t0cPPtMtu15DwQQNHt
        d+Jr6+H+H0vssHfq0wEf0pdZWHwlv3AjdsoSJm5VvGMRFVjZSn9SEJWEVQF/mzuo
        8woD0fKDXfO0NFbGkXSltY3g8IAUgotG3IkrirGI7png4BgKSgn1NXi2Jt0q2dzN
        JzgKcUHoX0sDHULIJmvp5wcO3biu6E2D7vfpojjfHfWPbmcRmROxav+gE733hkVj
        7qOO6C/ywySU1UvdflJbhdL1ynwHW+VwgWYZFaxoiq1yPLPaEKLYTmzsNqQAqtym
        2++7bPlf7U+waMeZQyPhnNywt/v77Xejm3fY0V0X6jbi56Q09qesTNKU97Jg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1668031406; x=1668117806; bh=90Q4t0I3ASO4wxuMFa7atJdc376I
        IEHg3Latfar0VBs=; b=gW5bJIIeE834epB1gsYZNQufn8noqrKb5utPDcQzQZpT
        bp8gpZNMOs0HvT/z5U1QTyYGCT7Kl9iaLKIBVif4QAo+aGTLn+OFNmxXXiVG7u2+
        +ofxIAxNR7XmDSh6dwG4WeqOZZpKpdMU/QLMO6DJz57WIhFJp572c/QaoBJjeF5O
        3xo4zH+DurVsfBJxh0vlBK5d+vTttCwejLe+kqItMi7vwqsRAbLCgk41y66vlV3a
        A/QX3Q3gIuz49hS8jgDdNSv9qdmh6hxeiwUSiyBt5Z35yitoRTQZvmGJSh71tMCc
        0YY/k3r926B6H96Jbnl3Nb3O71xpA7cnNj1TXdKHCA==
X-ME-Sender: <xms:riNsY-uLstp1juABk1gaG68k9LnBFcATQClxnYKMqjXAd6XKBy0Lvw>
    <xme:riNsYzfRVJau5Kmul0LA2lIYOAv0Pm8TsHUfpvUsCsDdwjTzoW2bG1A-I6OLP9ldh
    I3OIZ7Y1ZZDtv0D_HA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrfedvgdduheejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhepffehueegteeihfegtefhjefgtdeugfegjeelheejueethfefgeeghfektdek
    teffnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:riNsY5zWKL50a4m4D2wx7Kio7mm5sWOgMXT6eWzNWkqGUzgTy3Exfw>
    <xmx:riNsY5P05gy3Fy0r5g2wWZtISogUKnAM0Ncg-wgnuzJVyyOINnc79g>
    <xmx:riNsY-_42SthFO2d8KWjA5w9quY3hfFsBydSZ4znhi4sKopORLSXxg>
    <xmx:riNsYzMXgTR_q1idrdEuh4L2TX9tCRofkagocUfcnm84lzohkwOPOQ>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 927D7B60086; Wed,  9 Nov 2022 17:03:26 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-1115-g8b801eadce-fm-20221102.001-g8b801ead
Mime-Version: 1.0
Message-Id: <96a99291-7caa-429c-9bbd-29721a2b5637@app.fastmail.com>
In-Reply-To: <29824864-f076-401f-bfb4-bc105bb2d38f@app.fastmail.com>
References: <CA+G9fYt49jY+sAqHXYwpJtF0oa-jL8t8nArY6W1_zui0sKFipA@mail.gmail.com>
 <29824864-f076-401f-bfb4-bc105bb2d38f@app.fastmail.com>
Date:   Wed, 09 Nov 2022 23:03:04 +0100
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Naresh Kamboju" <naresh.kamboju@linaro.org>,
        linux-stable <stable@vger.kernel.org>,
        "open list" <linux-kernel@vger.kernel.org>,
        "Linux ARM" <linux-arm-kernel@lists.infradead.org>,
        lkft-triage@lists.linaro.org
Cc:     "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Sasha Levin" <sashal@kernel.org>,
        "Linus Walleij" <linus.walleij@linaro.org>,
        "Mark Brown" <broonie@kernel.org>,
        "Liam Girdwood" <lgirdwood@gmail.com>
Subject: Re: arm: TI BeagleBoard X15 : Unable to handle kernel NULL pointer dereference
 at virtual address 00000369 - Internal error: Oops: 5 [#1] SMP ARM
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 9, 2022, at 13:57, Arnd Bergmann wrote:
>
> One thing that sticks out is the print_constraints_debug() function
> in the regulator framework, which uses a larger-than-average stack
> to hold a string buffer, and then calls into the low-level
> driver to get the actual data (regulator_get_voltage_rdev,
> _regulator_is_enabled). Splitting the device access out into a
> different function from the string handling might reduce the
> stack usage enough to stay just under the 8KB limit, though it's
> probably not a complete fix. I added the regulator maintainers
> to Cc for thoughts on this.

I checked the stack usage for each of the 147 functions in the
backtrace, and as I was guessing print_constraints_debug() is
the largest, but it's still only 168 bytes, and everything else
is smaller, so no point hacking this.

168 	print_constraints_debug
96 	timekeeping_advance
64 	set_machine_constraints
64 	of_i2c_register_device
56 	of_platform_bus_create
48 	schedule_timeout

One more idea I had is the unwinder: since this kernel is built
with the frame-pointer unwinder, I think the stack usage per
function is going to be slightly larger than with the arm unwinder.

Naresh, how hard is it to reproduce this bug intentionally?
Can you try if it still happens if you change the .config to
use these:?

# CONFIG_FUNCTION_GRAPH_TRACER is not set
# CONFIG_UNWINDER_FRAME_POINTER is not set
CONFIG_UNWINDER_ARM=y

       Arnd
