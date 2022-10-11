Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B59875FBA51
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 20:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbiJKSZT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 14:25:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbiJKSYt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 14:24:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B69F7792CC;
        Tue, 11 Oct 2022 11:24:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C54986125D;
        Tue, 11 Oct 2022 18:24:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7791CC433D6;
        Tue, 11 Oct 2022 18:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665512651;
        bh=KS86MgZUsJFlt5BXRqWspAaxPjZljTkZi5/nzYdd054=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yqqHgWMgeXWiOzY7cNVnqWXW0rBP83QwCvij3MBqoEiXcl/VqFSSP6Hvvlfvy69Z1
         xzLENh+WVkA3E6Ki85A3jRWweJi1Jlu1O1HwlRJOnNQIWkkPt+g9o4SF02MUJzPuey
         aikstgZTnqxleHHrs3ulEmBfUZw/aSY67PklmKKE=
Date:   Tue, 11 Oct 2022 20:24:54 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Bhatnagar, Rishabh" <risbhat@amazon.com>
Cc:     "hch@lst.de" <hch@lst.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "sagi@grimberg.me" <sagi@grimberg.me>,
        "axboe@fb.com" <axboe@fb.com>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "Bacco, Mike" <mbacco@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Park, SeongJae" <sjpark@amazon.com>
Subject: Re: [PATCH v2] nvme-pci: Set min align mask before calculating
 max_hw_sectors
Message-ID: <Y0W09tcGK/1ZAhQh@kroah.com>
References: <20220929182259.22523-1-risbhat@amazon.com>
 <EB43F4D1-BFD0-408B-93E7-10643B59F766@amazon.com>
 <b73250f3-2dd6-36da-4d69-3149959f2e67@amazon.com>
 <20221011060829.GA3172@lst.de>
 <8f451a9e-3324-c7d4-cf61-a105fd087192@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8f451a9e-3324-c7d4-cf61-a105fd087192@amazon.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 11, 2022 at 10:05:38AM -0700, Bhatnagar, Rishabh wrote:
> 
> On 10/10/22 11:08 PM, hch@lst.de wrote:
> > CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> > 
> > 
> > 
> > The patch already made it to Linux 6.0, so I'm not sure what we need
> > to review again.
> 
> Oh, I never got any email that this was being picked up so sent it again.
> Anyways thanks for taking it.
> We need this patch for 5.10/5.15 stable kernels as well. I can send backport
> patches to stable tree
> maintainers unless there is a way for you to mark it so that its
> automatically picked for stable trees.

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
