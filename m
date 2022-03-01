Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF974C9467
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 20:35:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236601AbiCATg1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 14:36:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235896AbiCATg0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 14:36:26 -0500
Received: from new2-smtp.messagingengine.com (new2-smtp.messagingengine.com [66.111.4.224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 513336AA6A;
        Tue,  1 Mar 2022 11:35:45 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id B56A658027D;
        Tue,  1 Mar 2022 14:35:44 -0500 (EST)
Received: from imap49 ([10.202.2.99])
  by compute2.internal (MEProxy); Tue, 01 Mar 2022 14:35:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        sladewatkins.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; bh=vc9LalCB263Kc9
        a9+Kanp1F3jfXQOYis0wcOQebY/uI=; b=GbsevPaLbKJ++KMEjPVyAJY3xopdsg
        GOiatG9ODboPWmyChM+aiqudO8XTVahKBUTC6gydywu3PgUMlEl2DCPGEyfHbO6i
        erXs6EtisH9Oscy7LHryGPtJNnh5E3eDMrzTLXrSLcmmVO0mlllIcQnuptnGRClC
        cklPuT4DTGdk/piBCT17IDGcj+XG8M62lbNUo5XacXM9WzaGHslhz2+ao2EpbEsa
        NsrTFZwpMSMbizvV7JcM4fp4qVc9twWtAINbBM3s5VIN4ve69JjHC+5eDPv+peh3
        AQSzS6Vmo1yTiFY4u4g2MUIhZdbtOqs1Bj9FF2rEZODr+toKHXQZitDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=vc9LalCB263Kc9a9+
        Kanp1F3jfXQOYis0wcOQebY/uI=; b=KSv7922/6MXw6Uhjn2o7pBvqdkUcKV5sq
        uImV+/a3cKHDZZXoFwCUlaH+Af+YGgDYqYNbTZa7kBpiOBfNrqO9P2EnHfLKNzXZ
        2H1vL9lPcwLLIePAAkJcrged3PZ20rH81fDUBYtokh8es1gnZmBcIO2Bz01c4OFT
        Pb5Zh8ZDk7+1UPeALhMh+pqMIfZV5zvnFCtSn/USp5vB9M15C/izpZTaqqaytFlM
        9s7isxaSXgojPUw3QmJelEuOIPH7Bt+dTkG6Z5ELc8IIvIHC+7FIatScDXtZ0Zt9
        ygskrThs57t5CGW4Id9Y0vYuvSqj3MwVQ+jh71nxaxmoigQKcpaYg==
X-ME-Sender: <xms:kHUeYr3kwzf72BoS4_3nK7zRNzRhAq7dr2hQKcGE2Czv7MIYY7kRUg>
    <xme:kHUeYqFOHMqzkkBgnL7z-WQIa5lHgi_CMPN9n2tmOBBJBH7U7qyg8QIvsuOFeMyBk
    YrOs3L-0FcG1DVcw2c>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddruddtvddguddvgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvufgtsehttdertderredtnecuhfhrohhmpedfufhl
    rgguvgcuhggrthhkihhnshdfuceoshhlrgguvgesshhlrgguvgifrghtkhhinhhsrdgtoh
    hmqeenucggtffrrghtthgvrhhnpeeuieffteejieetgfevteelheevudehteeihffhteeh
    tdetleegtedtvdevvddugeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehslhgruggvsehslhgruggvfigrthhkihhnshdrtghomh
X-ME-Proxy: <xmx:kHUeYr54fo64I9KWdFcf_I28Q6oDXkxa1D62ltSi4TaXyIMIr89UtQ>
    <xmx:kHUeYg2JX6RVDSZbQzO9rhQIV5rhogoXT_qjDMsx4lwH-HI67_7o7A>
    <xmx:kHUeYuHMDqxPJx_4GxSoypVeKEI6RDyOUtNXz3RyjTwXA-f2p_RzBw>
    <xmx:kHUeYm9ZtpNPFSf2yNr3ufT8h4H6SRAXkgBNsPt4JH2JTi7aTqOPE98WYig>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 6FDAFF6007E; Tue,  1 Mar 2022 14:35:44 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-4778-g14fba9972e-fm-20220217.001-g14fba997
Mime-Version: 1.0
Message-Id: <42623c43-17f3-41c3-976b-ab618c3005d1@www.fastmail.com>
In-Reply-To: <20220228172159.515152296@linuxfoundation.org>
References: <20220228172159.515152296@linuxfoundation.org>
Date:   Tue, 01 Mar 2022 14:35:44 -0500
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
Subject: Re: [PATCH 4.14 00/31] 4.14.269-rc1 review
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
> This is the start of the stable review cycle for the 4.14.269 release.
> There are 31 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 02 Mar 2022 17:20:16 +0000.
> Anything received after that time might be too late.

4.14.269-rc1 compiled and booted with no errors or regressions on my x86_64 test system.

Tested-by: Slade Watkins <slade@sladewatkins.com>

Cheers, 
Slade
