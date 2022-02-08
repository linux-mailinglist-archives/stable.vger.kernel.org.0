Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B09664ACF16
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 03:45:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235948AbiBHCpM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 21:45:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232395AbiBHCpM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 21:45:12 -0500
Received: from new1-smtp.messagingengine.com (new1-smtp.messagingengine.com [66.111.4.221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6EF1C061A73;
        Mon,  7 Feb 2022 18:45:11 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id EACAE580226;
        Mon,  7 Feb 2022 21:45:10 -0500 (EST)
Received: from imap49 ([10.202.2.99])
  by compute2.internal (MEProxy); Mon, 07 Feb 2022 21:45:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        sladewatkins.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; bh=GPPvZF7CrpCa01
        ldSCH7Kb3KmYZSJ9z2RRGc0QtN2mA=; b=fgRaUT5qeuwprMW3BODkLqX1dvpX4k
        qkUGQjdyG4wmHvvAYApgKyAQnoxYsdsIXrgEdKtvxrdTfHY7PXM7fJ4lYVv3oEeb
        l6c5rkM55KUvocuqYMeL8lX17iLukdreL4Xg2cQbOIqUDFkrkBoRB9v2I31vF7+b
        n7dAIOMYLXyjRa45h9PBWui9KW4NsG6fZcGUsdmb0JSVZnmHGlElNPGUtehNjdbH
        qqm4vQqajztuUWCRiTEzVgdCE9ZDK9EO2Te77x0eHlp5nQisHPzSEriv1v91xSES
        /SkC/a3H2MXjNPXxzY5dvn/ZCRfnBYIZC+e5djgXbzLaGz1RQR3zHYJQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=GPPvZF7CrpCa01ldS
        CH7Kb3KmYZSJ9z2RRGc0QtN2mA=; b=H8qie7AUArXm59XzaaMdQwY94zK5KwaOV
        OVMzNW/dt8YkvWzyZBLHsFvia1eqFozoJLUYNopumbATEutcRz6TA9R68GV3xccT
        nvpmkDbTMgBRxTaQ0R5YKzhhEW5yrhQFkgOK5djeAu6O4Y5jBRKELoUfnhLk8Iwg
        21jEEOHK8Ofqf8oHsyMoWBpWEi1Xma1fWoDFx1YECie5nW6ma0VbotAfCTnXvqxb
        NmDEYCLQnQY0rnUr1M/Mh5w7dJYCqgRWG10y4Ix4lFs1Ft+CiE6Jziv6FFqgHtU0
        lXl8qkLV6IxECch2N3+iHaUDKpnw15yX03MTiLQwv9cKhdWkDHlog==
X-ME-Sender: <xms:NtkBYm0yxdkSGk9RDEkpGesAX3EDyT_Q_EO_0uiEardh0CWe7tSqUQ>
    <xme:NtkBYpGCti6om80-GadM4pTZvm2qkCaZiWyzqoPZljFDJQsKoartQlneorPTLa5-M
    ye8FoKLaja6irqf5us>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrheeigdegkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvufgtsehttdertderredtnecuhfhrohhmpedfufhlrggu
    vgcuhggrthhkihhnshdfuceoshhlrgguvgesshhlrgguvgifrghtkhhinhhsrdgtohhmqe
    enucggtffrrghtthgvrhhnpeeuieffteejieetgfevteelheevudehteeihffhteehtdet
    leegtedtvdevvddugeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehslhgruggvsehslhgruggvfigrthhkihhnshdrtghomh
X-ME-Proxy: <xmx:NtkBYu41EPCdE_0v57zg3tcKvZdGechEREtIZ9y3grCipX3J3caiEQ>
    <xmx:NtkBYn02pidNS-Qw6Re1xR8h638E9jucaYrM7mfEFS7eQbLfvdFzjg>
    <xmx:NtkBYpFFORRd5u8xfCGt4KD3p-jzr2puPCQRHArzq-HH83pooRKvPw>
    <xmx:NtkBYh9eMAvTDAcfbRo_rEj6XOfjVje9ujBv66qqhupORmbcj9e21yocmcE>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 2C8EFF6007E; Mon,  7 Feb 2022 21:45:10 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-4748-g31a5b5f50e-fm-cal2020-20220204.001-g31a5b5f5
Mime-Version: 1.0
Message-Id: <07d66f94-1290-4d87-bf94-dacd550e6a21@www.fastmail.com>
In-Reply-To: <20220207103757.232676988@linuxfoundation.org>
References: <20220207103757.232676988@linuxfoundation.org>
Date:   Mon, 07 Feb 2022 21:45:09 -0500
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
Subject: Re: [PATCH 5.10 00/74] 5.10.99-rc1 review
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
> This is the start of the stable review cycle for the 5.10.99 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 09 Feb 2022 10:37:42 +0000.
> Anything received after that time might be too late.

Compiled and booted 5.10.99-rc1 on my x86_64 test system successfully without errors or regressions.

Tested-by: Slade Watkins <slade@sladewatkins.com>

Thanks,
Slade
