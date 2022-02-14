Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7AA4B5CD0
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 22:30:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231307AbiBNV3o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 16:29:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231324AbiBNV3n (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 16:29:43 -0500
Received: from new4-smtp.messagingengine.com (new4-smtp.messagingengine.com [66.111.4.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7AD913FA9;
        Mon, 14 Feb 2022 13:29:35 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 80DB5580593;
        Mon, 14 Feb 2022 16:29:33 -0500 (EST)
Received: from imap49 ([10.202.2.99])
  by compute2.internal (MEProxy); Mon, 14 Feb 2022 16:29:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        sladewatkins.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; bh=e4v6AJqxv1yPHN
        FtXns14bhk4nbzQ0lLtskgxFCqFXg=; b=aF8hmvj19DhWjKDc1bfcOW93NLhAGe
        x9RZnIrENOXXSZ2opKXLSxNhChLk4xQb6ndxqCWl+rhRT+iraGRwPJwqwfNRMRPu
        SggMCJIRG8mDSHmjnp36HsPW8c3kRU4FEJXnVm79zD1SGg2ZZ2leEP8vS9EwRHsT
        n00lLGz/X+G8ZZZCBuXkVH+7NNn89Mnh2FdzdEm6Jk+2grb9JX2uJLLbrK0QMOOc
        dTCaxQ4/+jb2j0XOZhWAN39BfTz81vJEpSs+MUBc4EygEosd5PEIF+rIUEBawRmh
        c6/3v4q4CtWQKEgXbvK2EBxOAcQ/Xy/oZZZ3FwvejSo7k1zFCBHVv6jg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=e4v6AJqxv1yPHNFtX
        ns14bhk4nbzQ0lLtskgxFCqFXg=; b=eUyt+i9jZcPJx4Z3B/N2xrvbNLZO4TM5k
        rOt3iIQz9wZzHeSPQz29i1RRGYbJc4h9ZtR6b/yBoHiMCqvzrVDXJg5zlLOkL0z6
        jQQWUVhDed1w6ycbhbotSmADBqxRVrBlTmrBYU66kczN5PRkyrOD/pZ38Giw5d3p
        5rfJ0rczinhHLxUrrWCHvGKehHBNssgRAkAP/T2lJ9SNonGHMocBYuXw6EmgYHCK
        0RiJAuSZ422TURYgardukgA59GEBsppjDOsbNpw4lFOg8mbiHi6f4JejoaQ/wkpe
        1T4t+5SSdfRqf6t1oCM0x9pGZROUDofigUO60pqGGF3npfZWhOz9Q==
X-ME-Sender: <xms:vckKYgS9KQ7JHuWHjbIqAz4aQEZGqwvjf1jun2f_bGTvh2liP_SrZA>
    <xme:vckKYtwuPYcFOOy5JM9n2dCDtg7q3ZkeudtWqol0gRfZ6QOGGXjh8yE4hc6smNM93
    pxUrrWTGMNgkFRUQ9A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrjedvgddugeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvffutgesthdtredtreertdenucfhrhhomhepfdfulhgr
    uggvucghrghtkhhinhhsfdcuoehslhgruggvsehslhgruggvfigrthhkihhnshdrtghomh
    eqnecuggftrfgrthhtvghrnhepueeiffetjeeitefgveetleehveduheetiefhhfethedt
    teelgeettddvvedvudegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepshhlrgguvgesshhlrgguvgifrghtkhhinhhsrdgtohhm
X-ME-Proxy: <xmx:vckKYt3zVn-fRTGxiG0CooS0N3ljgcQFzfWTE1TNsPzvdlpmsBGl7g>
    <xmx:vckKYkDPvRGfKRKyyIdI4yn6oSsgVascO58TcgYEi30kndShnE8-kQ>
    <xmx:vckKYpiCSOHobRZLHjHj0Vnt0hpGG0oaoSh6c2eXpYgTNiZhYd5kgw>
    <xmx:vckKYubqtIEY_Ou1yyGHFvVrF2VgXGxKu8X8G46qv6MlIGzYTnfBPQwi8CI>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 0D187F6007E; Mon, 14 Feb 2022 16:29:33 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-4748-g31a5b5f50e-fm-cal2020-20220204.001-g31a5b5f5
Mime-Version: 1.0
Message-Id: <046eebf9-c62a-4843-9779-d8495cc62417@www.fastmail.com>
In-Reply-To: <20220214092452.020713240@linuxfoundation.org>
References: <20220214092452.020713240@linuxfoundation.org>
Date:   Mon, 14 Feb 2022 16:29:32 -0500
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
Subject: Re: [PATCH 5.4 00/71] 5.4.180-rc1 review
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

On Mon, Feb 14, 2022, at 4:25 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.180 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 16 Feb 2022 09:24:36 +0000.
> Anything received after that time might be too late.

5.4.180-rc1 on my x86_64 test system compiled and booted with no errors or regressions.

Tested-by: Slade Watkins <slade@sladewatkins.com>

Thanks,
Slade
