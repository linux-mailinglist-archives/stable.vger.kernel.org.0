Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 561B74AAF5A
	for <lists+stable@lfdr.de>; Sun,  6 Feb 2022 14:10:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235261AbiBFNKw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Feb 2022 08:10:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbiBFNKv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Feb 2022 08:10:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90AFBC06173B
        for <stable@vger.kernel.org>; Sun,  6 Feb 2022 05:10:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4CD6DB80E11
        for <stable@vger.kernel.org>; Sun,  6 Feb 2022 13:10:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB66BC340E9;
        Sun,  6 Feb 2022 13:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644153048;
        bh=svdmoRKuQU8b5SGzof9kPqai0FXMRoJjvii7s3XGoEg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HSzQCoKeE8BqLFK4jkJN15SPRR/wP6uMb67hz0lTgJTAT8A6Bo53IDbsXhqRPaO9j
         x4/Op1mNdBpOUr7DmCrjFWrZbaozsOlCuOJGOVYkvKguYfPKqYQ+WXx2gDLIblDRes
         5roBrNkJqMGkJIj5KnGdQhUdHrX7xU+ILV3hhM7o=
Date:   Sun, 6 Feb 2022 14:10:45 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     Helge Deller <deller@gmx.de>, geert@linux-m68k.org,
        svens@stackframe.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] Revert "fbcon: Disable accelerated
 scrolling"" failed to apply to 5.10-stable tree
Message-ID: <Yf/I1S+hXA8aJ3B5@kroah.com>
References: <1644066743887@kroah.com>
 <Yf7DsmnLOBa6BnzM@p100>
 <CAKMK7uFB--nvHStJLPLFMDh_+4+Xt6fSCQVt5YO29K2uReQ5Tw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uFB--nvHStJLPLFMDh_+4+Xt6fSCQVt5YO29K2uReQ5Tw@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 06, 2022 at 01:55:35PM +0100, Daniel Vetter wrote:
> On Sat, Feb 5, 2022 at 7:36 PM Helge Deller <deller@gmx.de> wrote:
> >
> > * gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>:
> > >
> > > The patch below does not apply to the 5.10-stable tree.
> > > If someone wants it applied there, or to any other stable or longterm
> > > tree, then please email the backport, including the original git commit
> > > id to <stable@vger.kernel.org>.
> >
> > Hello Greg,
> >
> > below is a rebased patch which you can use instead and which applies cleanly.
> > The attached patch below is a 100% "git revert 397971e1d891", with added
> > info to the commit message.
> >
> > After applying the patch below, the other failed patch:
> > "[PATCH] fbcon: Add option to enable legacy hardware acceleration"
> > doesn't fail to apply any longer either.
> >
> > Please make sure to apply BOTH patches (the one below and the other
> > failed one) or NONE of those two patches.
> >
> > Ideally, I'd suggest to wait until monday to get an Ack from Daniel for this.
> 
> Ack.

Both now queued up, thanks.

greg k-h
