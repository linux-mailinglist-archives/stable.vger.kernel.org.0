Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A38635BB8EC
	for <lists+stable@lfdr.de>; Sat, 17 Sep 2022 17:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbiIQPB2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Sep 2022 11:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiIQPB1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Sep 2022 11:01:27 -0400
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E52401F61F;
        Sat, 17 Sep 2022 08:01:25 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 8FE8632003F4;
        Sat, 17 Sep 2022 11:01:21 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Sat, 17 Sep 2022 11:01:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        joshtriplett.org; h=cc:cc:content-transfer-encoding:content-type
        :date:date:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to;
         s=fm1; t=1663426881; x=1663513281; bh=QakTsMOTOSQcuDHAp3T1zWhE/
        2pa8qxh1dkXdRWc93I=; b=rbIEusppIH3QrikqOfej2MeuuAH7yDYRUPaxpnL14
        gHzKryLB0+DD/dcx7ypbu3qgj8kZQ+4f6kbEKpvYesO7rN3n1YKFM9fA730fUuBS
        F23joSD3iXwKFtQQXu7en1/8Em2NQlfijFifkMVywsr4pi0i9/VoyD2AlRY0w216
        3eUVOkZ7HynHbL6UJLBovXjkU3sT1bwHbhEOePjd2JVEcOrl0zSWWXhY8BylBdAT
        i1L4G5b5+T4Ah3XfaGsKdlyCIB1BoM94R+7UBt6c8LLogJPBn0ggXd6HQuuCMZ69
        474pXwJ/ktUUJVKVNOe/65T+u/iz9nDoab6HsfK/zLMnQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1663426881; x=
        1663513281; bh=QakTsMOTOSQcuDHAp3T1zWhE/2pa8qxh1dkXdRWc93I=; b=u
        xILl/lKvQo+b6MTM+sXIS7ox7OsH+Vdjdifl7B93X9yZmxJ+S80UXVO4R9eGNHU8
        6h8+hYsWD0v+w6dQMe0CEz1dRZp7Mp2o7e3Nl9HSVPrrCXS5Y7YdASBYtslmK3Bc
        ncML2NRGTIQIK3ojBk/5+ISdpLbyl9agNneD/NxKhja54sENZMCGNFFeXqPMZI1+
        5nG3ZSVqqqha9bpgADUUw4ev0rhmEYVvwVtaAeCPUP/Q4QNwT653mH8MIPZTZL95
        RrcrhdCM2PLf1+nrIelp8iwTFBMMTco9YmuNUXo31CjhWUU+l+GOM3YQuCMz7aAN
        VaayJo2xQqcFPdGipVHAw==
X-ME-Sender: <xms:P-ElY4UW7K7ZOXdj7CwDQ_aXeZVv6rxuQSsZoHr326B9LChUqef0lw>
    <xme:P-ElY8kwU_dFlUgimOduepLUUfLz5wBPK8X4Dn_xrgqdh7AgBxuXlRoKvPd3eS44U
    8S2fterzowJoX4EKMU>
X-ME-Received: <xmr:P-ElY8az7EpLL6I0vZveYtUJTpt77cJRTRyALbZh-VR9ND6JJcRB8WK6cyqAMmA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfedvvddgkeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevufgjfhfkgggtgfesthhqmhdttddtjeenucfhrhhomheplfhoshhh
    ucfvrhhiphhlvghtthcuoehjohhshhesjhhoshhhthhrihhplhgvthhtrdhorhhgqeenuc
    ggtffrrghtthgvrhhnpeegkeeggfegjedtvdehgfdtvdekueetveetfedvveetueetffek
    ieekledthfeivdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfh
    hrohhmpehjohhshhesjhhoshhhthhrihhplhgvthhtrdhorhhg
X-ME-Proxy: <xmx:P-ElY3Xbt0OjbIzzSjMvArjJJlGLQD8Tq22Kx0MeK9nZKI-bT9U-TQ>
    <xmx:P-ElYylTkwb9gcEI8rnXgV1XGDDxdgiHv-_INQI8E2QpHT6hmtM5OA>
    <xmx:P-ElY8faI-JPNGTH1ZMaLzs66C8p1rl6WoWht_s4ct6WWWGS1roZtg>
    <xmx:QeElY5uCr-vivLol01RkFKy8PzJZGgE8QheivNQACTYaqL2AY1pfag>
Feedback-ID: i83e94755:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 17 Sep 2022 11:01:18 -0400 (EDT)
Date:   Sat, 17 Sep 2022 16:00:59 +0100
From:   Josh Triplett <josh@joshtriplett.org>
To:     "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>
CC:     Anders Blomdell <anders.blomdell@control.lth.se>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_0/2=5D_serial=3A_8250=3A_Let_driv?= =?US-ASCII?Q?ers_request_full_16550A_feature_probing?=
In-Reply-To: <alpine.DEB.2.21.2209162317180.19473@angie.orcam.me.uk>
References: <alpine.DEB.2.21.2209162317180.19473@angie.orcam.me.uk>
Message-ID: <0B189972-4FD8-4245-BF2F-ADEAB18AAAE0@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On September 17, 2022 11:07:18 AM GMT+01:00, "Maciej W=2E Rozycki" <macro@o=
rcam=2Eme=2Euk> wrote:
>Hi,
>
> A recent change has added a SERIAL_8250_16550A_VARIANTS option, which=20
>lets one request the 8250 driver not to probe for 16550A device features=
=20
>so as to reduce the driver's device startup time in virtual machines=2E =
=20
>This has turned out problematic to a more recent update for the OxSemi=20
>Tornado series PCIe devices, whose new baud rate generator handling code=
=20
>actually requires switching hardware into the enhanced mode for correct=
=20
>operation, which actually requires 16550A device features to have been=20
>probed for=2E
>
> This small patch series fixes the issue by letting individual device=20
>subdrivers to request full 16550A device feature probing by means of a=20
>flag regardless of the SERIAL_8250_16550A_VARIANTS setting chosen=2E
>
> The changes have been verified with an OXPCIe952 device, in the native=
=20
>UART mode and a 64-bit RISC-V system as well as in the legacy UART mode=
=20
>and a 32-bit x86 system=2E

Seems reasonable to me, as long as the flag is only set by drivers that kn=
ow they've found their hardware=2E

