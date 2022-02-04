Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 105384A9C0F
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 16:37:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238307AbiBDPht (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 10:37:49 -0500
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:37617 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230213AbiBDPht (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 10:37:49 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 082A95801BC;
        Fri,  4 Feb 2022 10:37:49 -0500 (EST)
Received: from imap49 ([10.202.2.99])
  by compute2.internal (MEProxy); Fri, 04 Feb 2022 10:37:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        sladewatkins.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; bh=266dD4NSwPNPJn
        kKiQXQOc827T09N8MFgpqfM7Ib0kM=; b=WQkfIUHvk6BMHz7UxvmVJTWM1B2eAS
        NFLEj/2WJhiDCqVK4LaV25jRxHyP8yMdlPgR2+95yJH/f+j1hQOogysYS2Q5j2t5
        h8DlZty1FAR52I73TTGR8yB1J5ejakPor+tnyK+XWqutSDctwJvyJ9ayeWNxuFxT
        l+UVSK/3c08r4rlFbxNfOiX+hmck6v420zQ8jOHr6D3DJHjWlnDSy2hhFhXKtZ4F
        M9CeWH8+5j9dG4zDyTgG3isLDBNC44fupINXP81IqUKzTBkpKdLt5MPxlcI98NW/
        ZBJujkG5ohnIoIXcfiCjYDutoddHEAE8pikATTJQZm/4i350JpNdvEKw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=266dD4NSwPNPJnkKi
        QXQOc827T09N8MFgpqfM7Ib0kM=; b=jWb+JiWqDB466InmUuY4zlI8KxsslyTON
        xsQ6WvlAz8bmsGyJWup0hkroKxeFY86RcclB6AGxsEeMTD/XKpo1/zpa+F8zfHut
        kl8GRklliYS5OncWziQQ7ivg26XbI/UlPn0Ip07yTz6Y5FFrNz5ppz4jAWcqzJXa
        VjGx2CZ1dFFuA2aG0iomFcAV7ZJKAPa0cDvrY/q03aVEIGR5D1HskEdVeD+FiXqY
        aX2upnJaP0je4F3bN/J4mqkV5z5WLMp4Mr2qFad85NRt1XvCKtEgjn0nkBvn7hiE
        qLmhGo0Qxv99IXI+2pRZIIvZ/PHnB8AQz6+9hvJimV3df0AG/HC6A==
X-ME-Sender: <xms:S0j9YToEFFW9nqR2aVANEP5NURSY0_aK2qAkRl1w-mtn5QNYx49FJg>
    <xme:S0j9YdoEwK7B__OZseWIPGRFZ9QPuAgORJrRcfWhBGN3ILmkBqTa7zmPNcBCS_1aK
    bVynTA0vqyYe3bUKL8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrgeelgdejkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvufgtsehttdertderredtnecuhfhrohhmpedfufhlrggu
    vgcuhggrthhkihhnshdfuceoshhlrgguvgesshhlrgguvgifrghtkhhinhhsrdgtohhmqe
    enucggtffrrghtthgvrhhnpeeuieffteejieetgfevteelheevudehteeihffhteehtdet
    leegtedtvdevvddugeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehslhgruggvsehslhgruggvfigrthhkihhnshdrtghomh
X-ME-Proxy: <xmx:TEj9YQNFdmhbQ2RNMd5dgOXCS7yOIltoaDLH8Jjpetl1UxVlIQv07w>
    <xmx:TEj9YW6AAzq7I57IsagmTtoROi5hqscSKZVdpzP877iio5ksqUkZkQ>
    <xmx:TEj9YS5HjN7QftxsglNmwTFVlO5g1aLDzgKhWgPTOPVaouC4X9H0nw>
    <xmx:TEj9YfwAa6sjpx76YJXnKq8xxGolKegyXkgXKjxk0JURDWl1BjkVvOBqpjqXCz1c>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id E3DF2F60083; Fri,  4 Feb 2022 10:37:47 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-4586-g104bd556f9-fm-20220203.002-g104bd556
Mime-Version: 1.0
Message-Id: <69db93e6-f542-4d59-8f3d-39392d3e8b06@www.fastmail.com>
In-Reply-To: <20220204091912.329106021@linuxfoundation.org>
References: <20220204091912.329106021@linuxfoundation.org>
Date:   Fri, 04 Feb 2022 10:36:37 -0500
From:   "Slade Watkins" <slade@sladewatkins.com>
To:     "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com
Subject: Re: [PATCH 5.4 00/10] 5.4.177-rc1 review
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 4, 2022, at 4:20 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.177 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 06 Feb 2022 09:19:05 +0000.
> Anything received after that time might be too late.

I was able to compile and boot on my x86_64 test system with no errors or regressions.

Tested-by: Slade Watkins <slade@sladewatkins.com>

Best,
Slade
