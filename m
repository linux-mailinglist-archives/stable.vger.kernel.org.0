Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8048A641DAB
	for <lists+stable@lfdr.de>; Sun,  4 Dec 2022 16:38:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbiLDPir (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Dec 2022 10:38:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbiLDPiq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Dec 2022 10:38:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4DA611175
        for <stable@vger.kernel.org>; Sun,  4 Dec 2022 07:38:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA3AA60DE4
        for <stable@vger.kernel.org>; Sun,  4 Dec 2022 15:38:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF1DFC433D6;
        Sun,  4 Dec 2022 15:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670168324;
        bh=ctdI2YEvFlmKT2YJRj65yRkzoZol77bTrzDHpgJn8NQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JDb1cZcG9Zp4n+iEM1Z0Nbb+L55UUdjR4k4HrlYY6FozQYZMidWFe4lcDW/3BamXr
         bYlQXgZtK7bL1gqHn4+WexrPerWgxYFceEw5XV4FAEqAZVEYpv4OgxsxgV52elVSRr
         8/Mh9LcZCX+I+/8nLfzE8/gq8gjYexuVDUvdCDbA=
Date:   Sun, 4 Dec 2022 16:38:40 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Hugh Dickins <hughd@google.com>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Sasha Levin <sashal@kernel.org>, llvm@lists.linux.dev,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 and earlier only] mm: Fix '.data.once' orphan section
 warning
Message-ID: <Y4y/AEsLmKRcQ/R0@kroah.com>
References: <20221128225345.9383-1-nathan@kernel.org>
 <Y4tQYgjDgodwR2pP@kroah.com>
 <5f9317c7-e899-a6b2-dd23-664a1b6d629@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f9317c7-e899-a6b2-dd23-664a1b6d629@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 03, 2022 at 09:41:34AM -0800, Hugh Dickins wrote:
> On Sat, 3 Dec 2022, Greg Kroah-Hartman wrote:
> > On Mon, Nov 28, 2022 at 03:53:46PM -0700, Nathan Chancellor wrote:
> > > 
> > > As far as I can tell, this should be applied to 5.4 and earlier. It
> > > should apply cleanly but let me know if not.
> > 
> > Queued up everywhere, thanks.
> 
> Thanks for queueing them up, Greg, but please read through the thread:
> I have doubts on the 4.14 and 4.9 ones, which would want a different patch
> if we're going to make any change; but thought we could just leave those
> trees without the patch, and Nathan agreed.

Oops, sorry, now dropped from 4.14 and 4.9 and I left the 4.19 one as
that one was ok to keep, right?

thanks,

greg k-h
