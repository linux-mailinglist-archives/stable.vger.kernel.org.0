Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA58667269
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 13:41:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbjALMlZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 07:41:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230300AbjALMkd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 07:40:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60AAE4C72F;
        Thu, 12 Jan 2023 04:40:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15D25B81E5E;
        Thu, 12 Jan 2023 12:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50DC2C433D2;
        Thu, 12 Jan 2023 12:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673527216;
        bh=1vTTKC4pZ83wrwuLF4kJycHMKLoz5qbUojG35EY4I0c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=En94d+OtKsnA6juqQBdQ2E8GT3xvBl0s9Wl1lzL22bc89mY68Ld1YDmZjXVr45nec
         kw4ZT0cZ7WYG0ejGx1rT8lDIT07tBaUC9CZRJPgX9+y849uKcN6l5Fkc4SxFo99bW8
         COQGkW7F0T2POvlg5cN6sTcqJcLRs1MGGfZuTyRQ=
Date:   Thu, 12 Jan 2023 13:40:13 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     stable@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 5.10 0/2] Selected ext4 fast-commit fixes for 5.10-stable
Message-ID: <Y7//re91/JKP0Fdx@kroah.com>
References: <20230107203713.158042-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230107203713.158042-1-ebiggers@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 07, 2023 at 12:37:11PM -0800, Eric Biggers wrote:
> The recent ext4 fast-commit fixes with 'Cc stable' didn't apply to 5.10
> due to conflicts.  Since the fast-commit support in 5.10 is rudimentary
> and hard to backport fixes too, this series backports the two most
> important fixes only.  Please apply to 5.10-stable.
> 
> Eric Biggers (2):
>   ext4: disable fast-commit of encrypted dir operations
>   ext4: don't set up encryption key during jbd2 transaction
> 
>  fs/ext4/ext4.h              |  4 ++--
>  fs/ext4/fast_commit.c       | 42 +++++++++++++++++++++--------------
>  fs/ext4/fast_commit.h       |  1 +
>  fs/ext4/namei.c             | 44 ++++++++++++++++++++-----------------
>  include/trace/events/ext4.h |  7 ++++--
>  5 files changed, 57 insertions(+), 41 deletions(-)
> 
> -- 
> 2.39.0
> 

All now queued up, thanks.

greg k-h
