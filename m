Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A741B4B1744
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 21:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237601AbiBJUz1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 15:55:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbiBJUz1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 15:55:27 -0500
Received: from new4-smtp.messagingengine.com (new4-smtp.messagingengine.com [66.111.4.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF64610C7;
        Thu, 10 Feb 2022 12:55:27 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 6752C580172;
        Thu, 10 Feb 2022 15:55:25 -0500 (EST)
Received: from imap49 ([10.202.2.99])
  by compute2.internal (MEProxy); Thu, 10 Feb 2022 15:55:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        sladewatkins.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; bh=wwKCXNdhpZntml
        zGFqcp0GxIpOAghWFs9swKtCeDavA=; b=ZVLMwYK3RH8eHkcN63agXdw/+DKumM
        n4bWYaH330sVIKaU7Wk7UEI9iJ16p6pmes1+iyAXq2i0trxYITw+UumOpLO/ObeK
        htcKAkijajL5UQKpUt4ht7Uv21BOQo1wgNTwEE4PBsiFS3XCXKhe/MtWynDU6n4m
        53v/7eND6bTTjcIdr6bV8iOf5S5HjxGRLKVg7qnbDvDKpsRNkRIUzpXOWTulMtbo
        2stcErmgF2BIOa/s2uGXhrXQGFKjsySkTBPlL4j4WY0+Qoyyk78RAlYxClLqBr/W
        kcNYoyT4HfdpRI3A9uSg98kKpP/u888Kj/NReTk96NA/1BAL+kjz3blQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=wwKCXNdhpZntmlzGF
        qcp0GxIpOAghWFs9swKtCeDavA=; b=emIZPqKj+r6S7z20jPeXEEU0HlA+R91K+
        KpmrZLZmeIS4lnRDGxCzL8e5rGWjTisbA7Dtj0m4EvBL+AVt8hhFk2dV3USmZ/jm
        MbzIY9rILd8X9j/rOkdeFrnSvCOjS5yqQeCiQmAhPWuFUeGiIRakrDAafepBt94U
        QcT0+JMQ+2OikUXH+1mQFjJfyyiHtd02rgZIqAsD5Q18IdtkRraFb7lNPHotti6n
        ADfxry3l+Sw4uSSpDA1Bm96ypDOQ/ZXFCHcTf3sNxjZb+yLE1TzkJbW3jdLm5rql
        jywZSLu9UrI8ms5VQOeZ1ALHJnAyoNILq86oj9Sw3ttILbLmMpYCQ==
X-ME-Sender: <xms:vXsFYnD-sqP_XgYQQ61NCnCLvuRBUDJn-tLmaaku04D9X7I-voE0Pw>
    <xme:vXsFYtgRBXs5a-JiPpn_9Ijf4d492AYzb5odoo88DLYOHnGPT36bh9i19slPMEskX
    5_93AbNEfaTho3LRG4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddriedugddugedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvffutgesthdtredtreertdenucfhrhhomhepfdfulhgr
    uggvucghrghtkhhinhhsfdcuoehslhgruggvsehslhgruggvfigrthhkihhnshdrtghomh
    eqnecuggftrfgrthhtvghrnhepueeiffetjeeitefgveetleehveduheetiefhhfethedt
    teelgeettddvvedvudegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepshhlrgguvgesshhlrgguvgifrghtkhhinhhsrdgtohhm
X-ME-Proxy: <xmx:vXsFYikBsandNZqmZNKDqUMjJYV5bBpXMqE6kZ5sDbsHfSB09VLfIA>
    <xmx:vXsFYpzAFyzV4zkGZo7IOF9BwAzUtZvreyj8jffKVM3j9SiS9Af7Mg>
    <xmx:vXsFYsTuPDGno9F4YWMrtiHaLsIJfJqakSFRVWflRSjjfTuTAQnesA>
    <xmx:vXsFYhK6jDsMp8Ehs1ETt1w-WpUTk5YOYDAzXKv9JPRYxWYDig0L7oGs2l4>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id DCB96F6007E; Thu, 10 Feb 2022 15:55:24 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-4748-g31a5b5f50e-fm-cal2020-20220204.001-g31a5b5f5
Mime-Version: 1.0
Message-Id: <cf61a232-474c-467c-83eb-c7ce59dd8854@www.fastmail.com>
In-Reply-To: <20220209191248.688351316@linuxfoundation.org>
References: <20220209191248.688351316@linuxfoundation.org>
Date:   Thu, 10 Feb 2022 15:55:21 -0500
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
Subject: Re: [PATCH 5.4 0/1] 5.4.179-rc1 review
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

On Wed, Feb 9, 2022, at 2:14 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.179 release.
> There are 1 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 11 Feb 2022 19:12:41 +0000.
> Anything received after that time might be too late.

Compiled and booted 5.4.179-rc1 on my x86_64 test system successfully without errors or regressions.

Tested-by: Slade Watkins <slade@sladewatkins.com>

Thanks,
Slade
