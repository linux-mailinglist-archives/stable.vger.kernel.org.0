Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39F5D534F21
	for <lists+stable@lfdr.de>; Thu, 26 May 2022 14:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240465AbiEZMaq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 May 2022 08:30:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239480AbiEZMap (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 May 2022 08:30:45 -0400
X-Greylist: delayed 535 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 26 May 2022 05:30:44 PDT
Received: from new4-smtp.messagingengine.com (new4-smtp.messagingengine.com [66.111.4.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C88374968B
        for <stable@vger.kernel.org>; Thu, 26 May 2022 05:30:44 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 3D361580116;
        Thu, 26 May 2022 08:21:48 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 26 May 2022 08:21:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1653567708; x=1653574908; bh=GRfnKkUTz0
        zKjL/dk0+dMGLfL/ozgSJ248GgBC6IKzc=; b=UXsSqKR0+SgCSpmYN/AG7VK8/1
        J5gEVXkNEDtmMzWSs18qZDX4ZQFhx2XONf89ylbUl7wM28FmvdjeEA6zDWaApvwV
        7yTam4X3hx/+2wz/5IESXh5c05+DpXyBVWSeh4kL7vE8WsZLrZgWG2vCucWzUVy8
        GD4F4eEa6FsKBcHdtUTvwQo50MJTyMSUQQtnDhEn7+4/SI48530y0jVv+Hn0fkJL
        3zzXpBZIi9rO1jWnu2G/B0BL2vFf7pF7E8DyRHDldoyGlwd9Yoc6hNgaWbdF/x6Z
        QXFy9NDtzXMC3nAFTSQf1jr/Qk+MmyEFEEWYyhOan6GjuHiXU5kRKIOdq2fQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1653567708; x=1653574908; bh=GRfnKkUTz0zKjL/dk0+dMGLfL/oz
        gSJ248GgBC6IKzc=; b=cGJ8QipVD80gsYuJfstfC1Vv+tf5iLSkQwCphZvdO/zH
        TKt0+31JVF4B9UZB9RS/8Jn2hRiP+N/TAfoGuuRkUcqcxuvYytd1bITrR2BLg9X8
        Cbw3yaMMYeKqSyN/0EG2qOZLdty05FLlUMaXMTXn/Br3d9OhCTWA1XioPis7iFfe
        bbBcyQheOdZL8LDrgYBz3lHGjEUtMI+zOMlmGwLkwHd/5x6UEh5CfApQa8IYpB/w
        QR4m5EUWR517lp+CrP3oqo4wmskOTdHWHrd4Hk3Qml2ZXdYCisButCnHOj79BiCE
        L+liG/fFJnHjGFuuBVRWHDEQWv9yiMs9S3udvBM3Jg==
X-ME-Sender: <xms:23CPYhEsM32F30C26JgxFvAkjzojpTzrwwZ8Kh_SaxLGFEDH330vtg>
    <xme:23CPYmUlA-4A1QnP35nVYuNb-euOW5f-RUsKk_0BJ38xYISuLBKcdJYZG58BFVmAv
    gMtHiCaw0pcOA>
X-ME-Received: <xmr:23CPYjICbDFBbPIza4uaJphZp6joeDVU_m5lJKnvBXhzyU1WzM2pVuf-3Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrjeejgdeglecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeehgedvve
    dvleejuefgtdduudfhkeeltdeihfevjeekjeeuhfdtueefhffgheekteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:23CPYnFH8bv0JGylA8anc6PlAsuSMURitxaRo8_nAtyOnt6Xe_plJg>
    <xmx:23CPYnW1WuJpqW6KqLO7HAAAe7MlAl1QKP-zX5dyZVlGSLiXe3qw4w>
    <xmx:23CPYiP9aB758wKHEJy4NerL9rW1jgoCpO32gxU9stYIyyxg3qmUnA>
    <xmx:3HCPYk0K4twfuaDP2J0dnv6smjZyFayJbl_oyM7qjZunZslYi170HA>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 26 May 2022 08:21:46 -0400 (EDT)
Date:   Thu, 26 May 2022 14:21:44 +0200
From:   Greg KH <greg@kroah.com>
To:     Stefan Ghinea <stefan.ghinea@windriver.com>
Cc:     stable@vger.kernel.org, edumazet@google.com, willemb@google.com,
        davem@davemloft.net, Jason@zx2c4.com, moshe.kol@mail.huji.ac.il,
        yossi.gilad@mail.huji.ac.il, aksecurity@gmail.com, w@1wt.eu,
        kuba@kernel.org
Subject: Re: [PATCH 4.14 2/2] secure_seq: use the 64 bits of the siphash for
 port offset calculation
Message-ID: <Yo9w2DyibH3N0ZfT@kroah.com>
References: <20220524185539.23950-1-stefan.ghinea@windriver.com>
 <20220524185539.23950-2-stefan.ghinea@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220524185539.23950-2-stefan.ghinea@windriver.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 24, 2022 at 09:55:39PM +0300, Stefan Ghinea wrote:
> From: Willy Tarreau <w@1wt.eu>
> 
> commit b2d057560b8107c633b39aabe517ff9d93f285e3 upstream
> 
> SipHash replaced MD5 in secure_ipv{4,6}_port_ephemeral() via commit
> 7cd23e5300c1 ("secure_seq: use SipHash in place of MD5"), but the output
> remained truncated to 32-bit only. In order to exploit more bits from the
> hash, let's make the functions return the full 64-bit of siphash_3u32().
> We also make sure the port offset calculation in __inet_hash_connect()
> remains done on 32-bit to avoid the need for div_u64_rem() and an extra
> cost on 32-bit systems.
> 
> Cc: Jason A. Donenfeld <Jason@zx2c4.com>
> Cc: Moshe Kol <moshe.kol@mail.huji.ac.il>
> Cc: Yossi Gilad <yossi.gilad@mail.huji.ac.il>
> Cc: Amit Klein <aksecurity@gmail.com>
> Reviewed-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Willy Tarreau <w@1wt.eu>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> [SG: Adjusted context]
> Signed-off-by: Stefan Ghinea <stefan.ghinea@windriver.com>

All now queued up, thanks.

greg k-h
