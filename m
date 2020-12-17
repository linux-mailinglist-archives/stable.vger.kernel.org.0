Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE772DDA2D
	for <lists+stable@lfdr.de>; Thu, 17 Dec 2020 21:37:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728966AbgLQUgs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Dec 2020 15:36:48 -0500
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:41185 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728174AbgLQUgr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Dec 2020 15:36:47 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 8926061D;
        Thu, 17 Dec 2020 15:36:01 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 17 Dec 2020 15:36:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:in-reply-to:references:message-id
        :mime-version:content-type:content-transfer-encoding; s=fm2; bh=
        t45ozTPrybNr/M6UAAkmifuRs0gYvsMvaHr/n/mLT2I=; b=Z7teO4R3T3WPJTpG
        8xk2fDEqmAw+IwuFi/TBmMSi+AMevjqsYeXg1JmF6geHZJ2pGot5vOa+juqsQwSa
        CXK2ftWdIf9G6Xk28/f3nCWGOrx0RlONUnpnBcDZ0eMQyGKMk5ADL/4wrn9chuZ6
        wpL8QuqF6osNYVvU3rU3WXJAjVmufksPcxPzkLU9dDl1tAiHp+ImpyKfYGkyiopp
        ja93y2kNmodPQWtPRiPQ2JlBdoJ0F8+2zwjfEecL7PwRq9ZwHRkdaLCswoClMebv
        0IsBj4KHNThWGgUGEAfl/9jTujz8Os+8OGWsbjnU26xjEsKRmZIkmy0L+1YnVQYx
        DRiwiQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=t45ozTPrybNr/M6UAAkmifuRs0gYvsMvaHr/n/mLT
        2I=; b=iVLkFi5Q/Bn+3ECOoCstXXeQ/TPXFMFInTj8dizz1k7CUuL9P/SR7BiaH
        Iu0U5YaQmuAHTjiaiFUXgM9qSxZQxh3ndORX5NangGecikL6U0XV/CkMWm6wKRiv
        7Gm57mgAz0DwjJ6hbOeQHYm2Vqfsp5rAp2Zvew7oT3PeG5rSTT+oBZEQNSmjFwXd
        zPit0fb0Jejxvz5W6s3Mpb+q8ICXs9M0RmdjUyXXEcrqlbssTr0URPUSqKkAagGO
        wf+gcfq6M2eRlH+8sGGXFlzXvUxcu1/bWmN8uQ0xflZ9P5lO8OV5vpINzzkqbhMW
        wyw3xPL7KQKVrwu79GpJGZ61h6cGQ==
X-ME-Sender: <xms:MMHbXwoKB5NFgQL6oJ0uC8GYwCQmrkYBRLe9Os5zmomaZIfGN54J0Q>
    <xme:MMHbX2peMiIX0IltVOpNTSWbASfe1y8mzPRC1tFaPNOm76Nh1AxF5WUVwUXN8vjhA
    lb5Rxz6dh90oA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudelgedgudefhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvufgfjghfkfggtgfgsehtqhhmtddtreejnecuhfhrohhmpefirhgv
    ghcumfdqjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepie
    dvudegfeehtedvgfffgfdvfeduhfehleegjedvveekvdegteegleffieeghfdtnecukfhp
    peekgedrvdeguddrudelhedrleeinecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrg
    hmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:MMHbX1PHXb3DTEHb-BfBEVQOLI6mrAhYT5cbEuUQlBGP7KrLPHX0uQ>
    <xmx:MMHbX37caeER4Z6ylswyjkrq5zfRzUkhY5D5D-WBe-IL0yNGUx-3Qw>
    <xmx:MMHbX_7Zl9oPmvlZlXkcRmwj66IUEM3-lhx7d2tXOTUj4ly__OiNpg>
    <xmx:McHbX_HoeH4EeNUkiGoZ1EHJ3VZT4VGkaIbKZVxQgI5JjZ7U7d6Emg>
Received: from [127.0.0.1] (unknown [84.241.195.96])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6EB6024005E;
        Thu, 17 Dec 2020 15:36:00 -0500 (EST)
Date:   Thu, 17 Dec 2020 21:35:57 +0100
From:   Greg K-H <greg@kroah.com>
To:     Young Hsieh <youngh@uber.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC:     x86@kernel.org
Subject: Re: Question for AMD patches
User-Agent: K-9 Mail for Android
In-Reply-To: <83E7490A-EFB0-42C2-BD9D-B5E6E5BF440D@uber.com>
References: <1B44E762-F9F2-4E2B-BFEF-6F032BE8841E@uber.com> <83E7490A-EFB0-42C2-BD9D-B5E6E5BF440D@uber.com>
Message-ID: <B23EF613-CE1A-482E-8AAE-7AB6FBA8B1D8@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

What exact commits are you referring to?

And you do know about the rules for stable kernel patches, right?

greg k-h

On December 17, 2020 9:05:45 PM GMT+01:00, Young Hsieh <youngh@uber=2Ecom>=
 wrote:
>Hello,=20
>
>This is Young Hsieh from Uber and currently I am in Uber infra team and i=
n charge of server system design=2E Nice to e-meet you!  :)
>
>We are working on AMD Milan platform with Debian, and notice there are so=
me patches for performance and security improvements, which are not impleme=
nted in LTS kernels (4=2E14/4=2E19/5=2E4) yet=2E On our side, we prefer to =
use the general LTS kernel release instead of a customized kernel, in case =
we will not align on major fixes down the road=2E So would like to know if =
there is any plan to backport these patches and if so, what is the timeline=
?  Thanks a lot again for any advice=2E =20
>
>Cheers,
>****************************************
>Young Hsieh
>Uber Hardware Engineer
>****************************************
