Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5A5F603513
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 23:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbiJRVoO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Oct 2022 17:44:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiJRVoN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Oct 2022 17:44:13 -0400
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D156E18399;
        Tue, 18 Oct 2022 14:44:12 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:281:8300:73::5f6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 661ED2D7;
        Tue, 18 Oct 2022 21:44:12 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 661ED2D7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1666129452; bh=GpCU8ZMVC2iySte9YK3M9WdzqhAYz08mfuhCcBroAYI=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=D8iwp1u/DyNeJq0Eofn+VyRo70q3GbgERe04B/0joQAR6FdwQIeahuo1V64zoZ1F7
         OZossqcoWzthSuItasSOOY5TYER4IwSZA0xS5vsFglsl9a27/mFTsCnw2pZ4LcbEmt
         FKrzbvJDcLz5hl3WfhjB5cI/xf227wpIJOck6i2wryifyjg6uaC3jv0V4/4wEz5+XH
         x7i8kPVTLtfQz9byw8oHvsYrA385aqKfKiwT4qm+fxoPWUJv/C7bjL6eEIae2j0e4E
         IfJtVz15VK/hJcE+PoyKmyReJ6Ax7YIXMSnTcDW7/3IF/zFdaQOkZC9Ls5txFpEkCj
         iJwfWHyqFT4ZA==
From:   Jonathan Corbet <corbet@lwn.net>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        Sasha Levin <sashal@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tyler Hicks <code@tyhicks.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>
Subject: Re: [PATCH v2] Documentation: process: replace outdated LTS table
 w/ link
In-Reply-To: <20221014171040.849726-1-ndesaulniers@google.com>
References: <Y0mSVQCQer7fEKgu@kroah.com>
 <20221014171040.849726-1-ndesaulniers@google.com>
Date:   Tue, 18 Oct 2022 15:44:11 -0600
Message-ID: <87sfjkdcyc.fsf@meer.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Nick Desaulniers <ndesaulniers@google.com> writes:

> The existing table was a bit outdated.
>
> 3.16 was EOL in 2020.
> 4.4 was EOL in 2022.
>
> 5.10 is new in 2020.
> 5.15 is new in 2021.
>
> We'll see if 6.1 becomes LTS in 2022.
>
> Rather than keep this table updated, it does duplicate information from
> multiple kernel.org pages. Make one less duplication site that needs to
> be updated and simply refer to the kernel.org page on releases.
>
> Suggested-by: Tyler Hicks <code@tyhicks.com>
> Suggested-by: Bagas Sanjaya <bagasdotme@gmail.com>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Applied, thanks.

jon
