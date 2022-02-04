Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 167554AA45D
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 00:31:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240215AbiBDXa7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 18:30:59 -0500
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:49799 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234948AbiBDXa7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 18:30:59 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id D6305580223;
        Fri,  4 Feb 2022 18:30:58 -0500 (EST)
Received: from imap49 ([10.202.2.99])
  by compute2.internal (MEProxy); Fri, 04 Feb 2022 18:30:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        sladewatkins.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; bh=/Gar/Fx++ay0RV
        7YJePn9xaoNkH+lcUDzbM2SCj8VPM=; b=zI7xkMv7IDW7GjQ3VH4et4ijNaPCEQ
        MZz6wJ90AFGrI6L8QTazBX6nKgNJc8of2qoDmk3EzXpzHOP2TqmbCXD2B/OZqGze
        eyOftaCl4p78lAYXGYjk3242AgoaSFBjTufHNoyFvNF9rBNApGPYWlmL6aAshmNM
        evSHHS/vpbB2GiYk91hH1LiKHM8drPPbA2TIskHyHxtL3Yo/Lz1K5XWshISDMbcR
        iPTgm9DEEQ8gTBw52L8BYLtxXFP25VWPA4EIdhn31eP6zdtstccKgzLZWggF5CYP
        gC41yQsq1+x9roAl4jLn/6GbhhWwpCNoYNNN7zMF9XXgjbW4UzH5043w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=/Gar/Fx++ay0RV7YJ
        ePn9xaoNkH+lcUDzbM2SCj8VPM=; b=fi8Gt0PFzyGaFrSZ85prlTi+nzsdwCdNr
        BDxM6I6Ros2E/nbf2pulaSWc9VnndptwnEUFGdvTaJ6s5zGg/3Rl3/s5H6rQPRfd
        IDHhmuBdo4VDQenaZBXSMskMCreVtqIEpYFiSWrC0QI5pWqqTUQP8s4K9JWMLjEy
        nw0p+dJLbWJ6eXDYMAIj/L76hC9q3SIYqAuFcW/0PAQesubJc/qJzdQbutOA752d
        05a57QEOmmRKyVAVpGmnTE7clSFLKxhCVFn971GmPsb6OdoeY1ZmSiIGJSKFdmmY
        +HoV/0FjAtY4Z3w2zOyt2K2ShEIsM2z4qqtQfuc3Hk56OTcuPdHPQ==
X-ME-Sender: <xms:Mrf9YY2cszxsmmpgBXdmPe4Uk0aPbzSaFO0T7WQhl6e4maCUDao-9A>
    <xme:Mrf9YTFyEhfL9m7MOlvq7fkthdtAj-j8onEN8c6t6gYnY5SKV_n7-6XEBOnl4hDea
    de59FW5_u3fzjigoTw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrhedtgddutdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvufgtsehttdertderredtnecuhfhrohhmpedfufhlrggu
    vgcuhggrthhkihhnshdfuceoshhlrgguvgesshhlrgguvgifrghtkhhinhhsrdgtohhmqe
    enucggtffrrghtthgvrhhnpeeuieffteejieetgfevteelheevudehteeihffhteehtdet
    leegtedtvdevvddugeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehslhgruggvsehslhgruggvfigrthhkihhnshdrtghomh
X-ME-Proxy: <xmx:Mrf9YQ79_h972gLe2YFcd2aO5BZ5dZa_4R50bpPkZt5fYzOaZPELqA>
    <xmx:Mrf9YR2_t2jgJ1OeifWKhB_byRPQSSJjJINJBVMGHmTI67lNdksj6w>
    <xmx:Mrf9YbEx8DzpyZ9p-bThyERMSNiyFScJG-TFuaY-xq05pTSuZDOiHg>
    <xmx:Mrf9YT-S-s2JwfUqMAeFfiXuYtFrr1x9LuEv5ZZtHDNyyNAJsaFLgXLao3woNwpC>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 3006FF6007E; Fri,  4 Feb 2022 18:30:58 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-4586-g104bd556f9-fm-20220203.002-g104bd556
Mime-Version: 1.0
Message-Id: <a30a737c-aa03-475f-afc1-a51ba01c7c37@www.fastmail.com>
In-Reply-To: <20220204091914.280602669@linuxfoundation.org>
References: <20220204091914.280602669@linuxfoundation.org>
Date:   Fri, 04 Feb 2022 18:30:37 -0500
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
Subject: Re: [PATCH 5.10 00/25] 5.10.97-rc1 review
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 4, 2022, at 4:20 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.97 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 06 Feb 2022 09:19:05 +0000.
> Anything received after that time might be too late.

I was able to compile and boot on my x86_64 test system without any errors or regressions.

Tested-by: Slade Watkins <slade@sladewatkins.com>

Thanks,
Slade
