Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60BA259CFBD
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 05:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239660AbiHWD5n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 23:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239454AbiHWD5m (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 23:57:42 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E703C5A2D9;
        Mon, 22 Aug 2022 20:57:41 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 4B0ED5C017D;
        Mon, 22 Aug 2022 23:57:41 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 22 Aug 2022 23:57:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        cc:cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm2; t=1661227061; x=
        1661313461; bh=DCa1+tn2wL/qaiJJ/v6UFWHx8ak4jYt6XIvYs1ogASU=; b=d
        Nm7xjWcTOqvSwz3gYuAarLkMwyk1L93rhjRpVFZPXwz6dFmRC4aCEh7aEUK0CdWn
        22sNwpjO0dIWuGu8prCS9bBX1i/IyA51+FVUSZaVQZKK9btir7e4vipNEijX/Tkn
        vO4fLwEFj2npXJMrqQ81ogpkboWCkX0dDcNBIQtajYby3vP7vl+5G4+8q0EsSro6
        eKGOifWHQ/RRa9x3V1G9XLKpm6bqpfKVHRYtE93SlymFQDGo1813dhBhO67xidO1
        dgMvadrQ97zo1PBynbXRYJ4ysZzVyxsZOUy/GS2rqLahrz0L/dFcMV2cydJDPfoK
        YT1+XlAjXjkjmi4KO7diw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1661227061; x=
        1661313461; bh=DCa1+tn2wL/qaiJJ/v6UFWHx8ak4jYt6XIvYs1ogASU=; b=Z
        Jm0FM3OvLfkKYN4sFPWIgRAG1XV2ynPZLtVnBLuBZl62D6YysNIz7b9vkCCrT6hW
        EPgcH+DIJI5sEeNMzV2E4ArYg+k3sKLSiJ3n1nyV/TKtDwLt0VH6biHkGvPPsiFM
        i1k04urhL3vAYWBJmKPmE/LzCUpVtL75ZiQREHCOQiECVcsf4pAHlR5gyHBv92C1
        bKYLODji5n6xouXrL3ctRK9srwUY83uySJj5Yi2Mi6w3CyLm/O5+7Y4iu6lBmNCJ
        FqHVHQfFnWwJuYHZXYaEsRr9c2lcFq5ve6ktzx1MuQkW3sV8BeJgEsI3T48Ks8wg
        qeo2EapXXryyZU/BKS5jw==
X-ME-Sender: <xms:NFAEYwBBNuYE_ZHBdryobgdhF8_0FG4RPvEblMksXZuNiyuy51I2Ww>
    <xme:NFAEYyjJdfcIt3etKUTInGw1u1wHZVWXWqC4xaEyXoQ7ERabdn_xH5bE87l5Mv5iG
    aa03CUynG3Z_JXodg>
X-ME-Received: <xmr:NFAEYznuIEgctqizdbNdpLa6Ddy8i5i95biA3eqkV7camQpV-kBM3mqQlNQ3WHgp4sLJFU_z7XHTL1Sf5Sm7vUyyREGLK5M1DDmOvZiy_q7CvoW8sg3-ro-mxQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdeikedgjeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepuffvvehfhffkffgfgggjtgfgsehtkeertddtfeejnecuhfhrohhmpefurghm
    uhgvlhcujfholhhlrghnugcuoehsrghmuhgvlhesshhhohhllhgrnhgurdhorhhgqeenuc
    ggtffrrghtthgvrhhnpedtvefhheehgfdvkeetffeludeuudehudeuvddtveelleekvedv
    uedviefhkeeuheenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfh
    hrohhmpehsrghmuhgvlhesshhhohhllhgrnhgurdhorhhg
X-ME-Proxy: <xmx:NFAEY2wQfJuLXStVYDzD7MonbWVO01PvpejRvoHL4XXZ6NpJ0hC_dw>
    <xmx:NFAEY1TKZ7KRMqXiDDkjRYvmTKCZf3hliiL0xNW8clijGVYSn1tqrA>
    <xmx:NFAEYxY6TxQu5Kp0zRAHWT5xJFekjf818HchEHzmIgOInMIqav1wHA>
    <xmx:NVAEY7CNXyIiw1a_-etXr3089TIFW41h48u5JJEGquqbDFAgyEZ5oA>
Feedback-ID: i0ad843c9:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 22 Aug 2022 23:57:40 -0400 (EDT)
Subject: Re: [PATCH v1 2/3] media: cedrus: Set the platform driver data
 earlier
To:     =?UTF-8?Q?Jernej_=c5=a0krabec?= <jernej.skrabec@gmail.com>,
        linux-media@vger.kernel.org, Maxime Ripard <mripard@kernel.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>
Cc:     kernel@collabora.com,
        Dmitry Osipenko <dmitry.osipenko@collabora.com>,
        stable@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
        linux-kernel@vger.kernel.org
References: <20220818203308.439043-1-nicolas.dufresne@collabora.com>
 <4418189.LvFx2qVVIh@jernej-laptop>
 <47ce07adc73887b5afaf9815a78b793d0e9a6b54.camel@collabora.com>
 <4733096.GXAFRqVoOG@jernej-laptop>
From:   Samuel Holland <samuel@sholland.org>
Message-ID: <0aab3720-7211-9414-0005-6a419b5f04c8@sholland.org>
Date:   Mon, 22 Aug 2022 22:57:39 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <4733096.GXAFRqVoOG@jernej-laptop>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
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

On 8/20/22 3:25 AM, Jernej Škrabec wrote:
> Dne petek, 19. avgust 2022 ob 17:37:20 CEST je Nicolas Dufresne napisal(a):
>> Le vendredi 19 août 2022 à 06:17 +0200, Jernej Škrabec a écrit :
>>> Dne četrtek, 18. avgust 2022 ob 22:33:07 CEST je Nicolas Dufresne 
> napisal(a):
>>>> From: Dmitry Osipenko <dmitry.osipenko@collabora.com>
>>>>
>>>> The cedrus_hw_resume() crashes with NULL deference on driver probe if
>>>> runtime PM is disabled because it uses platform data that hasn't been
>>>> set up yet. Fix this by setting the platform data earlier during probe.
>>>
>>> Does it even work without PM? Maybe it would be better if Cedrus would
>>> select PM in Kconfig.
>>
>> I cannot comment myself on this, but it does not seem to invalidate this
>> Dmitry's fix.
> 
> If NULL pointer dereference happens only when PM is disabled, then it does. I 
> have PM always enabled and I never experienced above issue.

There's still a bug even with PM enabled: the v4l2 device is exposed to
userspace, and therefore userspace could trigger a PM resume, before
platform_set_drvdata() is called.

>>>> Cc: stable@vger.kernel.org
>>>> Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
>>>> Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>

Please add a Fixes tag. With that:

Reviewed-by: Samuel Holland <samuel@sholland.org>

>>>> ---
>>>>
>>>>  drivers/staging/media/sunxi/cedrus/cedrus.c | 4 ++--
>>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/staging/media/sunxi/cedrus/cedrus.c
>>>> b/drivers/staging/media/sunxi/cedrus/cedrus.c index
>>>> 960a0130cd620..55c54dfdc585c 100644
>>>> --- a/drivers/staging/media/sunxi/cedrus/cedrus.c
>>>> +++ b/drivers/staging/media/sunxi/cedrus/cedrus.c
>>>> @@ -448,6 +448,8 @@ static int cedrus_probe(struct platform_device
>>>> *pdev)
>>>>
>>>>  	if (!dev)
>>>>  		return -ENOMEM;
>>>>
>>>> +	platform_set_drvdata(pdev, dev);
>>>> +
>>>>  	dev->vfd = cedrus_video_device;
>>>>  	dev->dev = &pdev->dev;
>>>>  	dev->pdev = pdev;
>>>>
>>>> @@ -521,8 +523,6 @@ static int cedrus_probe(struct platform_device
>>>> *pdev)
>>>>
>>>>  		goto err_m2m_mc;
>>>>  	}
>>>>
>>>> -	platform_set_drvdata(pdev, dev);
>>>> -
>>>>  	return 0;
>>>>  
>>>>  err_m2m_mc:
