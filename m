Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01FAE4BEBE2
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 21:33:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233732AbiBUUdV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 15:33:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233766AbiBUUdO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 15:33:14 -0500
Received: from new1-smtp.messagingengine.com (new1-smtp.messagingengine.com [66.111.4.221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56D44237CD;
        Mon, 21 Feb 2022 12:32:49 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 9FDC25801C5;
        Mon, 21 Feb 2022 15:32:48 -0500 (EST)
Received: from imap49 ([10.202.2.99])
  by compute2.internal (MEProxy); Mon, 21 Feb 2022 15:32:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        sladewatkins.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; bh=NED4cOpv9ehxeL
        floDZ2z4NkG7N66dYY5ssaAAMsdKA=; b=du7kcJj9nxtlaZuO7iaB4rOfCnMlvn
        2z8yhwdWkrI3UDNhxbg2Y67c89zEnXz4vKszlMNjO2yBgo84Yus9H7Q6dWB2P0i5
        y/SA4Xc939Tu8QidxqZwBSZ029WXIZO+lpv0QwpE/LkbINS5V6r8opEaqWPGkTj3
        ggoS0bhGvHtFdFDOrP3A99DuHvDUhGfoMkYKaeoZiVIlEQzPp7JAb6oWAte0VjiT
        z/19S9UabJn5bsks05U9+lyiFsZr+lVHWBOIS0AiL/3SOT0B6XFmEhGgL4KPyFUF
        EucQf8jhSIsfeiKUACgGzL4o0oeKye0X5z7ZTgq5X84guGMtjZIau90A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=NED4cOpv9ehxeLflo
        DZ2z4NkG7N66dYY5ssaAAMsdKA=; b=QYNfdCGSAw+/5+GgD0r1NXvE4k/m0XCI4
        mbv0P17Yx35W/tArs1ROndkBq7TjwEdZ9PR+4ZMVPtowI214iTOSPMFR8SuNCA9N
        Hj2E2yMBiIrtKQk/Xp6h45Y8C971XKt2Lotf3ghr1n9dKid3OuQR8f6z/NiLbZok
        4CwcEp8jQ6/2J7BqsZdLt4xfx5zQAP4cswfB3N3h24CyIGUKPoI8sQhsf/YTNDMC
        w/0XVZCVW0G/uXGL4Y65k84izNJamBKBhHfBLBiM3QMZv5f07VGfeLvftl69kZqO
        h1H7CXSSHV/hxXVXwHC5fEY4/pZxtZQWJpTMdwLgoWnbBi8o97ROA==
X-ME-Sender: <xms:7_YTYrZhQ2Vcxy6ouE0t8V5Zu1ElEUbxSFWGTxA1RuMi-Jwar99Vqw>
    <xme:7_YTYqY6ONfAv4Taf4WNsdCVd00NSXfe5gIsNqkueShFmL-PF2dGaWRXKD8nSE06-
    l_AwPJgcQhsGWqB9AI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrkeeigddufeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvffutgesthdtredtreertdenucfhrhhomhepfdfulhgr
    uggvucghrghtkhhinhhsfdcuoehslhgruggvsehslhgruggvfigrthhkihhnshdrtghomh
    eqnecuggftrfgrthhtvghrnhepueeiffetjeeitefgveetleehveduheetiefhhfethedt
    teelgeettddvvedvudegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepshhlrgguvgesshhlrgguvgifrghtkhhinhhsrdgtohhm
X-ME-Proxy: <xmx:7_YTYt90CiRlz2kjTJRYRJoIbgZNixuGOZhRu8Wfl5hNUZr7rW2mNw>
    <xmx:7_YTYhqJ6yH7jQS7z-X3YdY2cJfMJrlvzkqwSgWuJsuYLYb-CFPlBA>
    <xmx:7_YTYmqAsjoaC22sscS81Wo92L_J_y5E9-oZX9WGfHWMgadpyLLKEw>
    <xmx:8PYTYjgBwsxvY6UKBj1Rg-A2gDofx2h9Y2nEuwgElUthlU3eFo1m_4vH-f8>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id BB2C3F60083; Mon, 21 Feb 2022 15:32:47 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-4778-g14fba9972e-fm-20220217.001-g14fba997
Mime-Version: 1.0
Message-Id: <6d7d7dfa-69a0-436e-bc2e-75ca1279fd4d@www.fastmail.com>
In-Reply-To: <20220221084911.895146879@linuxfoundation.org>
References: <20220221084911.895146879@linuxfoundation.org>
Date:   Mon, 21 Feb 2022 15:32:47 -0500
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
Subject: Re: [PATCH 4.19 00/58] 4.19.231-rc1 review
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 21, 2022, at 3:48 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.231 release.
> There are 58 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 23 Feb 2022 08:48:58 +0000.
> Anything received after that time might be too late.

4.19.231-rc1 compiled and booted with no errors or regressions on my x86_64 test system.

Tested-by: Slade Watkins <slade@sladewatkins.com>

Cheers, 
Slade
