Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A53C58768E
	for <lists+stable@lfdr.de>; Tue,  2 Aug 2022 07:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbiHBFLe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Aug 2022 01:11:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiHBFLd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Aug 2022 01:11:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0CF117599;
        Mon,  1 Aug 2022 22:11:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6BD5DB8199B;
        Tue,  2 Aug 2022 05:11:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B98B3C433D6;
        Tue,  2 Aug 2022 05:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659417090;
        bh=edE86YHe/q+UpiENTiKCJQkihEbQZ912xpNdOfgB1Sg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H9w2eocq/4AU5715YlhY4o0AL7v+nWPegP+cZ56VJsy+viDPkZd5jINfG9tT8sRZP
         X+AEE2q2H0dp+n3VRUNmyW1YcYZSBMT0DMUhrr4JFUXtEyBxyBQjAmjOsi5RSIEgy6
         E0I8JgM03iOBmVbHfzm2lwBg7fIM5lImYavP8Auw=
Date:   Tue, 2 Aug 2022 07:11:24 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Yu Kuai <yukuai1@huaweicloud.com>, stable@vger.kernel.org,
        axboe@kernel.dk, snitzer@redhat.com, dm-devel@redhat.com,
        linux-block@vger.kernel.org, yukuai3@huawei.com,
        yi.zhang@huawei.com
Subject: Re: [PATCH stable 5.10 1/3] block: look up holders by bdev
Message-ID: <Yuix/CcmdKsSD+za@kroah.com>
References: <20220729062356.1663513-1-yukuai1@huaweicloud.com>
 <20220729062356.1663513-2-yukuai1@huaweicloud.com>
 <Yue2rU2Y+xzvGU6x@kroah.com>
 <20220801180458.GA17425@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220801180458.GA17425@lst.de>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 01, 2022 at 08:04:58PM +0200, Christoph Hellwig wrote:
> On Mon, Aug 01, 2022 at 01:19:09PM +0200, Greg KH wrote:
> > This is very different from the upstream version, and forces the change
> > onto everyone, not just those who had CONFIG_BLOCK_HOLDER_DEPRECATED
> > enabled like was done in the main kernel tree.
> > 
> > Why force this on all and not just use the same option?
> 
> I'm really worried about backports that are significantly different
> from the original commit.  To the point where if they are so different
> and we don't have a grave security or data integrity bug I'm really not
> very much in favor of backporting them at all.
> 

I agree, I'll drop this from my review queue now, thanks.

greg k-h
