Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 587254B1743
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 21:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344435AbiBJU4A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 15:56:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344434AbiBJUz6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 15:55:58 -0500
Received: from new4-smtp.messagingengine.com (new4-smtp.messagingengine.com [66.111.4.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4E5210A7;
        Thu, 10 Feb 2022 12:55:58 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 33A3F580228;
        Thu, 10 Feb 2022 15:55:58 -0500 (EST)
Received: from imap49 ([10.202.2.99])
  by compute2.internal (MEProxy); Thu, 10 Feb 2022 15:55:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        sladewatkins.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; bh=m5TshRHH2Zkb56
        uKE0sI6BuvJjk25Bn2vuq8TwyhHyA=; b=POg7NNkSzNbqXmgwdId27pvUo2TRTM
        /GFn61yRgmo9XSyBL3uJ1/+nVPL+WOnlyzh61VHHxXyqJntLihXDg/obIkOSIL97
        G2DBy3d/Kq6gLBhchj4r2eUbRCom1ySbSMCHSvG7+HAFEk0SNlZrJn6bnZE66CdW
        zhVYikugvVuZFHcU71OwsmtdJ5dqcx6/66G50kuGefDcSJGu1C/sHDXhj8dwSa6U
        M3C0c9VXVeZVHnPPAuoENTiiR7Bn9rl9YailKgHCK4sE2zTMVm9R6nUvHdOi3AyE
        FJGInHVP4OZAI9lWtbtqXrXeHhljhR9keZyDK92HEQf1ZhQnbV7x2xOw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=m5TshRHH2Zkb56uKE
        0sI6BuvJjk25Bn2vuq8TwyhHyA=; b=WWqXclirexBU0SOBHvjGFccccLCeueVf3
        nkD3e51ULi+vncypHzQeJz14l/103MXyBG7E0gj8D29BW4WbHrFpBauB1YChNXXY
        ocSZz2bU9e6+ShTUODfYr/D6OY5DmIeL+h5OEjGcNYI7+DiZKooYhoGUSrWvjkVx
        YHn/LwVFzlwxvfbe7z76BcVISMSA+0QV9Mb+3n0ZLKPEhQRyjyRhLPWPEVUryDQj
        WJGxSXTv+JAI6/ikNpVRP9LnkKPFjwuFwkrN8KJmnWjawNvCY59/g5iRsf/tl2zn
        5/0h+/wrb3Kn2/JEpCH7NyGp0SCSaHFnwWDHAUpg3g7LhTr159oIQ==
X-ME-Sender: <xms:3XsFYv1Ee5gyoFsEDJt_eyAzGY1aUm6mn6HgSYyTV7Dm2n6gUoNlQg>
    <xme:3XsFYuHJqfNaPMdlz-UD6rz1dytJZlhzclAyUu4dqA-fibejIX1zSH0NUMQFvwAeG
    BIUjTHqBFn8h9xmjus>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddriedugddugedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvffutgesthdtredtreertdenucfhrhhomhepfdfulhgr
    uggvucghrghtkhhinhhsfdcuoehslhgruggvsehslhgruggvfigrthhkihhnshdrtghomh
    eqnecuggftrfgrthhtvghrnhepueeiffetjeeitefgveetleehveduheetiefhhfethedt
    teelgeettddvvedvudegnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrg
    hilhhfrhhomhepshhlrgguvgesshhlrgguvgifrghtkhhinhhsrdgtohhm
X-ME-Proxy: <xmx:3XsFYv5yd3uxbrzbNI4GaOQ1jnFof-kyPCY56ncETYF5UHQR-fTGNw>
    <xmx:3XsFYk2WN24BSAZezqwbPelT7nXLpONKP_KM9VUzvJnzeY-16poNqA>
    <xmx:3XsFYiHx82-DvdLRSVFnS0DNghR8yJGIqwLJWxzOhU2gt5R8ubhPjw>
    <xmx:3nsFYq8NLYgUpxNxG6Qvw3yaqVgr-XXVFPCF-iv9705NU7Na26xaiI8ysOE>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id D9A9DF6007E; Thu, 10 Feb 2022 15:55:57 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-4748-g31a5b5f50e-fm-cal2020-20220204.001-g31a5b5f5
Mime-Version: 1.0
Message-Id: <1a70ada3-d400-43e6-80ca-94fff4407fc3@www.fastmail.com>
In-Reply-To: <20220209191247.830371456@linuxfoundation.org>
References: <20220209191247.830371456@linuxfoundation.org>
Date:   Thu, 10 Feb 2022 15:55:55 -0500
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
Subject: Re: [PATCH 4.9 0/2] 4.9.301-rc1 review
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

On Wed, Feb 9, 2022, at 2:13 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.301 release.
> There are 2 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 11 Feb 2022 19:12:41 +0000.
> Anything received after that time might be too late.

Compiled and booted 4.9.301-rc1 on my x86_64 test system successfully without errors or regressions.

Tested-by: Slade Watkins <slade@sladewatkins.com>

Thanks,
Slade
