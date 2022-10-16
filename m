Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A77785FFEAB
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 12:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbiJPKoR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 06:44:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiJPKoR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 06:44:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 464BD39BA7;
        Sun, 16 Oct 2022 03:44:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0A42B80C83;
        Sun, 16 Oct 2022 10:44:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 233F9C433D6;
        Sun, 16 Oct 2022 10:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665917053;
        bh=RGlcwFjnAJzR2vAEJptPRund7Ned/ff3vJDoCawrpsU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ujLGWGrA45GtYzOoL/TfcMhMYWycTm3+lMY66sxpbPRfN7sb7z0COZ4Ugwp2/iJCc
         SZutia2aGc/sqXPS17ygcKi1P+5rQ7DDthRwyZWZP/UFg6EDqy/7YRkhush7/5W70M
         JYKvCoB7lCZ+xLWrZbqdHZIgwupeqq2tNZ92xBzU=
Date:   Sun, 16 Oct 2022 12:44:59 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Rishabh Bhatnagar <risbhat@amazon.com>
Cc:     stable@vger.kernel.org, hch@lst.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5.15 5.10] nvme-pci: set min_align_mask before
 calculating max_hw_sectors
Message-ID: <Y0vgq8q3AjVGcVCn@kroah.com>
References: <20221013175827.25295-1-risbhat@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221013175827.25295-1-risbhat@amazon.com>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 13, 2022 at 05:58:27PM +0000, Rishabh Bhatnagar wrote:
> commit 61ce339f19fabbc3e51237148a7ef6f2270e44fa upstream.
> 
> If swiotlb is force enabled dma_max_mapping_size ends up calling
> swiotlb_max_mapping_size which takes into account the min align mask for
> the device.  Set the min align mask for nvme driver before calling
> dma_max_mapping_size while calculating max hw sectors.
> 
> Signed-off-by: Rishabh Bhatnagar <risbhat@amazon.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/nvme/host/pci.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Now queued up, thanks.

greg k-h
