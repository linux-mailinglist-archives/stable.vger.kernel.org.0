Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 338B360F527
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 12:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235028AbiJ0KaR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 06:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235494AbiJ0KaA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 06:30:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD71B1EEDC
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 03:29:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A8FDB81C68
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:29:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EDC0C433C1;
        Thu, 27 Oct 2022 10:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666866589;
        bh=m7Q/A23p44FrZh6OFyKKuA1mHEQtqrFF3p4k2Ou1AEk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rEL921+aLSfpjH6aMZ3aqD+V7CHDN9ZfjTrcmrXLeeOpwjRtBOnGpvZVif4/Ueb5r
         3QyWEGRwPRJ85IZb5B+jxrNKCmdSoaBMflPvLbX3hk+1Ghg2XLtmotLvEWKToaOs7i
         vF7qsIIxblJGvO/SdBw3fdrkcy0CYFXeWzkMtVYk=
Date:   Thu, 27 Oct 2022 12:29:47 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     ardb@kernel.org, bp@suse.de, ndesaulniers@google.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] x86/Kconfig: Drop check for -mabi=ms for
 CONFIG_EFI_STUB" failed to apply to 5.15-stable tree
Message-ID: <Y1pdmx8DD36s4jVt@kroah.com>
References: <166679808320556@kroah.com>
 <Y1lhm3mNdI0PFbLe@dev-arch.thelio-3990X>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1lhm3mNdI0PFbLe@dev-arch.thelio-3990X>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 26, 2022 at 09:34:35AM -0700, Nathan Chancellor wrote:
> On Wed, Oct 26, 2022 at 05:28:03PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.15-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > Possible dependencies:
> > 
> > 33806e7cb8d5 ("x86/Kconfig: Drop check for -mabi=ms for CONFIG_EFI_STUB")
> > c6dbd3e5e69c ("x86/mmx_32: Remove X86_USE_3DNOW")
> > 6bf8a55d8344 ("x86: Fix misspelled Kconfig symbols")
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > ------------------ original commit in Linus's tree ------------------
> > 
> > From 33806e7cb8d50379f55c3e8f335e91e1b359dc7b Mon Sep 17 00:00:00 2001
> > From: Nathan Chancellor <nathan@kernel.org>
> > Date: Thu, 29 Sep 2022 08:20:10 -0700
> > Subject: [PATCH] x86/Kconfig: Drop check for -mabi=ms for CONFIG_EFI_STUB
> 
> Attached is a backport that applies to both 5.15 and 5.10. Let me know
> if there are any issues.

Now queued up, thanks.

greg k-h
