Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BCD25F23E5
	for <lists+stable@lfdr.de>; Sun,  2 Oct 2022 17:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbiJBPgk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Oct 2022 11:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiJBPgj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Oct 2022 11:36:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB803F1FB;
        Sun,  2 Oct 2022 08:36:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B73B660EF1;
        Sun,  2 Oct 2022 15:36:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E148C433D6;
        Sun,  2 Oct 2022 15:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664724998;
        bh=s3EZOedlsCwkol5iNEutg98MEWtEMLEZ3vX2KyBD9XU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sNUpq/nFkqHTbQ8wl9lzsleFvrfIfpNEDB/3eCxIWdF3ZwLzNqjy0UTtvDvv3e2Zq
         0PtbGhBAp1TzknZdAQaLRIxmJdVTz9sq2RGte4IFZnN01enF5fUD1TfHy3cKmRHojW
         UzdRqvuaohnxF+pRqA4T9Ci2QbtPQWlUstdWsTJY=
Date:   Sun, 2 Oct 2022 17:37:15 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     wangyong <yongw.pur@gmail.com>
Cc:     jaewon31.kim@samsung.com, linux-kernel@vger.kernel.org,
        mhocko@kernel.org, stable@vger.kernel.org, wang.yong12@zte.com.cn
Subject: Re: [PATCH v2 stable-4.19 0/3] page_alloc: consider highatomic
 reserve in watermark fast backports to 4.19
Message-ID: <YzmwKxYVDSWsaPCU@kroah.com>
References: <Yyn7MoSmV43Gxog4@kroah.com>
 <20220925103529.13716-1-yongw.pur@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220925103529.13716-1-yongw.pur@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Sep 25, 2022 at 03:35:26AM -0700, wangyong wrote:
> Here are the corresponding backports to 4.19.
> And fix classzone_idx context differences causing patch merge conflicts.
> 
> Original commit IDS:
> 	3334a45 mm/page_alloc: use ac->high_zoneidx for classzone_idx
> 	f27ce0e page_alloc: consider highatomic reserve in watermark fast
> 	9282012 page_alloc: fix invalid watermark check on a negative value
> 
> Changes from v1:
> - Add commit information of the original patches.

None of these have your signed-off-by on them showing that the backport
came from you and that you are responsible for them.

So even if we did think they were valid to backport, I can't take them
as-is :(

thanks,

greg k-h
