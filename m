Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15D635FD6DF
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 11:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbiJMJSU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 05:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiJMJSS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 05:18:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3637819025
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 02:18:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C329361739
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 09:18:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0814C433D6;
        Thu, 13 Oct 2022 09:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665652697;
        bh=XfLLLV0yf7Vfms05peNWNqi3084uuOheUtIaX2FjHCY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u9SosKOcQYYB5ILmP60M0Ma5CLnoEUFg54v7AG7fon33egDwDI/XGx3jnrO6Q3X+S
         tmq8IOwdRh1F6EL25QuY5lAQqG0PG2vdbH8hsM1X+liJQiY9cpK8XbVxdL6dDHP7uW
         OLZIj7X5C8BvbFL9AlKLEqb74He21ty8AeSKbWLI=
Date:   Thu, 13 Oct 2022 11:19:01 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     "Bhatnagar, Rishabh" <risbhat@amazon.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "hch@lst.de" <hch@lst.de>
Subject: Re: nvme-pci patch backport to 5.15/5.10 stable
Message-ID: <Y0fYBdqf+cYuycA3@kroah.com>
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

The patch does not apply cleanly at all, how did you test this?  Please
provide a working backport for those trees if you wish to have it
applied there.

thanks,

greg k-h
