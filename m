Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC5C5BAD45
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 14:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231481AbiIPMVL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 08:21:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231405AbiIPMVK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 08:21:10 -0400
Received: from new2-smtp.messagingengine.com (new2-smtp.messagingengine.com [66.111.4.224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10EA4B089B;
        Fri, 16 Sep 2022 05:21:08 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id BB2CD58012F;
        Fri, 16 Sep 2022 08:21:07 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute3.internal (MEProxy); Fri, 16 Sep 2022 08:21:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1663330867; x=1663334467; bh=Z7y3PzeVTJ
        ZOhaYvhx0ZFCEnasatKo4vgoHWfeSmhxQ=; b=Gq8WZZlQodvsYxPY6MapHpPKVD
        WixsmUh93mSDnGjEeqZNS6a+mC8md5H+Z2yUlNlZDSA3nhKTselB1GAL8PagRPU3
        VdSkXW2+h3dby4y6mJjODA73NCB9awfEWMhN/OqE6b7Iv/0DMoudyDrhyvfaDfln
        LO8DPv58XlpwPywhQDFNYV2yFRWC+YmPxuL7ch33r9ic/H7klkRrmQT+dwBgN1y+
        MC4wzhDLHeRHH1hUdwAMEWuWfe0o67WqmxOS6PTuBLS04PtO8PxmwXAzQdnpN1lJ
        5HG1TkAy8eYZW/7Uso5wsl+qfoF2q85ttDhk1FUUO+MaaVbsaCcVxZrfkp8w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1663330867; x=1663334467; bh=Z7y3PzeVTJZOhaYvhx0ZFCEnasat
        Ko4vgoHWfeSmhxQ=; b=lix2UlhL3PIDge88fd8+Q0t/5j1Tvph0H4DMfuTRD7VZ
        tlsXBw8ch5khFuPrelEYTbECLJfkrdMorUkllfA0oqwYg6vf0Sw47h87ULYa7M/y
        bvHEJxWJa/tdqvBYiKt4vANh7EvbAxuuqrVFQQZWqZBiqiyYboTr2RF8D8AZ183J
        R5oSJiTwC27QSNsf3Tl9t50ueuwRsfka5bms/Mr/mzLls0qznCZzRwX/dJqiQACA
        KWbsl7tr0LwKid9EXBW8YMVeNhc/7v344SCIpZ/ORn2Wx1VgFmk+Mmai69WzDNDn
        3hV7wjyXbAOCxVg4Px+EzhmI+o0Zydsfc+XKaP94bg==
X-ME-Sender: <xms:M2okY7l4nigX1Ty5BPO1Yqq0q400eCI_sSKJWtsw5Bew28jsocDpkQ>
    <xme:M2okY-24cax230p6tAW7f5QzUmGY40xrIAkuq4QCHFu63LKrBJQ_PBZsrSFc8lQXH
    FB_r3yFPU10jXkww4U>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfedvtddgheefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhepffehueegteeihfegtefhjefgtdeugfegjeelheejueethfefgeeghfektdek
    teffnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:M2okYxoDbZC8hcX01i1MotbXSEMKAyGXBTcZmaR1j4qerwNNN8sQ9Q>
    <xmx:M2okYzkaDxwXx-HWJ-9VNsAwJF0aGuOJeHyMmNj0j4JzlZNADj0S9g>
    <xmx:M2okY50kzVpNn2UGApa23w0vIAp03plbfw0OM5H6wvXibRx8Pnvsdg>
    <xmx:M2okY2lYH0pzOhHFJ3Laoh4-iBQKR7iMO7f-vrZ6RBMHaxk9jPB_rw>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 500BEB60086; Fri, 16 Sep 2022 08:21:07 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-935-ge4ccd4c47b-fm-20220914.001-ge4ccd4c4
Mime-Version: 1.0
Message-Id: <17ee7d23-27d3-4d29-aec3-a61f7d0d3526@www.fastmail.com>
In-Reply-To: <20220915204844.3838-1-ansuelsmth@gmail.com>
References: <20220915204844.3838-1-ansuelsmth@gmail.com>
Date:   Fri, 16 Sep 2022 14:20:47 +0200
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Christian Marangi" <ansuelsmth@gmail.com>,
        "Andy Gross" <agross@kernel.org>,
        "Bjorn Andersson" <andersson@kernel.org>,
        "Konrad Dybcio" <konrad.dybcio@somainline.org>,
        "Vinod Koul" <vkoul@kernel.org>, "Mark Brown" <broonie@kernel.org>,
        linux-arm-msm@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] dmaengine: qcom-adm: fix wrong sizeof config in slave_config
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 15, 2022, at 10:48 PM, Christian Marangi wrote:
> Fix broken slave_config function that uncorrectly compare the
> peripheral_size with the size of the config pointer instead of the size
> of the config struct. This cause the crci value to be ignored and cause
> a kernel panic on any slave that use adm driver.
>
> To fix this, compare to the size of the struct and NOT the size of the
> pointer.
>
> Fixes: 03de6b273805 ("dmaengine: qcom-adm: stop abusing slave_id config")
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> Cc: stable@vger.kernel.org # v5.17+

Thanks for the fix,

Reviewed-by: Arnd Bergmann <arnd@arndb.de>

I guess this worked on 64-bit by accident, since both the pointer
and the struct are 8 bytes, but it was clearly wrong and broke
32-bit.

     Arnd
