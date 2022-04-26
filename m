Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 673C650F0E8
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 08:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244268AbiDZG13 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 02:27:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233942AbiDZG12 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 02:27:28 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BD531229E3;
        Mon, 25 Apr 2022 23:24:21 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id DD89B5C01C4;
        Tue, 26 Apr 2022 02:24:18 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Tue, 26 Apr 2022 02:24:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=living180.net;
         h=cc:cc:content-transfer-encoding:content-type:date:date:from
        :from:in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm2; t=1650954258; x=
        1651040658; bh=IbpOZ4LIDvEw4dX8hUlPl0oGzp/Zn8DhVhCgS0FVOGw=; b=C
        ciJEymzha16iPzvrr3rfGvi5jwKWaF+PpUaYBGS8GV+dWsJ8hP6PCwAcfWnAtN8h
        OpOSDuNhtX/w3JnyIHQzIL70By2rwgQ81GIsuNP+HtMaNWAqe7vHmvNclKeHM6nJ
        hkw6eCKQoQ8Y2OZyWuZrYRZYDPPwv1hnq6EQujQTF3DzEzAlxMJ2L9wFCGpu9Py7
        p4wkVpCQ/O1yPhlacZivMbbrFpi+6z7WKR8KpY3G8NOr0z6N9cdXOnbWDM+4c8Yc
        jYo8bkKvdk0smyd8fM+fnbEQahEdKB9Lgzx25RZeMenSjOmH1zSt0adM+w/4/NsP
        Dg3HDPc89IONGdITbNbEg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1650954258; x=1651040658; bh=IbpOZ4LIDvEw4
        dX8hUlPl0oGzp/Zn8DhVhCgS0FVOGw=; b=UCu10gk1CnyG/y2dOPp3a7GXqTtEu
        NKBPj5QjBhjFpYf1vq0U0G7/eva8Hn+xQqUFf1Cm1fRVTcfNvELB3zOm7eMCl2Vr
        Mrnm/vDFn2QFPTAxA1pD3s5UcF+S/GUx6WDrtvgyHWdQkDVP8jq2PVSdHLGCIMFl
        E+dEQbTC+VujEdt7kwCrxQnvTaBxgmv+RjIYyGv/wwdGJ3OQ+WyEprZl4twJZ59g
        UF3ojAvnolsm0HwA6uaUyR8/Jv/rkZFNBLJnNyCevvtZywov+5KwpbyzDgkc03Z7
        hpnrtEqod5J1bL8+tDS7MkKxcekRYRKbX1mMwJf6WWdFXWlaDHUlmjkfQ==
X-ME-Sender: <xms:EpBnYlCi6qrnQNvBOW9Dg-vqosSzTupUamTRg2nYezOVW2n5GrLNZA>
    <xme:EpBnYjgYcd1w0Oypa1b_lUogWNwMgWtvXRrV97ooziDxFK5KzRVfdXwudDpyQPaKf
    mHHtBSWorlV3g>
X-ME-Received: <xmr:EpBnYgn46b_TbqsRgGHMNbodIl2bZ8tvNcn_lPU2kgYZXlNcYfpftn_WgWB0xA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedruddvgddutdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkfffgggfuffvvehfhfgjtgfgsehtkeertddtfeejnecuhfhrohhmpeffrghn
    ihgvlhcujfgrrhguihhnghcuoeguhhgrrhguihhngheslhhivhhinhhgudektddrnhgvth
    eqnecuggftrfgrthhtvghrnheplefhtdejtdehhfdtveelfedtkeethefgudeftdevheej
    hfevtdfhkeevheefjeetnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhush
    htvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpeguhhgrrhguihhnghes
    lhhivhhinhhgudektddrnhgvth
X-ME-Proxy: <xmx:EpBnYvwdpqb8-4ovkGC-qbESxwWLcfpDe8V9DCsC0pSbGLpIoUNziA>
    <xmx:EpBnYqTwPpw4iM7irybCm45TgLjm4my2BYlsK2MYz0tqgBG7UBKUKQ>
    <xmx:EpBnYiZqFqNWa_ecxVOdTU4ZO7FDI-Gk7qUpjHQMAslMQL7SfQAfDQ>
    <xmx:EpBnYgM5SufEujTOUbjTJIuTE3qMZAl0j-4sZNLEEx2LougoAHi69A>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 26 Apr 2022 02:24:16 -0400 (EDT)
Message-ID: <975801fd-9c5b-6d09-f7cb-ee7af2fbbf65@living180.net>
Date:   Tue, 26 Apr 2022 09:24:14 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: Regression in 5467801f1fcbd
Content-Language: en-US
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     brgl@bgdev.pl, shreeya.patel@collabora.com,
        linux-gpio@vger.kernel.org, stable@vger.kernel.org,
        andy.shevchenko@gmail.com
References: <34212129-bb2e-46d4-4536-28f11b1c61ca@living180.net>
 <CACRpkdbw1E3qOc=+PXyO3tQSXpa0yHd5YTbXMe97dPq9vCcTVg@mail.gmail.com>
From:   Daniel Harding <dharding@living180.net>
In-Reply-To: <CACRpkdbw1E3qOc=+PXyO3tQSXpa0yHd5YTbXMe97dPq9vCcTVg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/25/22 23:09, Linus Walleij wrote:
> Hi Daniel,
>
> On Mon, Apr 25, 2022 at 9:00 PM Daniel Harding <dharding@living180.net> wrote:
>
>> The commit "Restrict usage of GPIO chip irq members before initialization" breaks suspend on a
>>   Dell Inspiron 5515 laptop in a very severe way.
> Does this commit, which is already upstream in Torvald's tree, solve the issue?
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/drivers/gpio?id=06fb4ecfeac7e00d6704fa5ed19299f2fefb3cc9

Yes, cherry-picking that commit on top of 5467801f1fcbd fixes the issue 
for me.  Thank so much for the quick response from you and Shreeya!

Regards,

Daniel Harding
