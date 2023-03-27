Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C60DD6CA2D5
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 13:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231932AbjC0Lvm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 07:51:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbjC0Lvl (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 27 Mar 2023 07:51:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9536D2D46;
        Mon, 27 Mar 2023 04:51:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49850B810E2;
        Mon, 27 Mar 2023 11:51:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAA67C433D2;
        Mon, 27 Mar 2023 11:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679917898;
        bh=tkUKHXUOdkTFseJ4nMnQlFeH70mDuPicL36cxP8wSBM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hgw4lNYiuvCorBcv1OFHp3G4ha5Vd/AKzqSNTJx0TkyTItpNScXqDXlVr3PyiArEG
         dZTEgcajIDU0D8I64kN57F+0liO88s31pb9nCuzaYxymrgBQyzjVi9BLma/nvdNf4a
         zpoAgusmveHLJC9N4W/b26C90NjwHUnrLwpu0eSU=
Date:   Mon, 27 Mar 2023 13:51:34 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mathias Nyman <mathias.nyman@linux.intel.com>
Cc:     mirsad.todorovac@alu.unizg.hr, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        ubuntu-devel-discuss@lists.ubuntu.com, stern@rowland.harvard.edu,
        arnd@arndb.de, Stable@vger.kernel.org
Subject: Re: [PATCH] xhci: Free the command allocated for setting LPM if we
 return early
Message-ID: <ZCGDRrT4Bo3-UYOZ@kroah.com>
References: <b86fcdbd-f1c6-846f-838f-b7679ec4e2b4@linux.intel.com>
 <20230327095019.1017159-1-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230327095019.1017159-1-mathias.nyman@linux.intel.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 27, 2023 at 12:50:19PM +0300, Mathias Nyman wrote:
> The command allocated to set exit latency LPM values need to be freed in
> case the command is never queued. This would be the case if there is no
> change in exit latency values, or device is missing.
> 
> Fixes: 5c2a380a5aa8 ("xhci: Allocate separate command structures for each LPM command")
> Cc: <Stable@vger.kernel.org>
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> ---
>  drivers/usb/host/xhci.c | 1 +
>  1 file changed, 1 insertion(+)

Do you want me to take this now, or will you be sending this to me in a
separate series of xhci fixes?  Either is fine with me.

thanks,

greg k-h
