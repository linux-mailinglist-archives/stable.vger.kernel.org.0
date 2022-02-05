Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5024AA6B5
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 06:08:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232114AbiBEFIH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 00:08:07 -0500
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:54809 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229486AbiBEFIG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 00:08:06 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id B9E91580196;
        Sat,  5 Feb 2022 00:08:05 -0500 (EST)
Received: from imap49 ([10.202.2.99])
  by compute2.internal (MEProxy); Sat, 05 Feb 2022 00:08:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        sladewatkins.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; bh=2RlY4R9lybWwdv
        24B6zmGkCHz3KZPXtlvbnrbu1Kd54=; b=pdt/ZcbAoNfVqEQNoU3SpgTp9hnM2L
        z2Z4uImJiM1n2cfElE+tkp4V/e2F9hLzrH4ARGe+K9g42+VSue6+FhXHsckwv1nk
        wdDzX4WJy7VrIwQARoVpP/7j3pnRNJaf7v3j1UBAl+LsIZ1n54I2lEl56fJY/X4m
        tT1zNT1wl+du5zq0tW4RAYT1pbzPKCBqsjXHOu4QYIV6e3IGWQU6ZAaNurvsl5gd
        ohepwiBzU7tB9heVPJxZwrs2GNHWOrvI7DxwBfzgCbacv02tj/pkuA/O2gTAtYu9
        UMsThud1YRZL3+FCmRCKHSUp0qLzzT6Mp2nX7WeWwWpDnYsBofAka4PQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=2RlY4R9lybWwdv24B
        6zmGkCHz3KZPXtlvbnrbu1Kd54=; b=hWRK9/j56zu/1ZnLAdI+tcL7N/fNsIGCe
        PsC9OTjQO8goGKX+AgD9dd3Hl+PWdilvUgZPMTxsv4ny/kY1FMtQGzj2ZG0SaAV1
        IwUHmWumv2tR1Jlv4BBkg0PsdLxGaRnzHU90qHu6qfK1sDXjf1s9laH5uhgSSJlD
        l5twxeDGp3hxOxyiCWonKz7K8V7joBdPnFpofdVkhdUFmbeNpBosmQ4HfJBPJU4r
        Yx6x+K94O6eR1e8b0PcoRUCKL/6+HIsnPhMJIdivmffY9UADXUotRgBskeO9RfhO
        R0nkKviZ/RD96RAAWRrVTd2Lj30xcviYvgGWV2HV/TZmlUA36UGRA==
X-ME-Sender: <xms:NQb-YUzZnedkmd6aE0QLK5xi-Isk5zTwr1B8rSc4bpMON4voZTNRhg>
    <xme:NQb-YYTpdfE_4ehjCDMm-qYsnsGOnniSsqg9SsFbvwYtCuh0ef9oj74iUUaN3y-EM
    HnBcTByrbvVcnmHGNs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrhedtgdektdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvufgtsehttdertderredtnecuhfhrohhmpedfufhlrggu
    vgcuhggrthhkihhnshdfuceoshhlrgguvgesshhlrgguvgifrghtkhhinhhsrdgtohhmqe
    enucggtffrrghtthgvrhhnpeeuieffteejieetgfevteelheevudehteeihffhteehtdet
    leegtedtvdevvddugeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehslhgruggvsehslhgruggvfigrthhkihhnshdrtghomh
X-ME-Proxy: <xmx:NQb-YWVdEXQTpcEVZO3mgx9dcOmNzWHZdzxXh6l5oGJh9kfo2JWlag>
    <xmx:NQb-YSjuTPmdC-EKzV9swTwIAtWLb_x0oKHZddh6riANVjYX_aomrw>
    <xmx:NQb-YWAb3bxUe7vhVeYAxyL_5NVlK8TtyC1zaYO53iJqVLBLYgDkwA>
    <xmx:NQb-Ya5FQaYoG7MXvI7gd4VECRMLs3dJ_Wx3MbgBDT_b9xQh3axmqQigZThON7dD>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 0FF42F6007E; Sat,  5 Feb 2022 00:08:04 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-4586-g104bd556f9-fm-20220203.002-g104bd556
Mime-Version: 1.0
Message-Id: <4aab1871-f009-4f34-b563-5320d691f921@www.fastmail.com>
In-Reply-To: <20220204091915.247906930@linuxfoundation.org>
References: <20220204091915.247906930@linuxfoundation.org>
Date:   Sat, 05 Feb 2022 00:07:44 -0500
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
Subject: Re: [PATCH 5.15 00/32] 5.15.20-rc1 review
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 4, 2022, at 4:22 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.20 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 06 Feb 2022 09:19:05 +0000.
> Anything received after that time might be too late.

Hi Greg,
Great news, I was able to compile and boot 5.15.20-rc1 on my x86_64 test system without any errors or regressions.

Tested-by: Slade Watkins <slade@sladewatkins.com>

Thanks,
Slade
