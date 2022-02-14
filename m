Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89FB84B5B55
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 21:52:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbiBNUp6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 15:45:58 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:33008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiBNUpg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 15:45:36 -0500
Received: from new1-smtp.messagingengine.com (new1-smtp.messagingengine.com [66.111.4.221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D0511AC9DA;
        Mon, 14 Feb 2022 12:43:08 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 1F4D058045B;
        Mon, 14 Feb 2022 15:42:42 -0500 (EST)
Received: from imap49 ([10.202.2.99])
  by compute2.internal (MEProxy); Mon, 14 Feb 2022 15:42:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        sladewatkins.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; bh=Uyb2iq10XWTMVa
        V5N9B4NHWUnZkVZVMjBnE0t3cE07g=; b=lBD28UYphy/67kwUGSA6JvaL+BAYGO
        +r7egVzFFN85U0h098jGeG9qN8mOXGHoEi6xDj8ZMzQUoKKprD8DMMHNU8BBP6Tp
        EJq2SSGjH+bJ/9tWuUM+oVW9c8jJqnQMVtnTSFYNcmkH6codTCT+kq10UD8NSUMm
        m9Pb0OLH6aK4In9wUw8waDt7KQlJyn3kRbDBGiyDtt74nOsNFo0SnGNokaL4DDAA
        ifzKRVT1F8ToNJSU3OS3T1ws10rLr5XvdUaTg7IW4Ljh7d6q8gFgmZRgoHt86HG4
        bMk8Yj3v4sIknCNrs2ObTLAFrxFig49SH2F0cfzSd5yUAXch05th+7iw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Uyb2iq10XWTMVaV5N
        9B4NHWUnZkVZVMjBnE0t3cE07g=; b=n9JH+tLDpLnW6WONhKrd4QHx7e618kjWa
        zYp6+yrk/dUprojI3RI0EqwV8A8OBF90rQbrRAtqfEoX9ZkpaUu+GJG6fUBl++uy
        JzRqTxwsnhfj2siNi1ma7yMl3n8e3BeWw7UtSOES8ZYKTTWOWvYN5BhmBtmwegZq
        EJe08m/LeVObSumXklQbIejbcGSeFovfc5fvT1jgojmgQ5UdV1SPZvxcUv5+jBRr
        HaCpE9Ms8qs9sd5y7mbp0j2NSs+fITMnTQcNQv0FixZdD+EDKRiZL5Yb9gQYbzba
        7HgVIXhKflw02dLG5iHHTf1NXycnezRvS3IdRXnT9LAq/ufmbF9sQ==
X-ME-Sender: <xms:wb4KYnAV3hFxnH9UlRdj-6Gd0XitgNn3PuyfsNIYGo4tCnFWyKk72g>
    <xme:wb4KYtjcB06KEqHM-Cvx_XjcYA3MASZes47Dxyqurw_Ozf86dZ50b4_QT_gwWy_6H
    01iFY9UUB_-NsrEcYI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrjedvgddufeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvffutgesthdtredtreertdenucfhrhhomhepfdfulhgr
    uggvucghrghtkhhinhhsfdcuoehslhgruggvsehslhgruggvfigrthhkihhnshdrtghomh
    eqnecuggftrfgrthhtvghrnhepueeiffetjeeitefgveetleehveduheetiefhhfethedt
    teelgeettddvvedvudegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepshhlrgguvgesshhlrgguvgifrghtkhhinhhsrdgtohhm
X-ME-Proxy: <xmx:wb4KYilwQygiKoa9T0KzAG96DS-CwIkKM6CoCrdP45-qG4ur2Mo2zg>
    <xmx:wb4KYpwDK_R08smvDsJDEqwIP3fOkNIYBKsCFj5Jc1gaJfGpw_x6gA>
    <xmx:wb4KYsR1onM8dbzO1oRCO3ZJKfVTZrM7oFPxg3QfwcVmcq7yk1JCrQ>
    <xmx:wr4KYhIBYg5L1CstAGFu8BxR_tyVOzw5H0OlCX_jZsDj4AfbBAAjJti4MTA>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id C884AF6007E; Mon, 14 Feb 2022 15:42:41 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-4748-g31a5b5f50e-fm-cal2020-20220204.001-g31a5b5f5
Mime-Version: 1.0
Message-Id: <ad2adecf-54cd-4a0f-86b2-c22552c5fb66@www.fastmail.com>
In-Reply-To: <20220214092447.897544753@linuxfoundation.org>
References: <20220214092447.897544753@linuxfoundation.org>
Date:   Mon, 14 Feb 2022 15:42:40 -0500
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
Subject: Re: [PATCH 4.14 00/44] 4.14.267-rc1 review
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

On Mon, Feb 14, 2022, at 4:25 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.267 release.
> There are 44 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 16 Feb 2022 09:24:36 +0000.
> Anything received after that time might be too late.

4.14.267-rc1 on my x86_64 test system compiled and booted with no errors or regressions.

Tested-by: Slade Watkins <slade@sladewatkins.com>

Thanks,
Slade
