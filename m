Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAB38633CB8
	for <lists+stable@lfdr.de>; Tue, 22 Nov 2022 13:39:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233145AbiKVMju (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Nov 2022 07:39:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232692AbiKVMjo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Nov 2022 07:39:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3573360370
        for <stable@vger.kernel.org>; Tue, 22 Nov 2022 04:39:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9DCEB81AB2
        for <stable@vger.kernel.org>; Tue, 22 Nov 2022 12:39:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4F49C433D6;
        Tue, 22 Nov 2022 12:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669120780;
        bh=JxLLgTNOpd1W+Qc+NJqx4rgHqQKbcjv+fYb82JKkWzE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=y5UNolfCkfcSdh6EbX4RKSN6GWvBYoSIAkzYQkko57vGWjgmGZQdS4o8EmOoasb6X
         oLrWq0sU11a0diY+zQeqQTWaVaspA9muhqNlc/k+2SCikh76Lbw2MmqrlLDdczRQih
         99Nanl3AdzP380v64N8u5LRg+HOhLGiCioAIRwIE=
Date:   Tue, 22 Nov 2022 13:39:36 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        stable@vger.kernel.org, wentong.wu@intel.com
Subject: Re: [PATCH backport to 5.15 1/1] serial: 8250_lpss: Use 16B DMA
 burst with Elkhart Lake
Message-ID: <Y3zDCEsZ9Q57PM5X@kroah.com>
References: <38cd338-61e5-5cbc-d3f6-9dc326f38743@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <38cd338-61e5-5cbc-d3f6-9dc326f38743@linux.intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 21, 2022 at 02:37:03PM +0200, Ilpo Järvinen wrote:
> commit 7090abd6ad0610a144523ce4ffcb8560909bf2a8 upstream.
> 
> Configure DMA to use 16B burst size with Elkhart Lake. This makes the
> bus use more efficient and works around an issue which occurs with the
> previously used 1B.
> 
> The fix was initially developed by Srikanth Thokala and Aman Kumar.
> This together with the previous config change is the cleaned up version
> of the original fix.
> 
> Fixes: 0a9410b981e9 ("serial: 8250_lpss: Enable DMA on Intel Elkhart Lake")
> Cc: <stable@vger.kernel.org> # serial: 8250_lpss: Configure DMA also w/o DMA filter
> Reported-by: Wentong Wu <wentong.wu@intel.com>
> Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Link: https://lore.kernel.org/r/20221108121952.5497-4-ilpo.jarvinen@linux.intel.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/tty/serial/8250/8250_lpss.c | 3 +++
>  1 file changed, 3 insertions(+)

Now queued up, thanks.

greg k-h
