Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA865A93B7
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 11:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232372AbiIAJ5A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 05:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231717AbiIAJ47 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 05:56:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0769913778D
        for <stable@vger.kernel.org>; Thu,  1 Sep 2022 02:56:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EDF6461B0D
        for <stable@vger.kernel.org>; Thu,  1 Sep 2022 09:56:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 061D4C433B5;
        Thu,  1 Sep 2022 09:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662026216;
        bh=1PRT7jsFTGFoQyaoG6xS8KSWnD42E82X8OoMjvWcq8M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EFVl15jAF+8BV4qjYJF9PHzPMvNVLZQpeskuztQif9r1/Rkmozh51rteCOuUT/7fe
         xVIWl/UHjUkkzbGu5q2u3Qbh3XAv7AeYYGZoQ6GMA2qpZL09/TG7G1rBbsdfnBdK0R
         8RndSrT35Wvntqnr2i/d/uaJZBI/nz3xiN29PbDw=
Date:   Thu, 1 Sep 2022 11:56:53 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lucas Wei <lucaswei@google.com>
Cc:     stable@vger.kernel.org, robinpeng@google.com,
        willdeacon@google.com, aaronding@google.com,
        danielmentz@google.com, James Morse <james.morse@arm.com>
Subject: Re: [PATCH] arm64: errata: Add Cortex-A510 to the repeat tlbi list
Message-ID: <YxCB5dzUHt17DZCe@kroah.com>
References: <20220831132724.4101958-1-lucaswei@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220831132724.4101958-1-lucaswei@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 31, 2022 at 09:27:25PM +0800, Lucas Wei wrote:
> From: James Morse <james.morse@arm.com>
> 
> commit 39fdb65f52e9a53d32a6ba719f96669fd300ae78 upstream.
> 
> Cortex-A510 is affected by an erratum where in rare circumstances the
> CPUs may not handle a race between a break-before-make sequence on one
> CPU, and another CPU accessing the same page. This could allow a store
> to a page that has been unmapped.
> 
> Work around this by adding the affected CPUs to the list that needs
> TLB sequences to be done twice.
> 
> Cc: stable@vger.kernel.org # 5.15.x
> Signed-off-by: James Morse <james.morse@arm.com>
> Link: https://lore.kernel.org/r/20220704155732.21216-1-james.morse@arm.com
> Signed-off-by: Will Deacon <will@kernel.org>
> Signed-off-by: Lucas Wei <lucaswei@google.com>
> ---
>  Documentation/arm64/silicon-errata.rst |  2 ++
>  arch/arm64/Kconfig                     | 17 +++++++++++++++++
>  arch/arm64/kernel/cpu_errata.c         |  8 +++++++-
>  3 files changed, 26 insertions(+), 1 deletion(-)

Now queued up, thanks.

greg k-h
