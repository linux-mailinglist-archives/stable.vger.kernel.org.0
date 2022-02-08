Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D47B14AD1E4
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 08:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237121AbiBHHDn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 02:03:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233309AbiBHHDm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 02:03:42 -0500
Received: from new3-smtp.messagingengine.com (new3-smtp.messagingengine.com [66.111.4.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 007BEC0401F4;
        Mon,  7 Feb 2022 23:03:38 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id D1CE35801C4;
        Tue,  8 Feb 2022 02:03:35 -0500 (EST)
Received: from imap49 ([10.202.2.99])
  by compute2.internal (MEProxy); Tue, 08 Feb 2022 02:03:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        sladewatkins.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; bh=1zZeOHN8TQZQpX
        SBE9ns/EHrQBA4/VHUOn1td3lu4bY=; b=UPeru9y8pzDYJINqGGFCZLTaoiE2Cc
        NjBbWZ8dz+XyohKX+vsHRBDrFAPeZdNfZr/qqQcUbWpUBi/o6tK6rdTaAlvlexGO
        49rKVQSpZa09AZijMIhybcogle1+cQlg1xF2RiNql5rbdKLHcqQ11dgoL5tVwyV5
        bdKdOvaZItuTbIGn4c+mRhLmInbmq3g2a+wO/MCZKCaEYVxt4l2Eoc04SI9x3+7K
        QpCY1zMPY+75f3qCgrLdW6eGUuaCrTRpypMv8Hd5+T6JLUzL1WLVEzNI1MWZ916P
        kXEAakTn3Du5RV09kwY4NVd9I2BOHas5DpIpE8HQgTOFr59qHKYNO5VA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=1zZeOHN8TQZQpXSBE
        9ns/EHrQBA4/VHUOn1td3lu4bY=; b=kCzv7xzpIq7NAwTR6wdnR/Xlc8apTdgz9
        uWiA8MFf/uvYZQDhulKNlqybNVQii+7YHNV7jb1qQv6WI3M9DWycoAumsMeFok++
        U7qiApcX+YNe6zgrPBfEM/r+XBt2Kk1HLKFPU3WJHAJfpMA5Gtj5iJiSHzx5gfO6
        KmQq/PGcYfGv3kzy/pKwkcKGczWWNo+Kd5KvAFpMK1T7hqTBzxcKpNA80GIzng7L
        D6+20bn6CatlPwd9l02HECDEJ1sJvtOQ+kG+UW0nVps1PrqCsjkpWTmyKtE+Wm6D
        mWJ4tsEN0M5dC2DMj5FXmiqMAN8Laa7XbNl6Z5C03hx9rIxSIgwXw==
X-ME-Sender: <xms:xhUCYmkROP--4Oe2xv_yfKO-ck5upi_vNrHamTBPa1tCvZebTM__jw>
    <xme:xhUCYt3bRW2NwkLZMxmxjIR15EoosSxdENleGL2nx_FOfZDyKab1Iy7cg2RlIvQY4
    pn4z-kQikTSXYEvaKs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrheeigddutddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvffutgesthdtredtreertdenucfhrhhomhepfdfulhgr
    uggvucghrghtkhhinhhsfdcuoehslhgruggvsehslhgruggvfigrthhkihhnshdrtghomh
    eqnecuggftrfgrthhtvghrnhepueeiffetjeeitefgveetleehveduheetiefhhfethedt
    teelgeettddvvedvudegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepshhlrgguvgesshhlrgguvgifrghtkhhinhhsrdgtohhm
X-ME-Proxy: <xmx:xhUCYkqDY5eEl7_pdGQSlNL1hNjkl_AwxV7yMPfhOPjnVjeAW3Yj8A>
    <xmx:xhUCYqnOblalu6JZb__5uDzjbrlPyo2FbT1lxQiA8OGQIMaTgJnb7Q>
    <xmx:xhUCYk2Y6ajGQ_zUSgGSPvHOWWinMZfL_T770ceGmj-iBZ6EU91MWA>
    <xmx:xxUCYtvXyik6yDHJxqssZVzsf-ZNyYdXU45__DV0xwlaUDQ5nJBvU_0U4Cw>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id CEAC9F6007E; Tue,  8 Feb 2022 02:03:34 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-4748-g31a5b5f50e-fm-cal2020-20220204.001-g31a5b5f5
Mime-Version: 1.0
Message-Id: <16bbddcb-d827-490a-ac80-cd5a75404d6f@www.fastmail.com>
In-Reply-To: <20220207133856.644483064@linuxfoundation.org>
References: <20220207133856.644483064@linuxfoundation.org>
Date:   Tue, 08 Feb 2022 02:03:33 -0500
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
Subject: Re: [PATCH 5.16 000/127] 5.16.8-rc2 review
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

On Mon, Feb 7, 2022, at 9:04 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.8 release.
> There are 127 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 09 Feb 2022 13:38:34 +0000.
> Anything received after that time might be too late.

Compiled and booted 5.16.8-rc2 on my x86_64 test system successfully without errors or regressions.

Tested-by: Slade Watkins <slade@sladewatkins.com>

Thanks,
Slade
