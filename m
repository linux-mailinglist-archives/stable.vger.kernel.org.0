Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED28F584215
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 16:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbiG1Op2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 10:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232730AbiG1Op0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 10:45:26 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D96B4474C1;
        Thu, 28 Jul 2022 07:45:24 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6A6F367373; Thu, 28 Jul 2022 16:45:20 +0200 (CEST)
Date:   Thu, 28 Jul 2022 16:45:20 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Tadeusz Struk <tadeusz.struk@linaro.org>, stable@vger.kernel.org,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        Christoph Hellwig <hch@lst.de>,
        syzbot+4f441e6ca0fcad141421@syzkaller.appspotmail.com,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 5.10 1/2] block: split bio_kmalloc from bio_alloc_bioset
Message-ID: <20220728144520.GA18285@lst.de>
References: <20220718211226.506362-1-tadeusz.struk@linaro.org> <YtwM3uHugOOdDQZT@kroah.com> <YuKgW9BCNl8ChT/v@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YuKgW9BCNl8ChT/v@kroah.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 28, 2022 at 04:42:35PM +0200, Greg KH wrote:
> > > Link: https://syzkaller.appspot.com/bug?id=a3416231e37024a75f2b95bd95db0d8ce8132a84
> > 
> > Both now queued up, thanks.
> 
> As was just reported, this breaks things all over the place:
> 	https://lore.kernel.org/r/219030d8-3408-cc9d-7aec-1fb14ab891ce@roeck-us.net
> 
> Note, I also had to add lots of fix-up patches on top of these two that
> you missed, so odds are there are other fix-ups that I also missed.
> 
> Please go and test this again, and submit ALL patches that are needed
> after they pass the proper testing and I will be glad to reconsider them
> again.

Why did this even get backported?  It was a cleanup that required a lot
of prep work, and should not by itself fix anything.
