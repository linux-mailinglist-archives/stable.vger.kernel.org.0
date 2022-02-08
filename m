Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29CA64ACE7A
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 02:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343600AbiBHB4V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 20:56:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345421AbiBHBzy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 20:55:54 -0500
Received: from new1-smtp.messagingengine.com (new1-smtp.messagingengine.com [66.111.4.221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67A64C061A73;
        Mon,  7 Feb 2022 17:55:53 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 19726580226;
        Mon,  7 Feb 2022 20:47:37 -0500 (EST)
Received: from imap49 ([10.202.2.99])
  by compute2.internal (MEProxy); Mon, 07 Feb 2022 20:47:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        sladewatkins.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; bh=AIJDFoyXpBhaPA
        EgX+WgiEi6pe71yl0G8E0zD2RLtzo=; b=uEyIkkvsaFUbmHPtcV16zeiQD/GArt
        twWFIaXjueJ4u9/Op5ngV9gvv3kuuhX7fluyb43yrSr+rAjyC3X8q3PVN+go63qe
        ZyVwqns82CRYJ7s3KTA9jPwujPpzgtPCSTHj/FnWFW30F+LpH7Q/qZpJ2+X+4QyT
        IEPmdlkCu1dXqhNa4cdnEvUm9OwMPLpd8DTaQRahEDiWj9o5vZyDm1m35Hu/GQKr
        3U72eJyatvYBZ3L/kIq0lUtTgQXmJydhUFZCDbSGkPkBT/72Z2E0pmphTvNnHgwq
        h9j0MDyKj+vwuL/FNFVp9hS3pzQeYxzHbQ/UtX/wIJ3YhnixPNGWbPcA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=AIJDFoyXpBhaPAEgX
        +WgiEi6pe71yl0G8E0zD2RLtzo=; b=WxUdLolZxdXn1EQBoBn+lzu29baRI8OBY
        AUbD6kKj7Tg53TJaNU0qzTBAKdiw55cIjphKk5eP/tNOVseZ0D69PJE4TZqsNvgM
        g2GBvsLYImy5tZPP0znuk3wesu/3b6rJaRGAOPTmZbAEHOmBwTiqEaXTMFiWBIXm
        shcGlBffcvAXxxs8PzoKje05AG4vtRlbfdEXaPG+6uqK7rPUo8ifP878eEFosQ5j
        nX/8Kblri4lCIuDjpoLC1VrEd2Dh5uRfxW0kZMF7K1ISlQiT+tOwsnZ90knGp6o2
        JPvH0vEFxab4NhlZztUIOdsuw3/kJhujuhdGxs2sMLmLGpG1pelUA==
X-ME-Sender: <xms:uMsBYkI0X2BX9JqxhUJ-2g0mdrn5LB0BY2B34pGTxiE8Cq74BDOQRA>
    <xme:uMsBYkKoSkJ69szOUi1B7x34_KsGeGTgyB-31g_Woana1dFTvBMCGTKnH6dP8VA8V
    cMOo6HOEBQ7ZJZovzk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrheeigdefjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvufgtsehttdertderredtnecuhfhrohhmpedfufhlrggu
    vgcuhggrthhkihhnshdfuceoshhlrgguvgesshhlrgguvgifrghtkhhinhhsrdgtohhmqe
    enucggtffrrghtthgvrhhnpeeuieffteejieetgfevteelheevudehteeihffhteehtdet
    leegtedtvdevvddugeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehslhgruggvsehslhgruggvfigrthhkihhnshdrtghomh
X-ME-Proxy: <xmx:uMsBYktILZ0nWCnk3ZwvdeLNKtCiM8aX7C4n9a1knumZXi5su2QgzQ>
    <xmx:uMsBYhaWQo_Oe5zpTeR_DOOTxCoI7HixTx9kmWbnC7VaJ2DYbwnRnQ>
    <xmx:uMsBYrZvvX44sxTE9jwYM6y_rmhobd_-Bng_UcUCqv6yz9xluqfFdQ>
    <xmx:uMsBYoRb1xfK2PDsKTgb6R0AnuATkMdkYti62AceV2joMSJgVc-r7SHolSs>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id B3DBEF6007E; Mon,  7 Feb 2022 20:47:36 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-4748-g31a5b5f50e-fm-cal2020-20220204.001-g31a5b5f5
Mime-Version: 1.0
Message-Id: <68faae8d-8c86-4e70-8206-f8554f2026e7@www.fastmail.com>
In-Reply-To: <20220207103753.155627314@linuxfoundation.org>
References: <20220207103753.155627314@linuxfoundation.org>
Date:   Mon, 07 Feb 2022 20:47:16 -0500
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
Subject: Re: [PATCH 5.4 00/44] 5.4.178-rc1 review
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

On Mon, Feb 7, 2022, at 6:06 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.178 release.
> There are 44 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 09 Feb 2022 10:37:42 +0000.
> Anything received after that time might be too late.

Compiled and booted 5.4.178-rc1 on my x86_64 test system successfully without errors or regressions.

Tested-by: Slade Watkins <slade@sladewatkins.com>

Thanks,
Slade
