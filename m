Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2B24BB9C7
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 14:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232685AbiBRND5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 08:03:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233170AbiBRND4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 08:03:56 -0500
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86F532B461C
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 05:03:39 -0800 (PST)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 783AB5C036A;
        Fri, 18 Feb 2022 08:03:36 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 18 Feb 2022 08:03:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; bh=u1vvAbR2H1XG8E6+/dAsxERCPEjcjF/jaEmLRC
        KMXIk=; b=YEd1k6kXUH/h9l0ERe05QZ7doc29YMIdOawIG17rS/LZpNghudq8K9
        bIjLpzUswJX9BR1OdY2TTmXye2bxX7fU/NqiGVg/6re1PElOCM3gt8y8rH0OOW/Y
        nWnb1GjRrbFsR2/w6AJCawxCOBUINNBe2pTL+jm8DdAufkSoE3rYan8xsZ8QDODX
        l75+kpK7Vcy+z7K2OzfexQOnqNUQwiwtbpTCA4MrfJZqz0PUFHkAh0uCOX340OUR
        BcJWq+T7fZBlpJZXmlWvqlYhgZfw0FXbc2auxfBRhzBRAOz5vgLDXZuDURNMjUwn
        e25HZ3hjhqMzXyMtBUalKx5FnJicqXbw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=u1vvAbR2H1XG8E6+/
        dAsxERCPEjcjF/jaEmLRCKMXIk=; b=lfNq2ISASCMmyh533ed1jZyp+MG/QYegt
        v1AuyB5BztmjR3nqKb9Lk9bkMdSGNEo7t5XZ5oRzDAjDkyzntrYnlFrmOYM1/spw
        5K5UPWcBCUYlzBupOTgr26aY5d7yNBLaHJeYBk3pSq5m5u82pb3v4hHfwv4CVbBM
        Y39jiXfSGXKkRW7l3P3ucXLI23ryeU8jZCUPdSX9cXV3xOffbDUn8U4r3UNjX1oz
        mmj4ctRfQMnAMHLiCQ8rCotgXaoyb33/kll5pveBuVq/RX/0x4t98IsKNAlVIDxb
        pJaxx4ED55e3eTZIBzYXdF0PCUDdphad69xhZU631/ROrcwTJHjsA==
X-ME-Sender: <xms:KJkPYgaJ0oXJYZ_Qq8TgRxbXgVMKfh4eprepWL_Vp7_1H1dD1ck-rQ>
    <xme:KJkPYrbXPe-BkQEInVMogFlqBzaZYlQt67qEQsELyNgrNNWEoq0C0he6XrckLQlJH
    ATcZ6AGvkG58w>
X-ME-Received: <xmr:KJkPYq-0ShQYW-ycktgnEsluJUo_lGSLGPp1DKow_DAar6h2L5GG3UMkDA7u7qn7kgsgbMK11U2od9mrXCKYU89Gm-85bBOR>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrkedtgdeghecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:KJkPYqqUW1qHF88MmC1DC4ruNjXNzQK19MVi-ZH9kvZbqBsOS7zTfw>
    <xmx:KJkPYrrMinUkSjG3mQEMjZV1SW9urumDKgucyFtNr8Mj4qZ8ugzGrA>
    <xmx:KJkPYoTjZkiTuerQgeiyYNRyZPdG7i7DOSrBdpwfEckHcbw357mwrQ>
    <xmx:KJkPYsc7rKH9QvNzifoKuczgsO8vx2g25vzXT_KV1u3gcbubpafqcw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 18 Feb 2022 08:03:35 -0500 (EST)
Date:   Fri, 18 Feb 2022 14:03:33 +0100
From:   Greg KH <greg@kroah.com>
To:     Jens Wiklander <jens.wiklander@linaro.org>
Cc:     stable@vger.kernel.org, Sumit Garg <sumit.garg@linaro.org>,
        Lars Persson <larper@axis.com>
Subject: Re: [PATCH backportt 5.16] optee: use driver internal tee_context
 for some rpc
Message-ID: <Yg+ZJeviMupQrGo4@kroah.com>
References: <20220218104529.436040-1-jens.wiklander@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220218104529.436040-1-jens.wiklander@linaro.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 18, 2022 at 11:45:29AM +0100, Jens Wiklander wrote:
> commit aceeafefff736057e8f93f19bbfbef26abd94604 upstream
> 
> Adds a driver private tee_context to struct optee.
> 
> The new driver internal tee_context is used when allocating driver
> private shared memory. This decouples the shared memory object from its
> original tee_context. This is needed when the life time of such a memory
> allocation outlives the client tee_context.
> 
> This patch fixes the problem described below:
> 
> The addition of a shutdown hook by commit f25889f93184 ("optee: fix tee out
> of memory failure seen during kexec reboot") introduced a kernel shutdown
> regression that can be triggered after running the OP-TEE xtest suites.
> 
> Once the shutdown hook is called it is not possible to communicate any more
> with the supplicant process because the system is not scheduling task any
> longer. Thus if the optee driver shutdown path receives a supplicant RPC
> request from the OP-TEE we will deadlock the kernel's shutdown.
> 
> Fixes: f25889f93184 ("optee: fix tee out of memory failure seen during kexec reboot")
> Fixes: 217e0250cccb ("tee: use reference counting for tee_context")
> Reported-by: Lars Persson <larper@axis.com>
> Cc: stable@vger.kernel.org # 1e2c3ef0496e tee: export teedev_open() and teedev_close_context()
> Cc: stable@vger.kernel.org
> Reviewed-by: Sumit Garg <sumit.garg@linaro.org>
> [JW: backport to 5.16-stable + update commit message]

This and 5.15 backport now queued up.

This needs to go farther back as well, right?

thanks

greg k-h
