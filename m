Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BDB5640707
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 13:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233540AbiLBMo0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 07:44:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233504AbiLBMoY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 07:44:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC112CD9B8
        for <stable@vger.kernel.org>; Fri,  2 Dec 2022 04:44:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B3DCB82156
        for <stable@vger.kernel.org>; Fri,  2 Dec 2022 12:44:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8AE9C433B5;
        Fri,  2 Dec 2022 12:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669985061;
        bh=xa5hpokMZcKjrq3nRa53lkeVFK7SlY2m3x4xqu5edg8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OUKgXa4HauDZctz+1e1iVeobYuVxWccbO3FU0j1oPvJConIwWvlRvGj1QHTTYaIE/
         IZfVIe2dlHm/E6Rmb2JesFoHWYBecD9pZeC1pZwtYce9sp/Kd6NeUZtl1z9yva7lYH
         k8wa2SfVMWJygmcketDHVmnSyQXhSrP3/GAUusxA=
Date:   Fri, 2 Dec 2022 13:44:16 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dicheng Wang <wangdicheng123@hotmail.com>
Cc:     wangdicheng@kylinos.cn, stable@vger.kernel.org
Subject: Re: [PATCH -next] The USB audio driver does not contain the VID and
 PID of this sound card, so the driver is not loaded.
Message-ID: <Y4nzIEdMV7h8xU/6@kroah.com>
References: <SG2PR02MB58786472A08370F924C3E7828A179@SG2PR02MB5878.apcprd02.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SG2PR02MB58786472A08370F924C3E7828A179@SG2PR02MB5878.apcprd02.prod.outlook.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 02, 2022 at 03:49:34PM +0800, Dicheng Wang wrote:
> From: wangdicheng <wangdicheng@kylinos.cn>
> 
> Add relevant information to the quirks-table.h file.
> The test passes and the sound source file plays normally.
> 
> Cc: stable@vger.kernel.org
> 
> Signed-off-by: wangdicheng <wangdicheng@kylinos.cn>
> ---
>  sound/usb/quirks-table.h | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
> index 874fcf245747..24b8d4fc87c4 100644
> --- a/sound/usb/quirks-table.h
> +++ b/sound/usb/quirks-table.h
> @@ -2801,6 +2801,12 @@ YAMAHA_DEVICE(0x7010, "UB99"),
>  	.idVendor = 0x17cc,
>  	.idProduct = 0x1020,
>  },
> +{
> +	/* Ktmicro Usb_audio */
> +	.match_flags = USB_DEVICE_ID_MATCH_DEVICE,
> +	.idVendor = 0x31b2,
> +	.idProduct = 0x0011,
> +},
>  
>  /* QinHeng devices */
>  {
> -- 
> 2.25.1
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
