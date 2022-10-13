Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99EC95FD6DB
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 11:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbiJMJRX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 05:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiJMJRW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 05:17:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C01062D6
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 02:17:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 168BFB81D55
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 09:17:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68404C433D6;
        Thu, 13 Oct 2022 09:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665652638;
        bh=JX2AG5TmyGuf+6ai0iX++OK0B8iN/q3K37dVSV1i4QM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GFlBthu9f0tIh65NdGuwna8yN9HSPVXpuhawbYz+8r76UxqRjCtufSY/JAD3ruqp5
         ToqKkOhCGaftu+Ehp39aotQTPOOfmwJ9NHzrN3JB4LXgW8bu52h4a1c2H5Ew0YPr4f
         PYvUFOipKwWc4fUe6fdiDGndK5P4QaRCZck9g7+I=
Date:   Thu, 13 Oct 2022 11:18:03 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     "Bhatnagar, Rishabh" <risbhat@amazon.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "hch@lst.de" <hch@lst.de>
Subject: Re: nvme-pci patch backport to 5.15/5.10 stable
Message-ID: <Y0fXy8iIi70I+Cak@kroah.com>
References: <db989ce3-5f0e-dc4e-e536-ec806744c229@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db989ce3-5f0e-dc4e-e536-ec806744c229@amazon.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 11, 2022 at 02:12:27PM -0700, Bhatnagar, Rishabh wrote:
> Hi
> 
> The following patch is needed in 5.10 and 5.15 stable trees.
> 
> Commit: 61ce339f19fabbc3e51237148a7ef6f2270e44fa
> Subject: nvme-pci: set min_align_mask before calculating max_hw_sectors
> 
> This patch fixes the swiotlb usecase for nvme driver
> where if dma_min_align is not considered the requested buffer
> size overflows the swiotlb buffer.
> Patch applies cleanly for 5.15/5.10 stable trees.

What about 5.19 and 6.0?  You don't want someone upgrading to a newer
kernel and having a regression, right?

thanks,

greg k-h
