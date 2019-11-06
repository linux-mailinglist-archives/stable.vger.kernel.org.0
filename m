Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28F5EF128A
	for <lists+stable@lfdr.de>; Wed,  6 Nov 2019 10:41:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727363AbfKFJlk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Nov 2019 04:41:40 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:59284 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726192AbfKFJlk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Nov 2019 04:41:40 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 5F7D11C0930; Wed,  6 Nov 2019 10:41:38 +0100 (CET)
Date:   Wed, 6 Nov 2019 10:41:38 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Pascal Bouwmann <bouwmann@tau-tec.de>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 059/149] iio: fix center temperature of
 bmc150-accel-core
Message-ID: <20191106094138.62qkvhfpyf5brits@ucw.cz>
References: <20191104212126.090054740@linuxfoundation.org>
 <20191104212140.681522108@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191104212140.681522108@linuxfoundation.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> From: Pascal Bouwmann <bouwmann@tau-tec.de>
> 
> [ Upstream commit 6c59a962e081df6d8fe43325bbfabec57e0d4751 ]
> 
> The center temperature of the supported devices stored in the constant
> BMC150_ACCEL_TEMP_CENTER_VAL is not 24 degrees but 23 degrees.
> 
> It seems that some datasheets were inconsistent on this value leading
> to the error.  For most usecases will only make minor difference so
> not queued for stable.
> 
> Signed-off-by: Pascal Bouwmann <bouwmann@tau-tec.de>
> Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Minor miscalibration, and author specifically states it should not be
queued for stable. Yet, Sasha goes and queues it for stable. Why?

       	   	   	      	       	      	     	     Pavel

> +++ b/drivers/iio/accel/bmc150-accel-core.c
> @@ -125,7 +125,7 @@
>  #define BMC150_ACCEL_SLEEP_1_SEC		0x0F
>  
>  #define BMC150_ACCEL_REG_TEMP			0x08
> -#define BMC150_ACCEL_TEMP_CENTER_VAL		24
> +#define BMC150_ACCEL_TEMP_CENTER_VAL		23
>  
>  #define BMC150_ACCEL_AXIS_TO_REG(axis)	(BMC150_ACCEL_REG_XOUT_L + (axis * 2))
>  #define BMC150_AUTO_SUSPEND_DELAY_MS		2000
> -- 
> 2.20.1
> 
> 
