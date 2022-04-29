Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 123835144E9
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 10:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236950AbiD2JAA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 05:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356175AbiD2I77 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 04:59:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A29FA86E13
        for <stable@vger.kernel.org>; Fri, 29 Apr 2022 01:56:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B522621E6
        for <stable@vger.kernel.org>; Fri, 29 Apr 2022 08:56:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43274C385A7;
        Fri, 29 Apr 2022 08:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651222601;
        bh=Rl+6+buQzIjMCGUJrzA1ThjzE/MbV4yb4ikXjQMyLpg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e2nGX41qlHe0+nZjlgJXv7NGDMisYhBA9JscP3NqqsCfYFNQqreb7nJ5wzqmsnci6
         QNKl+l+lNaBpevib2n1qQa8Qqs+eKNnYgr2ErgCxpPMpTRe79FqVLamgjeZUupWtiY
         FKHVBlm3ZRt6/DbVRofx10+2NLj0Z//74uzWZ298=
Date:   Fri, 29 Apr 2022 10:56:38 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     stable@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        npiggin@gmail.com
Subject: Re: [PATCH v4.19 0/2] Custom backports for powerpc SLB issues
Message-ID: <YmuoRmZHtJpx5pzT@kroah.com>
References: <20220428124150.375623-1-mpe@ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220428124150.375623-1-mpe@ellerman.id.au>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 28, 2022 at 10:41:48PM +1000, Michael Ellerman wrote:
> Hi Greg,
> 
> Here are two custom backports to v4.19 for some powerpc issues we've discovered.
> Both were fixed upstream as part of a large non-backportable rewrite. Other stable
> kernel versions are not affected.
> 
> cheers
> 
> Michael Ellerman (1):
>   powerpc/64s: Unmerge EX_LR and EX_DAR
> 
> Nicholas Piggin (1):
>   powerpc/64/interrupt: Temporarily save PPR on stack to fix register
>     corruption due to SLB miss
> 
>  arch/powerpc/include/asm/exception-64s.h | 37 ++++++++++++++----------
>  1 file changed, 22 insertions(+), 15 deletions(-)
> 
> -- 
> 2.35.1
> 

Both now queued up, thanks.

greg k-h
