Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27B486EB79D
	for <lists+stable@lfdr.de>; Sat, 22 Apr 2023 07:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbjDVFoY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Apr 2023 01:44:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjDVFoX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Apr 2023 01:44:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB46C1BC6;
        Fri, 21 Apr 2023 22:44:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6105D609D1;
        Sat, 22 Apr 2023 05:44:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41C8CC433EF;
        Sat, 22 Apr 2023 05:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682142261;
        bh=548omaBy8eoqc944JBzv8PKC3A65fKx3oFNKIC3BVk0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oJIZyz0QZAqcqfin1m5zmyKIQ9hLJuJUoIXv6HeqiSexSpRSR+qxu3bMb5e57uinB
         Lo/9+apfeCgs9rn4GWw30m+iRFgLgUSDCMKmlWrbOIBmc5nGm2WAoV49beWW/XlFNY
         qCBWrvS1sqGaxI/vyQFgU/xGvYeYC74jxi4GFFVM=
Date:   Sat, 22 Apr 2023 07:44:18 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?iso-8859-1?Q?Andr=E9?= Almeida <andrealmeid@collabora.com>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v2 stable-5.10.y stable-5.15.y] docs: futex: Fix
 kernel-doc references after code split-up preparation
Message-ID: <ZEN0MsKMQXTqGwk-@kroah.com>
References: <20230421221741.1827866-1-carnil@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230421221741.1827866-1-carnil@debian.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Apr 22, 2023 at 12:17:42AM +0200, Salvatore Bonaccorso wrote:
> In upstream commit 77e52ae35463 ("futex: Move to kernel/futex/") the
> futex code from kernel/futex.c was moved into kernel/futex/core.c in
> preparation of the split-up of the implementation in various files.
> 
> Point kernel-doc references to the new files as otherwise the
> documentation shows errors on build:
> 
>     [...]
>     Error: Cannot open file ./kernel/futex.c
>     Error: Cannot open file ./kernel/futex.c
>     [...]
>     WARNING: kernel-doc './scripts/kernel-doc -rst -enable-lineno -sphinx-version 3.4.3 -internal ./kernel/futex.c' failed with return code 2
> 
> There is no direct upstream commit for this change. It is made in
> analogy to commit bc67f1c454fb ("docs: futex: Fix kernel-doc
> references") applied as consequence of the restructuring of the futex
> code.
> 
> Fixes: 77e52ae35463 ("futex: Move to kernel/futex/")
> Signed-off-by: Salvatore Bonaccorso <carnil@debian.org>
> ---
> v1->v2:
>  - Fix typo in description about new target file for futex.c code
>  - Indent block with build log output
> 
>  Documentation/kernel-hacking/locking.rst                    | 2 +-
>  Documentation/translations/it_IT/kernel-hacking/locking.rst | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
