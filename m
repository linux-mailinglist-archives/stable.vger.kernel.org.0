Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85A106E5FB1
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 13:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbjDRLUV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 07:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbjDRLUU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 07:20:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E38244B5
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 04:19:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E7A4363019
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 11:19:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3C5DC433D2;
        Tue, 18 Apr 2023 11:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681816782;
        bh=tiNY34yatprSRuDk/xtrhy6loqeOuTr8t9eXB5L73Xw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BVydh2rz8jc63dwKlTRoy3RnpcAvOc0jUtSGlu1j8OluTUcY+hvysUSbr0pgNV1R0
         qaoULxDpq5DJXI+pZ14JPUm4KJGyQGTIgKIejEI0lhnEiwLKk/H5vI6FTjY2cM9RzP
         DI1SolYTl+/pX02/zdBA0gMafaTtCM6pxyx92MoI=
Date:   Tue, 18 Apr 2023 13:19:39 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alyssa Ross <hi@alyssa.is>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>
Subject: Re: Patch "purgatory: fix disabling debug info" has been added to
 the 5.15-stable tree
Message-ID: <2023041837-dial-catchable-0203@gregkh>
References: <20230418012722.330253-1-sashal@kernel.org>
 <20230418103951.2b7kia6nb2zdeqje@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230418103951.2b7kia6nb2zdeqje@x220>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 18, 2023 at 10:39:51AM +0000, Alyssa Ross wrote:
> On Mon, Apr 17, 2023 at 09:27:22PM -0400, Sasha Levin wrote:
> > This is a note to let you know that I've just added the patch titled
> >
> >     purgatory: fix disabling debug info
> >
> > to the 5.15-stable tree which can be found at:
> >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> >
> > The filename of the patch is:
> >      purgatory-fix-disabling-debug-info.patch
> > and it can be found in the queue-5.15 subdirectory.
> >
> > If you, or anyone else, feels it should not be added to the stable tree,
> > please let <stable@vger.kernel.org> know about it.
> 
> There's no need for this patch on 5.15, as the regression it fixes was
> only introduced in 6.0.

Not according to the information in this commit, which says:

Fixes: 32ef9e5054ec ("Makefile.debug: re-enable debug info for .S files")

And that commit is in the following releases:

	4.19.264 5.4.221 5.10.152 5.15.76 5.19.12 6.0

So it should be also in 5.4.y and 4.19.y, right?

thanks,

greg k-h
