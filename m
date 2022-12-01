Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2B0C63EB07
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 09:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbiLAI0x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 03:26:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbiLAI0t (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 03:26:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98C8268C77;
        Thu,  1 Dec 2022 00:26:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 39B2961ECC;
        Thu,  1 Dec 2022 08:26:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E3ECC433D6;
        Thu,  1 Dec 2022 08:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669883207;
        bh=FLiivefubG0M1VN/dAgF1P5CtTe9qGh2FWfKO/VJKFo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WVByf2YUdsIhg0LrPxW2uCeo7tIxOM2pujLlUdX6Y1fhmwPsEcEGl3XtpBv3hTlDV
         tbD4QHPP4fQl864NXJuWDhX85KvtutKViWFb1igQWQ4ihyDmGoO8UMJyz5A6AIl917
         WCmZ4WSAskjNxfX32b4MV6YPqsduadBYfmLrDep4=
Date:   Thu, 1 Dec 2022 08:58:49 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sam James <sam@gentoo.org>
Cc:     stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        stable-commits@vger.kernel.org
Subject: Re: Patch "kbuild: fix -Wimplicit-function-declaration in
 license_is_gpl_compatible" has been added to the 6.0-stable tree
Message-ID: <Y4heuSx4Sr8dMWkt@kroah.com>
References: <166974128121866@kroah.com>
 <73A357E7-91A4-4E78-963C-806C49B2F8BB@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73A357E7-91A4-4E78-963C-806C49B2F8BB@gentoo.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 01, 2022 at 04:52:50AM +0000, Sam James wrote:
> 
> 
> > On 29 Nov 2022, at 17:01, gregkh@linuxfoundation.org wrote:
> > 
> > 
> > This is a note to let you know that I've just added the patch titled
> > 
> >    kbuild: fix -Wimplicit-function-declaration in license_is_gpl_compatible
> > 
> > to the 6.0-stable tree which can be found at:
> >    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> > 
> > The filename of the patch is:
> >     kbuild-fix-wimplicit-function-declaration-in-license_is_gpl_compatible.patch
> > and it can be found in the queue-6.0 subdirectory.
> > 
> > If you, or anyone else, feels it should not be added to the stable tree,
> > please let <stable@vger.kernel.org> know about it.
> > 
> > From 50c697215a8cc22f0e58c88f06f2716c05a26e85 Mon Sep 17 00:00:00 2001
> > From: Sam James <sam@gentoo.org>
> > Date: Wed, 16 Nov 2022 18:26:34 +0000
> > Subject: kbuild: fix -Wimplicit-function-declaration in license_is_gpl_compatible
> > 
> > From: Sam James <sam@gentoo.org>
> > 
> > commit 50c697215a8cc22f0e58c88f06f2716c05a26e85 upstream.
> 
> Hi Greg,
> 
> Please yank this commit from all the stable queues -- it needs
> Some further baking, and a revert is queued in Andrew's tree.

Ok, now deleted from all queues, thanks.

greg k-h
