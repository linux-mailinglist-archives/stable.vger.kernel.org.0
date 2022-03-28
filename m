Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB7EE4E9BF4
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 18:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236931AbiC1QKc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 12:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241321AbiC1QKb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 12:10:31 -0400
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E9431CFF5;
        Mon, 28 Mar 2022 09:08:50 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 1A8463201DA2;
        Mon, 28 Mar 2022 12:08:47 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 28 Mar 2022 12:08:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=animalcreek.com;
         h=cc:cc:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; bh=RK/wz/U+TabQb++KAzGvfQskuMllPD
        dsm08D4cpJkec=; b=NVcWj4wjAMrHacgiBm0vLytCFKNuNB3EDWcOA9dEJnpVJX
        XUkbpoHf993ZhGBi/hPPtyuwS2Xh7wt28+EgW9ak1iZE60RFl50CPO4LNmuE5aw0
        eIHWweithGeR6iAVZ+Bb7Z4WkPIZRj1LqCkM/VNjtL9/Ew4xIY/1+gkYfkWACO8G
        w5w1sdzav9MhNkPT5dyCijrkC2DgThazAy6385aJfaFWnrJT6Eyrrq4oDFyACRyA
        YPardJDVkFMmIhQpzfSWmrJnnHHUc7r1CRiVBrTmJsr9julV/6fIdYCA4LKdMt5C
        ywH/yE+BVJrxMjb9a9TdpHJL8B99pTefwRz2nqCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=RK/wz/U+TabQb++KA
        zGvfQskuMllPDdsm08D4cpJkec=; b=JPRaQHr1SDfv3tKuhbsVliljiAw+86tp/
        WXOZDWvDJoxGFxxFKOq3cIZVK/3eA2nVDrUM8gGJinU4m4vlOfvlghK1/oFPCLE4
        j3rkeZvZc2DowwnnnOlkFo8ngQS+u4N14KfeN4ouAyHWVZ6KCF3xpQQMdLIFNypV
        d/pqExLEerd+mOGVG27cNgIryKI9ADOHZAOELBSQNy3DH8JvV7qTraArCae8AzbA
        mNPhxd8kZ/Rfs8uadtnAaGDNXd+7HZd6YxpzysTjNQCix2Tg4WLrwcpLKGNCb61l
        ld4JLJhy+3YRxcGRP9v+uoJe0MpwijIIFd+r3gHVrRF8WGraSNYyA==
X-ME-Sender: <xms:jN1BYmY4suobs2sUUBp0M5Dq9MHCrta9W-J_f7bQD82u5w1Jz3Y87A>
    <xme:jN1BYpbDi8buphAtwO7Vk6OMOBb1_n8uzvtCk1nF_2ah8j1ShIERxN_hxvKykSUTJ
    pOxsE1-6HxA7aBhRw>
X-ME-Received: <xmr:jN1BYg9j43Q7HgNz5GplDQ9hgUFfkBQTvtXxnXt60mfdLqPfxZs-gFKQ8eDwEYT4O_SXWdW9TFKmmHjliulukfBbOWOvpwN8MpgHKjQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudehjedgleeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjohesthdtredttddtvdenucfhrhhomhepofgrrhhk
    ucfirhgvvghruceomhhgrhgvvghrsegrnhhimhgrlhgtrhgvvghkrdgtohhmqeenucggtf
    frrghtthgvrhhnpeeiuefguddtfeeitddvffetudefvdejhefgveevfedugfejffegieet
    teejudffhfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehmghhrvggvrhesrghnihhmrghltghrvggvkhdrtghomh
X-ME-Proxy: <xmx:jd1BYooTiKhX42yKuBXXhbWazOdABTRHbXVrA5965ALSgusYWS4quw>
    <xmx:jd1BYhoS-u6Nbhuu8bH_p2lPg79eH9jtaZgl3HE9DjlJvUz85vb6lA>
    <xmx:jd1BYmStmylj_P1bmoUxTcjIhhijhNBj-VNLAzyd_1f0bAebv06tgQ>
    <xmx:jt1BYs0qUZI5sb1PD54R8hGePO3Tq_5MzvsVBoKAYRb5pbroRj8Vyw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Mar 2022 12:08:44 -0400 (EDT)
Received: by blue.animalcreek.com (Postfix, from userid 1000)
        id B7F8313601FE; Mon, 28 Mar 2022 09:08:43 -0700 (MST)
Date:   Mon, 28 Mar 2022 09:08:43 -0700
From:   Mark Greer <mgreer@animalcreek.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Xiaomeng Tong <xiam0nd.tong@gmail.com>, vaibhav.sr@gmail.com,
        mgreer@animalcreek.com, johan@kernel.org, elder@kernel.org,
        gregkh@linuxfoundation.org, greybus-dev@lists.linaro.org,
        linux-staging@lists.linux.dev, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] greybus: audio_codec: fix three missing initializers for
 data
Message-ID: <20220328160843.GA262674@animalcreek.com>
References: <20220327060120.4316-1-xiam0nd.tong@gmail.com>
 <20220328141944.GT3293@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220328141944.GT3293@kadam>
Organization: Animal Creek Technologies, Inc.
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 28, 2022 at 05:19:45PM +0300, Dan Carpenter wrote:
> On Sun, Mar 27, 2022 at 02:01:20PM +0800, Xiaomeng Tong wrote:
> > These three bugs are here:
> > 	struct gbaudio_data_connection *data;
> > 
> > If the list '&codec->module_list' is empty then the 'data' will
> > keep unchanged.
> 
> All three of these functions check for if the codec->module_list is
> empty at the start of the function so these are not real bugs.

Umm, yep, oops.  Thanks Dan.

Mark
--
