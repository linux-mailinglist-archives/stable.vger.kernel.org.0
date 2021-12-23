Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 938A047E172
	for <lists+stable@lfdr.de>; Thu, 23 Dec 2021 11:29:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347711AbhLWK34 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Dec 2021 05:29:56 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:44155 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347617AbhLWK3z (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Dec 2021 05:29:55 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id C1EFC5C00A0;
        Thu, 23 Dec 2021 05:29:53 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 23 Dec 2021 05:29:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=turner.link; h=
        references:from:to:cc:subject:date:in-reply-to:message-id
        :mime-version:content-type; s=fm1; bh=c0dEb8Sd5IRaAHS6zzm6qJ/RcQ
        uh4nx5B28r+1eovHM=; b=u/Jl0vPFrrh8swbdKLXp3+SGm/o16Hxf7zHIMRV/Jd
        5uoQ4iXO4S/lT2DvurODfrNuA+PuKOYqftmtJScDwuirNNtrXBiFsn7857k37pPr
        Nlf4XzMdh9Qde9Bu8AwrpYgBUm3co80U1I/7TVPA1YjWHWNwZ2Ic0CCAwFprdUlE
        q1eGxe9fZNwGO6yF75N3T/nhUczL2squbvM9tmkKZCsCrBDmUgEVx/3+V2LDG5Yv
        yUYAf4J5BZElq/tHXVwoaHwSgSIY/MPExmA2gNAbCKtsdUtK4nNs1649RmZ+23z+
        hHPEDHK0WMFXCETzrE4y3OKAVTbZuoBswKKRaCewuMiw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=c0dEb8
        Sd5IRaAHS6zzm6qJ/RcQuh4nx5B28r+1eovHM=; b=m0xq7MGgQiB6EC7oFKZMVu
        gS6NIzvSJ5wxEcWjHIYYGJsNseCDgcTVQmi9pfPCcSlHa5x81t9o8KyIa14qVOnE
        TEYINFiie+GXXL/pGvDPN/G5tUEpvFXopSNs8EQ3qV3R4rJDnfI2uh/t2q2qmQrP
        Kcj83tRPn35JuCev4l3URLYRPLqivx6jOqeIqxfP78EHVBmkDvuTjKRfubzWfT0y
        Mjx0ddfwy/XC9RA9Ga07zcV9XbalB+UtTU02pFFOfoiCAX8OPPKcj/yA4uLFhJQm
        uigG7tpjGDeK2jefa2gG7c9fshob9w2P0edVwt71L5DbSSx9cjM9RwrkRKBR6MyQ
        ==
X-ME-Sender: <xms:oU_EYbKohGWo2lSHiU6zkbsmkesONZwRpQn0zPfBRSKoJ3MrPi4sPA>
    <xme:oU_EYfLbGZGFEzi-kuDznWOM5T9woqx6md1Th5p1U9sdqkrcWZXu4LkbI75jDvqRb
    wPaYGdHUmHMoeAOJg>
X-ME-Received: <xmr:oU_EYTtqFpq6EHLTn3E13oxl2g-UCvaopuYFfj4jxJBGWO1AI9jvgxoCjho3SBGd59magDKgBHCpwV-1sI0JjuKlkyk9I_ELE4I>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddruddtkedgudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfhfhvffuffgjkfggtgesthdtredttddttdenucfhrhhomheplfhimhcuvfhu
    rhhnvghruceolhhinhhugihkvghrnhgvlhdrfhhoshhssegumhgrrhgtqdhnohhnvgdrth
    hurhhnvghrrdhlihhnkheqnecuggftrfgrthhtvghrnheptddvgfekheegfedtleegjeeu
    leetteeugfekleffkefgjeekgffguefgteejgfefnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomheplhhinhhugihkvghrnhgvlhdrfhhoshhssegu
    mhgrrhgtqdhnohhnvgdrthhurhhnvghrrdhlihhnkh
X-ME-Proxy: <xmx:oU_EYUapQxzaYi6H7yt-TqJ17SFEQR3L7kppUbMDixQMDrygQuSeHQ>
    <xmx:oU_EYSa7r8_DDbTuwREH92e3h-sqViJdHtgtr12zz0wI8svwsMdhMg>
    <xmx:oU_EYYBv5UufBe397e7fMJUf8uftA7cvdLl42tNMddndatXbBisZbw>
    <xmx:oU_EYa5GWmedpvxfAO-4KDbrhZqYEX-pUA82z0drg3yxzEvIAKT6xQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 23 Dec 2021 05:29:53 -0500 (EST)
References: <875yrgf05r.fsf@turner.link> <YcQfil1zb908p2hs@kroah.com>
From:   Jim Turner <linuxkernel.foss@dmarc-none.turner.link>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-input@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] HID: holtek-mouse: start hardware in probe
Date:   Thu, 23 Dec 2021 05:26:09 -0500
In-reply-to: <YcQfil1zb908p2hs@kroah.com>
Message-ID: <87lf0b397j.fsf@dmarc-none.turner.link>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> Thanks for the patch, but isn't this the same as commit 93a2207c254c
> ("HID: holtek: fix mouse probing") in Linus's tree right now?

Oh, I missed that. Yes, that commit is equivalent to this patch. I'm
sorry for the duplication. Please disregard this patch.
