Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 241184ADD59
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 16:47:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381771AbiBHPrS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 10:47:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240887AbiBHPrR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 10:47:17 -0500
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83C13C061576
        for <stable@vger.kernel.org>; Tue,  8 Feb 2022 07:47:17 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 289473200B23;
        Tue,  8 Feb 2022 10:47:15 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Tue, 08 Feb 2022 10:47:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
        cc:cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; bh=EDP0Vx0Cct+3F4
        wYIKAmvfthIAINKTM+IuBz/v/LA9s=; b=GuxFSVzQmAWImYq/N4mewXaEbgf9Js
        RjBPvTFk/vMFIGuem2olc6Umn9knucU8jDvjmOQ1e2GcfvP2gc2t2JtwXSBErUqq
        VgGWDUCakf3SO9PsNrbDUg3Gz6HwNcjp9PZnF3p131nPJZHuwQKF7G3Vsvqz9Vxj
        qaNssPV4+LC2W1FpVwACuFSP1suI9j1bs+1EYaipYkE7mfuvxwP4J5EtSHW4M/9b
        66wNaIZjkSkrEY5r1s0KBZejzOQ4/G9M4LY+5fmkySTBoqkLdBkoPBd3Jr9dU2eo
        l/jxi5iSBrbGIiw4hAV5ASCL/+okgfKJljgkufUhx2y9FoWuZAg0z2Ww==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=EDP0Vx0Cct+3F4wYIKAmvfthIAINKTM+IuBz/v/LA
        9s=; b=OoZ9Mcw9HE+g8Ze2wlOLvM02h6UbFmZzg/vRv1l2QbjvBYVHNr2AbdBbW
        R1PIfhcyYSp+tyxgKtbc7SrlY0uXEfehTkcNfUj1KvLG4GCexpOuuuQoHhTWYtS+
        4+uvQDEVRsUkai4WNZugTdO8fD1mRt+Djr2AUpM+BtrI8JdUlPz1AgeN3ZAHm0Bo
        j83Wqi++fBE8Q0tNQR6gYy0aOGv2jGJ8TXa/X5/KNXOh0zGoSdrio5KdPy3uyt8q
        U16GYjxAcV07W6StabLd3yqEQ9AQLobDrJNgLsUNpfeDblzckIdGTqoVHMGT7OQW
        Vo87gFdS+9YoFO5zDABOIaH3xEJUw==
X-ME-Sender: <xms:gpACYupRny_mP2ES-4xX6fKNY2j8uyfjJHSwhf0abChnpP5xmNOpvw>
    <xme:gpACYso4HCLSyfa__NuuZnCHdROLiX2wWl-xGMMUy5wKKTKxUaXuUifGttxMNvB__
    k5jiw3e0ujRt3KZcLc>
X-ME-Received: <xmr:gpACYjMCol74iLgpJx_Wgcq-o4B_OM07544QjBDh14jLlSyt2hfOfPcqNI0VSfQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrheejgdejjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkffggfgfuvfhfhfgjtgfgsehtkeertddtfeejnecuhfhrohhmpeflihgrgihu
    nhcujggrnhhguceojhhirgiguhhnrdihrghnghesfhhlhihgohgrthdrtghomheqnecugg
    ftrfgrthhtvghrnhepheeiuddvvefhkeejfedttdekieethfdukedvieeuueelgfelieej
    geehvdekudelnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepjhhirgiguhhnrdihrghnghesfhhlhihgohgrthdrtghomh
X-ME-Proxy: <xmx:gpACYt4t3F7WtaOtlhOWFOVW70uPU9tknMLzXjls9Ao8s9HHCoyJZA>
    <xmx:gpACYt6_4D3auylg53g53e7gbLyAfkteZ0KYYn7TxAJ6P0bBYzbolA>
    <xmx:gpACYtjBoSpRU6DYN-rQh-VylVV1KMnRJX8W0M7UUMgFd4FCCvqVNQ>
    <xmx:gpACYtGqBOtKAcwlMF9Z1TmPn8fDRSK3pLNLD9-RIWosQyRwdxb0xg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Feb 2022 10:47:13 -0500 (EST)
Message-ID: <516b790f-8f67-0523-a95b-9d359036bd59@flygoat.com>
Date:   Tue, 8 Feb 2022 15:47:13 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH for-5.4,5.10] kbuild: simplify access to the kernel's
 version
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>
References: <20220207143643.234233-1-jiaxun.yang@flygoat.com>
 <e781d772-71a8-f073-66cf-0b415399413e@flygoat.com>
 <YgKK7xskaM6NroIM@kroah.com>
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
In-Reply-To: <YgKK7xskaM6NroIM@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



在 2022/2/8 15:23, Greg KH 写道:
> On Tue, Feb 08, 2022 at 02:46:36PM +0000, Jiaxun Yang wrote:
>> Oh Please ignore this series of backport.
> For all branches?
Yep.
>
>> We find another way to workaround the issue.
> What is your solution?  I am sure that others would be interested in it.
Oh we just define them in Makefile with cflags
like:


--- a/Makefile.kernel
+++ b/Makefile.kernel
@@ -60,3 +60,5 @@ obj-$(CPTCFG_WLAN) += drivers/net/wireless/
  #obj-$(CPTCFG_USB_USBNET) += drivers/net/usb/
  #
  #obj-$(CPTCFG_STAGING) += drivers/staging/
+
+subdir-ccflags-y += -DCOMPAT_KERNEL_SUBLEVEL=$(SUBLEVEL)

Thanks.
- Jiaxun

>
> thanks,
>
> greg k-h

