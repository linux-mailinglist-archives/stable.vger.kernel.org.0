Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9669E599AAC
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 13:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348608AbiHSLHh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 07:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348516AbiHSLHU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 07:07:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F5F2FBA5A
        for <stable@vger.kernel.org>; Fri, 19 Aug 2022 04:07:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4872BB82751
        for <stable@vger.kernel.org>; Fri, 19 Aug 2022 11:07:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A19CC433D6;
        Fri, 19 Aug 2022 11:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660907235;
        bh=JPvnrUaQleYG9fRiIClWCkl3WYvHdIiARyVnVZJi1Lc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wurFzNTj5Vap5hppYQ2Ij9Ax+y8OnAYSx4a/ASuQViWHYhX7MZidZyx+qEZpY265Q
         uL6MvsJTHRYBoCXkO2ZAzNElIC2dDrdgIxHOJuPVH5jcxiad0GBhQc9Q8aVXAwHNr3
         001ETPPGl5XiIsa1PE9hd3GISxITcwZN08gMDDpU=
Date:   Fri, 19 Aug 2022 13:07:08 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Michael Bestas <mkbestas@gmail.com>
Cc:     hsinyi@chromium.org, rppt@linux.ibm.com, stable@vger.kernel.org,
        swboyd@chromium.org, will@kernel.org
Subject: Re: [PATCH] arm64: map FDT as RW for early_init_dt_scan()
Message-ID: <Yv9u3A33IpJ8cPwU@kroah.com>
References: <YvKVlhUZ2I1omy5S@kroah.com>
 <20220809181753.2556152-1-mkbestas@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220809181753.2556152-1-mkbestas@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 09, 2022 at 09:17:53PM +0300, Michael Bestas wrote:
> On Tue, 9 Aug 2022 19:12:54 +0200
> Greg KH <gregkh@linuxfoundation.org> wrote:
> 
> > What about 4.14.y and newer?
> > 
> > thanks,
> > 
> > greg k-h  
> 
> This patch should be required on all stable kernels that got commit
> "fdt: add support for rng-seed", however I have not tested it.
> 
> A similar backport exists in android 4.19 kernel:
> https://android-review.googlesource.com/c/kernel/common/+/1238592

Great, please submit it so that we can include it.

Also for 4.14.y.  I can't take a patch for an older kernel tree without
the same commit being in a newer one, otherwise people would have
regressions when upgrading.

thanks,

greg k-h
