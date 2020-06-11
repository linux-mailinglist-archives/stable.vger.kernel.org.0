Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A9B91F6B91
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 17:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728698AbgFKPvW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 11:51:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:45064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728379AbgFKPvW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Jun 2020 11:51:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DE2F2075E;
        Thu, 11 Jun 2020 15:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591890681;
        bh=hA8crjb1+eO8Ik/FhkrnD4BD1as2cXO76+YuSd8DasY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kf4wzQ/QSq468OsTOk9YbxdS+jLbXLI10PegVvY9Uxs45MurykHl2eAaIL6vR1W/E
         DeQUUvldiASxJmzNYayh2XTfVOfiQPZudOASBj2bjGpQyMLUjn9Ft4efKR37EQkzyJ
         eXBIBRk+5lTShKQQQhLDNPMMzYX6sC64ivTY5aM8=
Date:   Thu, 11 Jun 2020 17:51:14 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
Cc:     linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        helen.koike@collabora.com, ezequiel@collabora.com,
        hverkuil@xs4all.nl, kernel@collabora.com, dafna3@gmail.com,
        sakari.ailus@linux.intel.com, linux-rockchip@lists.infradead.org,
        mchehab@kernel.org, tfiga@chromium.org, stable@vger.kernel.org
Subject: Re: [RESEND PATCH v3 6/6] media: staging: rkisp1: common: add
 documentation for struct rkisp1_isp_mbus_info
Message-ID: <20200611155114.GD1456044@kroah.com>
References: <20200611154551.25022-1-dafna.hirschfeld@collabora.com>
 <20200611154551.25022-7-dafna.hirschfeld@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200611154551.25022-7-dafna.hirschfeld@collabora.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 11, 2020 at 05:45:51PM +0200, Dafna Hirschfeld wrote:
> Add documentation for the struct rkisp1_isp_mbus_info with
> one line doc of each field
> 
> Signed-off-by: Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
> ---
>  drivers/staging/media/rkisp1/rkisp1-common.h | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/drivers/staging/media/rkisp1/rkisp1-common.h b/drivers/staging/media/rkisp1/rkisp1-common.h
> index 13c5eeff66f3..6104eddac0e5 100644
> --- a/drivers/staging/media/rkisp1/rkisp1-common.h
> +++ b/drivers/staging/media/rkisp1/rkisp1-common.h
> @@ -268,6 +268,19 @@ struct rkisp1_device {
>  	struct rkisp1_debug debug;
>  };
>  
> +/*
> + * struct rkisp1_isp_mbus_info
> + *
> + * holds information about the supported isp media bus
> + * @mbus_code: the media bus code
> + * @pixel_enc: the pixel encoding
> + * @mipi_dt: the mipi data type
> + * @yuv_seq: the order of the yuv values for yuv formats
> + * @bus_width: the bus width
> + * @bayer_pat: the bayer pattern for bayer formats
> + * @isp_pads_mask: a bitmask of the pads that the format is supported on
> + */
> +
>  /*
>   * struct rkisp1_isp_mbus_info - ISP pad format info
>   *
> -- 
> 2.17.1
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
