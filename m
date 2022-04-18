Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82D3E505A2F
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 16:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345045AbiDROmu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 10:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344777AbiDROmc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 10:42:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B3662FB
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 06:27:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9DE24B80EE2
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 13:27:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB402C385A1;
        Mon, 18 Apr 2022 13:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650288452;
        bh=nSLln0H9BVYg0AJBJU6glZPL3ZHDwOxE4pVNMJBWgP0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wkIHmJK1tFCbnKdN1T554kfm7k4UuTYQzGZLLsHnOB3zf5TSmy7v5Lpo0AKUXj0br
         O0OmZ8wEoKpA8Srnz6DhdilodtB5kCC4LeAiV9Ozx8mm4sTQ2ZQLPTcz3lY9s5EpKj
         MxQ7tIB0UA4B/Cc2v1gv9SKnSn8s4+WIWwZPsDgE=
Date:   Mon, 18 Apr 2022 15:06:19 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     asml.silence@gmail.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] io_uring: use right issue_flags for
 splice/tee" failed to apply to 5.17-stable tree
Message-ID: <Yl1iS7/yaWKLDktm@kroah.com>
References: <1650275686134226@kroah.com>
 <6bb25dbf-a25b-b35a-d6dd-bb5845084649@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bb25dbf-a25b-b35a-d6dd-bb5845084649@kernel.dk>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 18, 2022 at 06:43:13AM -0600, Jens Axboe wrote:
> On 4/18/22 3:54 AM, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.17-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here's this one, and the two others that failed to apply for
> 5.17-stable.

Thanks for these, now queued up.

greg k-h
