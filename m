Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF23E4B1748
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 21:56:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344336AbiBJU4W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 15:56:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241575AbiBJU4W (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 15:56:22 -0500
Received: from new4-smtp.messagingengine.com (new4-smtp.messagingengine.com [66.111.4.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF2ED10A7;
        Thu, 10 Feb 2022 12:56:22 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 3CC6A5801D5;
        Thu, 10 Feb 2022 15:56:22 -0500 (EST)
Received: from imap49 ([10.202.2.99])
  by compute2.internal (MEProxy); Thu, 10 Feb 2022 15:56:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        sladewatkins.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; bh=WWJfizk8fowQvV
        3+Z2PQ3kVVooCwktVVaQRnc7bffIk=; b=G10YaAN2n2pjVUNR+l8pDQpZtF/+N6
        ze2ksY+J2ObtmLvpduZTMz9PHu8xE/7tap70Xv0PWIS5eFgWNdGBBlmrjJPrrad8
        wU3unuQu+2ZMlIIgoeE1nViyDoBInft4xxK9F31refkkzU3bW+RXdiomyyTfIRDi
        3lk+zRqVhFmnV5iQWDfirGr2oiPLoEpSZbgEHkpx2vbEiO4+5EZE8uLhYeaSPTtp
        MMAMI3jGbi8Vl2S9pXHmqwGocG6KjpObCsOik5qkr0pjKW7bP0a/MN05f+Y0D1dO
        I2exo0At83uI/xMgO9I23Yi4JBBsFZhUbqMQNn4j61E5nicGXkfRVCAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=WWJfizk8fowQvV3+Z
        2PQ3kVVooCwktVVaQRnc7bffIk=; b=amqL/TSojj8gVGrfuQvlCYRqxHXn8QaF0
        3koN6RQsNrRDVqeHaz+vaswi3Ip9gx8mZmYVZYpU9QFmdWqtHTw6JQbosbFHM5yY
        hoUOPYvf6ligBzpyoefj2lYqxazv6cAB7RwdLIlP7KbRTLqb5RDHYTNSO0e31J6v
        nO92/GrvKG8C3Hz69uBLeA2JBzSgAxLUMggiRXyDquQ5AQnbogfCnbjQt9hufJhs
        w4NtR/Xg9oP3WzzRMS8k6ye6Vqgw8NdiPjRNpEa+30kbSos8AflVDEnInGoGIFl8
        z3UAORqE72kJqfaOyS0CiAxsEJYRVyk5vz8oVhb/ueiFM5YZgZ0gQ==
X-ME-Sender: <xms:9nsFYumSp6ehWu4pKNLqNI1For9p__RqsN9y-x0UuZU0bPUKSvnbAg>
    <xme:9nsFYl3_GLUH0QkC4CAvUch6oX8nxf7Int_CfCZk-QErNK6gToxST5ASuzsTsPCFR
    2i97lzwOgkwM-WfKZM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddriedugddugeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvffutgesthdtredtreertdenucfhrhhomhepfdfulhgr
    uggvucghrghtkhhinhhsfdcuoehslhgruggvsehslhgruggvfigrthhkihhnshdrtghomh
    eqnecuggftrfgrthhtvghrnhepueeiffetjeeitefgveetleehveduheetiefhhfethedt
    teelgeettddvvedvudegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepshhlrgguvgesshhlrgguvgifrghtkhhinhhsrdgtohhm
X-ME-Proxy: <xmx:9nsFYsqgLphy8bQ-jLWOYqNm-oUSkhhJ83tKpiXDFC8gDZt5epUXig>
    <xmx:9nsFYilea1v2Q3-UyfAJRmOHqtjIHTKvDlFfJcT8FMWc47suTNWwjQ>
    <xmx:9nsFYs2xX_vu3MToNmdwxa2EyYxVrKP3ABd6blkDPv_pynoHa5pTQw>
    <xmx:9nsFYltR-pMCJ7oJSmOcz3rA6mfk1xCH0J1s606C-p7ubfQm0kR3HRfpxK0>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id F3042F6007E; Thu, 10 Feb 2022 15:56:21 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-4748-g31a5b5f50e-fm-cal2020-20220204.001-g31a5b5f5
Mime-Version: 1.0
Message-Id: <02bc91d9-92c6-4e5c-8746-62bd573a9feb@www.fastmail.com>
In-Reply-To: <20220209191248.659458918@linuxfoundation.org>
References: <20220209191248.659458918@linuxfoundation.org>
Date:   Thu, 10 Feb 2022 15:56:18 -0500
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
Subject: Re: [PATCH 4.14 0/3] 4.14.266-rc1 review
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 9, 2022, at 2:13 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.266 release.
> There are 3 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 11 Feb 2022 19:12:41 +0000.
> Anything received after that time might be too late.

Compiled and booted 4.14.266-rc1 on my x86_64 test system successfully without errors or regressions.

Tested-by: Slade Watkins <slade@sladewatkins.com>

Thanks,
Slade
