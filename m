Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 703F34B5CF2
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 22:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231543AbiBNVf2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 16:35:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbiBNVfV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 16:35:21 -0500
Received: from new4-smtp.messagingengine.com (new4-smtp.messagingengine.com [66.111.4.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86C1D12BF5A;
        Mon, 14 Feb 2022 13:33:09 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id D94965805C9;
        Mon, 14 Feb 2022 16:33:08 -0500 (EST)
Received: from imap49 ([10.202.2.99])
  by compute2.internal (MEProxy); Mon, 14 Feb 2022 16:33:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        sladewatkins.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; bh=TegN10TcON7Ef9
        rSlWGRxf3RX8/SkGBoxJPDJKmn5m0=; b=hIhkwsH/rs82TnIcSVip6DWPIA3VG9
        KRH2shsFgkaZaIEecz7Fy6tGn0R/tX4SiXfDJNxYDAxt+5CBXaCofpF0HgJ+/PiW
        6NMm5LR6xYqrKGoG8lb88Mdfd+iMCbieonUJNMqIA1OOCR7QqRul7fkkvTOM6/ar
        qLjkvk+LLGZp9QoYNJ9ampIiGywrE4mtBTZ7m8KDI3o+50bcKnmr7hB2e0G21Q11
        TIt9u2X2hRRIHeZTO0v1WpzuKF0sCipGp1a6ucfSrRfG8MZza2fOsMejIRofuicD
        rdzkBOJGlEaxWboGEeSYUT/uOd8sfDnfVQ35f0vFEF+4mzzDNoM3fsmQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=TegN10TcON7Ef9rSl
        WGRxf3RX8/SkGBoxJPDJKmn5m0=; b=D5qE62cB5M3jf3Jud+PtuNSGQb6NXuSW7
        qZjFVfd3a3jzfPghJAoKTPl+13fsW3ZhBu/A5T5RhyC5au5X3lwu1TBSPreieM6U
        wkWzaLVL092PRgACm9slTjN8ZMDNdGAicD9LT9twyZy9/UoBCgh0lRPg9zgk7N+Q
        9eZohI2nspzsUZ2rPwnDX58sBL6SNJ6x67wjzDCgC6UjGbRIHrLaHGoPH9Rs1qyr
        nNKLCwgUHNn9bO7k1rrQI0TenLs34EuKq4PqajgE71vX6c2jlz5Bt03rFeKNwovB
        hYiYs+MWUCT3QyGvkui83SGUheoHAveq652nHWhykFc1RWEjSf1mg==
X-ME-Sender: <xms:lMoKYoZFAvbCo5jjPJCPlGBR0lW2D0vXJpX1zHsLfPqHVb577qA2bA>
    <xme:lMoKYjYa7FyBcZxy8Z2SFgw7nkHsHA-A19hDkH5wAv7vY_RsFAZcnjuq1A-xmY7re
    WmXolcyYoMs6wPssBo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrjedvgddugeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvffutgesthdtredtreertdenucfhrhhomhepfdfulhgr
    uggvucghrghtkhhinhhsfdcuoehslhgruggvsehslhgruggvfigrthhkihhnshdrtghomh
    eqnecuggftrfgrthhtvghrnhepueeiffetjeeitefgveetleehveduheetiefhhfethedt
    teelgeettddvvedvudegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepshhlrgguvgesshhlrgguvgifrghtkhhinhhsrdgtohhm
X-ME-Proxy: <xmx:lMoKYi8FPKX4JtsyhHGUM3wCTBa-s19YyY4lX9bsBTqMIMCHk1zHuA>
    <xmx:lMoKYirbbRW78lzYlzjP13WHgUyJpTvxFC8B9OLCAGGFZHLWzUSIVA>
    <xmx:lMoKYjrRqYXmBpC6GmtGwgneqSSuD4-ZXUbQsVqvG7UmylmOpFXsEg>
    <xmx:lMoKYggmb2JsBcFJeEtEDVkJLop3NqMg_gKIuwAB3q_pwdb-kthvGYCF5Vs>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 826B7F6007E; Mon, 14 Feb 2022 16:33:08 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-4748-g31a5b5f50e-fm-cal2020-20220204.001-g31a5b5f5
Mime-Version: 1.0
Message-Id: <afdf21e9-7576-473d-bcee-7ee8bd373fae@www.fastmail.com>
In-Reply-To: <20220214092458.668376521@linuxfoundation.org>
References: <20220214092458.668376521@linuxfoundation.org>
Date:   Mon, 14 Feb 2022 16:33:07 -0500
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
Subject: Re: [PATCH 5.10 000/116] 5.10.101-rc1 review
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 14, 2022, at 4:24 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.101 release.
> There are 116 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 16 Feb 2022 09:24:36 +0000.
> Anything received after that time might be too late.

5.10.101-rc1 on my x86_64 test system compiled and booted with no errors or regressions.

Tested-by: Slade Watkins <slade@sladewatkins.com>

Thanks,
Slade
