Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A12ED676DC6
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 15:46:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbjAVOqT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 09:46:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbjAVOqT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 09:46:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 766631C304
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 06:46:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30163B80AE6
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 14:46:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83A00C433EF;
        Sun, 22 Jan 2023 14:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674398775;
        bh=7jNB25dwWXxo7+vQMs2uaIpoKyKqh7yr4/8+S5hkcrQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L6+oOrAUotTSGlLH+v2hUlXTmgUt9ClMuaHeHjAwXrJGmCQdn3j8HGCXKo/sLN+8y
         57Q2AP0HUl2gZFs5uqiA+qHhfnjVnlEnUu3iyJtjPR48fkyc4vzq9+pPgpgv+qsCLV
         moZwPYcnL3R1gbYzymXkiU9kUrmJsjnjUyw+BJWE=
Date:   Sun, 22 Jan 2023 15:46:13 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     stable <stable@vger.kernel.org>
Subject: Re: Patches for 5.15-stable
Message-ID: <Y81MNeUGrntM0FKW@kroah.com>
References: <be4f98fe-2e66-f7df-5f59-acc2ed7cccdb@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <be4f98fe-2e66-f7df-5f59-acc2ed7cccdb@kernel.dk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 21, 2023 at 10:52:10AM -0700, Jens Axboe wrote:
> Hi,
> 
> Two parts here:
> 
> 1) The wakeup fix that went into 5.10-stable, but hadn't been done for
>    5.15-stable yet. It was the last 3 patches in the 5.10-stable backport
>    for io_uring
> 
> 2) Other patches that were marked for stable or should go to stable, but
>    initially failed.
> 
> This gets us to basically parity on the regression test front for 5.15,
> and have all been runtime tested.
> 
> Please queue up for the next 5.15-stable, thanks!

Note, some of the io_uring patches you sent for 5.10 and 5.15 have
commits in the tree that are marked as "fixing" these commits.  I tried
to backport them as well, but got a lot of failures, which is why you
got those emails.  If they are not relevant, please feel free to ignore,
but if they are needed, maybe we also need them as well?

thanks,

greg k-h
