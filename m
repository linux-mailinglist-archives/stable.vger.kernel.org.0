Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60B87601602
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 20:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbiJQSKC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 14:10:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiJQSKB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 14:10:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1646326112
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 11:09:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E275B81914
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 18:09:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB31BC433C1;
        Mon, 17 Oct 2022 18:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666030196;
        bh=Rbz5Z0PTX9MQLpx1StYwonaIVmkNls/JnKZSuVNHk5I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=siFHGQosE8UKI8en/Z6QiVXkgZwZrOUMBDCQfmZf8UbbxxHFLDfzWg0vxq/vrN1Ir
         SsUUXn67S7CxYNM30YfZtbQBLnzVGmHPAWevJUR1oVxe9+R0kD/OJ0FiO7MflSk/MM
         9bjnSyBNWA+CsaqtdV4nTGM+KTCTUwAFzcKYtiNVKksFK+6MOJOlqXJPqYhrb/IMfq
         NPhHKsf4TGkU4xvvNU6roHTCxgTgZNA8Kz+ex80oB+ZtfGRa/BB6JbChe2HqbwMPFU
         GGkAoO40wPAScU9T6rG9k9MqeeMJSKyrLMR6qnC1cYrZtkmBqrVQcVMfts5wa4oEpl
         EJlABP0sgxrjQ==
Date:   Mon, 17 Oct 2022 11:09:54 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     samitolvanen@google.com, tpgxyz@gmail.com, tzimmermann@suse.de,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] drm/simpledrm: Fix return type of" failed
 to apply to 6.0-stable tree
Message-ID: <Y02acmLNms9UygZL@dev-arch.thelio-3990X>
References: <166593672329153@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166593672329153@kroah.com>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Oct 16, 2022 at 06:12:03PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 6.0-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> Possible dependencies:
> 
> f9929f69de94 ("drm/simpledrm: Fix return type of simpledrm_simple_display_pipe_mode_valid()")
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From f9929f69de94212f98b3ad72a3e81c3bd3d333e0 Mon Sep 17 00:00:00 2001
> From: Nathan Chancellor <nathan@kernel.org>
> Date: Mon, 25 Jul 2022 16:36:29 -0700
> Subject: [PATCH] drm/simpledrm: Fix return type of
>  simpledrm_simple_display_pipe_mode_valid()

Just for the record, this change is already in the stable trees it is
relevant for, as it was a part of 5.19:

5.19 and 6.0: 0c09bc33aa8e ("drm/simpledrm: Fix return type of simpledrm_simple_display_pipe_mode_valid()")
5.15: 11c1cc3f6e42 ("drm/simpledrm: Fix return type of simpledrm_simple_display_pipe_mode_valid()")

I am not sure how a second copy (f9929f69de94) ended up in the tree
during the 6.1 cycle, I am guessing it was cherry picked to a
development branch from a fixes branch, rather than backmerged.

TL;DR: Nothing for stable to do here.

Cheers,
Nathan
