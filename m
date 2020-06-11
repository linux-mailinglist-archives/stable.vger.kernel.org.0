Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 353081F6B8F
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 17:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728676AbgFKPvQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 11:51:16 -0400
Received: from wnew1-smtp.messagingengine.com ([64.147.123.26]:49733 "EHLO
        wnew1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728379AbgFKPvQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jun 2020 11:51:16 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.west.internal (Postfix) with ESMTP id 8AF2FACF;
        Thu, 11 Jun 2020 11:51:14 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 11 Jun 2020 11:51:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=daLc1HsVhBp9onjQoLrDZsYYV3Q
        XgEBOoD2o0RaIJa4=; b=jVmCmb7qn2xgP82Qdyft5SSd3A1xlRf2Ep4UjPk6Q/Z
        RzG5f8OU3a6VBOjofM4jcOHN/Zkckddlh9L8GTeIbpZWi9JId3GJE5FNgNCVeEMy
        eWocFY/Qd5GuQYGfBIa25jgcCFd8+GxATxugetAx1QxYJe39mZK23kK9O4VxxnE8
        IgxJHJSqjWOlAI0SWcSXk/xPyWlTBsp2V+3/z4SPmu4j2XJzPcTAU09OL71J6WWG
        ZUybSISHc5ePDzRIc+SFF+Hs9yI32Pgwt0M7OHDv2G0ZScf+bwwS4RgZu3odCn11
        gz5+gC3Dn+51Onpb4KK21eqYjJNTMDXfXtz6lPezHRA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=daLc1H
        sVhBp9onjQoLrDZsYYV3QXgEBOoD2o0RaIJa4=; b=I6NYP8J2g/hjb6HeiRusVQ
        iKzayMDghTSiGQMPlBW0qxVWUHz5IwIgCZM75HeP4wPY9oDScpibMloP6o/s66Zf
        C03fiZ4fKJ28pZyS7jeRscPovUfNyW+xWTMZKlfi23K+IJKLvu48cJO8L0kpAZxa
        7yoENg6OZtn7Xg/Sygo44WcDxaurDZpAhMyNlzTQHuE82GcudoOitHg7oXGZWzJl
        tsVh8ZnJchom3eG/QjL/Y+7R/1W/KdO+sUGMRCn3zQHp9VrDHE2D0X7nDN6pb4a+
        LO2XkjiZJPIeMw8C15UP/1estSDbpHgKTbuCNlRwsWjHUpCK+28EpgudahtnAyqg
        ==
X-ME-Sender: <xms:8VLiXixt_dlnHGo7EtgrLQhWsJaZfwWwoNl3nFA_EUvfkB-Ks_-F_Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudehledgieekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeuleeltd
    ehkeeltefhleduuddvhfffuedvffduveegheekgeeiffevheegfeetgfenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledruddtjeenucevlhhush
    htvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgr
    hhdrtghomh
X-ME-Proxy: <xmx:8VLiXuQfg5VwHMLRxwc3ojOYozOq9Lj7Hc9o8Ah3rTsMX7H-V1Ok6w>
    <xmx:8VLiXkXEC413g_9NEHkQbBoEJWDbiscONxZI3bAjD93_ma4UgLiH4g>
    <xmx:8VLiXoj716pOKj2nwLNS5bHKE77yzdN_dPrYGautBipoYm5YBJ0Zlg>
    <xmx:8lLiXksOgye53mUJYjJbTib8HefVBVCQ2lNyCve9QskVTTz-1gUzUs7ttyk>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id AC9F2328006A;
        Thu, 11 Jun 2020 11:51:12 -0400 (EDT)
Date:   Thu, 11 Jun 2020 17:51:04 +0200
From:   Greg KH <greg@kroah.com>
To:     Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
Cc:     linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        helen.koike@collabora.com, ezequiel@collabora.com,
        hverkuil@xs4all.nl, kernel@collabora.com, dafna3@gmail.com,
        sakari.ailus@linux.intel.com, linux-rockchip@lists.infradead.org,
        mchehab@kernel.org, tfiga@chromium.org, stable@vger.kernel.org
Subject: Re: [RESEND PATCH v3 4/6] media: staging: rkisp1: rename macros
 'RKISP1_DIR_*' to 'RKISP1_ISP_SD_*'
Message-ID: <20200611155104.GC1456044@kroah.com>
References: <20200611154551.25022-1-dafna.hirschfeld@collabora.com>
 <20200611154551.25022-5-dafna.hirschfeld@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200611154551.25022-5-dafna.hirschfeld@collabora.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 11, 2020 at 05:45:49PM +0200, Dafna Hirschfeld wrote:
> The macros 'RKISP1_DIR_*' are flags that indicate on which
> pads of the isp subdevice the media bus code is supported. so the
> prefix RKISP1_ISP_SD_ is better.
> 
> Signed-off-by: Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
> ---
>  drivers/staging/media/rkisp1/rkisp1-common.h  |  4 +-
>  drivers/staging/media/rkisp1/rkisp1-isp.c     | 42 +++++++++----------
>  drivers/staging/media/rkisp1/rkisp1-resizer.c |  2 +-
>  3 files changed, 24 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/staging/media/rkisp1/rkisp1-common.h b/drivers/staging/media/rkisp1/rkisp1-common.h
> index 0ec8718037a4..12bd9d05050d 100644
> --- a/drivers/staging/media/rkisp1/rkisp1-common.h
> +++ b/drivers/staging/media/rkisp1/rkisp1-common.h
> @@ -22,8 +22,8 @@
>  #include "rkisp1-regs.h"
>  #include "uapi/rkisp1-config.h"
>  
> -#define RKISP1_DIR_SRC BIT(0)
> -#define RKISP1_DIR_SINK BIT(1)
> +#define RKISP1_ISP_SD_SRC BIT(0)
> +#define RKISP1_ISP_SD_SINK BIT(1)
>  
>  #define RKISP1_ISP_MAX_WIDTH		4032
>  #define RKISP1_ISP_MAX_HEIGHT		3024
> diff --git a/drivers/staging/media/rkisp1/rkisp1-isp.c b/drivers/staging/media/rkisp1/rkisp1-isp.c
> index 157ac58c2efc..b21a67aea433 100644
> --- a/drivers/staging/media/rkisp1/rkisp1-isp.c
> +++ b/drivers/staging/media/rkisp1/rkisp1-isp.c
> @@ -58,119 +58,119 @@ static const struct rkisp1_isp_mbus_info rkisp1_isp_formats[] = {
>  	{
>  		.mbus_code	= MEDIA_BUS_FMT_YUYV8_2X8,
>  		.pixel_enc	= V4L2_PIXEL_ENC_YUV,
> -		.direction	= RKISP1_DIR_SRC,
> +		.direction	= RKISP1_ISP_SD_SRC,
>  	}, {
>  		.mbus_code	= MEDIA_BUS_FMT_SRGGB10_1X10,
>  		.pixel_enc	= V4L2_PIXEL_ENC_BAYER,
>  		.mipi_dt	= RKISP1_CIF_CSI2_DT_RAW10,
>  		.bayer_pat	= RKISP1_RAW_RGGB,
>  		.bus_width	= 10,
> -		.direction	= RKISP1_DIR_SINK | RKISP1_DIR_SRC,
> +		.direction	= RKISP1_ISP_SD_SINK | RKISP1_ISP_SD_SRC,
>  	}, {
>  		.mbus_code	= MEDIA_BUS_FMT_SBGGR10_1X10,
>  		.pixel_enc	= V4L2_PIXEL_ENC_BAYER,
>  		.mipi_dt	= RKISP1_CIF_CSI2_DT_RAW10,
>  		.bayer_pat	= RKISP1_RAW_BGGR,
>  		.bus_width	= 10,
> -		.direction	= RKISP1_DIR_SINK | RKISP1_DIR_SRC,
> +		.direction	= RKISP1_ISP_SD_SINK | RKISP1_ISP_SD_SRC,
>  	}, {
>  		.mbus_code	= MEDIA_BUS_FMT_SGBRG10_1X10,
>  		.pixel_enc	= V4L2_PIXEL_ENC_BAYER,
>  		.mipi_dt	= RKISP1_CIF_CSI2_DT_RAW10,
>  		.bayer_pat	= RKISP1_RAW_GBRG,
>  		.bus_width	= 10,
> -		.direction	= RKISP1_DIR_SINK | RKISP1_DIR_SRC,
> +		.direction	= RKISP1_ISP_SD_SINK | RKISP1_ISP_SD_SRC,
>  	}, {
>  		.mbus_code	= MEDIA_BUS_FMT_SGRBG10_1X10,
>  		.pixel_enc	= V4L2_PIXEL_ENC_BAYER,
>  		.mipi_dt	= RKISP1_CIF_CSI2_DT_RAW10,
>  		.bayer_pat	= RKISP1_RAW_GRBG,
>  		.bus_width	= 10,
> -		.direction	= RKISP1_DIR_SINK | RKISP1_DIR_SRC,
> +		.direction	= RKISP1_ISP_SD_SINK | RKISP1_ISP_SD_SRC,
>  	}, {
>  		.mbus_code	= MEDIA_BUS_FMT_SRGGB12_1X12,
>  		.pixel_enc	= V4L2_PIXEL_ENC_BAYER,
>  		.mipi_dt	= RKISP1_CIF_CSI2_DT_RAW12,
>  		.bayer_pat	= RKISP1_RAW_RGGB,
>  		.bus_width	= 12,
> -		.direction	= RKISP1_DIR_SINK | RKISP1_DIR_SRC,
> +		.direction	= RKISP1_ISP_SD_SINK | RKISP1_ISP_SD_SRC,
>  	}, {
>  		.mbus_code	= MEDIA_BUS_FMT_SBGGR12_1X12,
>  		.pixel_enc	= V4L2_PIXEL_ENC_BAYER,
>  		.mipi_dt	= RKISP1_CIF_CSI2_DT_RAW12,
>  		.bayer_pat	= RKISP1_RAW_BGGR,
>  		.bus_width	= 12,
> -		.direction	= RKISP1_DIR_SINK | RKISP1_DIR_SRC,
> +		.direction	= RKISP1_ISP_SD_SINK | RKISP1_ISP_SD_SRC,
>  	}, {
>  		.mbus_code	= MEDIA_BUS_FMT_SGBRG12_1X12,
>  		.pixel_enc	= V4L2_PIXEL_ENC_BAYER,
>  		.mipi_dt	= RKISP1_CIF_CSI2_DT_RAW12,
>  		.bayer_pat	= RKISP1_RAW_GBRG,
>  		.bus_width	= 12,
> -		.direction	= RKISP1_DIR_SINK | RKISP1_DIR_SRC,
> +		.direction	= RKISP1_ISP_SD_SINK | RKISP1_ISP_SD_SRC,
>  	}, {
>  		.mbus_code	= MEDIA_BUS_FMT_SGRBG12_1X12,
>  		.pixel_enc	= V4L2_PIXEL_ENC_BAYER,
>  		.mipi_dt	= RKISP1_CIF_CSI2_DT_RAW12,
>  		.bayer_pat	= RKISP1_RAW_GRBG,
>  		.bus_width	= 12,
> -		.direction	= RKISP1_DIR_SINK | RKISP1_DIR_SRC,
> +		.direction	= RKISP1_ISP_SD_SINK | RKISP1_ISP_SD_SRC,
>  	}, {
>  		.mbus_code	= MEDIA_BUS_FMT_SRGGB8_1X8,
>  		.pixel_enc	= V4L2_PIXEL_ENC_BAYER,
>  		.mipi_dt	= RKISP1_CIF_CSI2_DT_RAW8,
>  		.bayer_pat	= RKISP1_RAW_RGGB,
>  		.bus_width	= 8,
> -		.direction	= RKISP1_DIR_SINK | RKISP1_DIR_SRC,
> +		.direction	= RKISP1_ISP_SD_SINK | RKISP1_ISP_SD_SRC,
>  	}, {
>  		.mbus_code	= MEDIA_BUS_FMT_SBGGR8_1X8,
>  		.pixel_enc	= V4L2_PIXEL_ENC_BAYER,
>  		.mipi_dt	= RKISP1_CIF_CSI2_DT_RAW8,
>  		.bayer_pat	= RKISP1_RAW_BGGR,
>  		.bus_width	= 8,
> -		.direction	= RKISP1_DIR_SINK | RKISP1_DIR_SRC,
> +		.direction	= RKISP1_ISP_SD_SINK | RKISP1_ISP_SD_SRC,
>  	}, {
>  		.mbus_code	= MEDIA_BUS_FMT_SGBRG8_1X8,
>  		.pixel_enc	= V4L2_PIXEL_ENC_BAYER,
>  		.mipi_dt	= RKISP1_CIF_CSI2_DT_RAW8,
>  		.bayer_pat	= RKISP1_RAW_GBRG,
>  		.bus_width	= 8,
> -		.direction	= RKISP1_DIR_SINK | RKISP1_DIR_SRC,
> +		.direction	= RKISP1_ISP_SD_SINK | RKISP1_ISP_SD_SRC,
>  	}, {
>  		.mbus_code	= MEDIA_BUS_FMT_SGRBG8_1X8,
>  		.pixel_enc	= V4L2_PIXEL_ENC_BAYER,
>  		.mipi_dt	= RKISP1_CIF_CSI2_DT_RAW8,
>  		.bayer_pat	= RKISP1_RAW_GRBG,
>  		.bus_width	= 8,
> -		.direction	= RKISP1_DIR_SINK | RKISP1_DIR_SRC,
> +		.direction	= RKISP1_ISP_SD_SINK | RKISP1_ISP_SD_SRC,
>  	}, {
>  		.mbus_code	= MEDIA_BUS_FMT_YUYV8_1X16,
>  		.pixel_enc	= V4L2_PIXEL_ENC_YUV,
>  		.mipi_dt	= RKISP1_CIF_CSI2_DT_YUV422_8b,
>  		.yuv_seq	= RKISP1_CIF_ISP_ACQ_PROP_YCBYCR,
>  		.bus_width	= 16,
> -		.direction	= RKISP1_DIR_SINK,
> +		.direction	= RKISP1_ISP_SD_SINK,
>  	}, {
>  		.mbus_code	= MEDIA_BUS_FMT_YVYU8_1X16,
>  		.pixel_enc	= V4L2_PIXEL_ENC_YUV,
>  		.mipi_dt	= RKISP1_CIF_CSI2_DT_YUV422_8b,
>  		.yuv_seq	= RKISP1_CIF_ISP_ACQ_PROP_YCRYCB,
>  		.bus_width	= 16,
> -		.direction	= RKISP1_DIR_SINK,
> +		.direction	= RKISP1_ISP_SD_SINK,
>  	}, {
>  		.mbus_code	= MEDIA_BUS_FMT_UYVY8_1X16,
>  		.pixel_enc	= V4L2_PIXEL_ENC_YUV,
>  		.mipi_dt	= RKISP1_CIF_CSI2_DT_YUV422_8b,
>  		.yuv_seq	= RKISP1_CIF_ISP_ACQ_PROP_CBYCRY,
>  		.bus_width	= 16,
> -		.direction	= RKISP1_DIR_SINK,
> +		.direction	= RKISP1_ISP_SD_SINK,
>  	}, {
>  		.mbus_code	= MEDIA_BUS_FMT_VYUY8_1X16,
>  		.pixel_enc	= V4L2_PIXEL_ENC_YUV,
>  		.mipi_dt	= RKISP1_CIF_CSI2_DT_YUV422_8b,
>  		.yuv_seq	= RKISP1_CIF_ISP_ACQ_PROP_CRYCBY,
>  		.bus_width	= 16,
> -		.direction	= RKISP1_DIR_SINK,
> +		.direction	= RKISP1_ISP_SD_SINK,
>  	},
>  };
>  
> @@ -570,9 +570,9 @@ static int rkisp1_isp_enum_mbus_code(struct v4l2_subdev *sd,
>  	int pos = 0;
>  
>  	if (code->pad == RKISP1_ISP_PAD_SINK_VIDEO) {
> -		dir = RKISP1_DIR_SINK;
> +		dir = RKISP1_ISP_SD_SINK;
>  	} else if (code->pad == RKISP1_ISP_PAD_SOURCE_VIDEO) {
> -		dir = RKISP1_DIR_SRC;
> +		dir = RKISP1_ISP_SD_SRC;
>  	} else {
>  		if (code->index > 0)
>  			return -EINVAL;
> @@ -657,7 +657,7 @@ static void rkisp1_isp_set_src_fmt(struct rkisp1_isp *isp,
>  
>  	src_fmt->code = format->code;
>  	mbus_info = rkisp1_isp_mbus_info_get(src_fmt->code);
> -	if (!mbus_info || !(mbus_info->direction & RKISP1_DIR_SRC)) {
> +	if (!mbus_info || !(mbus_info->direction & RKISP1_ISP_SD_SRC)) {
>  		src_fmt->code = RKISP1_DEF_SRC_PAD_FMT;
>  		mbus_info = rkisp1_isp_mbus_info_get(src_fmt->code);
>  	}
> @@ -741,7 +741,7 @@ static void rkisp1_isp_set_sink_fmt(struct rkisp1_isp *isp,
>  					  which);
>  	sink_fmt->code = format->code;
>  	mbus_info = rkisp1_isp_mbus_info_get(sink_fmt->code);
> -	if (!mbus_info || !(mbus_info->direction & RKISP1_DIR_SINK)) {
> +	if (!mbus_info || !(mbus_info->direction & RKISP1_ISP_SD_SINK)) {
>  		sink_fmt->code = RKISP1_DEF_SINK_PAD_FMT;
>  		mbus_info = rkisp1_isp_mbus_info_get(sink_fmt->code);
>  	}
> diff --git a/drivers/staging/media/rkisp1/rkisp1-resizer.c b/drivers/staging/media/rkisp1/rkisp1-resizer.c
> index fa28f4bd65c0..137298b77341 100644
> --- a/drivers/staging/media/rkisp1/rkisp1-resizer.c
> +++ b/drivers/staging/media/rkisp1/rkisp1-resizer.c
> @@ -542,7 +542,7 @@ static void rkisp1_rsz_set_sink_fmt(struct rkisp1_resizer *rsz,
>  					    which);
>  	sink_fmt->code = format->code;
>  	mbus_info = rkisp1_isp_mbus_info_get(sink_fmt->code);
> -	if (!mbus_info || !(mbus_info->direction & RKISP1_DIR_SRC)) {
> +	if (!mbus_info || !(mbus_info->direction & RKISP1_ISP_SD_SRC)) {
>  		sink_fmt->code = RKISP1_DEF_FMT;
>  		mbus_info = rkisp1_isp_mbus_info_get(sink_fmt->code);
>  	}
> -- 
> 2.17.1
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
