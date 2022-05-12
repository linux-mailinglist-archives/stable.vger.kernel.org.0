Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1244525275
	for <lists+stable@lfdr.de>; Thu, 12 May 2022 18:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356443AbiELQXt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 May 2022 12:23:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356435AbiELQXs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 May 2022 12:23:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C80D01EE0B7
        for <stable@vger.kernel.org>; Thu, 12 May 2022 09:23:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A35EB82910
        for <stable@vger.kernel.org>; Thu, 12 May 2022 16:23:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2327AC385B8;
        Thu, 12 May 2022 16:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652372625;
        bh=N/M747+r/CA0amjpS6gshcI9F5RbqJl7rtN7DBtRoEg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sD9QPtUniWGTglMIXCtf6GCBnHLNeTbsghWslwEEEOz0wyinYfkntUhqVCVGWslqU
         yXhYjuNhc0XJn2yXcJA5WEGn1rQA5KIT56LNRog+ONRYfLQzNUa4YDhnK8HUD3YijD
         58iHTDTHme/Uh9N8Oxl/+P5D6bAO5AZQ+obYm8y8=
Date:   Thu, 12 May 2022 18:23:41 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Meena Shanmugam <meenashanmugam@google.com>
Cc:     stable@vger.kernel.org, trond.myklebust@hammerspace.com
Subject: Re: Request to cherry-pick f00432063db1 to 5.10
Message-ID: <Yn00jd+uX8PVZv/9@kroah.com>
References: <CAMdnWFC4+-mEubOVkzaoqC5jnJCwY5hpcQtDnkmgqJ-mY5_GYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMdnWFC4+-mEubOVkzaoqC5jnJCwY5hpcQtDnkmgqJ-mY5_GYg@mail.gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 10, 2022 at 07:33:23PM -0700, Meena Shanmugam wrote:
> Hi all,
> 
> The commit f00432063db1a0db484e85193eccc6845435b80e upstream (SUNRPC:
> Ensure we flush any closed sockets before xs_xprt_free()) fixes
> CVE-2022-28893, hence good candidate for stable trees.
> The above commit depends on 3be232f(SUNRPC: Prevent immediate
> close+reconnect)  and  89f4249(SUNRPC: Don't call connect() more than
> once on a TCP socket). Commit 3be232f depends on commit
> e26d9972720e(SUNRPC: Clean up scheduling of autoclose).
> 
> Commits e26d9972720e, 3be232f, f00432063db1 apply cleanly on 5.10
> kernel. commit 89f4249 didn't apply cleanly. I have patch for 89f4249
> below.

We also need this for 5.15.y first, before we can apply it to 5.10.y.
Can you provide a working backport for that tree as well?

And as others pointed out, your patch is totally corrupted and can not
be used, please fix your email client.

thanks,

greg k-h
