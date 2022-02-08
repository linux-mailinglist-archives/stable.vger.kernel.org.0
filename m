Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 141884ACE6F
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 02:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345458AbiBHBxf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 20:53:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345603AbiBHBxO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 20:53:14 -0500
X-Greylist: delayed 197 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 07 Feb 2022 17:50:54 PST
Received: from new1-smtp.messagingengine.com (new1-smtp.messagingengine.com [66.111.4.221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4921FC002B4B;
        Mon,  7 Feb 2022 17:50:53 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 4ADC35801B0;
        Mon,  7 Feb 2022 20:45:30 -0500 (EST)
Received: from imap49 ([10.202.2.99])
  by compute2.internal (MEProxy); Mon, 07 Feb 2022 20:45:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        sladewatkins.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; bh=xfHjsk/Ab5em69
        ApYaItpIQPphwvspyed8kLJ5wDAeI=; b=0aCQGqE1NNXNjib9Cq4fFaeO7SYJc0
        CdlLxAMX4kcRreTyas9KMyjd9ByL+ejeMqtVSNoR/aZ009NIunJMWZV3vrfyipH3
        4mWHmyPNft2WL0JBpeactZ2jLoClL18Ijhl3Cuuk84opzwzaiIpydvq1ZvGHyDX/
        Jw3XpTIsiEmdx2xAOpu2dSdMOEH3/GOMCkgfjv0RA55iNqCWWqJUszONZBOxiFUu
        IWi3FN/lgRCZzSs/X8L3ls9IhBTn5EAYsdSNl8icgW82CRenZoCHtp6TY5/nEcBm
        /aeSzl4aN1fSEPhDta+autGHnHlR0c5BU8Nn5EAn7oNeO2ryvk9TxWRw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=xfHjsk/Ab5em69ApY
        aItpIQPphwvspyed8kLJ5wDAeI=; b=fSxjvw9vctzACM5LBzDKVnTWLBLX1zeme
        TInmW2BHmpwQeRTReDm4qfVEY4hL2pvvWO//ydGGp9Iuc+2QMBwEePMsp43cHwkP
        Kn+rl9Rc1oaCj/wqZsCQtygZNgJbNHyY1GaTaUAI7zU5nI/nqgAGLqyMDEhMJ7iB
        bC7eDMMMan5X63XMoLD50wwulXgiWLupNl3ukb+al0lZ2THRaYxo1ZUcnjrYebZk
        bXMobl9+59EQW99vxi0y1IQ8jCpJGrrVgGu5qlBiyjglnY5UtjLKIG/PUoP33/no
        S4W2HNtLOS2FtumHgma1o+cKWPFfDB5RjCOFToKg56JnlsbmIDhfw==
X-ME-Sender: <xms:OcsBYpcCSbg20ERhG8gZsQNyjQLnAYiyXyMJh1dUFqneKHIvaOPSZw>
    <xme:OcsBYnPgk6xHSDc_UjEDuKfEeoLRQyP0IVCAuw15okiOAilxt_IHq81hqzaS8GiJT
    wFJrber2k8I90P9TDw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrheeigdefiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvufgtsehttdertderredtnecuhfhrohhmpedfufhlrggu
    vgcuhggrthhkihhnshdfuceoshhlrgguvgesshhlrgguvgifrghtkhhinhhsrdgtohhmqe
    enucggtffrrghtthgvrhhnpeeuieffteejieetgfevteelheevudehteeihffhteehtdet
    leegtedtvdevvddugeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehslhgruggvsehslhgruggvfigrthhkihhnshdrtghomh
X-ME-Proxy: <xmx:OcsBYig7AvLOOR686Tf17QJrIHieBoWbK6iqKH0DkHEgnjK2KogA8g>
    <xmx:OcsBYi-M3ImmHhqRLmp5z-vfD237yO7IxSe9Ykzu8eZTI3TkXylb4w>
    <xmx:OcsBYluucRK9FYANeYOkY7eodLNWzqhNDC-2DbYdNbfBD6vH-s0nEg>
    <xmx:OcsBYmmN3EP02T9q91SnHWDA40ne2XaivZAdsVxPwF60uBI86D14YStzy48>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 1863CF6007E; Mon,  7 Feb 2022 20:45:29 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-4748-g31a5b5f50e-fm-cal2020-20220204.001-g31a5b5f5
Mime-Version: 1.0
Message-Id: <26a95129-ea68-4877-b2d0-118bdb998611@www.fastmail.com>
In-Reply-To: <20220207103755.604121441@linuxfoundation.org>
References: <20220207103755.604121441@linuxfoundation.org>
Date:   Mon, 07 Feb 2022 20:45:07 -0500
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
Subject: Re: [PATCH 4.14 00/69] 4.14.265-rc1 review
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
> This is the start of the stable review cycle for the 4.14.265 release.
> There are 69 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 09 Feb 2022 10:37:42 +0000.
> Anything received after that time might be too late.

Compiled and booted 4.14.265-rc1 on my x86_64 test system successfully without errors or regressions.

Tested-by: Slade Watkins <slade@sladewatkins.com>

Thanks,
Slade
