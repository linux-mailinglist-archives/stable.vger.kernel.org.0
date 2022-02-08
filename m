Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEF604ACE79
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 02:56:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243204AbiBHB4U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 20:56:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345412AbiBHBzx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 20:55:53 -0500
Received: from new1-smtp.messagingengine.com (new1-smtp.messagingengine.com [66.111.4.221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 285EEC061355;
        Mon,  7 Feb 2022 17:55:53 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 9AE675801A8;
        Mon,  7 Feb 2022 20:46:12 -0500 (EST)
Received: from imap49 ([10.202.2.99])
  by compute2.internal (MEProxy); Mon, 07 Feb 2022 20:46:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        sladewatkins.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; bh=5+76eXXO9x6v5j
        dgARY6WL3HFi5ejxI1U2gzzn4TQV8=; b=KIpS8MJ0/E7AS8EwU75dlgJxq/GO0b
        /an7Aa8y2dbAOgLsTwPsANUVIfHXVFp0fVJkjBdYkqaMQhNtL/zcK26N898bE50f
        uPBUYUCVpleMv7lajcUodBhC3O9Lm1rRQsxAOcCfs84LeYHMttSfGYrViflIQm7I
        e1n5eQi4k+FXR4FS3rc7gdddCmy8sM2Mc/ePLlTmG9/QMk2LoJ5qeX6cbGMvPppZ
        zQfh0nlZu1cYauGcE0ycYDBOQJtE+Lb3wtTl6gi/UPtf15jbOk7OfIdVzLMCSreJ
        W98eOLRQ42oUO0QvgGbFBG0mL4+2LF5g7rvZMCOHQeh1U64B3Z2goISA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=5+76eXXO9x6v5jdgA
        RY6WL3HFi5ejxI1U2gzzn4TQV8=; b=cdF5Kv0ki0kMMfLqDLCgnfxGEL2F2Uj8o
        KX9+aD6ISWeTyevY4vzuDakWLl1AUfGRFN5h1W7AGKRa3ZrUsz5ym20y2xwcEKd0
        Pd2Uk5MLKhIWbSbH4WnUlVz/XQ/DTpOKlH/roJ5r3jzBvNLMLk0Kjb7WYfRy1+UL
        ZnP73Qp2CDa1ynxU6WQgkIEl3R9fVBLYznYQowhqSqNrbFZwXzyOZSAMlz7S2tWC
        39jUDqTg0DJlqV3IOB9gvMKOmzVCDviSdcHe3gWRd/WFnZ3DgNuhKaZ6NhIkLwkM
        IyhvxGo9rNxWJyFkP8QwtJnEYZmbZJb4YsA+lXBc383EscfVYdzGA==
X-ME-Sender: <xms:ZMsBYrivwJfeProIDu2iqbiOtbVDcHOHuxp5C8TYHEMuv_zYaY1Djg>
    <xme:ZMsBYoA9gJCZOASJa5BMhZPkMjb_gtlr77mydMwtF8_1zvN4Y8a_tP5c9NTMU26A5
    xx2K4gR6i8DOdmlOjM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrheeigdefiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvufgtsehttdertderredtnecuhfhrohhmpedfufhlrggu
    vgcuhggrthhkihhnshdfuceoshhlrgguvgesshhlrgguvgifrghtkhhinhhsrdgtohhmqe
    enucggtffrrghtthgvrhhnpeeuieffteejieetgfevteelheevudehteeihffhteehtdet
    leegtedtvdevvddugeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehslhgruggvsehslhgruggvfigrthhkihhnshdrtghomh
X-ME-Proxy: <xmx:ZMsBYrGHO2eGNBi7uquc9UXJM5bE0-f3Z8uFF4VG0pNmjQliyhpulg>
    <xmx:ZMsBYoQ4UUqCDYMmR1kwbIFFlRC2OtgEeTF0aXpe_GoG3X201qM0qg>
    <xmx:ZMsBYoxsT2ves09QRyv03R3EjzoLaZpayu_8UsruWN9ABkYhJEY3SQ>
    <xmx:ZMsBYto52h2ZJNzreV8Y-6g6WwmsHQPKXWqTQ372TWezjpBEJm7LxzGPqhs>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 64FA8F6007E; Mon,  7 Feb 2022 20:46:12 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-4748-g31a5b5f50e-fm-cal2020-20220204.001-g31a5b5f5
Mime-Version: 1.0
Message-Id: <ca0e703a-0c19-49c9-b0cb-a5fc4b38f898@www.fastmail.com>
In-Reply-To: <20220207103752.341184175@linuxfoundation.org>
References: <20220207103752.341184175@linuxfoundation.org>
Date:   Mon, 07 Feb 2022 20:45:52 -0500
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
Subject: Re: [PATCH 4.9 00/48] 4.9.300-rc1 review
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

On Mon, Feb 7, 2022, at 6:05 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.300 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 09 Feb 2022 10:37:42 +0000.
> Anything received after that time might be too late.

Compiled and booted 4.9.300-rc1 on my x86_64 test system successfully without errors or regressions.

Tested-by: Slade Watkins <slade@sladewatkins.com>

Thanks,
Slade
