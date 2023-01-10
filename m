Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83308663A80
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 09:08:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbjAJIHg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 03:07:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231509AbjAJIHH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 03:07:07 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61717165AC
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 00:07:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E610ECE12A9
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 08:07:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D63AC433D2;
        Tue, 10 Jan 2023 08:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673338022;
        bh=CCd0rM1lWIe5PFLe5Wp/e5upgs+Q9s50ywLI0TglBj4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BYGy8IfSlqLDqENeICYs6DTqVXDWzvX7bR96gdO2S7BnRjljlpmY6uZv52cXfhbzR
         QmVR5GxUc4ljjl+bpu1GPgEHdkI42/xL+Zl9O1rD08epyYQISzccDkUk5uSNC3ASwh
         OXTUtMrT+VLFVyUPMchsSPnSXqaDxY1BArTVtDqg=
Date:   Tue, 10 Jan 2023 09:06:55 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Noor Azura Ahmad Tarmizi <noor.azura.ahmad.tarmizi@intel.com>
Cc:     Noor Azura Ahmad Tarmizi 
        <noor.azura.ahmad.tarmizi@linux.intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH net v2 1/1] net: stmmac: add aux timestamps fifo
 clearance wait
Message-ID: <Y70cn8qvBUF+Y9tn@kroah.com>
References: <20230109144439.5615-1-noor.azura.ahmad.tarmizi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230109144439.5615-1-noor.azura.ahmad.tarmizi@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 09, 2023 at 10:44:39PM +0800, Noor Azura Ahmad Tarmizi wrote:
> Add timeout polling wait for auxiliary timestamps snapshot FIFO clear bit
> (ATSFC) to clear. This is to ensure no residue fifo value is being read
> erroneously.
> 
> Cc: <stable@vger.kernel.org> # 5.10.x
> Signed-off-by: Noor Azura Ahmad Tarmizi <noor.azura.ahmad.tarmizi@intel.com>
> ---
> v1 -> v2: Test update to version 2
> 
>  drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
