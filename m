Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29C1F657568
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 11:41:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbiL1Kls (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 05:41:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiL1Klr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 05:41:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C9492B2;
        Wed, 28 Dec 2022 02:41:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06E38B81257;
        Wed, 28 Dec 2022 10:41:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 329EBC433EF;
        Wed, 28 Dec 2022 10:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672224103;
        bh=TH+zx9iaIvmfVub7LWioSsnVKuj8Sde3mb+0AlFZ5rg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hJIkYoX/5JEAOw1so00L1+3VvaKlTEvkOpla595uUM8zXT2omvWPitmW2s6KK9BkS
         LACGRZQRJheTtAEWqzv5AbtuQjIHlzvJ75rUQyqU5oIhKq3q5XykeS+6B2bMXakLFj
         M8Wwlec+gsnZwEsd7UD+POoFCN05ij+0oj6fHUcM=
Date:   Wed, 28 Dec 2022 11:41:40 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Diederik de Haas <didi.debian@cknow.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        LABBE Corentin <clabbe@baylibre.com>
Subject: Re: crypto-rockchip patches queued for 6.1
Message-ID: <Y6wdZHlnUIzzreTA@kroah.com>
References: <2236134.UumAgOJHRH@prancing-pony>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2236134.UumAgOJHRH@prancing-pony>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 28, 2022 at 11:37:16AM +0100, Diederik de Haas wrote:
> Hi,
> 
> I couldn't find an existing mail with "[PATCH AUTOSEL 6.1 N/M] XYZ" to reply 
> to, so I'm just sending an email like this. Hope that's ok.
> 
> In https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/
> tree/queue-6.1 there are a number of patches which start with:
> crypto-rockchip- like crypto-rockchip-add-fallback-for-ahash.patch
> 
> I guess they were (auto) selected as they contain a "Fixes: <commitid>" line. 
> Those 7 patches are actually part of a larger patch set, see here:
> https://lore.kernel.org/all/20220927075511.3147847-1-clabbe@baylibre.com/
> 
> All those patches have been merged into Linus' tree for 6.2 and there's a 
> hotfix planned to be submitted for 6.2 here:
> https://git.kernel.org/pub/scm/linux/kernel/git/mmind/linux-rockchip.git/
> commit/?h=v6.2-armsoc/dtsfixes&id=53e8e1e6e9c1653095211a8edf17912f2374bb03
> 
> Wouldn't it make more sense to queue the whole patch set for 6.1?
> Or (at least) the whole crypto rockchip part as mentioned here:
> https://lore.kernel.org/all/Y5mGGrBJaDL6mnQJ@gondor.apana.org.au/ 
> under the "Corentin Labbe (32):" label?

Please provide us a list of the specific git commits and in the order in
which you wish to see them applied and we will be glad to review them.

Looking at random links (that are wrapped and not able to be easily
used) is not going to work well.

thanks,

greg k-h
