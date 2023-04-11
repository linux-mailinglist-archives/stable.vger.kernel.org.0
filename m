Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5961E6DDD63
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 16:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbjDKON2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 10:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjDKON1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 10:13:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39740B1
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 07:13:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C946D61E59
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 14:13:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC7B4C4339C;
        Tue, 11 Apr 2023 14:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681222404;
        bh=5EE0uLPpYKgJEBoeXQYO9p1OLylcYX71lDn8imw30nI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yv2shrpEkLY8naBI/a+qyCe+9/ebF9Qo7YQgxejGQatMpvpm2ka106LF/MPPGCnWN
         3r363L/lXd68HyUPjK8Xx3ZpAmpA107OQnj5mgTKzycz4u+t8033r/fDMAs8ZzYJzc
         OjtIJRXjOQX2EFG8Rq/c+1JR/bWUE6nIN3jZ1PT4=
Date:   Tue, 11 Apr 2023 16:13:21 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Amit Pundir <amit.pundir@linaro.org>
Cc:     Stable <stable@vger.kernel.org>,
        Robert Foss <robert.foss@linaro.org>
Subject: Re: [PATCH for-5.10+] drm/bridge: lt9611: Fix PLL being unable to
 lock
Message-ID: <2023041111-purveyor-epidermis-87b3@gregkh>
References: <20230405092052.3843974-1-amit.pundir@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405092052.3843974-1-amit.pundir@linaro.org>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 05, 2023 at 02:50:52PM +0530, Amit Pundir wrote:
> From: Robert Foss <robert.foss@linaro.org>
> 
> [ Upstream commit 2a9df204be0bbb896e087f00b9ee3fc559d5a608 ]
> 
> This fixes PLL being unable to lock, and is derived from an equivalent
> downstream commit.
> 
> Available LT9611 documentation does not list this register, neither does
> LT9611UXC (which is a different chip).
> 
> This commit has been confirmed to fix HDMI output on DragonBoard 845c.
> 
> Suggested-by: Amit Pundir <amit.pundir@linaro.org>
> Reviewed-by: Amit Pundir <amit.pundir@linaro.org>
> Signed-off-by: Robert Foss <robert.foss@linaro.org>
> Link: https://patchwork.freedesktop.org/patch/msgid/20221213150304.4189760-1-robert.foss@linaro.org
> Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
> ---
> 
> To be cherry-picked on v5.10.y, v5.15.y and v6.1.y.

You forgot 6.2.y, added there too...
