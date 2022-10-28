Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3EC611AFF
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 21:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbiJ1Tki (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 15:40:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbiJ1Tkh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 15:40:37 -0400
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2F5D23E99
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 12:40:36 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 829AD320090B;
        Fri, 28 Oct 2022 15:40:33 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Fri, 28 Oct 2022 15:40:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tyhicks.com; h=
        cc:cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1666986033; x=1667072433; bh=s6kKhxevdI
        uKGKi/k8jayFf+rAlgWMx0OyDh49ljuZw=; b=dj9dFtir7txv64MDV2sDX8CNva
        LUtVdlhQripp4aTdFhHkLG6VnQL+wDljDZK+8Avdsqvs4GCBhEws83/m29XylSzb
        vtZ9aEvB3FCAKErQBjg72chH1aZsQMCZpwEFUDwzEshgnzpOJG9psgsE/lo0s4jv
        uXT12vDYiQ2UmPqHHUkCfKwZX8FNXQLTIxOu4c0DGxLQUXcL7QiMrin/LBAKW8Vu
        CHyEe2o1T0WDIQ0MowfePYbYKIK2U+RBblfdgoC4yqqAZXp7Mg/b8ietLYSfbAV5
        9BqRB6lkebgC452cc0xIHQMfxhZKQzcRG0pntW/ZPESn57ClWA9bIftD/wQQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1666986033; x=1667072433; bh=s6kKhxevdIuKGKi/k8jayFf+rAlg
        WMx0OyDh49ljuZw=; b=Te+mO16EzlkNtZHU5vb9QfT4gqjRwTmBDf3InKmSQCoK
        ZO1dScaPl1iNMBCkyQldEokQtkOk7Q6IDFJ3vazd/3qKMknJZo1PHoCL0aJboEvC
        BL8OsNTdkD3a8goIrKofY/EqLyXTZeYNxeDhDCgnfKpkxMaemqVZ1P0R4rroVOrW
        bFI0XFui/XWCMQ1uVT1MpbREsRr76RqUzmdmzmJSEsMfycRVvyYICvh4eCeVnnqr
        o55/rxdGV61hF2pwfdzg+C4Quohno7Ppt0HQIabK8bIL2GmQchSTpg4gBxBNYNGD
        Kw9ErJwnDIBTX0JuRCNQlzXtP3vk+eP87YY24+8K1A==
X-ME-Sender: <xms:MDBcY3KvCC0VwE8LHiFq1XEVeSugdJgksmjNodat6s8rpEkxgK-hHA>
    <xme:MDBcY7I7Ydvv-41bYKhPdHzPJUzAmATEDX83SDhLgof4dH-cffPzSeRtwA3vUoRah
    ykt7RjMTlkol2JIrVI>
X-ME-Received: <xmr:MDBcY_uugB_5BdskYQX9aUc1EVNDiJXIFIw1uxy40_sbcKAWkfaDp5OEMaU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrtdeigddufeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepfdfvhihl
    vghrucfjihgtkhhsucdlofhitghrohhsohhfthdmfdcuoegtohguvgesthihhhhitghksh
    drtghomheqnecuggftrfgrthhtvghrnhepveefvdeigedtudfhhedtgfelfeeuueekhefh
    ueefgfdukeejvddtffejvdejtdffnecuffhomhgrihhnpehkrhhorghhrdgtohhmnecuve
    hluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheptghouggvseht
    hihhihgtkhhsrdgtohhm
X-ME-Proxy: <xmx:MDBcYwZvR0UmKB7xTphlHObZbQGFCzF9wMmtpkbb1HFAWWVZ1JJ_Gw>
    <xmx:MDBcY-Zt9XZKkrW6x_dEV068Lzj2L0SNo9Bue4_VTpXnByBz0SekLQ>
    <xmx:MDBcY0ALK2yecfNWZ6niI5OnFW8LMiuRlKxNATfv-a-BxXR-Dc_yHw>
    <xmx:MTBcY1yRyN9Is05QBvrYOYl_eIFbCzg5_cpZLTJEYLphDvuRIMEgpQ>
Feedback-ID: i78e14604:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 28 Oct 2022 15:40:32 -0400 (EDT)
Date:   Fri, 28 Oct 2022 14:40:19 -0500
From:   "Tyler Hicks (Microsoft)" <code@tyhicks.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc:     Suleiman Souhlal <suleiman@google.com>, sashal@kernel.org,
        Sangwhan Moon <sxm@google.com>, stable@vger.kernel.org,
        Kelsey Steele <kelseysteele@linux.microsoft.com>,
        Allen Pais <stable.kernel.dev@gmail.com>
Subject: Re: LTS 5.15 EOL Date
Message-ID: <20221028194019.vda2ei2nsqsysvby@sequoia>
References: <CABCjUKBwLuTWE7A4PkNvRZx=6jeu3QjsFZq5iWZAKnmPYWKLog@mail.gmail.com>
 <Y1EGHnKcWzKv6t99@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1EGHnKcWzKv6t99@kroah.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-10-20 10:26:06, gregkh@linuxfoundation.org wrote:
> On Thu, Oct 20, 2022 at 08:25:35AM +0900, Suleiman Souhlal wrote:
> > Hello,
> > 
> > I saw that the projected EOL of LTS 5.15 is Oct 2023.
> > How likely is it that the date will be extended? I'm guessing it's
> > pretty likely, given that Android uses it.
> 
> Android is the only user that has talked to me about this kernel
> version so far.  Please see:
> 	http://kroah.com/log/blog/2021/02/03/helping-out-with-lts-kernel-releases/
> for what I require in order to keep an LTS kernel going longer than 2
> years.

Microsoft is also interested in a longer lifetime for v5.15 LTS. An
additional year should meet our needs.

We are aware of your "Helping Out ..." blog post and have been making
improvements to be of more assistance. Kelsey and Allen (Cc'ed) have
been doing -rc testing of v5.15 -rc releases and reporting the results
to the list, on behalf of Microsoft. Testing of the -rc releases is
mostly manual at this point, so we don't get every release tested before
the release happens, but we're working on improving our processes and
having builds/tests kick off automatically so that you can rely on us
even more. We should have a much better system in place to help with
testing and reporting by the time Oct 2023 rolls around. :)

Let us know if there's anything else that we can do to help.

Tyler
