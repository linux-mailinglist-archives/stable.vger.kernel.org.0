Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 539FD510E7F
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 04:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242345AbiD0Bu6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 21:50:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343746AbiD0Bu5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 21:50:57 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8F8049F17;
        Tue, 26 Apr 2022 18:47:48 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 5D68D5C016C;
        Tue, 26 Apr 2022 21:47:46 -0400 (EDT)
Received: from imap49 ([10.202.2.99])
  by compute4.internal (MEProxy); Tue, 26 Apr 2022 21:47:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        sladewatkins.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm2; t=1651024066; x=
        1651110466; bh=1EqF4Kf2tXbvxOf+HEU2PJ2lhOfS0Kbjd2UlZLRC5uo=; b=w
        dGk3ZtC7dQCgTkXuaaQ7YCHh9drwls9PnXZAhEaaix4EWZ1RVz784AHJCwW4PyiI
        vwjlU9YT3G5QctrvIiKfS1n8nQWJ7emY9PN6u11RJaip+HwOo49E8OzMp2GRcizo
        VtfRF/NRR2KpzF1ZTF8LWHfsB+ZSGSpbj/tG0gOVApm6GCbeEhJiW5371hPtrag6
        V+g3SDdz7lHpwCHa3VrbaNMOCq65oq270qVPJ14kz7Ngeg4qYfv+Z1MieSxFlC84
        /Ke8nE2/Y7QngeORMkYd1Iwt+C9ArQ3yRYX+bCAEtuWkM+w4XxJmnW9865+7Qfn5
        GNw0zYHZql5Npk7QfKY0g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1651024066; x=
        1651110466; bh=1EqF4Kf2tXbvxOf+HEU2PJ2lhOfS0Kbjd2UlZLRC5uo=; b=x
        +bgVrtgB/ymEM+EbQEzkKtLXWsftCmrUw9wTeIea5zfN3cpUG80q4rmFzmvjmRVb
        tUx3QID3v7GIIuqP2AvVz24roImCY6fnnwAgo0CVqPKRgCkmL0k1MhB6qfqAztFQ
        8UJT6HVh8HNkimppxF5ZmiAQGoCJ1IJYtu15alddsgbhDc4UJtyuIYtHDMzwFVCv
        Roadj6pDwrr2bguE2E9v0DpFlsILNZB+fuwy80Ka8Pv2AZ5ywxK26ZFmUKi5iylV
        CNAB2Ubmg8zrXPjXTABWY1i1X20rO6L0njJJwbSVFWHxGJOo2mIqWOhmDfBQyBG0
        tdCVcTUiXfryw9cEWd4BQ==
X-ME-Sender: <xms:waBoYudUehYEtPJRnxMOiTiZea4H5FAhPwYJK_WjGwt_wJJTXxkl6A>
    <xme:waBoYoPMR1kQguFEUA1nRHiLjmQ7wIeCaVktCmBmBeFHRL8pE1hUxONawwA5E5Obm
    OAOynplLC3597Pm_ao>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudeggdegiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdfulhgr
    uggvucghrghtkhhinhhsfdcuoehslhgruggvsehslhgruggvfigrthhkihhnshdrtghomh
    eqnecuggftrfgrthhtvghrnhepjedtjeffgeekueegteefudegfeekteetvdegudfhuefg
    hfdtteeigfeggfelteeknecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepshhlrgguvgesshhlrgguvgifrghtkhhinhhsrdgtohhm
X-ME-Proxy: <xmx:waBoYvgddJ_VegaM07Za5EN2nJvRh0dSfAIxqUz3z43fuUjAJdFm0w>
    <xmx:waBoYr_-4Cx5DLm7Zs9jrHO7vhCDTWeWBUAVKcWVqi90yLzZfQ7fbw>
    <xmx:waBoYqvVA_d-DpQc_DeCq7Ee2iyIlSpbuFruS6HZQzOgjy2IkrUmfg>
    <xmx:wqBoYrkoh0GkHe1VovHlx7q1ZCUE2hEKtDxdJZYHozx3cuoDvDQMow>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id BE93815A007A; Tue, 26 Apr 2022 21:47:45 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-569-g7622ad95cc-fm-20220421.002-g7622ad95
Mime-Version: 1.0
Message-Id: <6efc1cb1-3aa5-4cd4-b33e-13d5aa792855@www.fastmail.com>
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
References: <20220426081750.051179617@linuxfoundation.org>
Date:   Tue, 26 Apr 2022 21:47:45 -0400
From:   "Slade Watkins" <slade@sladewatkins.com>
To:     "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Guenter Roeck" <linux@roeck-us.net>, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        "Pavel Machek" <pavel@denx.de>,
        "Jon Hunter" <jonathanh@nvidia.com>,
        "Florian Fainelli" <f.fainelli@gmail.com>,
        "Sudip Mukherjee" <sudipm.mukherjee@gmail.com>
Subject: Re: [PATCH 5.17 000/146] 5.17.5-rc1 review
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

On Tue, Apr 26, 2022, at 4:19 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.5 release.
> There are 146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 28 Apr 2022 08:17:22 +0000.
> Anything received after that time might be too late.

5.17.5-rc1 compiled and booted with no errors or regressions on my x86_64 test system.

Tested-by: Slade Watkins <slade@sladewatkins.com>

Cheers, 
Slade
