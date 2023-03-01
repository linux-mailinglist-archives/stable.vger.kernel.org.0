Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97AE46A6F79
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 16:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbjCAPal (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 10:30:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbjCAPak (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 10:30:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DE383BDB5
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 07:30:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42D25B81077
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 15:30:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852FAC433D2;
        Wed,  1 Mar 2023 15:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677684636;
        bh=m8mLbd7RHXNqbil9oDtr6CReXcqGylV1abfPugoL20Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eeBBIA4H2LYAfvzwYkaabSeW5wYfSOqK4fbDw2bLBPT3A5oK7Zj8VyMC9W93trG72
         kBnw6aJEcEX12OWhxCH29jQ+ubXc0ov70ZCKTjpCWE+eT6FAUaNtOBXYS/Ogb/9P/q
         GtAkX3NzwDWTV1FVp0FHvfehvraKYRCyS1L0dsQU=
Date:   Wed, 1 Mar 2023 16:30:34 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Vegard Nossum <vegard.nossum@oracle.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH stable-queue.git] scripts/bad_stable: include
 instructions to fix and resubmit
Message-ID: <Y/9vmjs8kb1kshAn@kroah.com>
References: <20230301093449.16560-1-vegard.nossum@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301093449.16560-1-vegard.nossum@oracle.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 01, 2023 at 10:34:49AM +0100, Vegard Nossum wrote:
> This basically implements the suggestion from
> <https://lore.kernel.org/stable/46577540-6ed7-0ff5-11d5-2982cd29e92b@oracle.com/>.
> 
> Sample output:
> 
>   To reproduce the conflict and resubmit, you may use the following commands:
> 
>   git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.15.y
>   git checkout FETCH_HEAD
>   git cherry-pick -x 9f46c187e2e680ecd9de7983e4d081c3391acc76
>   # <resolve conflicts, build, test, etc.>
>   git commit -s
>   git send-email --to '<stable@vger.kernel.org>' --in-reply-to '<165314153515625@kroah.com>' --subject-prefix 'PATCH 5.15.y' HEAD^..
> 
> Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
> ---
>  scripts/bad_stable | 9 +++++++++
>  1 file changed, 9 insertions(+)

Thanks for this, now applied, let's see how it looks in action, I'll go
find some patches to fail :)
