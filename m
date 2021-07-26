Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B35F3D5360
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 08:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231825AbhGZGNS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 02:13:18 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:43329 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229658AbhGZGNR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Jul 2021 02:13:17 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 98A315C00BC;
        Mon, 26 Jul 2021 02:53:46 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 26 Jul 2021 02:53:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=HG3h7vUAbQfGpe4Y5BgK03SCh15
        0xBlKoQ1J9Rpg3gQ=; b=yv9OKkLcoqeNvg8K4YA7Ml2kdk8XRt1ov+2hfje+RrX
        ebbFxb7nP0oX1wRvHIGjKAiSUaGwT6qGRGCO9tR/rwp+Qo3tsFZdam/gtNIzdPK4
        qF5UvjX5ZaywS1E17IWAEw8s0VTDPpKQ/+dRT2tLEY06Jnc7d+0vORyrKJGCB3Vx
        KIsl22u5ly5OL8DitgTrdfu4eXzPmp+O8oH+PdVfJwJbhRQHKilacI3OjlOsEQ9A
        x3FklOIkltXjHY43lYnyLI65ufMDBvLrP1C9lPCxkbKeq9L0fcNccpvmOUImBqQ0
        lBIoQWrlpk8VWfX2XlFJ2UZBijW+M+Q6+cybYJMXhoQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=HG3h7v
        UAbQfGpe4Y5BgK03SCh150xBlKoQ1J9Rpg3gQ=; b=a6x96brohf7ickmxoZafd0
        IwH6fwH/NJG1PuBDRMEqB1e/Y+6yB2AhIlr3CpXDQ9Vc9H12nRT/jyR/SnfeQj7S
        +8UvoRYrm5GfUd7KFDhLyYgKfmBGBvLTlmodCJ50GIQRrSo6nHtFqUDLyQ61EI38
        nKPvgpIkqx6KXhT9OE8W1SQBpXepaKhqKsfSfrm+joMYiRlCd5CYOEkdV3n7NbEG
        vlfOY+/irHX6AQaYp3Ae+Q4zED8ya7v2l0JYnooSTrJXCGR6jdJiuStWnxas1a2O
        nIYBIZrVJrhHG/2vJabS48qCHW5gngK4Vjt2kei9UiWRdtvclVGhMMQdD6qoo0kw
        ==
X-ME-Sender: <xms:-lv-YPnVNFaTsvn3Uh9A_EjmVAZTcMzOVvM1toNdYaK1_wOWThEyag>
    <xme:-lv-YC3tPqSjXF6gnb9rbGiMTqQULUYaM8lChtPv1SQ6N5Zj4SE6jOlozWRPV8ocX
    lM28VEnapuOkg>
X-ME-Received: <xmr:-lv-YFrCvRqhAIMQx8y2Nrxt8n_4iossrZ2In_j61BRIZiAvS_IR3kOL8pYaFXcIQlSHT-zl2R94V0t_ciRndaL52V9JwXum>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrgeeggddutdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeuleeltd
    ehkeeltefhleduuddvhfffuedvffduveegheekgeeiffevheegfeetgfenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:-lv-YHkIRFsltABzdbtViZL19X-zvcHDkKgDOKZwP2-gLIFoAep-HA>
    <xmx:-lv-YN0VZPXtCj1032wrBHW-HRDN0Nmy4RU7O3eQhtMOR1HO7Z1kHg>
    <xmx:-lv-YGt55LV_m7WyUwmowZZcLebhKxsLmqwlfR1PH3aw11rItSufFA>
    <xmx:-lv-YHqrV02_t-aw_m1N5GA117iqDeYSFSC8siSXAAkm0qJbd1wZGw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 26 Jul 2021 02:53:45 -0400 (EDT)
Date:   Mon, 26 Jul 2021 08:53:44 +0200
From:   Greg KH <greg@kroah.com>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>, Stable <stable@vger.kernel.org>,
        stable-commits@vger.kernel.org
Subject: Re: Patch "ACPI: utils: Fix reference counting in
 for_each_acpi_dev_match()" has been added to the 5.13-stable tree
Message-ID: <YP5b+FrIhXUQ2KiQ@kroah.com>
References: <20210726024441.16E8E60F11@mail.kernel.org>
 <CAHp75Vda-5ESLvnqVZEE_JRYr5k38gw0g-R650bNULf78d1t1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75Vda-5ESLvnqVZEE_JRYr5k38gw0g-R650bNULf78d1t1w@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 26, 2021 at 09:49:16AM +0300, Andy Shevchenko wrote:
> On Mon, Jul 26, 2021 at 5:44 AM Sasha Levin <sashal@kernel.org> wrote:
> >
> > This is a note to let you know that I've just added the patch titled
> >
> >     ACPI: utils: Fix reference counting in for_each_acpi_dev_match()
> >
> > to the 5.13-stable tree which can be found at:
> >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> >
> > The filename of the patch is:
> >      acpi-utils-fix-reference-counting-in-for_each_acpi_d.patch
> > and it can be found in the queue-5.13 subdirectory.
> >
> > If you, or anyone else, feels it should not be added to the stable tree,
> > please let <stable@vger.kernel.org> know about it.
> 
> This has to be accompanied with
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=fc68f42aa737dc15e7665a4101d4168aadb8e4c4

Now added, thanks.

greg k-h
