Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26BB4510E61
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 04:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356745AbiD0B50 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 21:57:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbiD0B5Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 21:57:25 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1258FE5E9;
        Tue, 26 Apr 2022 18:54:15 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 607745C00E5;
        Tue, 26 Apr 2022 21:54:15 -0400 (EDT)
Received: from imap49 ([10.202.2.99])
  by compute4.internal (MEProxy); Tue, 26 Apr 2022 21:54:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        sladewatkins.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm2; t=1651024455; x=
        1651110855; bh=vtUz4f2VJMP5BoH/zWItiGZDfjzaqjKJ9ICWNvmmVPA=; b=L
        oy4Q8/GRLI7+k7h6EP1TZ2+K6HzJ9UFIjaPfJuIRRBmLVfB/3PCSsoVkolJVd+fa
        xccP2OFIUaexfMfTUmzBKPMamMznFH8lY75B0ebsWkgf2SMaTdtMK76Z0plmEwnp
        jzK/2DUMvE61UOebQXelNTOUp0bjd03PpLIQz2HvuNMM6qwP/2eABRGKAIr6CUng
        PtFZXu0KkysYI8bl3C5oneX9gppQRvlh10FAV6r5SWgCsPmQEqTYLn26sZ3IJFmu
        L1GFOh8ZCybwiloV8lF19IuSqeQRe5YYKCqFf7VZFAUMLQDdV5JcdOfVkwr5Ps8x
        rhi87f2QyDiuOByYZ8HIA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1651024455; x=
        1651110855; bh=vtUz4f2VJMP5BoH/zWItiGZDfjzaqjKJ9ICWNvmmVPA=; b=X
        9nnd7olbStGdFliRaYWS8m0Ku+TwKP9XOznfZVEb6fBuRaIIuKyOY/CZB0kfQOoN
        oLzSasLU54SpTzG62DFRdhYnfVgB/cwwOfX25AkRWudVAfbKZ1Z1B4wDAEc3TO4K
        Ms1mxFChCPsE9go9hqAc9G7NzVIYhAHvVfUJaDtulcu7GNjf1uArx73lEjoaoYcP
        P/vdblOaIbLgZrYoJaWlzrwK8XlQNcXg8PJXmsotQ0k7Njj7LV0rVuVaI6tCImwS
        VnMz01DU/CO/BLUUpdYEoVM3hi3OuGg/TEL91uMtOX6SPCkuEp9rz+lwR6XZh/Iy
        EiwftY5KCrrSoSA+yY9tQ==
X-ME-Sender: <xms:R6JoYqOXvOmLSRcCQ2N_acJlPUFJxTCW0omjpGaFTXR37F2EmeF46w>
    <xme:R6JoYo8ew2FFpA0wg9VNKeJgdEZJIhfVEvt_L3u9SyhKZEPOh8YR-AmBtszNvfd4H
    QhKuaEo7_TbAqM0iC8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudeggdegjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdfulhgr
    uggvucghrghtkhhinhhsfdcuoehslhgruggvsehslhgruggvfigrthhkihhnshdrtghomh
    eqnecuggftrfgrthhtvghrnhepjedtjeffgeekueegteefudegfeekteetvdegudfhuefg
    hfdtteeigfeggfelteeknecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepshhlrgguvgesshhlrgguvgifrghtkhhinhhsrdgtohhm
X-ME-Proxy: <xmx:R6JoYhTVvBI6dvMknja49kaqNDnxTCWI2ym09L8fPeNUPpSQGJAnxg>
    <xmx:R6JoYqsdKq3PiSFykopZigYVAfr5VBAxHeCwaM69cgtTy3aBr0b6wQ>
    <xmx:R6JoYicIfnGhWB_ILwhvmNqw_r9O282YzhGRZatM4lXlrp9VKXjuYQ>
    <xmx:R6JoYjXyIq_r8zNLn1WvM7Ao3uQ98gOOK6Yn2EHc7mZ35MMW3jCPZQ>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 042E015A007A; Tue, 26 Apr 2022 21:54:14 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-569-g7622ad95cc-fm-20220421.002-g7622ad95
Mime-Version: 1.0
Message-Id: <3afd8c94-ab58-43b0-830e-0c8577078159@www.fastmail.com>
In-Reply-To: <20220426081747.286685339@linuxfoundation.org>
References: <20220426081747.286685339@linuxfoundation.org>
Date:   Tue, 26 Apr 2022 21:54:13 -0400
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
Subject: Re: [PATCH 5.15 000/124] 5.15.36-rc1 review
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 26, 2022, at 4:20 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.36 release.
> There are 124 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 28 Apr 2022 08:17:22 +0000.
> Anything received after that time might be too late.

5.15.36-rc1 compiled and booted with no errors or regressions on my x86_64 test system.

Tested-by: Slade Watkins <slade@sladewatkins.com>

Cheers, 
Slade
