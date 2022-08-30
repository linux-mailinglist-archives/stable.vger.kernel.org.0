Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2B35A672D
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 17:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbiH3PWH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 11:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbiH3PWG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 11:22:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A244F7B38
        for <stable@vger.kernel.org>; Tue, 30 Aug 2022 08:22:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A08E061566
        for <stable@vger.kernel.org>; Tue, 30 Aug 2022 15:22:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7BDBC433D6;
        Tue, 30 Aug 2022 15:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661872924;
        bh=dPh7fY9ISjI71LqUqLPBLpLpwM6+gm9DhYqgA5/rAmA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EHcJU/z3tJe6D4V7TbA7Bk830JHUzTGtr2sf6/3APRVJHGxvGsEsSH9dqBonBy9Y/
         O40+kwBhbKQP0QsASHpXniUTvC0oRgRNGDLrCZk28B2YkGgijIJ4kD8L/finZTMCu3
         SmSJ9CN2PIxTrJzF7uGUYUFMGoG+oMFp5cPO8n6E=
Date:   Tue, 30 Aug 2022 17:22:01 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lucas Wei <lucaswei@google.com>
Cc:     stable@vger.kernel.org, robinpeng@google.com,
        willdeacon@google.com, aaronding@google.com,
        danielmentz@google.com, James Morse <james.morse@arm.com>
Subject: Re: [PATCH] arm64: errata: Add Cortex-A510 to the repeat tlbi list
Message-ID: <Yw4rGZ2LFgQN8qeB@kroah.com>
References: <20220830150804.3425929-1-lucaswei@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220830150804.3425929-1-lucaswei@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 30, 2022 at 11:08:04PM +0800, Lucas Wei wrote:
> From: James Morse <james.morse@arm.com>
> 
> Cortex-A510 is affected by an erratum where in rare circumstances the
> CPUs may not handle a race between a break-before-make sequence on one
> CPU, and another CPU accessing the same page. This could allow a store
> to a page that has been unmapped.
> 
> Work around this by adding the affected CPUs to the list that needs
> TLB sequences to be done twice.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> Link: https://lore.kernel.org/r/20220704155732.21216-1-james.morse@arm.com
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  Documentation/arm64/silicon-errata.rst |  2 ++
>  arch/arm64/Kconfig                     | 17 +++++++++++++++++
>  arch/arm64/kernel/cpu_errata.c         |  8 +++++++-
>  3 files changed, 26 insertions(+), 1 deletion(-)

What is the upstream commit id of this patch in Linus's tree, and what
tree(s) do you want it applied to?

Always be specific, remember, some of us have to deal with over a
thousand emails a day...

thanks,

greg k-h
