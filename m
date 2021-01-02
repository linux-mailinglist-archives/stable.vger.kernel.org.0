Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 706BF2E862A
	for <lists+stable@lfdr.de>; Sat,  2 Jan 2021 03:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727038AbhABChR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jan 2021 21:37:17 -0500
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:39259 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726424AbhABChQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jan 2021 21:37:16 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 4F70D580396;
        Fri,  1 Jan 2021 21:36:10 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 01 Jan 2021 21:36:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
        subject:to:cc:references:from:message-id:date:mime-version
        :in-reply-to:content-type:content-transfer-encoding; s=fm1; bh=x
        yRrbT8lXGFkiDEUfbBEaK2NaqFc77PXiY9PLLIADYI=; b=gCcYRkSO36qASJ8hG
        NRjHzojE1vA9uy3ZSzEkOUAUL0sn+g3rAvKind+h8p44JJu33Cqsep1z/4zNGTBp
        4mRH0CtbvgVhiSdD4a12E4xVUYU6bAt0azY0jv0BVUTZYJqb2P9FJyjvrg2S/CdP
        HTxF2D0faCg/SA8I84H/d5Ld6soKQ72+eNDIO6DTnsKWRtFuxFSCWawKm9dQFS0N
        NrbvS0aB7iFZOzZknkWI/ATk096PI0LDxIt2oZTZvi9lz/Fm2LVbgwo8DnwS5ra9
        /EqBjeBoBmMJsjpJwVyvfFiKlYPTYwZ/+tMjG8mwVNMSYHMObaT9oQxSrlKfCwm3
        GTGVA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=xyRrbT8lXGFkiDEUfbBEaK2NaqFc77PXiY9PLLIAD
        YI=; b=raAj0+vsSZQWz6rq2fgzYHTjCigp0ytuPhEaZnzKIe335a8vAzEzISiht
        fmHzzwmzKGL5U7UqSt14Xv/yjFckHl1a1Y1+sSYe0bu85UC9seOsJVrx1IgVAvxl
        WbbP6/OZn4gEf8oSCVYxB4XNhkzfi0nDc5Q/KK72P7iC9BTLxYyfhZjqjdWXlFbo
        n+tyTGS2c4bv/FpSxKbiQZgVEbMFVUoa0essHziKQL2rn0JnfyeVkK+gDQivgjSz
        n0MlLXAtqmRhIpQaQ70AM7hjbpTJCgwjNNMPOiZR0ln0YUzTSpbidraWlkb445s2
        q37AsQSvalyl5jf3jHzYc0A/h+e3g==
X-ME-Sender: <xms:GNzvXxIO8iVRz9kUCfG8_qFXOO5IqMjjfEWdFSGbTbTC2AyxtX8zHw>
    <xme:GNzvX9JFQn1yH3AuuBQWPa0pGs6kMCF3EshbEj84PxEh2VJ7LO8b8tgdDnGXR_Gip
    lPmdrAmcBFSau5pI9Y>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvddvkedggeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepuffvfhfhkffffgggjggtgfesthekredttdefjeenucfhrhhomheplfhirgig
    uhhnucgjrghnghcuoehjihgrgihunhdrhigrnhhgsehflhihghhorghtrdgtohhmqeenuc
    ggtffrrghtthgvrhhnpeeihffghfeikedugeejvefgffevgeevgeehfffhudeiieffffev
    ffeugeevfefgfeenucfkphepgeehrdeffedrhedtrddvheegnecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepjhhirgiguhhnrdihrghnghesfhhl
    hihgohgrthdrtghomh
X-ME-Proxy: <xmx:GNzvX5u-6lA0nFN4mCw4MddHNHBCt9yo-0_mHyVAOyNB8o9wPayoxg>
    <xmx:GNzvXybW-cCZl7_m43NV5sCxwNirsyxEA2u_b8XQNGkUJ-LKHK-zgw>
    <xmx:GNzvX4YWEjzf_ZZ-ayQGP511zCox2fk57M0rN7s6cJ03HdHJowZbJw>
    <xmx:GtzvXwGJvv7RchG-AkPG4E9x4Uy9_4GeJ1GgNAhQJZjAUPOXyDz2Tg>
Received: from [0.0.0.0] (li1000-254.members.linode.com [45.33.50.254])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0EC3E24005A;
        Fri,  1 Jan 2021 21:36:05 -0500 (EST)
Subject: Re: [PATCH] platform/x86: ideapad-laptop: Add has_touchpad_switch
To:     =?UTF-8?Q?Barnab=c3=a1s_P=c5=91cze?= <pobrn@protonmail.com>
Cc:     "platform-driver-x86@vger.kernel.org" 
        <platform-driver-x86@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Ike Panhc <ike.pan@canonical.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <mgross@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20210101061140.27547-1-jiaxun.yang@flygoat.com>
 <_kQDaYPt7vh_mQfPr1tLJV2IP-p40OBPcU5zk-1xHhF9XJsm8Y-efANBgiRdWU-J2QTtOjmrfE0Tw6UrZpm6uG-zZGlfpaVOp9FuoKAbjzA=@protonmail.com>
 <bcb3bc76-da83-4ee1-8c2d-0453d359ae37@www.fastmail.com>
 <XVSpzJf9TdCi-rg53vfxB7yLg8VJQsQVbqoC1Fu1L7tL5mPKCpMABkedQNatITMiUy7pvBC7g0Cqd30-zqc0bCsSSoy5YXp_gJLTLM0odTg=@protonmail.com>
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
Message-ID: <063eb02d-a699-3f6c-fd1b-721e9d195e82@flygoat.com>
Date:   Sat, 2 Jan 2021 10:36:02 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <XVSpzJf9TdCi-rg53vfxB7yLg8VJQsQVbqoC1Fu1L7tL5mPKCpMABkedQNatITMiUy7pvBC7g0Cqd30-zqc0bCsSSoy5YXp_gJLTLM0odTg=@protonmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

在 2021/1/2 上午1:09, Barnabás Pőcze 写道:
> Hi
>
>
> 2021. január 1., péntek 17:08 keltezéssel, Jiaxun Yang írta:
>
>> [...]
>>>> @@ -1006,6 +1018,10 @@ static int ideapad_acpi_add(struct platform_device *pdev)
>>>>   	if (!priv->has_hw_rfkill_switch)
>>>>   		write_ec_cmd(priv->adev->handle, VPCCMD_W_RF, 1);
>>>>
>>>> +	/* The same for Touchpad */
>>>> +	if (!priv->has_touchpad_switch)
>>>> +		write_ec_cmd(priv->adev->handle, VPCCMD_W_TOUCHPAD, 1);
>>>> +
>>> Shouldn't it be the other way around: `if (priv->has_touchpad_switch)`?
>> It is to prevent accidentally disable touchpad on machines that do have EC switch,
>> so it's intentional.
>> [...]
> Sorry, but the explanation not fully clear to me. The commit message seems to
> indicate that some models "do not use EC to switch touchpad", and I take that
> means that reading from VPCCMD_R_TOUCHPAD will not reflect the actual state of the
> touchpad and writing to VPCCMD_W_TOUCHPAD will not change the state of the touchpad.

I'm just trying to prevent removing functionality on machines that 
touchpad can be controlled
by EC but also equipped I2C HID touchpad. At least users will have a 
functional touchpad
after that.

>
> But then why do you still write to VPCCMD_W_TOUCHPAD on devices where supposedly
> this does not have any effect (at least not the desired one)? And the part of the
> code I made my comment about only runs on machines on which the touchpad supposedly
> cannot be controlled by the EC. What am I missing?
>
> And there is the other problem: on some machines, this patch removes working
> functionality.
Yeah that's a problem. I just don't want to repeat the story of rfkill 
whitelist, it ends up with
countless machine to be added.

Maybe I should specify HID of touchpad as well. Two machines that known 
to be problematic
all have ELAN0634 touchpad.

Thanks.

- Jiaxun

>
>
> Regards,
> Barnabás Pőcze

