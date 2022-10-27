Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9C360F67E
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 13:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235176AbiJ0LtN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 07:49:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234021AbiJ0LtM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 07:49:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7C0C58524;
        Thu, 27 Oct 2022 04:49:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A7CD9B825BC;
        Thu, 27 Oct 2022 11:49:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D9CEC433D6;
        Thu, 27 Oct 2022 11:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666871349;
        bh=h22rnlxlTQFHOfM4MxiClc1KLLjGK5lk+wbuRxMnR5Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dtH1Sw2HtovdyAqQORZsrQDx2pwlB/yxbwfxOLlofyRWatDMyJKM9Yr4zJtLARl6I
         AJmcH7UFyGzhiAZEGd8ij4Oiz2dX/Ro4uhSWWUkn6gf+2QfHhMblveo86fnpG3Y2Ym
         vWBiVRc1jdc3BXUmON5P1d5j7yPPPAh31N9tFibs=
Date:   Thu, 27 Oct 2022 13:49:06 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     axboe@kernel.dk, stable@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        yi.zhang@hawei.com, "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH 5.10 2/3] blk-wbt: call rq_qos_add() after wb_normal is
 initialized
Message-ID: <Y1pwMhBTym5CYH9q@kroah.com>
References: <20221018014326.467842-1-yukuai1@huaweicloud.com>
 <20221018014326.467842-3-yukuai1@huaweicloud.com>
 <Y1lkvFXjEMA80AFO@kroah.com>
 <fa4a2aed-4a9e-abfa-6fcf-d402ec9a1647@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fa4a2aed-4a9e-abfa-6fcf-d402ec9a1647@huaweicloud.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 27, 2022 at 07:28:26PM +0800, Yu Kuai wrote:
> Hi,
> 
> 在 2022/10/27 0:47, Greg KH 写道:
> > On Tue, Oct 18, 2022 at 09:43:25AM +0800, Yu Kuai wrote:
> > > From: Yu Kuai <yukuai3@huawei.com>
> > > 
> > > commit 8c5035dfbb9475b67c82b3fdb7351236525bf52b upstream.
> > 
> > I need a 5.15 version of this, and the 3/3 patch in order to be able to
> > apply the 5.10.y version.
> > 
> > Can you please send that, and then resend the remaining patches here for
> > 5.10.y?
> 
> Yes, I can do that. By the way, just to confirm:
> 
> I already saw that patch 2,3 is queued:
> 
> [PATCH 5.15 122/530] blk-wbt: call rq_qos_add() after wb_normal is
> initialized
> [PATCH 5.15 519/530] blk-wbt: fix that rwb->wc is always set to 1 in
> wbt_init()
> 
> Do I still need to send a 5.15 version?

Not if it is already in the tree, no.

thanks,

greg k-h
