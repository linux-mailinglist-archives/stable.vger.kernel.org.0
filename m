Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12A374BEBD4
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 21:27:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233668AbiBUU2D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 15:28:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233677AbiBUU2C (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 15:28:02 -0500
Received: from new1-smtp.messagingengine.com (new1-smtp.messagingengine.com [66.111.4.221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93C16237D7;
        Mon, 21 Feb 2022 12:27:38 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id A8B3158028F;
        Mon, 21 Feb 2022 15:27:37 -0500 (EST)
Received: from imap49 ([10.202.2.99])
  by compute2.internal (MEProxy); Mon, 21 Feb 2022 15:27:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        sladewatkins.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; bh=+U+4b0s+qEhQ/L
        rJPfrLJfFcrW4ZOXE562V36EJMYCM=; b=kbXRtnfrD1asc0hvQlgv30/gQKrIX2
        DS36SVtDCiuy+PCXqzt3S7LiO///Yc4lI+2nInFoFPTo2oK9nJhYwTU/MSoxV3bS
        OjvoEd+x9SWBHQ/ShmGP+OzukUHa8ImrOAxe4DhbcYm2C7bDHGQTOpdjy01ZWYi7
        021LJ+Jd6MGolKSK7EqvhDLEYs8mDHYhFLq6yEkKzUAdf67zYYWA+k/hp1JprXoB
        lS9MjEY17CIdGG8RhAraTmcaTZy9Joga4fUMk+URADzToah2LHfNvlnN1uobthwq
        9Lxl/VYG7wugT6MTOWwWMkWdpC6990YBc/Nyy3LhQP0H6fMQl0Mg20qQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=+U+4b0s+qEhQ/LrJP
        frLJfFcrW4ZOXE562V36EJMYCM=; b=Yk/3tPD7KtkZcmNpVPLuUPKpwH1Pd4vJN
        wR5+0T2gP369+XWEKclTFAU92gn4UhDZm5Gl4sTAhoEK+SMYGfTSWLO/gUF6bP4e
        yxOds2Uom5y7CVmGO/OIJmHvtIHtQbXwacZXMBfk5pSscTaDmX/DpAMF7/RfUbe9
        eiK5GCqXaXalPmBlWG3/AHtNCzhCuUWmPO25XcYSJUsy97sDc2jhx6UroAH9ihFm
        IpGpXJXvoF2tHe2uCEgcH21wF75POx4EzE2w5SnMYyDqaoOEq738ldbr/jrOkGcG
        jS8i/1gUjAr/paP48T4iYy6RzkXaeT/fC22DMq2m5UH/R+Ky0ZfhA==
X-ME-Sender: <xms:ufUTYj6Yvu1zV5U__79kZxoEUDGaug-fHK3F_-r1xsx1NSDsWN5G4A>
    <xme:ufUTYo6iDNybZsiYSw8Sdw-1JoAeZvnFDULxK5eg8S37ZIE-_3btg8i4LVIlznNDx
    hD9zBxV51qXeUVmiP4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrkeeigddufeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvffutgesthdtredtreertdenucfhrhhomhepfdfulhgr
    uggvucghrghtkhhinhhsfdcuoehslhgruggvsehslhgruggvfigrthhkihhnshdrtghomh
    eqnecuggftrfgrthhtvghrnhepueeiffetjeeitefgveetleehveduheetiefhhfethedt
    teelgeettddvvedvudegnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrg
    hilhhfrhhomhepshhlrgguvgesshhlrgguvgifrghtkhhinhhsrdgtohhm
X-ME-Proxy: <xmx:ufUTYqcitQHvBSRaM1D1ntZx08bTDYxt85Pwqmutigao0VTyPJo12Q>
    <xmx:ufUTYkI3GYD_3G23FQfJxhk437zC-2J5auaRe2pJCIcxTTVe-YXRoA>
    <xmx:ufUTYnKXfZvAC62QmPIAETVh6GhnisNp3O2pkYWBEtp7n9b_C-qiuA>
    <xmx:ufUTYkDqIGbITtdAW7eFeaTnCA7TLeKGabANcj6MU1be2RN8Al9Dshcw40k>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 66051F6007E; Mon, 21 Feb 2022 15:27:37 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-4778-g14fba9972e-fm-20220217.001-g14fba997
Mime-Version: 1.0
Message-Id: <8fe7d542-e831-40c6-ba62-08a9bbbf45ec@www.fastmail.com>
In-Reply-To: <20220221084910.454824160@linuxfoundation.org>
References: <20220221084910.454824160@linuxfoundation.org>
Date:   Mon, 21 Feb 2022 15:27:37 -0500
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
Subject: Re: [PATCH 4.14 00/45] 4.14.268-rc1 review
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
> This is the start of the stable review cycle for the 4.14.268 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 23 Feb 2022 08:48:58 +0000.
> Anything received after that time might be too late.

4.14.268-rc1 compiled and booted with no errors or regressions on my x86_64 test system.

Tested-by: Slade Watkins <slade@sladewatkins.com>

Cheers, 
Slade
