Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7A325EF0CE
	for <lists+stable@lfdr.de>; Thu, 29 Sep 2022 10:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235444AbiI2Iru (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Sep 2022 04:47:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235585AbiI2Irq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Sep 2022 04:47:46 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16C6B12E421;
        Thu, 29 Sep 2022 01:47:43 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 5EAC75C0150;
        Thu, 29 Sep 2022 04:47:40 -0400 (EDT)
Received: from imap47 ([10.202.2.97])
  by compute2.internal (MEProxy); Thu, 29 Sep 2022 04:47:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=svenpeter.dev;
         h=cc:cc:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1664441260; x=1664527660; bh=dk
        M3wIQDoYndkcHfwuQVpdncU+62VEaoUMXwD9D/Gy0=; b=flg8i4MbVNdOli5ES5
        xzdo0er3T4ut6N/ut8EMJC1RAuY2yZ4BLZS0G/QbeN/PC6YcbHb5V9XZI1raxRRR
        pN428YbdurvSl3PkV3gxraGfRQLjF6Kgv61hxXryivJF83uUEqUaItAj0y7pl9BL
        dDFIHb6ws1Dbtd67/q4DGr53p3SAoLDpywPjpljX+E5mGMu2pq8/VBt/zPeaPMhv
        QcCzdoXaaPeRy4LdKMsR3M/ME8a0WFWiBHCd5195z7fsGq/4criIsn0Pqri3PsP0
        QaC7k9x1zt3tOoYUZg215DYyf37ukbpAtCFtH93S8jkwU1OMx4XQDL6LXIrBOCFp
        9flA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1664441260; x=1664527660; bh=dkM3wIQDoYndkcHfwuQVpdncU+62
        VEaoUMXwD9D/Gy0=; b=s8QhI8pSHrorgnbDj27E5z6FMSmt/Vn5Ht8rdpcM9/TX
        oNptLejlyEljqggdR2H1X5tk7vg4wOXG87hprj/+Z4ODOVqDIjd8GUc20lETT8l7
        l4ye3gLmpabtvDRip123Q+s4f9dItc8g57x+NzyHeBT1TMOXSC7BejIfWzYdZG1X
        XLT5xSgejBc8CEkmSKvCVX0vXK44Wihqb7wYQrSrsaGj9dThO4RJhPhWgTU9bcsn
        RtnP7R6rQyguher/IW/LP8tu/Rkb99QrCkwIaeLf/5FV5yBL/Ix6p0xDcv8MpkuR
        VKU1EsPdvr5n8FTNIvFhnoalOTTZuoEw7H1ruV8/mg==
X-ME-Sender: <xms:rFs1YwpzYglwJCPYPXJjAmB_016Ndgvsf0XDtF2Q_T6cfmE7UsakDw>
    <xme:rFs1Y2oTdHPg7tzbqrm6y571sE_QktMyEsm7DFEwXtrWqz1w82WGrfrtGXVcead5W
    MGvN1_HoHBTKsW1FOk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfeehtddgtdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedfufhv
    vghnucfrvghtvghrfdcuoehsvhgvnhesshhvvghnphgvthgvrhdruggvvheqnecuggftrf
    grthhtvghrnhepleevgfegffehvedtieevhfekheeftedtjeetudevieehveevieelgffh
    ieevieeunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    epshhvvghnsehsvhgvnhhpvghtvghrrdguvghv
X-ME-Proxy: <xmx:rFs1Y1PY9Tqx3fS9dOLwQgte36eK1XX0Po7bJhkDJROZUw--ZvkJ1Q>
    <xmx:rFs1Y34Zb6ZMg5-tR8PwRUzVhHQZAWL2A_XyRnYL5viqIu44KiNDUA>
    <xmx:rFs1Y_7SoK4z5WaORkt5LmMNrH6fIZ_MjnIlqE2NuZ9RhYgVRt7MNQ>
    <xmx:rFs1Y1SyIT2IwN8YSQO67E-EV9RefNSyWmRnjmYGE45z0LnMpLdpdQ>
Feedback-ID: i51094778:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 26F46A6007C; Thu, 29 Sep 2022 04:47:40 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-968-g04df58079d-fm-20220921.001-g04df5807
Mime-Version: 1.0
Message-Id: <21064478-92ce-475d-b5b2-c7b9badba40c@app.fastmail.com>
In-Reply-To: <CAHQ1cqG5RmqnOuTch02y=pE-XK5dZABTN+FNaF2LOg5oJx=PPQ@mail.gmail.com>
References: <20220927155332.10762-1-andriy.shevchenko@linux.intel.com>
 <20220927155332.10762-3-andriy.shevchenko@linux.intel.com>
 <CAHQ1cqG5RmqnOuTch02y=pE-XK5dZABTN+FNaF2LOg5oJx=PPQ@mail.gmail.com>
Date:   Thu, 29 Sep 2022 10:47:19 +0200
From:   "Sven Peter" <sven@svenpeter.dev>
To:     "Andrey Smirnov" <andrew.smirnov@gmail.com>
Cc:     "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Felipe Balbi" <balbi@kernel.org>, "Ferry Toth" <fntoth@gmail.com>,
        stable@vger.kernel.org,
        "Andy Shevchenko" <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH v2 2/2] Revert "usb: dwc3: Don't switch OTG -> peripheral if extcon
 is present"
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



On Thu, Sep 29, 2022, at 05:01, Andrey Smirnov wrote:
> On Tue, Sep 27, 2022 at 8:53 AM Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
>>
>> This reverts commit 0f01017191384e3962fa31520a9fd9846c3d352f.
>>
>> As pointed out by Ferry this breaks Dual Role support on
>> Intel Merrifield platforms.
>>
>> Fixes: 0f0101719138 ("usb: dwc3: Don't switch OTG -> peripheral if extcon is present")
>> Reported-by: Ferry Toth <fntoth@gmail.com>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>> Tested-by: Ferry Toth <fntoth@gmail.com> # for Merrifield
>
> Sven can you check that this also fixes the regression of your fix?

I'll only have time to test this on the weekend but the fix looks good to me.

Reviewed-by: Sven Peter <sven@svenpeter.dev>


Sven

