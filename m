Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2C13B6DD4
	for <lists+stable@lfdr.de>; Tue, 29 Jun 2021 07:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbhF2FOg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 29 Jun 2021 01:14:36 -0400
Received: from mga04.intel.com ([192.55.52.120]:55906 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229969AbhF2FOg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Jun 2021 01:14:36 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10029"; a="206261755"
X-IronPort-AV: E=Sophos;i="5.83,308,1616482800"; 
   d="scan'208";a="206261755"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2021 22:12:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,308,1616482800"; 
   d="scan'208";a="625502307"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga005.jf.intel.com with ESMTP; 28 Jun 2021 22:12:08 -0700
Received: from shsmsx603.ccr.corp.intel.com (10.109.6.143) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Mon, 28 Jun 2021 22:12:07 -0700
Received: from shsmsx603.ccr.corp.intel.com (10.109.6.143) by
 SHSMSX603.ccr.corp.intel.com (10.109.6.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Tue, 29 Jun 2021 13:12:05 +0800
Received: from shsmsx603.ccr.corp.intel.com ([10.109.6.143]) by
 SHSMSX603.ccr.corp.intel.com ([10.109.6.143]) with mapi id 15.01.2242.008;
 Tue, 29 Jun 2021 13:12:05 +0800
From:   "Zhang, Rui" <rui.zhang@intel.com>
To:     Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "amitk@kernel.org" <amitk@kernel.org>
CC:     "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [UPDATE][PATCH] thermal: int340x: processor_thermal: Fix tcc
 setting
Thread-Topic: [UPDATE][PATCH] thermal: int340x: processor_thermal: Fix tcc
 setting
Thread-Index: AQHXbGiwqq3P26te60OZFhNIzULFPqsqcalQ
Date:   Tue, 29 Jun 2021 05:12:05 +0000
Message-ID: <553943329ddf452c80c15fc6cdded366@intel.com>
References: <20210628215803.75038-1-srinivas.pandruvada@linux.intel.com>
In-Reply-To: <20210628215803.75038-1-srinivas.pandruvada@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [10.239.127.36]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----Original Message-----
> From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
> Sent: Tuesday, June 29, 2021 5:58 AM
> To: daniel.lezcano@linaro.org; Zhang, Rui <rui.zhang@intel.com>;
> amitk@kernel.org
> Cc: linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org; Srinivas
> Pandruvada <srinivas.pandruvada@linux.intel.com>; stable@vger.kernel.org
> Subject: [UPDATE][PATCH] thermal: int340x: processor_thermal: Fix tcc setting
> Importance: High
> 
> The following fixes are done for tcc sysfs interface:
> - TCC is 6 bits only from bit 29-24
> - TCC of 0 is valid
> - When BIT(31) is set, this register is read only
> - Check for invalid tcc value
> - Error for negative values
> 
> Fixes: fdf4f2fb8e899 ("drivers: thermal: processor_thermal_device:
> Export sysfs interface for TCC offset"
> Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
> Cc: stable@vger.kernel.org

Acked-by: Zhang Rui <rui.zhang@intel.com>
> ---
> Update
> 	Added Fixes tag and cc to stable
> 
>  .../processor_thermal_device.c                | 20 +++++++++++--------
>  1 file changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c
> b/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c
> index de4fc640deb0..0f0038af2ad4 100644
> --- a/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c
> +++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c
> @@ -78,24 +78,27 @@ static ssize_t tcc_offset_degree_celsius_show(struct
> device *dev,
>  	if (err)
>  		return err;
> 
> -	val = (val >> 24) & 0xff;
> +	val = (val >> 24) & 0x3f;
>  	return sprintf(buf, "%d\n", (int)val);  }
> 
> -static int tcc_offset_update(int tcc)
> +static int tcc_offset_update(unsigned int tcc)
>  {
>  	u64 val;
>  	int err;
> 
> -	if (!tcc)
> +	if (tcc > 63)
>  		return -EINVAL;
> 
>  	err = rdmsrl_safe(MSR_IA32_TEMPERATURE_TARGET, &val);
>  	if (err)
>  		return err;
> 
> -	val &= ~GENMASK_ULL(31, 24);
> -	val |= (tcc & 0xff) << 24;
> +	if (val & BIT(31))
> +		return -EPERM;
> +
> +	val &= ~GENMASK_ULL(29, 24);
> +	val |= (tcc & 0x3f) << 24;
> 
>  	err = wrmsrl_safe(MSR_IA32_TEMPERATURE_TARGET, val);
>  	if (err)
> @@ -104,14 +107,15 @@ static int tcc_offset_update(int tcc)
>  	return 0;
>  }
> 
> -static int tcc_offset_save;
> +static unsigned int tcc_offset_save;
> 
>  static ssize_t tcc_offset_degree_celsius_store(struct device *dev,
>  				struct device_attribute *attr, const char *buf,
>  				size_t count)
>  {
> +	unsigned int tcc;
>  	u64 val;
> -	int tcc, err;
> +	int err;
> 
>  	err = rdmsrl_safe(MSR_PLATFORM_INFO, &val);
>  	if (err)
> @@ -120,7 +124,7 @@ static ssize_t tcc_offset_degree_celsius_store(struct
> device *dev,
>  	if (!(val & BIT(30)))
>  		return -EACCES;
> 
> -	if (kstrtoint(buf, 0, &tcc))
> +	if (kstrtouint(buf, 0, &tcc))
>  		return -EINVAL;
> 
>  	err = tcc_offset_update(tcc);
> --
> 2.27.0

