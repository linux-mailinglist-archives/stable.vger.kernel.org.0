Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEE386507E5
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 07:53:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbiLSGxF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 01:53:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiLSGxE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 01:53:04 -0500
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 986E92AF5
        for <stable@vger.kernel.org>; Sun, 18 Dec 2022 22:53:02 -0800 (PST)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 491925C0052;
        Mon, 19 Dec 2022 01:53:00 -0500 (EST)
Received: from imap46 ([10.202.2.96])
  by compute5.internal (MEProxy); Mon, 19 Dec 2022 01:53:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.com.au;
         h=cc:cc:content-type:date:date:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to; s=fm2; t=
        1671432780; x=1671519180; bh=02BfbmfbOBdCzAizCzAHPU7Stnvl04tgCkF
        2mb/oknU=; b=BWCSdd0s2YkAzqLCZrtKOexKAMtdxuhngeFluck6gzMkwAekgIG
        0DKOj0o8eHTuIJpARIPjD4m9/uKttjBDMbNLFMqsBDOWfMqpB2KA26TGjfP+Ka1D
        diPAXe6Y3A/T6kt0UX4ZW42TmveAjWfDWPORsDRBB9VfU81pGTc4mSD9Onikb+LI
        f6Vw6XkmJFCTxJ9rI8BiwV9ZWufIB9xUQS6W9YCdlhkkShZdhVHTXgKFYoXopetJ
        ZBfiF+Y83OIzIAm48ePLcf2r4PYiEnV1TQRV1wjA8bmFpxIcUoGnzUFR8uX0fbJ0
        qz8uiJH4IFvOLQqmSyNyQ5j0MZz6Ew5OKDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:message-id:mime-version
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1671432780; x=
        1671519180; bh=02BfbmfbOBdCzAizCzAHPU7Stnvl04tgCkF2mb/oknU=; b=M
        LOnD2b4bPggyGMmQA/aCS+vgQtF52rVyp034uxMQvZR6tOcBm1jRcruw9G+rCWnC
        S77ZnTDuhSLH/qnjO0Zv4zqmbfYGBVcz1i4XvQoiJBvVbvmqZPyOAyT2XQkks62C
        QZwdNwiqoTt9WEzgf4M8f6VwJ/Nuok9Upru0meh1OK5R3pXef13Kus4Qjz6Ej/b8
        eMde+EjuS4cT9jv5eUe2ObxX3VJrcRsSkblUBKuUajmJ7nEGFnPSgN/SBGI+NEBV
        Df5FYtBZgSEMqmjHjEgvC+vTa0gag7Mlb/sR1miiV9qNUcZWR7w1qzHQmjumfUOd
        EMCu6CfDejM/YwwD3++Gw==
X-ME-Sender: <xms:TAqgY-ij4hE6ogcPYNiEoYhwMUdK0MKhRHYeW1A_p1mJCIRI1aKhNQ>
    <xme:TAqgY_BVmM5fhruvr1Qp7jGPTJzpMPwhRWUi5R4HgyPpXmC4oHGUxaSQtHisNQYfW
    yYXK6FHZReE2UvHmg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrgedvgdellecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepofgfggfkfffhvfevufgtsehttdertd
    erredtnecuhfhrohhmpedflfhohhhnucfvhhhomhhsohhnfdcuoehlihhsthhssehjohhh
    nhhthhhomhhsohhnrdhfrghsthhmrghilhdrtghomhdrrghuqeenucggtffrrghtthgvrh
    hnpeefieelgeetlefgheeuleekfedtleeiueeugedujeehfffftdelffelgfdtveehgfen
    ucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomheplhhishhtshesjhhohhhnthhhohhmshhonhdrfhgr
    shhtmhgrihhlrdgtohhmrdgruh
X-ME-Proxy: <xmx:TAqgY2GPsiRE38e-XHGdS2CatHB8W2L2P0REUbN7N_uXCD_lTPG2pw>
    <xmx:TAqgY3SeJ51SipHWTKUvwLoSUuhnyzJ4y6EdComGWi5T2bw7m1l7GA>
    <xmx:TAqgY7xzbmkvnVcxHKSZLL2-yFtNYHCTXOcYRXRwaVWJ9kLaovNKeQ>
    <xmx:TAqgY8tWdyrxE9focaXrOLlhw9Hc3vDITI7ATRw9fZvZ32Pl5lqRDA>
Feedback-ID: ia7894244:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 0FEC92A20080; Mon, 19 Dec 2022 01:52:59 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-1185-g841157300a-fm-20221208.002-g84115730
Mime-Version: 1.0
Message-Id: <1a53deef-63f7-43c7-aa73-7ce46fb92a0d@app.fastmail.com>
Date:   Mon, 19 Dec 2022 06:51:44 +0000
From:   "John Thomson" <lists@johnthomson.fastmail.com.au>
To:     stable@vger.kernel.org
Cc:     sergio.paracuellos@gmail.com
Subject: request for mt7621 SLUB boot fix for 6.1.y
Content-Type: text/plain
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi stable team,

I would like to request for cherry picking to the linux-6.1.y branch:
19098934f910 ("PCI: mt7621: Add sentinel to quirks table")
a2cab953b4c0 ("mips: ralink: mt7621: define MT7621_SYSC_BASE with __iomem")
b4767d4c0725 ("mips: ralink: mt7621: soc queries and tests as functions")
7c18b64bba3b ("mips: ralink: mt7621: do not use kzalloc too early")


On the mips mt7621 SoC, a kzalloc is used too early and returns before reaching a soc_device_register.
soc_device_attribute->revision is used to identify MT7621 ver:1 eco:1 devices for a pci & phy-pci quirk.
A SLUB change in kernel 6.1 caused the device to fail to boot, rather than silently continue.

In fixing this, it was then seen that the pci & phy-pci drivers would oops,
as they were missing a sentinel in their soc_device_match quirks table.
The phy-pci fix has already been applied to stable.
The pci & early kzalloc fixes missed the 6.1rc window and are being taken for 6.2

In a quick web search I cannot find any reference to bootlogs for "ver:1 eco:1"
(which would use the quirk for PCI), so cannot see a current need to backport this
further than fixing the 6.1 boot error.

Link: https://lore.kernel.org/linux-mm/becf2ac3-2a90-4f3a-96d9-a70f67c66e4a@app.fastmail.com/
Link: https://lore.kernel.org/lkml/20221205204645.301301-1-git@johnthomson.fastmail.com.au/
Link: https://lore.kernel.org/lkml/20221114015658.2873120-1-git@johnthomson.fastmail.com.au/#t

cc'ed the maintainer, Sergio.


Thank you,

Cheers,
-- 
  John Thomson
