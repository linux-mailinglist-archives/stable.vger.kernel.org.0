Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3C8F54E81F
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 18:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231732AbiFPQwN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 12:52:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233189AbiFPQwM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 12:52:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A6C0C54
        for <stable@vger.kernel.org>; Thu, 16 Jun 2022 09:52:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA69F618DC
        for <stable@vger.kernel.org>; Thu, 16 Jun 2022 16:52:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D988EC34114;
        Thu, 16 Jun 2022 16:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655398331;
        bh=Lz2SmAwvkt8PxsmGKPNe+yUGMvgiSxX2C1f1j51T6dM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=etipc5thlCq8jHf0RXiwocj1CWUj4p2ySpmaAokuvm2IoXlnMHNDgkBsaxotcvhnt
         dcXqDmO890TLMVWi1TYnbV8sQAkr9FzFtwiB1SFWY/DD1DwDbPXXrNeWg1MUZ/F0ZY
         Fr+0XdMD2BE0lcy/a1a7jnTZVIy4CD/7hSmbWFho=
Date:   Thu, 16 Jun 2022 18:52:08 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] io_uring: reinstate the inflight
 tracking" failed to apply to 5.18-stable tree
Message-ID: <YqtfuFZUz2Si66pN@kroah.com>
References: <1655384994105244@kroah.com>
 <7a0b40ae-4b1a-a512-1fdc-abfd8ffc56e8@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a0b40ae-4b1a-a512-1fdc-abfd8ffc56e8@kernel.dk>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 16, 2022 at 09:39:43AM -0600, Jens Axboe wrote:
> On 6/16/22 7:09 AM, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.18-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here's the stable backport, thanks.
> 

Now queued up, thanks.

greg k-h
