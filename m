Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B82052264B
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 23:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbiEJV2O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 17:28:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbiEJV2N (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 17:28:13 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5921A5A170;
        Tue, 10 May 2022 14:28:12 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id BD85C5C01EF;
        Tue, 10 May 2022 17:28:11 -0400 (EDT)
Received: from imap49 ([10.202.2.99])
  by compute4.internal (MEProxy); Tue, 10 May 2022 17:28:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        sladewatkins.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm2; t=1652218091; x=
        1652304491; bh=sywqqE9FtlILNFSlcQzDzh9BmIypW7JhutKYFfhszfQ=; b=T
        ho8lGjFgtK700NnZcYF8cfZhnFIQal9OtiNUG2yCFJ864q5Wq7t/eEQzySlWR1by
        nNDpJ1iUwe0cgHyV+5bs421LCDWtgP3P2/TMIxPIhUw01tEdWl8Pc9RGxlgtrbI3
        7FZM7b1uW7VplhxEdy35tu38+Xb4Y6KHvBiM025vziJ6W/rNyIFvQDc5CXZPrbii
        ou+kjjVW/J3rTv6hoYCWgOexi5OjZ0V2k0Objvnv61AQXp5uHWJFHTFy6iL6jL4N
        a9G3Zcx/qyGFO4L+nfklNI2gOQWJ5RsdGMnBANwYv9ACoced3K2ZQScXt/Imzxxr
        U8FmkB7dgFoDHKHmgJwMg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1652218091; x=
        1652304491; bh=sywqqE9FtlILNFSlcQzDzh9BmIypW7JhutKYFfhszfQ=; b=M
        lvpL9wJWvu7QJUqTtPCjj5Br5P4/hX78tj9Hr3SvgXJiyz67kuzKdLIKGojPucQk
        eff+678PftDr1m70yC3zDIBpcT4xWWR+b6IytqOpzkLFamTrt1SXLwRg9e9svyx4
        0N2cu672Q7CUfAKuSpil0txO/NQVMf4pOH68dS2InAUv9qJsxi2NDLJDNVvBJeMK
        hlBxtZznLYT9fmmN20G/2TA4yelToM93GFOMY+rKKLkGo5ve0LKO+4mmazI1hplU
        unR5vVBgbFxPpZUn0Y7Eo0jjhFXYBP0JAsN8Puhi7lFeyAXHnAlizezbsC/bojdW
        uhiM9+SiLTbnWv/eZGVGQ==
X-ME-Sender: <xms:69h6YpNltSiWxQID3HNc3BrnLGHDpLA_p_wVptrFq8p0mKJk6-ZjrQ>
    <xme:69h6Yr9t-LPs5nK34xaY61aCg6_KNvMTNeJCSVQyw7xPio8rpRWIjkEboULPhHXbL
    xNeuSZWvIKkKfkxlTU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrgeefgddvjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdfulhgr
    uggvucghrghtkhhinhhsfdcuoehslhgruggvsehslhgruggvfigrthhkihhnshdrtghomh
    eqnecuggftrfgrthhtvghrnhepjedtjeffgeekueegteefudegfeekteetvdegudfhuefg
    hfdtteeigfeggfelteeknecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepshhlrgguvgesshhlrgguvgifrghtkhhinhhsrdgtohhm
X-ME-Proxy: <xmx:69h6YoSs1Jgu513r2-dnDxrLKyZEtQ0nG-MGMf2wBH19CpARL38WWA>
    <xmx:69h6Ylt4H-yXmefLbLIZyrdmfPdAD5nOl6uJMIsfBSlHChumeqbkmw>
    <xmx:69h6YhfFr-mDRdcdetqVgdFdxf98_6XYIzLEac746n2q-f8If_6ksw>
    <xmx:69h6YiXL_TP6AZZqp_DdRBOeggs_0R7zBTvXQSv50u9csJEY4vdcYA>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id A730A15A0080; Tue, 10 May 2022 17:28:11 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-591-gfe6c3a2700-fm-20220427.001-gfe6c3a27
Mime-Version: 1.0
Message-Id: <bdc18b99-9a75-4481-8875-96ceec5bffe4@www.fastmail.com>
In-Reply-To: <20220510130740.392653815@linuxfoundation.org>
References: <20220510130740.392653815@linuxfoundation.org>
Date:   Tue, 10 May 2022 17:28:11 -0400
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
Subject: Re: [PATCH 5.15 000/135] 5.15.39-rc1 review
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 10, 2022, at 9:06 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.39 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 12 May 2022 13:07:16 +0000.
> Anything received after that time might be too late.

5.15.39-rc1 compiled and booted with no errors or regressions on my x86_64 test system.

Tested-by: Slade Watkins <slade@sladewatkins.com>

Cheers, 

-srw
