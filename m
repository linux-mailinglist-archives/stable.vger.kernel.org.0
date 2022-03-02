Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2C7E4C9E22
	for <lists+stable@lfdr.de>; Wed,  2 Mar 2022 08:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232482AbiCBHE5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Mar 2022 02:04:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231287AbiCBHE4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Mar 2022 02:04:56 -0500
Received: from new2-smtp.messagingengine.com (new2-smtp.messagingengine.com [66.111.4.224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACC72B3E44;
        Tue,  1 Mar 2022 23:04:10 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 4DD385800E8;
        Wed,  2 Mar 2022 02:04:08 -0500 (EST)
Received: from imap49 ([10.202.2.99])
  by compute2.internal (MEProxy); Wed, 02 Mar 2022 02:04:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        sladewatkins.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; bh=PtyXlBAMRksx2k
        euLGv8zpdla9w5ErOiH3vNaKUGa8k=; b=PySEKMUAzvvPS7dn6Q28WWP/52PacE
        z4hg7eGRHexTb8wg+Y5xtvO+2eG+aYGntq60FIcYkJmsf5Qb3b6tGS58bt5OTnRI
        WUI71KyY/23RtVtS5/1GIfuWIwSMxWDyND3mdPK2PjLT4j4u85ToOKcoajHvNy6y
        9oEEOa6r1e2sq3Qm7NHSzhGF5VwVfiJXV8bfeI1+oZoM048ys0+lKfrmjcmmEoUh
        I+lsGBuf9pSd9SRjrObdr/G7DTaFPUwip80d2N2fu11sFWXnA9xJjqLyRc5eS7w6
        BrHLLzzUNM1eMDszxZE8B+/a7fDvNED48QUGF3HJZw1/uyVAbCRr48Kw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=PtyXlBAMRksx2keuL
        Gv8zpdla9w5ErOiH3vNaKUGa8k=; b=ZkUxqouPjEjyO2j7xw9GUM5RUV8XGA6fX
        w9w/7UhXL3yjFbHu0P4Ctm8UP/OVSvnBkZqcz5I8xTXrft6IQ+vonyfl/d5FI3Iq
        q41ts9EfVkdRGw+p0q9pGlSXSawfvUjTmX4dMQb0vUKHJYURpBzlvmzc9UOekFH3
        qeOs4mfovJDLNG3fz0dqzyz+Y9elan05bwRTN6gx/U47/OEY2wOka6x1Dm7C7IVm
        qmmfQGcCSnpxWOd0HDQCuSptGOaaaxUBNVdlWi6WdjQ54zo+BRyEDSrO5jz8S/nj
        ohUSexQI0o3ui7boE/AdI38gFVOOejqSticeK5Ycj/kyssbuG4Faw==
X-ME-Sender: <xms:5xYfYstDuggb9mb-7-Ao6vDfkZdlUc4e0snDUDZ94GKW_gqhOa9dCA>
    <xme:5xYfYpdbUeGTPYsud-3idoPJ-SGZNKM0BFwzBtkQ0TM62boUmA8whzUVGKJkUGwyM
    nwoLLb4_xYHZiZQlQ4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddruddtfedgleegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvffutgesthdtredtreertdenucfhrhhomhepfdfulhgr
    uggvucghrghtkhhinhhsfdcuoehslhgruggvsehslhgruggvfigrthhkihhnshdrtghomh
    eqnecuggftrfgrthhtvghrnhepueeiffetjeeitefgveetleehveduheetiefhhfethedt
    teelgeettddvvedvudegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepshhlrgguvgesshhlrgguvgifrghtkhhinhhsrdgtohhm
X-ME-Proxy: <xmx:5xYfYnwBgmCDzfJ6L_rswVgcvohfzFzeNgTho_N1jeihydu_Tke5fw>
    <xmx:5xYfYvN14w_yP9wgocCSaIT4fb8CHAITNR_4SIOZFptELw0BcjSmdw>
    <xmx:5xYfYs9OGdLYMymkX31YWK0IuxcTUNwr4ifrhwCd47sx38gdxTq1Cg>
    <xmx:6BYfYt0yPXFDtpT7vLeFldrh6uF1QaSrnpmAzXAhQbpv3fzw_lEJ1J9EI8I>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id B1869F60084; Wed,  2 Mar 2022 02:04:07 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-4778-g14fba9972e-fm-20220217.001-g14fba997
Mime-Version: 1.0
Message-Id: <09ca3973-795c-4f6d-8584-96f4dd233567@www.fastmail.com>
In-Reply-To: <20220228172248.232273337@linuxfoundation.org>
References: <20220228172248.232273337@linuxfoundation.org>
Date:   Wed, 02 Mar 2022 02:04:06 -0500
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
Subject: Re: [PATCH 5.4 00/53] 5.4.182-rc1 review
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
> This is the start of the stable review cycle for the 5.4.182 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 02 Mar 2022 17:20:16 +0000.
> Anything received after that time might be too late.

5.4.182-rc1 compiled and booted with no errors or regressions on my x86_64 test system.

Tested-by: Slade Watkins <slade@sladewatkins.com>

Cheers, 
Slade
