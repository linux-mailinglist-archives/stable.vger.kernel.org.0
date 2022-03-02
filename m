Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 832E14C9E26
	for <lists+stable@lfdr.de>; Wed,  2 Mar 2022 08:04:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239819AbiCBHFb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Mar 2022 02:05:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231935AbiCBHFa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Mar 2022 02:05:30 -0500
Received: from new2-smtp.messagingengine.com (new2-smtp.messagingengine.com [66.111.4.224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 647CDB3E47;
        Tue,  1 Mar 2022 23:04:48 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id C304F5800E8;
        Wed,  2 Mar 2022 02:04:47 -0500 (EST)
Received: from imap49 ([10.202.2.99])
  by compute2.internal (MEProxy); Wed, 02 Mar 2022 02:04:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        sladewatkins.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; bh=9mrsQi2Q1hd/hs
        Pq0nG9PGaoutxHLx3FQIr3V593JXM=; b=rCZHJPXkKbakxinLaJAcYPWVp8fuku
        bM1uy/AdTRN/02FXryXSH8i01uGMSM/UwU8tvHXnMbYTmnaSqDHe2Ept0xbIWZxi
        K+V+54KWqpRs2oV5v9I/TLpabTHGM1U9tAgZoneP/CNcifCrBHjSP/7knUwChURy
        fCbYgiEgijkXjfpsuHEpPuzaU/XL4uu4SUby+8OeClZwmf014KKRcXCXRoRC5zyF
        P5k8NO8qZvn0drUAdcfoRI5ZqesWtCjhv06xHYTok/cODOGrLnmHI0v1IlLdv9x9
        /8Fm9Lz37hO7UrPHJQ9GZOp5bHCBUsojXnDCh8sMAUcNdP3ea0dj5VrQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=9mrsQi2Q1hd/hsPq0
        nG9PGaoutxHLx3FQIr3V593JXM=; b=hwTSHFxeUUUMOeH3Lpm9Hq1u952dQmfxg
        07WyI8peve378rjaN/4qzQCEBF7SijSYjWJYchrDLg/TLHr4WYJohECfQNSH8u2o
        hSf6aUD4PAzLZ8i/YCiCtm4SLSukHmP6OjifID/lQPFqIY16ia4R2OXDj0zmJSBH
        iPGStO/lDXB4keDEshOYPJ3nPsp0yZ7QS40HcgnAo5O13I5hEEVEQvnKTagYUHEA
        GVRXgjIURCSyNFRScq7IbhRmImIlitHQWGZ3UmPot6mavUbDx+4dBSzXRcJq/Vw8
        aRDQ3Hu0M26QUcHD7RviRX6QGPvHW4aI0uZCVWPU88DypjB99SOgw==
X-ME-Sender: <xms:DxcfYjYrnJQjL5k2_aeOvo_6MbNCsH-xQz0DVM4sR50Ou49vvqdNPg>
    <xme:DxcfYiYGD4eKc46vHoskpMmejNJ66L9E1QzhrtLsoH3tVPPfjN1lsNSRXjDss3Ic8
    KhP5INo5aB2DHeeLbQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddruddtfedgleegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvffutgesthdtredtreertdenucfhrhhomhepfdfulhgr
    uggvucghrghtkhhinhhsfdcuoehslhgruggvsehslhgruggvfigrthhkihhnshdrtghomh
    eqnecuggftrfgrthhtvghrnhepueeiffetjeeitefgveetleehveduheetiefhhfethedt
    teelgeettddvvedvudegnecuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpehmrg
    hilhhfrhhomhepshhlrgguvgesshhlrgguvgifrghtkhhinhhsrdgtohhm
X-ME-Proxy: <xmx:DxcfYl8aVJfX7TpyP7oAXPER6ikj9n6n-Vj6VnOtOc7vgWpNrbRW4Q>
    <xmx:DxcfYpoA-PSTRM3M-zCpbPwDq8AyF6zoOGV_cWnF_Y8ddTHgzduz3A>
    <xmx:DxcfYuphXnQnwVPRQ7KskQkpRk4FTa_lGMDnQccFbh0evbyN1jBv3w>
    <xmx:DxcfYrhCKfeECouVSDk-5XipiH94h2cgiHHAjpMv8zXierhUzRAd_WdsvA4>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 8386DF60084; Wed,  2 Mar 2022 02:04:47 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-4778-g14fba9972e-fm-20220217.001-g14fba997
Mime-Version: 1.0
Message-Id: <eaad0624-0aa6-4f43-995e-17b67351011b@www.fastmail.com>
In-Reply-To: <20220228172347.614588246@linuxfoundation.org>
References: <20220228172347.614588246@linuxfoundation.org>
Date:   Wed, 02 Mar 2022 02:04:46 -0500
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
Subject: Re: [PATCH 5.15 000/139] 5.15.26-rc1 review
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

On Mon, Feb 28, 2022, at 12:22 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.26 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 02 Mar 2022 17:20:16 +0000.
> Anything received after that time might be too late.

5.15.26-rc1 compiled and booted with no errors or regressions on my x86_64 test system.

Tested-by: Slade Watkins <slade@sladewatkins.com>

Cheers, 
Slade
