Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE7876ADA65
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 10:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbjCGJbV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 04:31:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbjCGJbR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 04:31:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01FE950982
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 01:31:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2C7EB816AC
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:31:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05031C433EF;
        Tue,  7 Mar 2023 09:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678181465;
        bh=+c6iSvmWDnCSBLFJZPHypRN6Ze3xqj53zOSKeH88eDE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b/VK2gc80Xw8qZxBSsuNr5x8+COTVmk/HPB/NMHixreevoOrYzMq87YtD9f+zAtPS
         0r0P0UNTxlIz2gw5ePfe3/pmqZhLMedWrGsTe1ZzjK1fB29yA1AKqROjqutJ7eQUvm
         EENQhEDzX/G9OQ0DaqGRG6GeJX5E4BEZfg3GhWEw=
Date:   Tue, 7 Mar 2023 10:30:36 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] io_uring: handle TIF_NOTIFY_RESUME when
 checking for" failed to apply to 5.15-stable tree
Message-ID: <ZAcEPNQ88yw2akou@kroah.com>
References: <16780996985892@kroah.com>
 <1515f12c-fe81-b9c4-5d64-5f2b51be5466@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1515f12c-fe81-b9c4-5d64-5f2b51be5466@kernel.dk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 06, 2023 at 02:29:47PM -0700, Jens Axboe wrote:
> On 3/6/23 3:48?AM, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.15-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Greg, here are the patches that failed in 5.10/5.15 stable, plus one
> extra that is in mainline that fixes a bug in one of the ones marked for
> backporting.
> 
> This series will apply both to 5.10-stable and 5.15-stable, and I ran
> the usual regression tests on both. Please add these to both, thanks!

All now queued up, thanks.

greg k-h
