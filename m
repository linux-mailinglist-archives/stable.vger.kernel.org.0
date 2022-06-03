Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 527C953CAB0
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 15:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244583AbiFCNba (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 09:31:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240806AbiFCNba (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 09:31:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B31D26544
        for <stable@vger.kernel.org>; Fri,  3 Jun 2022 06:31:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9051616F2
        for <stable@vger.kernel.org>; Fri,  3 Jun 2022 13:31:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F31F9C385A9;
        Fri,  3 Jun 2022 13:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654263088;
        bh=CnF8OFikT7FVkfbeolAaBWC4OffU3VR9zWqjbLaRS3U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HmcdD5/rZ75Q/HjEUJX7iTwcDe8wfPW+2SsykQGT/BBDMIN+VhVydd/S410pBDt3/
         fruMVfhNcQfkMfrMXEwkyJX563hE76TNOep/wKWgwRQINRGUGaJ4WbGCLMFEIXWC7I
         294r71KW1htNG2aAYLwSWlty9e9po9cwyuYS/2t8=
Date:   Fri, 3 Jun 2022 15:31:25 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/2] io_uring iter_revert issues
Message-ID: <YpoNLTxKFGbyZcnr@kroah.com>
References: <cover.1654258554.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1654258554.git.asml.silence@gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 03, 2022 at 01:17:03PM +0100, Pavel Begunkov wrote:
> 5.10 fixup for 89c2b3b7491820 ("io_uring: reexpand under-reexpanded iters").
> We can't just directly cherry-pick them as the code base is quite different,
> so we also need patch 1/2. Previous attempts to backport 2/2 directly
> were pulling in too many dependencies only adding more problems.
> 
> Pavel Begunkov (2):
>   io_uring: don't re-import iovecs from callbacks
>   io_uring: fix using under-expanded iters
> 
>  fs/io_uring.c | 47 ++++++-----------------------------------------
>  1 file changed, 6 insertions(+), 41 deletions(-)
> 
> -- 
> 2.36.1
> 

All now queued up, thanks.

greg k-h
