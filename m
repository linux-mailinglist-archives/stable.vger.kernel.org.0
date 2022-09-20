Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D313F5BEC28
	for <lists+stable@lfdr.de>; Tue, 20 Sep 2022 19:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbiITRlL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 13:41:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbiITRlK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 13:41:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1C505757A;
        Tue, 20 Sep 2022 10:41:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50ACC62BC7;
        Tue, 20 Sep 2022 17:41:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B840C433D6;
        Tue, 20 Sep 2022 17:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663695668;
        bh=BxVpknZK9EdHmqlMiQ8woqQonSpD76mWH1B1NrVfkjQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hoX0y+SR9C12C/FOhr9fUVZHwHxXrJUSN8fwNjeO093tQopvqgMuwpXQRwvzwIary
         cFhqfe/rVy2ltJ5ZAjS49GGysVFcAKHfXgKg3hhhhT0Cm+mH5qXWhr9BApFgnF0T1K
         vJ4KHz7GrY9jZ5msD6hgiJVXGJme9yJs1cx7Lk38=
Date:   Tue, 20 Sep 2022 19:41:06 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     wangyong <yongw.pur@gmail.com>
Cc:     jaewon31.kim@samsung.com, linux-kernel@vger.kernel.org,
        mhocko@kernel.org, stable@vger.kernel.org, wang.yong12@zte.com.cn
Subject: Re: [PATCH stable-4.19 0/3] page_alloc: consider highatomic reserve
 in watermark fast backports to 4.19
Message-ID: <Yyn7MoSmV43Gxog4@kroah.com>
References: <YyREk5hHs2F0eWiE@kroah.com>
 <1663347949-20389-1-git-send-email-wang.yong12@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1663347949-20389-1-git-send-email-wang.yong12@zte.com.cn>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 16, 2022 at 10:05:46AM -0700, wangyong wrote:
> Here are the corresponding backports to 4.19.
> And fix classzone_idx context differences causing patch merge conflicts.
> 
> Jaewon Kim (2):
>   page_alloc: consider highatomic reserve in watermark fast
>   page_alloc: fix invalid watermark check on a negative value
> 
> Joonsoo Kim (1):
>   mm/page_alloc: use ac->high_zoneidx for classzone_idx
> 
>  mm/internal.h   |  2 +-
>  mm/page_alloc.c | 69 +++++++++++++++++++++++++++++++++------------------------
>  2 files changed, 41 insertions(+), 30 deletions(-)
> 
> -- 
> 2.7.4
> 

What are the git commit ids of these commits?  That needs to be in the
commit changelog.

Also you did not sign off on the backports, please fix that up when you
resend this series.

thanks,

greg k-h
