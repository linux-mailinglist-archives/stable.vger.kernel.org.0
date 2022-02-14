Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90A0D4B5B42
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 21:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbiBNUtG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 15:49:06 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:59618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbiBNUtF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 15:49:05 -0500
Received: from new1-smtp.messagingengine.com (new1-smtp.messagingengine.com [66.111.4.221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FBA0D0B57;
        Mon, 14 Feb 2022 12:48:38 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id C929C58045E;
        Mon, 14 Feb 2022 15:37:53 -0500 (EST)
Received: from imap49 ([10.202.2.99])
  by compute2.internal (MEProxy); Mon, 14 Feb 2022 15:37:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        sladewatkins.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; bh=fvb3ktE3Gr/xOs
        apIiaveTmnPwWHzlBe7MHVZfBd8/8=; b=Be5WEXK8CvTF1UXpIGg69ARDjoLHAO
        1PRkTNJuAXhOIw6GPISzILNEnGqB79diDkRMP/zP+zOK0A/zOhJmjlU7DNHc5Pik
        jVB35u0cWNTeZWI9JMFRpkKXiG7xNkn+6vzSLbgtBKdykCXIXcazX3VeymKX48Th
        b6BYA52QT6DAYbnzsRwuo3biGNh36F/eazFc57RBLsY1WWhuy2y+aXhYGxH6tKRm
        j+i8HJHNtEwbM0Hdv4mBSzgb55VNGnVW9MLd9OazAn77qfl8ARteYErq/keEc5ej
        kc8/on8jej7Tw+y0ORBgC0PILz9UojAuHjIPt3YZ5DOV3kUdXRs3HntA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=fvb3ktE3Gr/xOsapI
        iaveTmnPwWHzlBe7MHVZfBd8/8=; b=MvYKnymfyw7HtJwX5YO4TvaYl13s6dzna
        P0FHQYA/tkn/tP0UItzaa0oMXA51a6L6tjj2jqWZC6vqV7sKllTQD5ClRVGcqGmx
        0/lc0MWeAk3myT9xrzNYB/U73/LNcvI9Hex6ZwzS1zIDdlL5w6ZUQPZ++m2/wN24
        nErYdbvYWyDX1/DJTCDo3bx9m7h0odoW+TViJ9K72tQWRH0GNqquyiY3MuB7xiJw
        wHp4Vt74mQQolQ7tdCA3MRCI0lrBtLEt3c0V8HzhCICKcVwJ7be8tfzjJz6A3Idi
        ExspxzhQSkYYJA/QvK+6oYVBXfx5OMEtCqXfRXcLNSVSQrgCsvzHg==
X-ME-Sender: <xms:ob0KYvXk6hY1daMiWoSpWVGAZRPLPyHSue4OvzPTJIByrrPUqU4vow>
    <xme:ob0KYnm2iZvXTd1M9av8Vu7oNsBhcclINy34uqgDeO9-OXCwg6MUFn1sOJIbwtmff
    DRA5KsJyWpArW78y8E>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrjedvgddufeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvffutgesthdtredtreertdenucfhrhhomhepfdfulhgr
    uggvucghrghtkhhinhhsfdcuoehslhgruggvsehslhgruggvfigrthhkihhnshdrtghomh
    eqnecuggftrfgrthhtvghrnhepueeiffetjeeitefgveetleehveduheetiefhhfethedt
    teelgeettddvvedvudegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepshhlrgguvgesshhlrgguvgifrghtkhhinhhsrdgtohhm
X-ME-Proxy: <xmx:ob0KYra_fxC7M2bPNYoFVJm54FZDkgHDEu2OFauYnBDlfjF6lcaGjA>
    <xmx:ob0KYqWQTaGnCY4rd9mTkvh85aIqv1LvvVfbYjuwzpQfwAjOeQujMQ>
    <xmx:ob0KYpmYWgj6CWOCbb4_kln249o327mFWRr-dqwCebVbzjnX4p_jEw>
    <xmx:ob0KYieD7OnqXEOJrX4Y7kJsrqsVzAUEoCG_YEfuwP1ihmWS7qWaQQzlP5c>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 308F3F6007E; Mon, 14 Feb 2022 15:37:53 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-4748-g31a5b5f50e-fm-cal2020-20220204.001-g31a5b5f5
Mime-Version: 1.0
Message-Id: <2a5e8c17-39a7-4ecf-bda7-22fad961063a@www.fastmail.com>
In-Reply-To: <20220214092445.946718557@linuxfoundation.org>
References: <20220214092445.946718557@linuxfoundation.org>
Date:   Mon, 14 Feb 2022 15:37:52 -0500
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
Subject: Re: [PATCH 4.9 00/34] 4.9.302-rc1 review
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

On Mon, Feb 14, 2022, at 4:25 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.302 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 16 Feb 2022 09:24:36 +0000.
> Anything received after that time might be too late.

4.9.302-rc1 on my x86_64 test system compiled and booted with no errors or regressions.

Tested-by: Slade Watkins <slade@sladewatkins.com>

Thanks,
Slade
