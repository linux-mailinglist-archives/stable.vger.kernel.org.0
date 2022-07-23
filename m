Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16BF457EFEB
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 16:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236970AbiGWO7s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 10:59:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236191AbiGWO7r (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 10:59:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5214E14D0A;
        Sat, 23 Jul 2022 07:59:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E439360BA9;
        Sat, 23 Jul 2022 14:59:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF125C341C0;
        Sat, 23 Jul 2022 14:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658588385;
        bh=M9jMVR91TD7sPGCXWoiFHEnLMPyC1nFPhYQlehtKTj0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i7yaspiq2062x2uoFJS3DlPxhhbXNmhSyRyrWSs+DbKNseT/oOPPA2tjkmGt1qzSP
         Vrav+H0vlqdTFzsnhZevG49y+69orIdlp/xECwFXeEfKWaJrCBJFUgtJVmRil+U7PC
         0iCLS5KfpAE7N/gxh1nTaa9G/9ynEoUbj7lGPibE=
Date:   Sat, 23 Jul 2022 16:59:42 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     stable@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>,
        syzbot+4f441e6ca0fcad141421@syzkaller.appspotmail.com,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 5.10 1/2] block: split bio_kmalloc from bio_alloc_bioset
Message-ID: <YtwM3uHugOOdDQZT@kroah.com>
References: <20220718211226.506362-1-tadeusz.struk@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718211226.506362-1-tadeusz.struk@linaro.org>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 18, 2022 at 02:12:25PM -0700, Tadeusz Struk wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> From: Christoph Hellwig <hch@lst.de>
> 
> Upstream commit: 3175199ab0ac ("block: split bio_kmalloc from bio_alloc_bioset")
> 
> This is backport to stable 5.10. It fixes an issue reported by syzbot.
> Link: https://syzkaller.appspot.com/bug?id=a3416231e37024a75f2b95bd95db0d8ce8132a84

Both now queued up, thanks.

greg k-h
