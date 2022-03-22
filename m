Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A88F74E3C73
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 11:29:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231407AbiCVKah (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Mar 2022 06:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232372AbiCVKah (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Mar 2022 06:30:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D57561B7B2
        for <stable@vger.kernel.org>; Tue, 22 Mar 2022 03:29:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C4A6B81B67
        for <stable@vger.kernel.org>; Tue, 22 Mar 2022 10:29:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF3FAC340EC;
        Tue, 22 Mar 2022 10:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647944945;
        bh=yvnFDdfcmkaEElEC+hak3U3xjNYnG2u3/q9TIJLvzL8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=x6bbf4/xt+GVkHscvms8q+mbcwK6PcJs48D/D13T5zkGkkZwdMjMCUNt/HZ1hS0R+
         qNvBMhXwhrc3+s5pHulnnBcE+Ca6EBxJ+0lv/HBoyKe+/GQVPz2Lj2Z/Vabk5dGc+U
         a/IpE/mM3S0eJbqf62gmO6WUmoh9li2100q7s2Mg=
Date:   Tue, 22 Mar 2022 11:29:02 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     stable@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Doug Gilbert <dgilbert@interlog.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH for 5.10.y 0/2] backports of ddbd89deb7d3 and aa6f8dcbab47
Message-ID: <Yjmk7mM36st0YeHd@kroah.com>
References: <20220322100218.2158138-1-pasic@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220322100218.2158138-1-pasic@linux.ibm.com>
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 22, 2022 at 11:02:16AM +0100, Halil Pasic wrote:
> Dear Stable Team,
> 
> This is a backport of ddbd89deb7d3 ("swiotlb: fix info leak with
> DMA_FROM_DEVICE") and aa6f8dcbab47 ("swiotlb: rework "fix info leak with
> DMA_FROM_DEVICE"") to 5.10.y.  
> 
> I had to handle some merge conflicts, and at this point we have
> swiotlb_tbl_sync_single() as opposed to swiotlb_sync_single_for_device()
> so I had to handle that as well.
> 
> Halil Pasic (2):
>   swiotlb: fix info leak with DMA_FROM_DEVICE
>   swiotlb: rework "fix info leak with DMA_FROM_DEVICE"
> 
>  kernel/dma/swiotlb.c | 24 ++++++++++++++++--------
>  1 file changed, 16 insertions(+), 8 deletions(-)

Thanks for these.

What about for kernels older than 5.10?  Do they matter for this issue?

thanks,

greg k-h
