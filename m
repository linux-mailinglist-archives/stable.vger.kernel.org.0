Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46BF46510AC
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 17:46:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231447AbiLSQql (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 11:46:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232308AbiLSQqi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 11:46:38 -0500
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4F0D1B3
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 08:46:36 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id ED74032007BE;
        Mon, 19 Dec 2022 11:46:33 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Mon, 19 Dec 2022 11:46:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1671468393; x=1671554793; bh=YeSBqNNDBB
        j0Tf82vY+EgQE6yCwXfNE9NcJ7OR8ugTU=; b=NHMKh+ibLNpEDfnTph+8ccqoxU
        NloJViZPZIvzrdiULwKkZxT3PfewDFxhbORJF+OYk9rdy1vvDfsLPJQAJ5S1znKC
        JBMtzLaSQ+UxV4nn3fSsz5MhhGiRIY0JCq5tA1xREMKdrjwNPFeDY4tMRS+zoD5Q
        2ta7MtIdhmkQsIuHvih5OBdXqWnTdDtAKTGuSLgfnDLi3Poz/FGrvrAQgDVyLWIc
        E6uLJRPI4TKiXDbKyTtkAM6sqWt4RDZsLf/L1M2M0orjPOh9vimwXAyzFJd2FHOs
        zpmXxBktf2clizTb/IR+5Teb+gwvfwkFLsJPeOIbKK9IX/twnQeNjwNx3pmw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1671468393; x=1671554793; bh=YeSBqNNDBBj0Tf82vY+EgQE6yCwX
        fNE9NcJ7OR8ugTU=; b=cHIBs3tPhCo5qro1QZXcg/fQRvJ14TyC8VubK0MEb746
        5P8E4sdJw6TS8R0fbPhSkx6O6ehl5oGBGUgNYCdALDf12RY/rmg70/rdAXZQLM+k
        wJ9JBsdYnrjTw5S+6tGWoJ+E0hdqxPXszbrducnboIpm+IgasmuK7nK7U8D/TlYE
        ATlrodNW9Aj8jHaSif6KLtutMtvysjLqCxwOLKYl+nlHveLYjWDCItx8nb5boe8T
        84lxKQ1/OND0xOwpm+Cqkg9grKb8iNoai3VGv9wXhDBfFQMDMEu0pywbKvZMJCRl
        UKzLJAMj64+CGknKV+Ee0dQH2LrQLUOlGaRgX2av7g==
X-ME-Sender: <xms:aZWgY12s8mFPxPB6TIlCsn5SJFlKOMTp2Hrjkeih8LI_A9GNflHnAg>
    <xme:aZWgY8EN4Y4i5SKOBt6YYxa7_e2yRkjqfo5RhXr5hrINq_zRd2p0os5kq2JycmANo
    YSJ-73UK1_a6QVQInw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrgeefgdeiiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdetrhhn
    ugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrghtth
    gvrhhnpeevhfffledtgeehfeffhfdtgedvheejtdfgkeeuvefgudffteettdekkeeufeeh
    udenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomheprghrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:aZWgY16ZegvIhRayQg54QZZkMcz-e_aPZlkuYUzNsc57rksVBn4ESQ>
    <xmx:aZWgYy0tiTSuvSKaDyHU2jBf7IV_KnWBn5m9my-kS0P_NHqyflQBNQ>
    <xmx:aZWgY4FuvoSYGE-tmrKahG5gwh5cv6aP5JwuL_tnQ_W8DIclOZQS7g>
    <xmx:aZWgY8D93GTHgcNIJ1onSpAKQFHibuyoC--MIJqyQfK0wmnpOPnN4A>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id F2B4EB60086; Mon, 19 Dec 2022 11:46:32 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-1185-g841157300a-fm-20221208.002-g84115730
Mime-Version: 1.0
Message-Id: <66f77424-0df2-4f49-8215-3aec1761c1ea@app.fastmail.com>
In-Reply-To: <CA+G9fYua0HB+KCjXh-5J6ZJUMS-aaXjHxSsK=ux-sY_ye+tupw@mail.gmail.com>
References: <CA+G9fYua0HB+KCjXh-5J6ZJUMS-aaXjHxSsK=ux-sY_ye+tupw@mail.gmail.com>
Date:   Mon, 19 Dec 2022 17:46:11 +0100
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Naresh Kamboju" <naresh.kamboju@linaro.org>,
        linux-stable <stable@vger.kernel.org>, llvm@lists.linux.dev
Cc:     "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Sasha Levin" <sashal@kernel.org>,
        "Giulio Benetti" <giulio.benetti@benettiengineering.com>
Subject: Re: linux-stable-rc: queue_4.19: 4.14: arm: clang-nightly-tinyconfig failed
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 19, 2022, at 17:41, Naresh Kamboju wrote:
> Linux stable-rc queue-4.19 arm: clang nightly tinyconfig build failed.
>
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>
> make --silent --keep-going --jobs=8
> O=/home/tuxbuild/.cache/tuxmake/builds/1/build LLVM=1 LLVM_IAS=0
> ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- HOSTCC=clang CC=clang
> arch/arm/mm/nommu.c:163:12: error: incompatible integer to pointer
> conversion assigning to 'void *' from 'phys_addr_t' (aka 'unsigned
> int') [-Wint-conversion]
>         zero_page = memblock_alloc(PAGE_SIZE, PAGE_SIZE);
>                   ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 1 error generated.
> make[2]: *** [scripts/Makefile.build:303: arch/arm/mm/nommu.o] Error 1

https://lore.kernel.org/linux-kernel/20221213191813.4054267-1-giulio.benetti@benettiengineering.com/

     Arnd
