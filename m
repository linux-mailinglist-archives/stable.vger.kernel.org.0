Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE48353306
	for <lists+stable@lfdr.de>; Sat,  3 Apr 2021 09:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232161AbhDCHwx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Apr 2021 03:52:53 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:46069 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232157AbhDCHwx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Apr 2021 03:52:53 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 2155AEBD;
        Sat,  3 Apr 2021 03:52:50 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 03 Apr 2021 03:52:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=LpBqOIn5u2gF3QrQ7oMvv1w2fD5
        hVTILKFdHdVI/0ZA=; b=NWSmpFamykyRybFYcFvsqQiDu3T7iWMCotquAhhKfqB
        JL7nAPupKvuBOS/w23+7oTAZFuPzcBi7CMQqBDFrOb2Pv2l5MjYh86GiTRb/lWYg
        MhH8EYn5UEppGrOCnMWp0Ush6v4o45/ddH/8X5tZJFh8FFid+OA05eLVbvtSfpoU
        dgEEuWdyqPV7HhWKKv9IEEI/pmQwT4qEZZrKxHbIa4ZxK1rHDxG3VtgoeV57k7Sf
        UNDyySB1sQzvRjuaG+HZkLINWhkeHPowriWHcLLd55AUaEzPx28E52T805ZLicF1
        oOq1S8rAI1/tcjf1k5D0k+kKGf3trtG4tnfsvagu55Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=LpBqOI
        n5u2gF3QrQ7oMvv1w2fD5hVTILKFdHdVI/0ZA=; b=vf1GM1jHRohs+jFuKAkNyb
        m2vqyMt3ys9z0ZrFcViVQR9kahYXFNlzHugLjDsfg6fMAwoxInznT/y1DInkkLgI
        HQYrMuTw81zeVsUHhQWy2grcxCKdn0dINRJs2AGz4iHPTdoigh+OJhyEYchO0v8N
        gAKjvOV/RiYf1y/ZL38jvCIgmvRGU8iRb5AoPLxG8uEwGxbb0hyzauEQhzvI+CEd
        NQllDreWTQV1byNzRQKasGkz4nNrUFscDoFCIdtKJU7VO15kCRTJWT0alVeH5RWz
        4zN9ec1+JXRV54yHScmD+kPffEp2aodI7AMfnTfjcXrJIqpaHlQQPxeZnM/theAA
        ==
X-ME-Sender: <xms:0R5oYHAPRRYUkgkSwEQKZ1OadfEIyZSg_tKkO8NcgP-crsj2RY4-Vg>
    <xme:0R5oYNhOfCocdCx-w1qIOSchK2s1AZk6jFe2jWopQxUpUpfI_6kmIpB0kA6XrUi11
    _UR4fQOfF9aMw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudeijedguddvgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuhe
    ejgfffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:0R5oYCn6Q7xEoZrCin7o0ISzIU4_6J8Jvu-x9bmVDQ1IlSmBkiklTA>
    <xmx:0R5oYJzFYazJpKMER6NcccQf2YguL1RnJ2cLduyLt8o290mnE-v3Fg>
    <xmx:0R5oYMQPP-0QQK9Sg9oei8R2Sw5KXjawApsxx_y69uxF6EFnd5_3Wg>
    <xmx:0R5oYCOhPs0vmP9gIrwl4cBayLQBL6l6IAPCIgFxD3GbAxeFibp2zw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 334A81080064;
        Sat,  3 Apr 2021 03:52:49 -0400 (EDT)
Date:   Sat, 3 Apr 2021 09:52:46 +0200
From:   Greg KH <greg@kroah.com>
To:     Gwendal Grignou <gwendal@chromium.org>
Cc:     bleung@chromium.org, enric.balletbo@collabora.com,
        groeck@chromium.org, linux-kernel@vger.kernel.org,
        Gwendal Grignou <gwendal@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH] platform/chrome: Update cros_ec sysfs attributes on
 sensors discovery
Message-ID: <YGgezmIRoxtVF4f7@kroah.com>
References: <20210403062031.1820582-1-gwendal@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210403062031.1820582-1-gwendal@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 02, 2021 at 11:20:31PM -0700, Gwendal Grignou wrote:
> When cros_ec_sysfs probe is called before cros_ec_sensorhub probe
> routine, the |kb_wake_angle| attribute will not be displayed, even if
> there are two accelerometers in the chromebook.
> 
> Call sysfs_update_group() when accelerometers are enumerated if the
> cros_ec sysfs attributes group has already been created.
> 
> Fixes: d60ac88a62df ("mfd / platform / iio: cros_ec: Register sensor through sensorhub")
> Cc: stable@vger.kernel.org
> Signed-off-by: Gwendal Grignou <gwendal@google.com>
> ---
>  drivers/platform/chrome/cros_ec_sensorhub.c | 5 ++++-
>  drivers/platform/chrome/cros_ec_sysfs.c     | 2 ++
>  include/linux/platform_data/cros_ec_proto.h | 2 ++
>  3 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/platform/chrome/cros_ec_sensorhub.c b/drivers/platform/chrome/cros_ec_sensorhub.c
> index 9c4af76a9956e..78085ad362ca8 100644
> --- a/drivers/platform/chrome/cros_ec_sensorhub.c
> +++ b/drivers/platform/chrome/cros_ec_sensorhub.c
> @@ -106,8 +106,11 @@ static int cros_ec_sensorhub_register(struct device *dev,
>  		sensor_type[sensorhub->resp->info.type]++;
>  	}
>  
> -	if (sensor_type[MOTIONSENSE_TYPE_ACCEL] >= 2)
> +	if (sensor_type[MOTIONSENSE_TYPE_ACCEL] >= 2) {
>  		ec->has_kb_wake_angle = true;
> +		if (ec->group)
> +			sysfs_update_group(&ec->class_dev.kobj, ec->group);
> +	}
>  
>  	if (cros_ec_check_features(ec,
>  				   EC_FEATURE_REFINED_TABLET_MODE_HYSTERESIS)) {
> diff --git a/drivers/platform/chrome/cros_ec_sysfs.c b/drivers/platform/chrome/cros_ec_sysfs.c
> index f07eabcf9494c..3838d5f51aadc 100644
> --- a/drivers/platform/chrome/cros_ec_sysfs.c
> +++ b/drivers/platform/chrome/cros_ec_sysfs.c
> @@ -344,6 +344,8 @@ static int cros_ec_sysfs_probe(struct platform_device *pd)
>  	ret = sysfs_create_group(&ec_dev->class_dev.kobj, &cros_ec_attr_group);

This is odd, the platform/driver core should be creating these files,
you should never have to do this "by hand".  If you do it this way, you
are racing with userspace and loosing.

Please set the dev_groups field in the driver structure to be this group
and then all will be fine automatically.

>  	if (ret < 0)
>  		dev_err(dev, "failed to create attributes. err=%d\n", ret);
> +	else
> +		ec_dev->group = &cros_ec_attr_group;
>  
>  	return ret;
>  }
> diff --git a/include/linux/platform_data/cros_ec_proto.h b/include/linux/platform_data/cros_ec_proto.h
> index 02599687770c5..4cd06f68bc536 100644
> --- a/include/linux/platform_data/cros_ec_proto.h
> +++ b/include/linux/platform_data/cros_ec_proto.h
> @@ -191,6 +191,7 @@ struct cros_ec_platform {
>  /**
>   * struct cros_ec_dev - ChromeOS EC device entry point.
>   * @class_dev: Device structure used in sysfs.
> + * @group: sysfs attributes group for this EC.
>   * @ec_dev: cros_ec_device structure to talk to the physical device.
>   * @dev: Pointer to the platform device.
>   * @debug_info: cros_ec_debugfs structure for debugging information.
> @@ -200,6 +201,7 @@ struct cros_ec_platform {
>   */
>  struct cros_ec_dev {
>  	struct device class_dev;
> +	struct attribute_group *group;

This should not be needed.

thanks,

greg k-h
