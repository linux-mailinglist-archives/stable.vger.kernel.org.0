Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 753A957989C
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 13:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbiGSLiI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 07:38:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233786AbiGSLiH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 07:38:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 880D840BC8
        for <stable@vger.kernel.org>; Tue, 19 Jul 2022 04:38:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E6E66153B
        for <stable@vger.kernel.org>; Tue, 19 Jul 2022 11:38:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E4E4C341C6;
        Tue, 19 Jul 2022 11:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658230685;
        bh=wZk9mLvNtWC1tQpPyDHk8Z5bIhYWa1Nbj+DLSF3mlwc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RRVd0ABBtiuzFOUgvDgJrWUz1h9pVkf6JH/y1nq6JRDU/Acqx0XeLZDn+2Yc319z+
         xBhkU4du4QJaMG7oBRJ+kiAPnq3Tsy1S88SaFeYYvGv0RBouzKM0qCXNGERuacnKu/
         wVwdNjjr0eHR8v23IaunL1D4P5qzOc+dVSxc44Io=
Date:   Tue, 19 Jul 2022 13:38:02 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     riel@surriel.com, akpm@linux-foundation.org, hannes@cmpxchg.org,
        jhubbard@nvidia.com, linmiaohe@huawei.com, mgorman@suse.de,
        naoya.horiguchi@nec.com, osalvador@suse.de, stable@vger.kernel.org,
        torvalds@linux-foundation.org, willy@infradead.org
Subject: Re: FAILED: patch "[PATCH] mm: invalidate hwpoison page cache page
 in fault path" failed to apply to 4.14-stable tree
Message-ID: <YtaXmmBij7KDjIN/@kroah.com>
References: <164882002824865@kroah.com>
 <Ys8nBq9dzw9gzVkw@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ys8nBq9dzw9gzVkw@debian>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 13, 2022 at 09:11:50PM +0100, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Fri, Apr 01, 2022 at 03:33:48PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.14-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport.

Both now queued up, thanks.

greg k-h
