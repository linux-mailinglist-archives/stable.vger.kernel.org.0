Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1C5563DCA7
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:06:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbiK3SGD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:06:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbiK3SGB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:06:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F8CC7062A
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:06:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BEEEDB81C96
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:05:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19D8FC433C1;
        Wed, 30 Nov 2022 18:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669831558;
        bh=K2KNQZgUaf+gUVPOLihuN19hKk9agd0YOcEm1VGArzk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=x/EAo3b6c6Jd7O3+W0eb/BBMM0uKG+zKZNfOzOKGERdOxVQ2ERUKJKyV696Xuro/H
         gWIp41aRPIzNcPID7acP2EFhvqvP+B9/2Kt+jOmYGhKwW93uwx8f+FUMT7AJPxEq3q
         iXwS3HSaBop6l89DoBQQWJPLANGyf41cqNWpQpuU=
Date:   Wed, 30 Nov 2022 19:05:55 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     andrzej.hajda@intel.com, chris.p.wilson@intel.com,
        daniel.vetter@ffwll.ch, torvalds@linux-foundation.org
Cc:     stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] drm/i915: fix TLB invalidation for Gen12
 video and compute" failed to apply to 5.15-stable tree
Message-ID: <Y4ebgwSCQPeCPtFY@kroah.com>
References: <1669831197124193@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1669831197124193@kroah.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 30, 2022 at 06:59:57PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.15-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> Possible dependencies:
> 
> 04aa64375f48 ("drm/i915: fix TLB invalidation for Gen12 video and compute engines")
> 33da97894758 ("drm/i915/gt: Serialize TLB invalidates with GT resets")
> 7938d61591d3 ("drm/i915: Flush TLBs before releasing backing store")
> 1176d15f0f6e ("Merge tag 'drm-intel-gt-next-2021-10-08' of git://anongit.freedesktop.org/drm/drm-intel into drm-next")
> 

Ah, wait, I found the tarball you sent for these, and have taken them
for 5.4, 5.10, and 5.15 now (the original broke the build.)  We still
need them for older kernels though, that's still an issue.

thanks,

greg k-h
