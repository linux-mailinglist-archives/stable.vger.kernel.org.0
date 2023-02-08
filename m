Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7778B68F3BA
	for <lists+stable@lfdr.de>; Wed,  8 Feb 2023 17:48:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbjBHQsG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Feb 2023 11:48:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbjBHQsF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Feb 2023 11:48:05 -0500
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 371EA38B54;
        Wed,  8 Feb 2023 08:48:04 -0800 (PST)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id ADE053200958;
        Wed,  8 Feb 2023 11:48:01 -0500 (EST)
Received: from imap52 ([10.202.2.102])
  by compute5.internal (MEProxy); Wed, 08 Feb 2023 11:48:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=squebb.ca; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1675874881; x=1675961281; bh=7o+n0EaTSG
        Xkt9q2L0KwC4zzrM/LmUmRp6102o/qHiE=; b=O1MxcrcoPa7hRViRD22ed2qvN+
        JsNvvpG+WewrIh3sqC9OG87EjXJ/+orQGEp+HUphQVTq+v/v9e0P5Wxt7WDXdhYk
        UmD1cVdhFnDHByAdj7aW3II9f7G7WtDvU14Azdk/VVokudqZ3IlSpP7Mu2EoRgY1
        Kekd2sHjtP3R5smfaLEnS4S5NcODSE+jj4lOv0+1gdly73fqjggNrdrvfGQcWbo6
        OGV3owCK84Xj4FrvQeZaZcPmVnOEZsUfSmO4D/hqXyOcctmdMFNh6oei02omQKDm
        GD/DmEQe/VNDec1uBMziryuArE6MO1US0uo0uXQOygBCnYOupZLSwQiWoHIA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1675874881; x=1675961281; bh=7o+n0EaTSGXkt9q2L0KwC4zzrM/L
        mUmRp6102o/qHiE=; b=F+9OGY1O5QoYA3MiSsGClj66x3FojZO6y6HbhUaznl1j
        LYQsa8qm+LleNyXZsFgxuhXPAE+6ZIZsVvgwnm40Y1jW69mfBItb6jRXzX8J6CxY
        mnOR9jfXS70dW9CHzql/Qzy0johtmvUrhS85gTwcaO6vs2P5y73Syujyad8rUE/F
        zaj06riCEHjwXMNGYDZgon/Dk7hGlWfY9MYXkB2LAHjn07PsXMRa2e1K3h6DVEMq
        vH4BXts3nEVcDEVE1KTUFMaLspmBq8l6HNAIFR3ygVjkvHyq9R3OxRlCGHMc5f38
        k8XsBAOu4q1J2wTBMBjy+kr45B09CDEYyGgejiYVDQ==
X-ME-Sender: <xms:QNLjY3SjB0e3bfsfU6EoEAcPH28t6TOMvwgd-2PasVOvGN5sAVHQGg>
    <xme:QNLjY4zsAKpN-mBRv38mwkWXIY1mQupGEJF62W-bpf_vIYGcC_85t60HTN2SitAwk
    fzMW0SzAO516wKCQFI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudehuddgfedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedfofgr
    rhhkucfrvggrrhhsohhnfdcuoehmphgvrghrshhonhdqlhgvnhhovhhosehsqhhuvggssg
    drtggrqeenucggtffrrghtthgvrhhnpeeiueefjeeiveetuddvkeetfeeltdevffevudeh
    ffefjedufedvieejgedugeekhfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehmphgvrghrshhonhdqlhgvnhhovhhosehsqhhuvggssgdrtggr
X-ME-Proxy: <xmx:QNLjY83XWqexYMbPRHkNaCYGK3CLQbCSE4RV1kMlW_l2oopD7JZ8vg>
    <xmx:QNLjY3B8b9tXQ7UICYvWkvQiam49yFRibbzy6ixSc4aygh-dgdG8Fw>
    <xmx:QNLjYwhgyKv41PLqF4jL_A5rK2vFu5Puw9_LkLl4cWO3R-4p5XEJCA>
    <xmx:QdLjYztmbC6AFHVgf0RqrmZu95FW9OBXSARHnrmmbCZFkkUzajHjPw>
Feedback-ID: ibe194615:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 8A379C60091; Wed,  8 Feb 2023 11:48:00 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-156-g081acc5ed5-fm-20230206.001-g081acc5e
Mime-Version: 1.0
Message-Id: <6f6e61b3-84f7-40b1-a4f7-dede5d5bd8ce@app.fastmail.com>
In-Reply-To: <Y+O5pLXHW/0goHMy@kroah.com>
References: <mpearson-lenovo@squebb.ca>
 <20230208144648.1079898-1-mpearson-lenovo@squebb.ca>
 <Y+O5pLXHW/0goHMy@kroah.com>
Date:   Wed, 08 Feb 2023 11:47:39 -0500
From:   "Mark Pearson" <mpearson-lenovo@squebb.ca>
To:     "Greg KH" <greg@kroah.com>
Cc:     linux-usb@vger.kernel.org,
        =?UTF-8?Q?Miroslav_Za=C5=A5ko?= <mzatko@mirexoft.com>,
        "Dennis Wassenberg" <dennis.wassenberg@secunet.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] usb: core: add quirk for Alcor Link AK9563 smartcard reader
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks Greg

On Wed, Feb 8, 2023, at 10:03 AM, Greg KH wrote:
> On Wed, Feb 08, 2023 at 09:46:48AM -0500, Mark Pearson wrote:
> > The Alcor Link AK9563 smartcard reader used on some Lenovo platforms
> > doesn't work. If LPM is enabled the reader will provide an invalid
> > usb config descriptor. Added quirk to disable LPM.
> > 
> > Verified fix on Lenovo P16 G1 and T14 G3
> > 
> > Tested-by: Miroslav Zatko <mzatko@mirexoft.com>
> > Tested-by: Dennis Wassenberg <dennis.wassenberg@secunet.com>
> > 
> > Cc: stable@vger.kernel.org
> > 
> > Signed-off-by: Dennis Wassenberg <dennis.wassenberg@secunet.com>
> > Signed-off-by: Mark Pearson <mpearson-lenovo@squebb.ca>
> 
> No blank lines needed between tested-by and cc: stable.
Ack

> 
> > ---
> >  drivers/usb/core/quirks.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
> > index 079e183cf3bf..9b1c56646ac5 100644
> > --- a/drivers/usb/core/quirks.c
> > +++ b/drivers/usb/core/quirks.c
> > @@ -535,6 +535,9 @@ static const struct usb_device_id usb_quirk_list[] = {
> >  /* INTEL VALUE SSD */
> >  { USB_DEVICE(0x8086, 0xf1a5), .driver_info = USB_QUIRK_RESET_RESUME },
> >  
> > + /* Alcor Link AK9563 SC Reader used in 2022 Lenovo ThinkPads */
> > + { USB_DEVICE(0x2ce3, 0x9563), .driver_info = USB_QUIRK_NO_LPM },
> 
> Please follow the instructions in the comment right above this structure
> definition for where to put the entry in the list.

Ah - my bad. Will fix.

Mark
