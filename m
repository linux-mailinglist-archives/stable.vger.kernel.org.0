Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5981E4C9E28
	for <lists+stable@lfdr.de>; Wed,  2 Mar 2022 08:05:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231935AbiCBHFu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Mar 2022 02:05:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231864AbiCBHFu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Mar 2022 02:05:50 -0500
Received: from new2-smtp.messagingengine.com (new2-smtp.messagingengine.com [66.111.4.224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D10C4B45B5;
        Tue,  1 Mar 2022 23:05:07 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 40B75580165;
        Wed,  2 Mar 2022 02:05:07 -0500 (EST)
Received: from imap49 ([10.202.2.99])
  by compute2.internal (MEProxy); Wed, 02 Mar 2022 02:05:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        sladewatkins.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; bh=Y9cg5yFJmjEqXh
        nbWcKhPYXX/6jowEUPalG3oQ3UQWw=; b=oDc3mAqmjs0bfYoiBnE/dgbLcIte+v
        wRVfucgXVsoJIyz/IvzzcInK4u3pk0PQWirr/ydR07JX0mI9vGjKnaWAm/nC3zXq
        1xTl67l/SVjdUzP9vAvsTClO7j1zJOcQsIfeN2LQ0mm3eRL+A2fJK0tZmm1j5nnx
        fTMYAR/eaB8hrQ1DtMS42K76kOOtgOnLgTBi/JfmolE13pqQrCG4c4A/EVI6G/JO
        3apaW3/RkbVHNW9fE05HnvHn3Yf6KWJMf1PEA4dcde65aS8M7JYZwuS2+MoxDdW5
        03bQBj6BkHgYqjgRr5VJzkfyh87h01nCYCWfqlOVXOGgxz4JPzLQJUFQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Y9cg5yFJmjEqXhnbW
        cKhPYXX/6jowEUPalG3oQ3UQWw=; b=WAHvkqtMRpyXp/8lf/eXf5MRzEZdrwEDE
        Mo+3WpPJLEk9EjmjW3XiywFO4Xi8PwecSYHZRrY449L2xxzxt1BBIjv6mN1mwSUh
        rQ9RmobCVDfJTjylz4nRCEKuollFnKIFAiUwY6KjOHnabuXD/CBLrNqx0kelTkbb
        NaxMHTrdHXImCW/8zEk7Ul6JhPDrE2CD5qn1PWNQkPKpZ1u9FDQr0hHajGvUhiB7
        qs0sHA2leH9v/ZlUhgCMBmUtiG+m0KCPRBKGhD+8goPuM5/skYa8Tw5f/9qiaTks
        4gT+0Rz0WPbJfqGeFykD+D+1Ku1iJ+ok+dVLAbvx/t1jL9YbPzwCg==
X-ME-Sender: <xms:IxcfYlxx5dacEeJ5r-nZn8-lBobjOR6iWcnTDtm0HnuUj_0ZVp-QRw>
    <xme:IxcfYlQIUDRFqjixZ625_MwdZdRGaBfbJT4c65Ta_0OH9M7O8fXL2VTKpAfY4aUAo
    iOKH92L1dTt_4jpYok>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddruddtfedgleegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvffutgesthdtredtreertdenucfhrhhomhepfdfulhgr
    uggvucghrghtkhhinhhsfdcuoehslhgruggvsehslhgruggvfigrthhkihhnshdrtghomh
    eqnecuggftrfgrthhtvghrnhepueeiffetjeeitefgveetleehveduheetiefhhfethedt
    teelgeettddvvedvudegnecuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpehmrg
    hilhhfrhhomhepshhlrgguvgesshhlrgguvgifrghtkhhinhhsrdgtohhm
X-ME-Proxy: <xmx:IxcfYvVbX6p-TGmwW115bhIBW2lLR-GNaDu3iipYPVGMeiOeNkUl-Q>
    <xmx:IxcfYnix97eBRAQjDYlYndff7UZp2F2BEyAA6LeSaCx_r3q7_1LKdA>
    <xmx:IxcfYnAkzMRgc--Kc8ycWN_LavD1jWALZrpdBTsuTDH8MrKggXiLGQ>
    <xmx:IxcfYr6yRKNklcR61RbYUQcov9lOo3rVSt2Ueg4rr_NdfgaxT_5M5gWreSM>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 07DD0F60084; Wed,  2 Mar 2022 02:05:06 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-4778-g14fba9972e-fm-20220217.001-g14fba997
Mime-Version: 1.0
Message-Id: <08c6fbaa-f3ed-4606-b7f4-3eeae19fbabb@www.fastmail.com>
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
Date:   Wed, 02 Mar 2022 02:05:06 -0500
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
Subject: Re: [PATCH 5.16 000/164] 5.16.12-rc1 review
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
> This is the start of the stable review cycle for the 5.16.12 release.
> There are 164 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 02 Mar 2022 17:20:16 +0000.
> Anything received after that time might be too late.

5.16.12-rc1 compiled and booted with no errors or regressions on my x86_64 test system.

Tested-by: Slade Watkins <slade@sladewatkins.com>

Cheers, 
Slade
