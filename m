Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3F622E9246
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 10:02:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbhADJAw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 04:00:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:39652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726505AbhADJAw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 04:00:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6EC3C207AE;
        Mon,  4 Jan 2021 09:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609750811;
        bh=H9/XS7NCMpKpPhTNAtLqzqdQNc3TyLFgsTSqw/tJad4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lv0RMtqEowcS5BJ4iDjXQVREn0O4LZ6s94WWhlV6KJPh3plf16xlxI24AVHFOWD1g
         CwQZ7iTlkOpLnH6+pStdtP7TPbVUoaoGnGkOev+VXCJEx1Sae3bSy0h4o4gaek2V7t
         wy7pQz3N8MvztQPB9wbuZrC8w7VayvDLMIR+35lhgdo6h/Yd3CYjrEVCZudiQreGd0
         LygDTV9FK/qjt4pEkBOP7pXYWAarq6zBYVPbj9s7xgSXQkX7pZzlGPTtlPcxk9mSaG
         WYN0PQEoWSQuxTFc8Vmvrg2WRDBzdWFa0z1K17j5jFm+NM1CAFxXSPXQKlHF/wTkYU
         3YF31DZknheHg==
Received: from johan by xi with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1kwLih-0003ul-C3; Mon, 04 Jan 2021 10:00:08 +0100
Date:   Mon, 4 Jan 2021 10:00:07 +0100
From:   Johan Hovold <johan@kernel.org>
To:     =?utf-8?B?QmrDuHJu?= Mork <bjorn@mork.no>
Cc:     Johan Hovold <johan@kernel.org>, linux-usb@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] USB: serial: option: add Quectel EM160R-GL
Message-ID: <X/LZFzKyo4/d9Js0@hovoldconsulting.com>
References: <20201230152534.245337-1-bjorn@mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201230152534.245337-1-bjorn@mork.no>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 30, 2020 at 04:25:34PM +0100, Bjørn Mork wrote:
> New modem using ff/ff/30 for QCDM, ff/00/00 for  AT and NMEA,
> and ff/ff/ff for RMNET/QMI.

> Cc: stable@vger.kernel.org
> Signed-off-by: Bjørn Mork <bjorn@mork.no>
> ---
>  drivers/usb/serial/option.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
> index 2c21e34235bb..7c9cd921a738 100644
> --- a/drivers/usb/serial/option.c
> +++ b/drivers/usb/serial/option.c
> @@ -1117,6 +1117,8 @@ static const struct usb_device_id option_ids[] = {
>  	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EM12, 0xff, 0xff, 0xff),
>  	  .driver_info = RSVD(1) | RSVD(2) | RSVD(3) | RSVD(4) | NUMEP2 },
>  	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EM12, 0xff, 0, 0) },
> +	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, 0x0620, 0xff, 0xff, 0x30) },
> +	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, 0x0620, 0xff, 0, 0) },
>  	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_RM500Q, 0xff, 0xff, 0x30) },
>  	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_RM500Q, 0xff, 0, 0) },
>  	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_RM500Q, 0xff, 0xff, 0x10),

Thanks, Bjørn. Now applied with an added model comment after the first
entry.

Johan
