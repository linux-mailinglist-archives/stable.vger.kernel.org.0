Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65A795E9239
	for <lists+stable@lfdr.de>; Sun, 25 Sep 2022 13:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbiIYLA5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Sep 2022 07:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbiIYLA4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 25 Sep 2022 07:00:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B4A13137C;
        Sun, 25 Sep 2022 04:00:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0AD4DB8101B;
        Sun, 25 Sep 2022 11:00:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42331C433C1;
        Sun, 25 Sep 2022 11:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664103652;
        bh=Yfe0qoHburx2QsggZnRv2F3jtxrdv7EAgwg7pMzvbfA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cR3jqIT0OHmGHNnWY5YOTQCJCGDzG3BMXwfQsvJ+T4xtT7NmDbfm4RaWq++75C+fR
         Q8fPWhPnYBpTcx5KalN11+aEqKOssqyTINoKSwpvJAiWzgAIZlOdXMp+krY/EN8KMK
         HGD+BjjhuRt2Cg3Fp8L8+W4KNoWNt4mvNeq+p37Q=
Date:   Sun, 25 Sep 2022 13:00:49 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     wangyong <yongw.pur@gmail.com>
Cc:     jaewon31.kim@samsung.com, linux-kernel@vger.kernel.org,
        mhocko@kernel.org, stable@vger.kernel.org, wang.yong12@zte.com.cn,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan@kernel.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2 stable-4.19 1/3] mm/page_alloc: use ac->high_zoneidx
 for classzone_idx
Message-ID: <YzA04ZZI/1OH8oRT@kroah.com>
References: <Yyn7MoSmV43Gxog4@kroah.com>
 <20220925103529.13716-1-yongw.pur@gmail.com>
 <20220925103529.13716-2-yongw.pur@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220925103529.13716-2-yongw.pur@gmail.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Sep 25, 2022 at 03:35:27AM -0700, wangyong wrote:
> From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> 
> [ backport of commit 3334a45eb9e2bb040c880ef65e1d72357a0a008b ]

This is from 5.8.  What about the 5.4.y kernel?  Why would someone
upgrading from 4.19.y to 5.4.y suffer a regression here?

And why wouldn't someone who has this issue just not use 5.10.y instead?
What prevents someone from moving off of 4.19.y at this point in time?

thanks,

greg k-h
