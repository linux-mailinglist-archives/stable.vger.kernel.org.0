Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 417634ACF19
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 03:46:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241776AbiBHCps (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 21:45:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345150AbiBHCpl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 21:45:41 -0500
Received: from new1-smtp.messagingengine.com (new1-smtp.messagingengine.com [66.111.4.221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6300C061A73;
        Mon,  7 Feb 2022 18:45:40 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 4BB27580213;
        Mon,  7 Feb 2022 21:45:38 -0500 (EST)
Received: from imap49 ([10.202.2.99])
  by compute2.internal (MEProxy); Mon, 07 Feb 2022 21:45:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        sladewatkins.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; bh=j0ccKSr7FIxPdc
        pdLr0dNsL+atOvXOZ9B0vb6/Picxc=; b=nF+nXOE40VLgMrSNvYLIoP1ANeIRH8
        XtOunA6ZYUkxMKCFSU3/Vj5xGH2Mld5+klJw2t1wDKKr8Dq47EcbfMsxvUKCl6Mc
        kJ33FdiZzEx+ogrkeB613cCbN7MhYLRCjDjfkVnydH6Ym/2BkhcO8iVxLKOSX056
        JqwMCdSP6xyDxHBVnlY3CNVUHZBP1Tr7HKgyP6m3edlY13UzNs4hsvG4v8OjcRZw
        n2UoZickzGBIHZEiYcLrfK+Xbv6XSMrzU3KGGlgsI2pgeRRftoFZQ8Q+dhBLnM0K
        tQgbp30iOoSUJEivdGHfY2Ainr5FArHZ4wQPuYFOFLpOno1M7A7vRvEQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=j0ccKSr7FIxPdcpdL
        r0dNsL+atOvXOZ9B0vb6/Picxc=; b=jhLbTX3zwdwfsLQVD0vatnO35eK/f177f
        KgajZ6P2g5Sqhs3XsekqLCflF5m6g1exnzJxg0X+lXVHzaAVGZ+r5BDxQ14I+FoJ
        4/BHkk2A+LQSj3SGQyHJvITs+OzCdfu1abIvS/r0DNcL31JlDYrMbWMbz9No7gZb
        tuz8luMLPoFdqj5vo58Capb1Q/r34M1F3fw4PSN+F4ENNCFkR1HFEWyV6AFSXC9O
        k9dqM90+HtQQSqzM8w5/a31zEPzrrpRZA9zTIAJCuSFeqIw3hxdeebMhMFiikFgl
        31BfH/yv93hWCLQfM1uBCFeW8m01fsH2lqFGSrV9IsiMCxPZ3j9jA==
X-ME-Sender: <xms:UtkBYhQcrDRUR6Vq9zfWJ9pZljvYot53vcj9HnGRjh8KmIKKwraeyA>
    <xme:UtkBYqwI6JA923EGv16EsOl2iiGTUj-DAV8NQTxr9Y_3BdUrmonLQqYZ0DUwT9E4J
    Dov9-h8-xi3Cww5704>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrheeigdegkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvufgtsehttdertderredtnecuhfhrohhmpedfufhlrggu
    vgcuhggrthhkihhnshdfuceoshhlrgguvgesshhlrgguvgifrghtkhhinhhsrdgtohhmqe
    enucggtffrrghtthgvrhhnpeeuieffteejieetgfevteelheevudehteeihffhteehtdet
    leegtedtvdevvddugeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehslhgruggvsehslhgruggvfigrthhkihhnshdrtghomh
X-ME-Proxy: <xmx:UtkBYm2Rhkh0_xctA0vt7FvnrDA6UcGYhOTNRssNesGFX9iyGNlXyg>
    <xmx:UtkBYpBFU6OrQDBEaVcdUpvMR6Y9Q9LauiUYFnC2skrAP1U0mkWAzw>
    <xmx:UtkBYqjC95eKD3Qz_jmvld98_XYgOI48ru7nI-3NGCCD4wYNSBvQSQ>
    <xmx:UtkBYvZO9EkAmBS157nQk3bJ2pdEm8ve_89vW5_V5eZKPKW6TYhoP869EFc>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 07246F6007E; Mon,  7 Feb 2022 21:45:37 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-4748-g31a5b5f50e-fm-cal2020-20220204.001-g31a5b5f5
Mime-Version: 1.0
Message-Id: <3b3179a7-e2b5-4813-be64-fadc42dff7d0@www.fastmail.com>
In-Reply-To: <20220207133903.595766086@linuxfoundation.org>
References: <20220207133903.595766086@linuxfoundation.org>
Date:   Mon, 07 Feb 2022 21:45:36 -0500
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
Subject: Re: [PATCH 5.15 000/111] 5.15.22-rc2 review
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

On Mon, Feb 7, 2022, at 9:04 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.22 release.
> There are 111 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 09 Feb 2022 13:38:43 +0000.
> Anything received after that time might be too late.

Compiled and booted 5.15.22-rc2 on my x86_64 test system successfully without errors or regressions.

Tested-by: Slade Watkins <slade@sladewatkins.com>

Thanks,
Slade
