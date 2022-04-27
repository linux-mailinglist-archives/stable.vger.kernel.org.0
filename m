Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC45510E78
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 04:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356996AbiD0B54 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 21:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbiD0B5z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 21:57:55 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B307B17532F;
        Tue, 26 Apr 2022 18:54:46 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 1E7C25C00E5;
        Tue, 26 Apr 2022 21:54:46 -0400 (EDT)
Received: from imap49 ([10.202.2.99])
  by compute4.internal (MEProxy); Tue, 26 Apr 2022 21:54:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        sladewatkins.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm2; t=1651024486; x=
        1651110886; bh=m9esZQ1UEJYEnTtoO5j/Eq2p9RGoegOJLLSITtFI618=; b=c
        YjhHHA21oGiBkgaY7iRELfwNfLiCOza5hRlRHdwPhkkhL3DIjNnt8NbsPr4wFZPg
        Q26X9DSMpWllnrKXHnFzq0R8pHC18DR7QRIJt6yni2vHWl9ieA51KoGQbIWF1hvF
        xPL/2AvKOR5/n5tiRpBaem3FK7BziJksr6KkU+hgdybRt9WYQE+f3TkOQS8qs7yv
        u/YELxKEibjIzHYbEZPXAIrF+fiWHfsNIgJHLWaLOUHBkXpzMlNnPH1Du6pLE+1m
        nP+gTHpmwFvjWPsmhkmLmBogLN3fjQy+st7hwAj2DT7F+ZwOGa2lgcwf3UdWrwyP
        WRg5De5JAoX/PElyrHQ/A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1651024486; x=
        1651110886; bh=m9esZQ1UEJYEnTtoO5j/Eq2p9RGoegOJLLSITtFI618=; b=E
        j604lrtm1WLuSR3TM03g/CFRyuOcTqI7FueY5KVrDMHqDY68LLY7giY78N5M7TBN
        1CCgfvVbpPUCRYnjXw2J9m5ZkQ1BjUnoQyMSWGJ1idseU2jvEuJ3ZEIqp34paVOj
        nmVF1NWeu9pq1tKPsA+BhIdQZlCaXpstAkPODo2Pdj5Aa9t9hApMbZe6nM8gg1Sh
        MEWg4VVNhe3vOcvYvOveqffhullnFQt9bdQlKNJsDGBiOVeOaYCgyVmpQ8wDtDYQ
        O8OucgXwSL3w4YQebc9UMj5RkoiTFOHFFkKZonQ5CS+HKWvc3Za5jTgCil6V9L+Z
        eY3xZBL4GIy/ViOiZIyAQ==
X-ME-Sender: <xms:ZaJoYo2wmbeNYGG1oLM5koXsR-h7XyQ6kQ8ZKVBaUDsMrMwYBscLKw>
    <xme:ZaJoYjH2AJEJfdYgu2_JRCEQLSQm7JnZ7Kf3AupEv23g9xSwtd5E8-61-nyIbNaul
    GLwJtjuWorQYWBb9oM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudeggdegjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdfulhgr
    uggvucghrghtkhhinhhsfdcuoehslhgruggvsehslhgruggvfigrthhkihhnshdrtghomh
    eqnecuggftrfgrthhtvghrnhepjedtjeffgeekueegteefudegfeekteetvdegudfhuefg
    hfdtteeigfeggfelteeknecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrg
    hilhhfrhhomhepshhlrgguvgesshhlrgguvgifrghtkhhinhhsrdgtohhm
X-ME-Proxy: <xmx:ZaJoYg4xJQWed1fnEpFxjuUO0AFDi4cndXK0gSdZQfRSDaNjoLXcoQ>
    <xmx:ZaJoYh3jszw7cW4bKv81Nx_v-wDGPs3ogDdde7LAztGBgEMNq_XeHw>
    <xmx:ZaJoYrGFozcRJy1_pH93TLM0IKicLkej9efH8i0YCmeXcjRv7u0uYQ>
    <xmx:ZqJoYj_mKuxadA_ia8hUCIQu7-ArTgYpbEPZqUcrHuyuMBCJGKF6Zg>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id D0DD915A007A; Tue, 26 Apr 2022 21:54:45 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-569-g7622ad95cc-fm-20220421.002-g7622ad95
Mime-Version: 1.0
Message-Id: <f78519e2-5a50-4b04-b5c9-beb4100f5916@www.fastmail.com>
In-Reply-To: <20220426081741.202366502@linuxfoundation.org>
References: <20220426081741.202366502@linuxfoundation.org>
Date:   Tue, 26 Apr 2022 21:54:45 -0400
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
Subject: Re: [PATCH 5.10 00/86] 5.10.113-rc1 review
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
> This is the start of the stable review cycle for the 5.10.113 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 28 Apr 2022 08:17:22 +0000.
> Anything received after that time might be too late.

5.10.113-rc1 compiled and booted with no errors or regressions on my x86_64 test system.

Tested-by: Slade Watkins <slade@sladewatkins.com>

Cheers, 
Slade

