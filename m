Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8194C9E24
	for <lists+stable@lfdr.de>; Wed,  2 Mar 2022 08:04:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239755AbiCBHFM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Mar 2022 02:05:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236778AbiCBHFM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Mar 2022 02:05:12 -0500
Received: from new2-smtp.messagingengine.com (new2-smtp.messagingengine.com [66.111.4.224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5C10B45A1;
        Tue,  1 Mar 2022 23:04:29 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 26C165800E8;
        Wed,  2 Mar 2022 02:04:29 -0500 (EST)
Received: from imap49 ([10.202.2.99])
  by compute2.internal (MEProxy); Wed, 02 Mar 2022 02:04:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        sladewatkins.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; bh=RafBy0HW/Qzoaf
        IfGY0Gc5STkJdoba8El0nyWB0t0vo=; b=A/96WBVXd96qqREQk1WVaezBBC/r+Y
        /pUgV2tv34ovFaoCUhGeovyXTyvB8gJfU4Z0v5sogMsIJb5tz6aG4b+7/nfGFEos
        lple4E1Y7AUOAPB7XdOnKBnx63CiSMdtLXEfIq2Y6HFj5FO4gjQaISV9a5bRitN9
        ZJx4DwjN/veWUpJZzyHx24lwIOiA8Bwx9otsE+WPR5Uc5uH8ChJHjkb/AKDQaHU6
        ySY3qmnpMkjdBEXCSOfel+a3RDt0V+Bl385YYzp7bQDsjcISNWMzQ+HNxaxLxiZk
        8b1OWdWSZj6SrePbYXlUKaPMEMu7b3+tIhMajkDk34jpvnKTwWFcVrFg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=RafBy0HW/QzoafIfG
        Y0Gc5STkJdoba8El0nyWB0t0vo=; b=Z5xfqhKoAYqyD9KJCYePGxGOaBX57Kphz
        /5G/4NJsB1NVvsCFUW9flaMIVM7/qgKt8icXoDUdyVNWH9Gl06UQa+9xL3XBrmY/
        Nmlid1ndk0mIdMMHa4nViQMQtyqz8BqYpvKW5HQ3VyY4lVr910csMhHr9WIaxkdi
        y0qlLaUEYwRrLDgOyBHTMw6JU++ZVuhEKnZDHCLBcETzr7saJkUdLGU3Pd3kEwAW
        DgUPS6Ry709RSw18GS1wu4PuIK+94tCgcOf+FRNJ20o+yhPLA9MT1vOtKW6fuPW3
        j/75ukLyh4PSQkwQeE5takjACvlOovb/6SkjIcx1H1N+nm1hkOI4A==
X-ME-Sender: <xms:_BYfYrysPuGxpMfJo3NL2MepIxXrxdJ3nztZlTxKOH_vN526aWBofQ>
    <xme:_BYfYjSQJsQMkNXy2G5mf7qPbOIKZDfPlMEmQKudZVvbYpOibGJ_3snxicc_ZoEt3
    b5huD4Yv1Ppt_130YM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddruddtfedgleegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvffutgesthdtredtreertdenucfhrhhomhepfdfulhgr
    uggvucghrghtkhhinhhsfdcuoehslhgruggvsehslhgruggvfigrthhkihhnshdrtghomh
    eqnecuggftrfgrthhtvghrnhepueeiffetjeeitefgveetleehveduheetiefhhfethedt
    teelgeettddvvedvudegnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrg
    hilhhfrhhomhepshhlrgguvgesshhlrgguvgifrghtkhhinhhsrdgtohhm
X-ME-Proxy: <xmx:_BYfYlV2SilgZV00de7-7tE0hAeRUhGk5uIvxw14P5DDG9ZxPE7ayg>
    <xmx:_BYfYlgsRIye_Tyhhfv2t8EsYYE-Kd4S_86UHkD6xXc_NZrNQAq0Sw>
    <xmx:_BYfYtC1QWalZSlcBI91ZXoFboa6HUrNQuxL5OLr3Mkkgu_tXRlaRg>
    <xmx:_RYfYh5cwWzDk6sHsViPPS-YTrsFVf_vaNVJwohHqKdVGFyQYqjwdkznqm0>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id DD31BF60084; Wed,  2 Mar 2022 02:04:28 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-4778-g14fba9972e-fm-20220217.001-g14fba997
Mime-Version: 1.0
Message-Id: <1d819f61-c2d3-474f-88b6-e1b8886a1c6d@www.fastmail.com>
In-Reply-To: <20220228172311.789892158@linuxfoundation.org>
References: <20220228172311.789892158@linuxfoundation.org>
Date:   Wed, 02 Mar 2022 02:04:27 -0500
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
Subject: Re: [PATCH 5.10 00/80] 5.10.103-rc1 review
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 28, 2022, at 12:23 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.103 release.
> There are 80 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 02 Mar 2022 17:20:16 +0000.
> Anything received after that time might be too late.

5.10.103-rc1 compiled and booted with no errors or regressions on my x86_64 test system.

Tested-by: Slade Watkins <slade@sladewatkins.com>

Cheers, 
Slade
