Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 458C64B1E37
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 07:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233561AbiBKGMF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Feb 2022 01:12:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236027AbiBKGME (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Feb 2022 01:12:04 -0500
Received: from new4-smtp.messagingengine.com (new4-smtp.messagingengine.com [66.111.4.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63D66318;
        Thu, 10 Feb 2022 22:12:01 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id EC7DE580151;
        Fri, 11 Feb 2022 01:11:58 -0500 (EST)
Received: from imap49 ([10.202.2.99])
  by compute2.internal (MEProxy); Fri, 11 Feb 2022 01:11:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        sladewatkins.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; bh=7yA6z7PhVzwlb8
        6kW7KqNxkoBU4Efuv/kUiMjX8q454=; b=vBEjPq7fjjLMri8jv2utP4sNqDs7nf
        eaRr/AvBsDOAjyekxRtkEnnKd6XEOOSJzv5FAvA9Tp/CARHWcqiV85pFKDv350gT
        VXArZpexoqezsvaAsCYf9TJfPilZ96UKs9T4cnYsp2wa1YElhIexnaCLbdWHgnyj
        7wtuAEaHp4I92EaMb7pSZ/b5T5Q3durV4BnQpvEEiiMlgF6aBoBcNZsu9Wrd4opt
        PRdY+bNxDwRB4TKZXCTitlBZSAb0AGTNIyp/gA3+0wcRURchcQl/ddHZE6nS0OXe
        3jl0JGlJqIVR1LrRLJB/1TqEjilKMuXUwzpKVrdD60PbcxvdW5IRiisA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=7yA6z7PhVzwlb86kW
        7KqNxkoBU4Efuv/kUiMjX8q454=; b=Ui8rq8S3uc19DQgkNua+nh5vsfDLqGANC
        aBKdJXbQm8Rlh+wd1n9zcw9WBFOzAbvFX86oMv8duyDOHYxtHonDbV2OUL1d/WPu
        8T/m6zuctgsgdxy1fzfyKJQ75qMDrTaqq4jy1HrDbwldODKSZ6xnwjocNSwQY4kz
        7bGiGfv98lHLkxmRu6XOi6rVuQfTCHXYxzF5n67UwW3F8ECqIsi6y8CVjnChrXAS
        KpdfFKNiC5tH1QvNY3rpHN5jzFqKHVnGZRPiqMhyim3YCAZM/tcknB2/y4A0oB+E
        QuX/FcpAohzGI0rCtpW3q+k0vBYzJtOhz4PpGchsUERUQV394a0bg==
X-ME-Sender: <xms:Lf4FYsnbPB5IYMt40e6XKiDTQCtSBIyAPDdWqOjcqyAI2J7dBM4-fQ>
    <xme:Lf4FYr1GosAwk1hk6iFj_RnEq5CnovoIWYkD8OM1NqaLsX8yr5HhEDc-z02R6ERID
    7LtmzM9o-wXYnR99Ag>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddriedvgdekjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvufgtsehttdertderredtnecuhfhrohhmpedfufhlrggu
    vgcuhggrthhkihhnshdfuceoshhlrgguvgesshhlrgguvgifrghtkhhinhhsrdgtohhmqe
    enucggtffrrghtthgvrhhnpeeuieffteejieetgfevteelheevudehteeihffhteehtdet
    leegtedtvdevvddugeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehslhgruggvsehslhgruggvfigrthhkihhnshdrtghomh
X-ME-Proxy: <xmx:Lf4FYqpEQuQSIsikJ5-xFLjy8Amd-ci6eGAcyQoJ58NNtBKxdk_ysQ>
    <xmx:Lf4FYolkg7fgxEg5RcodgrysWnkjafoWT_qEE8oG0J4HOvuMpgM9VA>
    <xmx:Lf4FYq2o1Of5Bsz72a1EeTL_B4OjCH4k61ai77hbjyexwrbibnRXMQ>
    <xmx:Lv4FYjvAGmVWeUuPLW8koYVLHq4tEGvt5D7IeStigxP6EvLmJGuOa63Nr-s>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id CD860F6007E; Fri, 11 Feb 2022 01:11:57 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-4748-g31a5b5f50e-fm-cal2020-20220204.001-g31a5b5f5
Mime-Version: 1.0
Message-Id: <d7fe6305-4f05-4085-8a02-24d4fe46b79e@www.fastmail.com>
In-Reply-To: <20220209191248.892853405@linuxfoundation.org>
References: <20220209191248.892853405@linuxfoundation.org>
Date:   Fri, 11 Feb 2022 01:11:55 -0500
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
Subject: Re: [PATCH 5.10 0/3] 5.10.100-rc1 review
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 9, 2022, at 2:14 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.100 release.
> There are 3 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 11 Feb 2022 19:12:41 +0000.
> Anything received after that time might be too late.

Compiled and booted 5.10.100-rc1 on my x86_64 test system successfully without errors or regressions.

Tested-by: Slade Watkins <slade@sladewatkins.com>

Thanks,
Slade
