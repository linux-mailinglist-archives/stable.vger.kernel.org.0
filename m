Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C161F68D311
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 10:41:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231686AbjBGJld (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 04:41:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231681AbjBGJlc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 04:41:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C1707EC5
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 01:41:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC58C6125A
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 09:41:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B7BDC4339B;
        Tue,  7 Feb 2023 09:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675762891;
        bh=pwvBdQUtDE2Fx7cRAYcep6H0oih+/hHSgoZVybOlw1U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=k4apgIOKH/ADziDhi+fcbfii1UvuYgaLuKCv3cfEmQZupt+pHuD4z7VdfJ8EiP9zU
         lsMRL+pzn2WtPzuYt/TO712VV/gj1lryMyrbOj0dBTSO20MY2IzmyVG38PXpvfkDXf
         GaRiFbAKsXAz/UPw3DXqmLIxw55zaZsOpvhn7268=
Date:   Tue, 7 Feb 2023 10:41:23 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Luiz Capitulino <luizcap@amazon.com>
Cc:     stable@vger.kernel.org, Andrea Righi <andrea.righi@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        Minchan Kim <minchan@kernel.org>,
        Anchal Agarwal <anchalag@amazon.com>,
        Hugh Dickins <hughd@google.com>,
        Vineeth Remanan Pillai <vpillai@digitalocean.com>,
        Kelley Nielsen <kelleynnn@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RESEND stable 5.4] mm: swap: properly update readahead
 statistics in unuse_pte_range()
Message-ID: <Y+Icw+54/kbj2Fpr@kroah.com>
References: <20230203143622.55262-1-luizcap@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230203143622.55262-1-luizcap@amazon.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 03, 2023 at 02:36:22PM +0000, Luiz Capitulino wrote:
> From: Andrea Righi <andrea.righi@canonical.com>
> 
> Commit ebc5951eea499314f6fbbde20e295f1345c67330 upstream.
> 
> [ This fixes a performance issue we're seeing in AWS instances when
>   running swapoff and using the global readahead algorithm. For a
>   particular instance configuration, Without this fix I/O throughput
>   is very low during swapoff (about 15 MB/s) with this patch is
>   reaches 500 MB/s. Tested swapoff with different workloads with
>   this patch applied. 5.10 onwards already have this fix ]

Now queued up, thanks.

greg k-h
