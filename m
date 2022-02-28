Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FBE24C6919
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 11:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235473AbiB1K6x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 05:58:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235477AbiB1K6s (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 05:58:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D23661BEA2
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 02:55:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65A9BB80FD3
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 10:55:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A87B2C340EE;
        Mon, 28 Feb 2022 10:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646045753;
        bh=z7ysCiLXhrS2WEzeDfaXg7LZqNAbhZDb/cLFf8hhZ68=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RSFPgBa9sMx6mEcHkCps9VW6ctrcIBr1grXUtD9oOSgJG9IRDJj0aymtanZEtCQ4V
         Gq/HESptN+mB1A7ysH7bxFIChBUTqxdlUP7FYQmIElUl4N4iFabwPXPMIPqodblwbX
         kJMwwYpgEw9NQSUvq3e6ickobDe7WeYnDZkOidM8=
Date:   Mon, 28 Feb 2022 11:55:50 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mike Rapoport <rppt@linux.ibm.com>
Cc:     linmiaohe@huawei.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] memblock: use kfree() to release
 kmalloced memblock regions" failed to apply to 5.15-stable tree
Message-ID: <YhyqNv3PgdY6T5Ip@kroah.com>
References: <1646038723220154@kroah.com>
 <YhyXGAK9Se/ohdh9@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YhyXGAK9Se/ohdh9@linux.ibm.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 28, 2022 at 11:34:16AM +0200, Mike Rapoport wrote:
> On Mon, Feb 28, 2022 at 09:58:43AM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.15-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> This version applies to 5.15 and should apply to older version as well.
> 
> >From d4895990ebea634715d2dcf54121c5ae5a6612bc Mon Sep 17 00:00:00 2001
> From: Miaohe Lin <linmiaohe@huawei.com>
> Date: Thu, 17 Feb 2022 22:53:27 +0800
> Subject: [PATCH] memblock: use kfree() to release kmalloced memblock regions
> 
> memblock.{reserved,memory}.regions may be allocated using kmalloc() in
> memblock_double_array(). Use kfree() to release these kmalloced regions
> indicated by memblock_{reserved,memory}_in_slab.
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> Fixes: 3010f876500f ("mm: discard memblock data later")
> Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> ---
>  mm/memblock.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)

Now queued up, thanks.

greg k-h
