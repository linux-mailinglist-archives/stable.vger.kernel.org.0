Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAE9A66C2FE
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:58:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232855AbjAPO6R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:58:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbjAPO56 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:57:58 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD0BD298F7
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 06:47:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 42A95CE1095
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 14:47:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A561C433F2;
        Mon, 16 Jan 2023 14:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673880446;
        bh=ivs9jWEwDcCXPKY+X5VDNqMrmDN+BOWenEU+Aw5JDpg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N+ozI1ujy2vuxRKu73bOYq87EHrjCYdyE2i60p2AwACUnwI7LcQwTLPjzp3u9dCoM
         ijZEgm9bMbHTB8HS70lh4yDmiSIxmSgEEYVyOMDGp42lLfdKL/f7XQ7Nm/kO1/v7cR
         +6XS5iL6Ig/A2e3Qxo4rKcpc2Gtz1GlI8KYdQcXo=
Date:   Mon, 16 Jan 2023 15:47:24 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     asml.silence@gmail.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] io_uring: lock overflowing for IOPOLL"
 failed to apply to 5.15-stable tree
Message-ID: <Y8VjfOb5V9+sFiOL@kroah.com>
References: <1673689917176116@kroah.com>
 <f7ffd01f-71f2-6bfc-daf7-e149be9bf836@kernel.dk>
 <530fedb3-e8f4-46a0-faab-8435d313ad87@kernel.dk>
 <3a32e477-4170-07e7-94fc-384d8e86a7d7@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a32e477-4170-07e7-94fc-384d8e86a7d7@kernel.dk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 14, 2023 at 09:48:34AM -0700, Jens Axboe wrote:
> On 1/14/23 9:21?AM, Jens Axboe wrote:
> > On 1/14/23 9:15?AM, Jens Axboe wrote:
> >> On 1/14/23 2:51?AM, gregkh@linuxfoundation.org wrote:
> >>>
> >>> The patch below does not apply to the 5.15-stable tree.
> >>> If someone wants it applied there, or to any other stable or longterm
> >>> tree, then please email the backport, including the original git commit
> >>> id to <stable@vger.kernel.org>.
> >>
> >> This has to be done a bit differently, but this one should work. I tested
> >> it on 5.10-stable, but should apply to 5.15-stable as well as they are
> >> the same base now.
> > 
> > Oops, missed accounting for overflow. Please use this one instead! Sorry
> > about that.
> 
> Not batting 1000 on this one today. Wrote a test case for this
> specifically now and verified it, this one is good. For real.

Looks like Sasha grabbed all of these already, thanks for the backports!

greg k-h
