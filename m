Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8015A93E9
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 12:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbiIAKKE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 06:10:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232851AbiIAKJ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 06:09:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 851066363
        for <stable@vger.kernel.org>; Thu,  1 Sep 2022 03:09:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20A8D61BEC
        for <stable@vger.kernel.org>; Thu,  1 Sep 2022 10:09:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22D70C433D6;
        Thu,  1 Sep 2022 10:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662026996;
        bh=SCp6tArwaBH0EykUvI/GP1ia2eG8yVvFaWS3TK2pNYg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sDkFlZtwmvFJl6mfiLMKZysxSY/qe1syk6nx+alU4dg/AKrkNWDsZEH2qJCzNZ2Ue
         yECjjPuI5vqTIhEpf0nsT9n0Oih/SNunOPKUgwaMk1SF58dJm1FLhlteIXJ0N7pdLl
         t+cRzW+M0tLk+oDvbwSCdVZtLVD1wDVTwd4xZn4E=
Date:   Thu, 1 Sep 2022 12:08:53 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH stable-5.15 00/13] io_uring pollfree
Message-ID: <YxCEtV1VhdpVkKl2@kroah.com>
References: <cover.1661594698.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1661594698.git.asml.silence@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 29, 2022 at 02:30:11PM +0100, Pavel Begunkov wrote:
> 5.15 backport of io_uring pollfree patches.
> 
> Jens Axboe (2):
>   io_uring: remove poll entry from list when canceling all
>   io_uring: bump poll refs to full 31-bits
> 
> Jiapeng Chong (1):
>   io_uring: Remove unused function req_ref_put
> 
> Pavel Begunkov (10):
>   io_uring: correct fill events helpers types
>   io_uring: clean cqe filling functions
>   io_uring: refactor poll update
>   io_uring: move common poll bits
>   io_uring: kill poll linking optimisation
>   io_uring: inline io_poll_complete
>   io_uring: poll rework
>   io_uring: fail links when poll fails
>   io_uring: fix wrong arm_poll error handling
>   io_uring: fix UAF due to missing POLLFREE handling
> 
>  fs/io_uring.c | 746 +++++++++++++++++++++++---------------------------
>  1 file changed, 347 insertions(+), 399 deletions(-)
> 
> -- 
> 2.37.2
> 

All now queued up, thanks.

greg k-h
