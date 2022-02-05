Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8394E4AA6B9
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 06:14:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232148AbiBEFOk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 00:14:40 -0500
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:60315 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229486AbiBEFOj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 00:14:39 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 35557580168;
        Sat,  5 Feb 2022 00:14:39 -0500 (EST)
Received: from imap49 ([10.202.2.99])
  by compute2.internal (MEProxy); Sat, 05 Feb 2022 00:14:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        sladewatkins.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; bh=GgB5ue6nHvm1ln
        5ASBkfMq78HadgwpdH6W2KH2SgVUw=; b=Le2OiVV8S4El5NejK4fkVTdiVz5pnw
        8PPd6lBjIdmC5zm5Rj5Py724zRKyzbkdrYMEsjHdNsik3GJY1LilWWncGu0jMNhG
        kyEIDMX2LUkayqjTwAGTnZPYum2RMXjdQCcf90uOaQWUW8htB/XdR+qVd7ELgawv
        k5fFy9zCDf1kdtK4sMgGlYTRaqj/rFTSuNmIgy/IcKjhQ5FBd7JLVfbc1lRXtj6C
        O9Qn1BQfCap+AMXyl7HQX265NQxwlnk3/Oq1JjCn3oeKrHvX/qiQ5kH2UO/QjtOd
        q3YDwImgid44hquaeo1fgBQfmXLJCbPKEDyS7GfoCeQUZvzRz5GMhtCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=GgB5ue6nHvm1ln5AS
        BkfMq78HadgwpdH6W2KH2SgVUw=; b=km6rWcziSb0YZTQUhVNfBKr6IL0C6A0EI
        30bUITH5fR7tkVNCV4se2x1ibYVAW/U0+prmAucJinl8oqC+d1/0SUo5JZZgPA2s
        7VWzPE7JnIsVePx3h6jla1rBqByfDZkQc6Kr2X04UnKCqOR9ITwi+mrm2Cy4ZJkF
        l+1Y5AsXGJYbKfee1brmeM7Al4gYs7k36apRtMGEMypMMaP6kERjW4lp80GZnTAV
        RyuKFnjDnIuL37Yma+GUbXedkJyx6WHZ5yAOp3AMwx3ElaIPeVHsjYacdC8Io523
        UskApdhB/2EFZlr0HChkKLpr9LMO1ldLFinxvC4JJj/p6dkfgDYjg==
X-ME-Sender: <xms:vgf-Yd4NrwytpAhpA_MawSCFKgPU_xkib-SRb80TF5QVOO-6GuM6hw>
    <xme:vgf-Ya53nEH22FFRa_RLHppotwrg6fxuVxDqeaUnRPh6p9-_qrp4A1yW1ODsJpIUH
    NN8v7PGzfeXgOzmKBo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrhedtgdekudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvufgtsehttdertderredtnecuhfhrohhmpedfufhlrggu
    vgcuhggrthhkihhnshdfuceoshhlrgguvgesshhlrgguvgifrghtkhhinhhsrdgtohhmqe
    enucggtffrrghtthgvrhhnpeeuieffteejieetgfevteelheevudehteeihffhteehtdet
    leegtedtvdevvddugeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehslhgruggvsehslhgruggvfigrthhkihhnshdrtghomh
X-ME-Proxy: <xmx:vgf-YUeh7bJvTFpgI9mzUDljzNtP6nBToQUPknUOj6sU0sDjp9p0pQ>
    <xmx:vgf-YWLhajITD2N540pG_QMheZWa7DBq8iVPXXzvveU7axJ2k88wnw>
    <xmx:vgf-YRLHm3w_K2hiJc0iEy6JgtHNbk3JFcGY9aJCDlfuEoaH0x4PiA>
    <xmx:vwf-YeBBql_Kv-mZ5BN1f8WhM5r_CzOUp481pCGFO1WPGK0sXan9lpGL7F9O0Mkd>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id CE846F6007E; Sat,  5 Feb 2022 00:14:38 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-4586-g104bd556f9-fm-20220203.002-g104bd556
Mime-Version: 1.0
Message-Id: <97c33e1b-3b07-4b32-b31f-f4425edb3910@www.fastmail.com>
In-Reply-To: <20220204091917.166033635@linuxfoundation.org>
References: <20220204091917.166033635@linuxfoundation.org>
Date:   Sat, 05 Feb 2022 00:14:19 -0500
From:   "Slade Watkins" <slade@sladewatkins.com>
To:     "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        akpm@linux-foundation.org, "Guenter Roeck" <linux@roeck-us.net>,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, "Pavel Machek" <pavel@denx.de>,
        "Jon Hunter" <jonathanh@nvidia.com>,
        "Florian Fainelli" <f.fainelli@gmail.com>,
        sudipm.mukherjee@gmail.com
Subject: Re: [PATCH 5.16 00/43] 5.16.6-rc1 review
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 4, 2022, at 4:22 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.6 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 06 Feb 2022 09:19:05 +0000.
> Anything received after that time might be too late.

Compiled and booted 5.16.6-rc1 on my x86_64 test system successfully without errors or regressions.

Tested-by: Slade Watkins <slade@sladewatkins.com>

Best,
Slade
