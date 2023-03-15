Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 006036BA8F5
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 08:23:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231324AbjCOHXT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 03:23:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231340AbjCOHXE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 03:23:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 279D76EB4
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 00:23:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C369615ED
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 07:23:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D6A6C433D2;
        Wed, 15 Mar 2023 07:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678864982;
        bh=yTH5tg3xf72taHqmMoHU+RMO9nfQ6YLNazeUr/2jb7k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FeQ2iGBsraQL7nnLKN3sY4ZLR9mi2nnSOwo0bsmGIVKaOzyHBfOqdSB9ZxRElx3/Z
         WvDmkJOpgodq/T8MkPd8aQOqM3tHfxDy9cx69/w/upGsIl80goDwv2A195hvJyIUSU
         7PJKznvJiGAQ3v/RigReOpB6nSwID+UL08PTM1wU=
Date:   Wed, 15 Mar 2023 08:22:58 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Corey Minyard <minyard@acm.org>
Cc:     stable@vger.kernel.org
Subject: Re: Please apply db05ddf7f32 to 5.4.x and 5.10.x
Message-ID: <ZBFyUnq8RZcGTnLK@kroah.com>
References: <ZBC3hOAa/4vzTLTV@minyard.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBC3hOAa/4vzTLTV@minyard.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 14, 2023 at 01:05:56PM -0500, Corey Minyard wrote:
> Please apply:
> 
> db05ddf7f32 ("ipmi:watchdog: Set panic count to proper value on a panic to stable kernel")
> 
> to the stable branches from 5.4.x to 5.10.x.
> 
> It requires as a pre-requisite:
> 
> a01a89b1db ("ipmi/watchdog: replace atomic_add() and atomic_sub()")
> 
> This change went in to 5.16 and a backport war requested and put into
> 5.15.  It was missed in the earlier kernels; it didn't apply because
> the prerequisite was missed.  It fixes a lockup at panic time.  I think
> distros have picked it up, but I had a user report this.

Now queued up, thanks.

greg k-h
