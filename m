Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73ADE4BF0B0
	for <lists+stable@lfdr.de>; Tue, 22 Feb 2022 05:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240885AbiBVDUk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 22:20:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240828AbiBVDUf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 22:20:35 -0500
Received: from new2-smtp.messagingengine.com (new2-smtp.messagingengine.com [66.111.4.224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F24825EBA;
        Mon, 21 Feb 2022 19:19:57 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id A2818580186;
        Mon, 21 Feb 2022 22:19:56 -0500 (EST)
Received: from imap49 ([10.202.2.99])
  by compute2.internal (MEProxy); Mon, 21 Feb 2022 22:19:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        sladewatkins.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; bh=YOWiLnmDsFJa30
        vgbR9ruu8U64dueflFkh9DTFDInIw=; b=h/SVqFvNafU7IxSQufKaGFMYeCf5uC
        pEJIc8aVaosN2IoM6QeOdHG/spv4uTgzNy966cTquFsEG45JjqAGsN9JVu8/KCKF
        OFjdUa1MLyFfFglKuNNtCPwUZNRlgN9DOYxFa8CVuasikNN1GUzH9u7Ityct8iQ9
        MyRGW6TsT0Jbu3E8SfmhUqp0H9r59jfH7QI8IQWgAe+jtYHsaeWfYzqtkjBvD8aj
        K/kSeqJaAUJ/jayqMaLTgSMnwoFfeUdr5p4Fm4ywyEsOVW/yDS2LsKCKLtkZ2hcK
        HqKre6OjVVBc6ALDFB6VXk0N7wA1GxRMbNugnZV2i3G4Zka8x2k4Vfxw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=YOWiLnmDsFJa30vgb
        R9ruu8U64dueflFkh9DTFDInIw=; b=dgNICDkM5qpKo3fgdOPlSGNVegKiCpm17
        TYbEkWxE8SHE27MvSgTrb58X9biNPsrneA4byHa0r0E8ItsY5XHO8jtDZKlfEg+Z
        +xWQUyqDGezCXZQLIVv3eHq3Ew4OWPPMZ14XUWQSXhkYLvq+3reEfanAeNb9x1Qq
        y7e+EYygmIvcwISQh9nVnYbGnoSOX39wH85QtO8pdrognTEaTPK7nZ1kQIk6ac5F
        qmpwKDiHeLeTXVHKbZXRPoeIRzoo0BmUc4e7xS+1Gc+29Wi61ygVVsxr4cbmctdO
        63qYawk2AcPmu3RuRjOXspaxaIJ7eSPhQBLpHXaW76m1x8Nvt3Byg==
X-ME-Sender: <xms:XFYUYp6qHcQ3nsZ3_tCoOmgxEYAhnWwR2iVz87R5vwGqc4UKbwVWlA>
    <xme:XFYUYm61ib0jYCADGQpWFwvWXELba6BosLeKAGS8DzFXy3t0CIY5a1cn0-lz8M_gz
    py72VOpmDgUVT6muKM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrkeejgdehiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvufgtsehttdertderredtnecuhfhrohhmpedfufhlrggu
    vgcuhggrthhkihhnshdfuceoshhlrgguvgesshhlrgguvgifrghtkhhinhhsrdgtohhmqe
    enucggtffrrghtthgvrhhnpeeuieffteejieetgfevteelheevudehteeihffhteehtdet
    leegtedtvdevvddugeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehslhgruggvsehslhgruggvfigrthhkihhnshdrtghomh
X-ME-Proxy: <xmx:XFYUYgdsawksmqpJX0SbOPq79IVtvLK7Q77ozby0hgUF9NXNL43VFQ>
    <xmx:XFYUYiK1InNTKz1V-VFk_8bohBoaLnKmd6lRYCP846EkwpO8CIlebQ>
    <xmx:XFYUYtJvH-gUmcUynIWM9-WLOeJ2HvdBPIxxPvSJjeHJfv1May9UZw>
    <xmx:XFYUYqCaaSqayiGcrerG6aycz5kpG-IxYXRA-F-8-mMdEr0lT_urTmRA8uQ>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 40CDCF6007E; Mon, 21 Feb 2022 22:19:56 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-4778-g14fba9972e-fm-20220217.001-g14fba997
Mime-Version: 1.0
Message-Id: <8c891a05-ee64-4763-83a2-3f27413e545e@www.fastmail.com>
In-Reply-To: <20220221084921.147454846@linuxfoundation.org>
References: <20220221084921.147454846@linuxfoundation.org>
Date:   Mon, 21 Feb 2022 22:19:55 -0500
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
Subject: Re: [PATCH 5.10 000/121] 5.10.102-rc1 review
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

On Mon, Feb 21, 2022, at 3:48 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.102 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 23 Feb 2022 08:48:58 +0000.
> Anything received after that time might be too late.

5.10.102-rc1 compiled and booted with no errors or regressions on my x86_64 test system.

Tested-by: Slade Watkins <slade@sladewatkins.com>

Cheers, 
Slade
