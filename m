Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9418F695D58
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 09:41:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232134AbjBNIlv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 03:41:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231804AbjBNIlk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 03:41:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8987D2384B
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 00:41:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC447614AF
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 08:41:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3ECDC433EF;
        Tue, 14 Feb 2023 08:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676364074;
        bh=9q+pKx0WlyZOMiVUro9AhQHPwmXUUoepf90OBdHWUrg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PyJ3EjTprZ+v6wZNg6VrP0T/SNaDHXH4ioa53fWBv2csnts39PSgEybafB3y1gDLy
         Cv58DWNCFVQccLFZQ5GzePKSpmwn6F1iM30OGHCj/Ro/+Sgc3mZ3gFUomL5V/hKtcZ
         L2F7V8GPaSMFuwIXJRVk+ADdMceuHdKGi+Vgo3ug=
Date:   Tue, 14 Feb 2023 09:41:06 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Gwendal Grignou <gwendal@chromium.org>
Cc:     andriy.shevchenko@linux.intel.com, stable@vger.kernel.org,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 5.4] nvme-pci: Move enumeration by class to be last in
 the table
Message-ID: <Y+tJIkadn0IMFvT+@kroah.com>
References: <20230208030824.235941-1-gwendal@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230208030824.235941-1-gwendal@chromium.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 07, 2023 at 07:08:24PM -0800, Gwendal Grignou wrote:
> From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
> It's unusual that we have enumeration by class in the middle of the table.
> It might potentially be problematic in the future if we add another entry
> after it.
> 
> So, move class matching entry to be the last in the ID table.
> 
> [ Upstream commit 0b85f59d30b91bd2b93ea7ef0816a4b7e7039e8c ]
> 
> Without this change, quirks set in driver_data added after the catch-all
> are ignored.
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Reviewed-by: Keith Busch <kbusch@kernel.org>
> Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
> Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
> ---
>  drivers/nvme/host/pci.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Now queued up, thanks.

greg k-h
