Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A20F44F47CF
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 01:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242418AbiDEVVV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 17:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1572969AbiDERiC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 13:38:02 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8A9FB8202;
        Tue,  5 Apr 2022 10:35:59 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id AB2325C009C;
        Tue,  5 Apr 2022 13:35:56 -0400 (EDT)
Received: from imap49 ([10.202.2.99])
  by compute4.internal (MEProxy); Tue, 05 Apr 2022 13:35:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        sladewatkins.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm2; bh=RlDOrEhKX2leTS
        41joIzAvTOrasAxRRyMaip8pIxHRI=; b=oAWeZFLWD3FV4XnHxZuC/y64dROJeU
        Zo++E5uK9BMY8Sx3YA9k7M34um/oybeh8hBtFFXxXThMhLWiqZEOP9F+OKfJteKa
        apUvP/eZNKpXZYpkWfwFrWGoJdNg6fATjM+EO+XxY56VShXDo2b+9qniX1zBD8rA
        TdkECNlGksjXSO9OoKILOK/crfMTH8IOwGxVz9QXOcXT8fWy1fQiv6zdSOsYssZH
        w+Ckyt3i4qfVNDkHbRAVJ0SM76pl0HtOMsuukwD/WpICLZx+oJ1xpVL9owAXb7Xp
        wTtqZoJLVGJ3qn1J2XvD0DQl1s0yDStyfdq3ZA+dSgzMgaSR8bn5F8oA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=RlDOrEhKX2leTS41j
        oIzAvTOrasAxRRyMaip8pIxHRI=; b=f49rGYqUOlVXAiAQb7Tthpd5C3rMTOtSa
        BcvlZjMRhBD8hAgGXUunB9kFTVohXPfZOy2DI+msMXhrIaI7U42nRzGCpQ6m6UhQ
        ogC6T8dXvTMNd7pbPGSatMPuapsOayWc9vIpCOkT1nzsMcx75bOV57FRJktHnl3E
        2jzl6sBBIcZj2/H8sebtY0B6k4mKXQ+41jDbG+1N2n78HPYZFlbazHysbeBqWn6u
        kkygfbF9GHQA3qrAP7EXv6P46YXFEQtE2p3KArzLRTdPRxbapUFv5LB/bJtDpyOe
        hz/rhSEkV7FLkke06bTaU6+oe4sIzE2+BKZfMqfiYmqNeT2vMwoJw==
X-ME-Sender: <xms:_H1MYmgIsfOt_Yarwtc_kfg_bIeNvaBvUR6DQCyiHdJfyNkOexlqmg>
    <xme:_H1MYnAgxAdJBTo3YwRTYS1LIY6bajkCVFjUl5TKXJXXtNhFDTEe7qONuU4SZJ1tK
    ra_X5FHza0Rr78BP-I>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudejgedgudduudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvufgtsehttdertderredtnecuhfhrohhmpedfufhl
    rgguvgcuhggrthhkihhnshdfuceoshhlrgguvgesshhlrgguvgifrghtkhhinhhsrdgtoh
    hmqeenucggtffrrghtthgvrhhnpeeuieffteejieetgfevteelheevudehteeihffhteeh
    tdetleegtedtvdevvddugeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehslhgruggvsehslhgruggvfigrthhkihhnshdrtghomh
X-ME-Proxy: <xmx:_H1MYuHHRoIMCZ9fnD-fZBHH2GhzqOOiwIYU4uA0X_eVRt9WrfCK2w>
    <xmx:_H1MYvSsBrbiQIoqiGXXkGyCRe_tUK_NUiPhXBg_1wJr_qbTrQ6uMA>
    <xmx:_H1MYjygbsVpnnW8E-pErHpTfNoUuom6nB-jIDySbYcZAigw8gBGJw>
    <xmx:_H1MYoq57anBoAtO9HR40_QcWKhbdVYwSDXIE4u2YYV4zBAlnWvmAQ>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 0C4E715A005D; Tue,  5 Apr 2022 13:35:55 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-385-g3a17909f9e-fm-20220404.001-g3a17909f
Mime-Version: 1.0
Message-Id: <91d0682a-7be4-464e-812e-5e94dbfdbcd9@www.fastmail.com>
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
Date:   Tue, 05 Apr 2022 13:35:53 -0400
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
Subject: Re: [PATCH 5.10 000/599] 5.10.110-rc1 review
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

On Tue, Apr 5, 2022, at 3:24 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.110 release.
> There are 599 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 07 Apr 2022 07:01:33 +0000.
> Anything received after that time might be too late.

5.10.110-rc1 compiled and booted with no errors or regressions on my x86_64 test system.

Tested-by: Slade Watkins <slade@sladewatkins.com>

Cheers, 
Slade
