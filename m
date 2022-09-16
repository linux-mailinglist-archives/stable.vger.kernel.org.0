Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9040B5BA997
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 11:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbiIPJkP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 05:40:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbiIPJkO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 05:40:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 505452B180;
        Fri, 16 Sep 2022 02:40:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9024B824A5;
        Fri, 16 Sep 2022 09:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB66AC433C1;
        Fri, 16 Sep 2022 09:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663321210;
        bh=2y4F6kzQUAcWpEfeqLTDlB64eEYL2UprKkZnwQeKe9M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Kcj0Zu3DidA+9p4PnsSZDGImuLlMU5q01pPxtq/bpQkciTy08gfIPHGPJSm8hD4oM
         BDhR0uC9nt98T5Ws5LyEAQvgwW/fRMVwj8bRgzzl9FZTMQ+40FxlW5tZBQUWGbmj3a
         2VgXnHCcVI/fjhm1VDnJ9Y6Jh/f892wdOFFMXXsU=
Date:   Fri, 16 Sep 2022 11:40:35 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     yong w <yongw.pur@gmail.com>
Cc:     jaewon31.kim@samsung.com, mhocko@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        wang.yong12@zte.com.cn
Subject: Re: [PATCH v4] page_alloc: consider highatomic reserve in watermark
 fast
Message-ID: <YyREk5hHs2F0eWiE@kroah.com>
References: <ab879545-d4b2-0cd8-3ae2-65f9f2baf2fe@gmail.com>
 <YyCLm0ws8qsiEcaJ@kroah.com>
 <CAOH5QeAUGBshLQdRCWLg9-Q3JvrqROLYW6uWr8a4TBKxwAOPaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOH5QeAUGBshLQdRCWLg9-Q3JvrqROLYW6uWr8a4TBKxwAOPaw@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 14, 2022 at 08:46:15AM +0800, yong w wrote:
> Greg KH <gregkh@linuxfoundation.org> 于2022年9月13日周二 21:54写道：
> 
> >
> > On Tue, Sep 13, 2022 at 09:09:47PM +0800, yong wrote:
> > > Hello,
> > > This patch is required to be patched in linux-5.4.y and linux-4.19.y.
> >
> > What is "this patch"?  There is no context here :(
> >
> Sorry, I forgot to quote the original patch. the patch is as follows
> 
>     f27ce0e page_alloc: consider highatomic reserve in watermark fast
> 
> > > In addition to that, the following two patches are somewhat related:
> > >
> > >       3334a45 mm/page_alloc: use ac->high_zoneidx for classzone_idx
> > >       9282012 page_alloc: fix invalid watermark check on a negative value
> >
> > In what way?  What should be done here by us?
> >
> 
> I think these two patches should also be merged.
> 
>     The classzone_idx  parameter is used in the zone_watermark_fast
> functionzone, and 3334a45 use ac->high_zoneidx for classzone_idx.
>     "9282012 page_alloc: fix invalid watermark check on a negative
> value"  fix f27ce0e introduced issues

Ok, I need an ack by all the developers involved in those commits, as
well as the subsystem maintainer so that I know it's ok to take them.

Can you provide a series of backported and tested patches so that they
are easy to review?

thanks,

greg k-h
