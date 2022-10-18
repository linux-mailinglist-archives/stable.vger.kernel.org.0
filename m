Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9236023AA
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 07:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbiJRFPb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Oct 2022 01:15:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbiJRFPa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Oct 2022 01:15:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F1BE92F40
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 22:15:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3591D6144F
        for <stable@vger.kernel.org>; Tue, 18 Oct 2022 05:15:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5D9CC433D6;
        Tue, 18 Oct 2022 05:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666070127;
        bh=wazBatLNAoqQ55loXMBj+EGzJDnADkJLwxKlffnoduo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JT5DQu/mr738VqmSAW7dBjEMy1HNHAN85R/vj6oMHd5ozswx0msREuZe/xI/o3Hwh
         RG/1BnlpJlBzI628MoiZSIxQNcASQk6IwwrpVWT7f2rKlHVUm7S9tjtYGFSAV7dUL2
         auJjnJNn1dYYeHnt9Me+CDDllqM9dBg9pP96vTXs=
Date:   Tue, 18 Oct 2022 07:16:14 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     samitolvanen@google.com, tpgxyz@gmail.com, tzimmermann@suse.de,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] drm/simpledrm: Fix return type of" failed
 to apply to 6.0-stable tree
Message-ID: <Y042nnfd2rrfdjQB@kroah.com>
References: <166593672329153@kroah.com>
 <Y02acmLNms9UygZL@dev-arch.thelio-3990X>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y02acmLNms9UygZL@dev-arch.thelio-3990X>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 17, 2022 at 11:09:54AM -0700, Nathan Chancellor wrote:
> On Sun, Oct 16, 2022 at 06:12:03PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 6.0-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > Possible dependencies:
> > 
> > f9929f69de94 ("drm/simpledrm: Fix return type of simpledrm_simple_display_pipe_mode_valid()")
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > ------------------ original commit in Linus's tree ------------------
> > 
> > From f9929f69de94212f98b3ad72a3e81c3bd3d333e0 Mon Sep 17 00:00:00 2001
> > From: Nathan Chancellor <nathan@kernel.org>
> > Date: Mon, 25 Jul 2022 16:36:29 -0700
> > Subject: [PATCH] drm/simpledrm: Fix return type of
> >  simpledrm_simple_display_pipe_mode_valid()
> 
> Just for the record, this change is already in the stable trees it is
> relevant for, as it was a part of 5.19:
> 
> 5.19 and 6.0: 0c09bc33aa8e ("drm/simpledrm: Fix return type of simpledrm_simple_display_pipe_mode_valid()")
> 5.15: 11c1cc3f6e42 ("drm/simpledrm: Fix return type of simpledrm_simple_display_pipe_mode_valid()")
> 
> I am not sure how a second copy (f9929f69de94) ended up in the tree
> during the 6.1 cycle, I am guessing it was cherry picked to a
> development branch from a fixes branch, rather than backmerged.
> 
> TL;DR: Nothing for stable to do here.

Thanks, that's how the drm tree works, they like to have multiple copies
of patches in the tree in places...

thanks,

greg k-h
