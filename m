Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB645A53A0
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 19:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbiH2R4T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 13:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiH2R4T (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 13:56:19 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33CBF77566;
        Mon, 29 Aug 2022 10:56:17 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 933AF5C005D;
        Mon, 29 Aug 2022 13:56:15 -0400 (EDT)
Received: from imap49 ([10.202.2.99])
  by compute4.internal (MEProxy); Mon, 29 Aug 2022 13:56:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        sladewatkins.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm2; t=1661795775; x=
        1661882175; bh=HhMi6Ae2mKC0wqby3t/kIqrD8OSzWM6dTNwdDHPaLc8=; b=r
        C5MUz9Yuf3ougevGbgnYWYtihM8XI/ZIBkRRFgoNkBoH+LAevk8W+NHK54ba/I0t
        V8F+6N134I7fo3OAaytsEemXIHxbCanQtZnNfxF5YmnI+0HPCjw4TqeZCyx6olfp
        5keZFP+pGQSTr9H/nB9WpDDGfV4wBEH76ed197OFwfM4T+NJtGLRSLTuSiuV6nkQ
        E5dELaetPK1aGFx93xoBh6W/i0cZ0mpO12JCRQbP8mKDWhd3XenotUFYgnWCtgWI
        QM8QJYrxQFjP1UkR6RU3A3JA7vZ/5ndYKq647a0JfNczM7IkVGXU/gKUg+X8lENE
        S+C5u+qu6lJkXGR6j6d2g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1661795775; x=1661882175; bh=HhMi6Ae2mKC0wqby3t/kIqrD8OSz
        WM6dTNwdDHPaLc8=; b=aDrxeeDTyJ/pJoic2Skndu8eRLHguZe14DvqwL+y8Wnw
        tyMwgnQXYfz2es7PbS7e1AxTqOS9nrwJbtGi/qJWrST6xGspXzsD2Cfm5FaC4Em+
        oouKsKXm6ovl3hiceJbx/xVuRI10Zn8UIbyoE4a2pw6uE/AtIwQBsy/Q2MLfh48/
        0TMFYv0XS818XHDlCzT8Rvted+kllNbArE5vDWZ7nkmeKD7LtdPIOm3LZUVBw3mq
        DuxdEV5t3QijFPWG9Ly5nc6G2pDonmZ6T4aMIgQtp4HlTHOwyOEy3u5uyCJB+Org
        CNsqVLYMB3QKCZF+SQwXBq/2pNABaHh14Lx4X97lMQ==
X-ME-Sender: <xms:v_0MY2p_JQCePrAZHYk3Nkzpe_pj4Tp53EIIcTkYV2aD4-4sAypB4g>
    <xme:v_0MY0qYHmoMSdAPq9C6c9-r2fPztRMLsRff9aL8w_hHKXx4VnFWRoRxfgi2ECOW_
    9oIAZBxed1iveMestc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdekuddguddvtdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdfu
    lhgruggvucghrghtkhhinhhsfdcuoehslhgruggvsehslhgruggvfigrthhkihhnshdrtg
    homheqnecuggftrfgrthhtvghrnhepjedtjeffgeekueegteefudegfeekteetvdegudfh
    uefghfdtteeigfeggfelteeknecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepshhlrgguvgesshhlrgguvgifrghtkhhinhhsrdgtohhm
X-ME-Proxy: <xmx:v_0MY7OrcTNNyPQv7-srLtCIzKxaifV90ZgYifIgj4s0ij_Vuye4Mg>
    <xmx:v_0MY15ZkM8jtcmqgBjo40WyP_zv8SvEZgwDQGDGr1Rl06GsRe5HrQ>
    <xmx:v_0MY15FrDNYZBhk7rmcNWr2Z_JXOPxJBu_0RUjaLedavSOhlD7h9w>
    <xmx:v_0MYyzrRrYsudwWsle69RPjZGEeDWSHJ4HqKSAov-zzvB7OLB6WSQ>
Feedback-ID: i8ae946f9:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id F28E115A0087; Mon, 29 Aug 2022 13:56:14 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-841-g7899e99a45-fm-20220811.002-g7899e99a
Mime-Version: 1.0
Message-Id: <8d92c03a-67ca-4064-9e0c-0a19c2a87904@www.fastmail.com>
In-Reply-To: <20220829105756.500128871@linuxfoundation.org>
References: <20220829105756.500128871@linuxfoundation.org>
Date:   Mon, 29 Aug 2022 13:56:14 -0400
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
Subject: Re: [PATCH 5.10 00/86] 5.10.140-rc1 review
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

On Mon, Aug 29, 2022, at 6:58 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.140 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 31 Aug 2022 10:57:37 +0000.
> Anything received after that time might be too late.

5.10.140-rc1 compiled and booted with no errors or regressions on my x86_64 test system.

Tested-by: Slade Watkins <slade@sladewatkins.com>

Cheers, 
-srw
