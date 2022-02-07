Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2374ABFDA
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 14:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356818AbiBGNoL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 08:44:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387200AbiBGNdl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 08:33:41 -0500
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8978C0401C6;
        Mon,  7 Feb 2022 05:33:40 -0800 (PST)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 22F3D5C0326;
        Mon,  7 Feb 2022 08:33:40 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 07 Feb 2022 08:33:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
        cc:cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; bh=G8QFiH78/k8QSA
        C89RuN2OaBGSt/zrl07wOdzwSoXJc=; b=VTJ2yP5HMleEb7qCIs5v6d3Uxqtnz+
        LA+AqFfAFOR5SV3gSapNSx/b2Vw+Fv5R2mhxD4kLaVDFA+WjCjhDnhheKZNAX8uA
        ntYwr6xTKfm0Q5QhitcA9uipFQTS2lNn6BHKjQ1J16wHHyYeaCjpOMwUUh/q4WGL
        OxyUKi1vAZhz61YnPb+z/zsRn5RvrO/kYsYhSXQ/wHvR3WTu4z4Kk6aT3914JMmI
        K2B570Aj788uYsiP3jCqp8gib8D1TvBZefZSNhJNX0jBKRCucHAYIBa1UUdFfbgq
        b9pJdBJBBRmt454IrjIyZ62iA5BKgcxMAZked29G/NXB5xLtlf/7XZPA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=G8QFiH78/k8QSAC89RuN2OaBGSt/zrl07wOdzwSoX
        Jc=; b=lFyQzrA5HbhukKXsZy5uGyZh+cPTsZDf7kK+jz3Jdn7rri8EOdEZma9OD
        sEmpZ9zXt2c/bL8ZgV4V9jvwWgclNufayAj0sD/oiCRCDJG7Ckc0GSTvi6rwwlVA
        vsL2XdkNoug2yejmFWry8Pg0Belb0yxeFjXdgkLNQ0s6Sdgi0AxCjHinLuVbdoUk
        LLso76WnO1ofmtyh3Kx6VmyOXE4w9DvbegdLoKursUQFSyXkQ01EmED8OIKmhM62
        e8e2KET45UEnOc9XUWiOU8Op1A6weP6rh82KTsNUchczUbeda90BzDvbcZqFAZZy
        dRGXw5ge2psrhuXII6wfq6cmSKWlQ==
X-ME-Sender: <xms:sx8BYv9-UUzhvhYIQtIxYUiCIue2lOuXHwPqyGJn_zZdkaSzSUoFoQ>
    <xme:sx8BYrtI1jOlwOXAE4lK4hSfgOv6OMZWSGuEQznq2JOO031ceodJ4dRjWbfbinZxv
    iM7lXFSThh7Jy8fJSs>
X-ME-Received: <xmr:sx8BYtBRWcVmES2pv-OrSdiWIVrIypigziZ2l_W6-PcSFOnpZJ3fghETCOHwmKs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrheehgdehudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkffggfgfuvfhfhfgjtgfgsehtkeertddtfeejnecuhfhrohhmpeflihgrgihu
    nhcujggrnhhguceojhhirgiguhhnrdihrghnghesfhhlhihgohgrthdrtghomheqnecugg
    ftrfgrthhtvghrnhepheeiuddvvefhkeejfedttdekieethfdukedvieeuueelgfelieej
    geehvdekudelnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepjhhirgiguhhnrdihrghnghesfhhlhihgohgrthdrtghomh
X-ME-Proxy: <xmx:sx8BYrchLFed4y2yKMqf8NHZgCYvBnSbfBUviASxdS1KU9QDtH1J3Q>
    <xmx:sx8BYkOJDMfTKDzvqB32CVSVZJxEAU7kuznvBK8XJf69gjJzcHNXtQ>
    <xmx:sx8BYtk_UyhY-0wMr3AdO_G_O1Ipq55IBpfO_mxuv_tNT7c_7ws7og>
    <xmx:tB8BYu0Ma0m1SDam0r7qEZPtuPxaCTJTulZ_1fPEPOZwgItU_pBXiA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 7 Feb 2022 08:33:39 -0500 (EST)
Message-ID: <d0742b0f-ee22-f352-b89b-50bc5021fd2a@flygoat.com>
Date:   Mon, 7 Feb 2022 13:33:38 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [RFC PATCH for-stable] kbuild: Define
 LINUX_VERSION_{MAJOR,PATCHLEVEL,SUBLEVEL}
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-kbuild@vger.kernel.org
References: <20220207115212.217744-1-jiaxun.yang@flygoat.com>
 <YgEKBAWp+wAWLfFW@kroah.com>
 <4b23a6fe-32df-f20c-eb1b-eea3b01857d1@flygoat.com>
 <YgEbf7oxjSIDQDJo@kroah.com>
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
In-Reply-To: <YgEbf7oxjSIDQDJo@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



在 2022/2/7 13:15, Greg KH 写道:
> On Mon, Feb 07, 2022 at 12:47:41PM +0000, Jiaxun Yang wrote:
>
> 在 2022/2/7 12:01, Greg KH 写道:
>>> On Mon, Feb 07, 2022 at 11:52:12AM +0000, Jiaxun Yang wrote:
[...]
> Why do you need to do so?
4.9.297 brings build_bug.h and breaks part of our compat code.
> My point being that you should not try to duplicate changes that are
> already in Linus's tree.  What I think you want is commit 88a686728b37
> ("kbuild: simplify access to the kernel's version") to be backported,
> right?
>
> If so, please provide a working backport for all affected kernels and we
> will be glad to consider it.
Will do, thanks for pointing!

Thanks.
- Jiaxun
>
> thanks,
>
> greg k-h

