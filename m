Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0C213B7CC0
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 06:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232790AbhF3Ebo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 30 Jun 2021 00:31:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54250 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbhF3Ebo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Jun 2021 00:31:44 -0400
Received: from [222.129.34.206] (helo=[192.168.1.18])
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <aaron.ma@canonical.com>)
        id 1lyRqb-0003QF-SV; Wed, 30 Jun 2021 04:29:14 +0000
To:     lyude@redhat.com, jani.nikula@intel.com, airlied@linux.ie,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        daniel@ffwll.ch, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
References: <20210519095305.47133-1-aaron.ma@canonical.com>
 <57b373372cb64e8a48d12e033a23e7711332b0ec.camel@redhat.com>
From:   Aaron Ma <aaron.ma@canonical.com>
Subject: Re: [PATCH] drm/i915: Force DPCD backlight mode for Samsung 16727
 panel
Message-ID: <33f42229-780f-9b4e-69db-db3fad32bf3a@canonical.com>
Date:   Wed, 30 Jun 2021 12:29:05 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <57b373372cb64e8a48d12e033a23e7711332b0ec.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg:

Could this patch get a chance to be applied on stable kernel?
It only for 5.11- kernel, not for Linus' tree.

Thanks,
Aaron

On 5/20/21 12:27 AM, Lyude Paul wrote:
> Seems reasonable to me:
>
> Reviewed-by: Lyude Paul <lyude@redhat.com>
>
> On Wed, 2021-05-19 at 17:53 +0800, Aaron Ma wrote:
>> Another Samsung OLED panel needs DPCD to get control of backlight.
>> Kernel 5.12+ support the backlight via:
>> commit: <4a8d79901d5b> ("drm/i915/dp: Enable Intel's HDR backlight interface
>> (only SDR for now)")
>> Only make backlight work on lower versions of kernel.
>>
>> Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/3474
>> Cc: stable@vger.kernel.org # 5.11-
>> Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
>> ---
>>   drivers/gpu/drm/drm_dp_helper.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/gpu/drm/drm_dp_helper.c b/drivers/gpu/drm/drm_dp_helper.c
>> index 5bd0934004e3..7b91d8a76cd6 100644
>> --- a/drivers/gpu/drm/drm_dp_helper.c
>> +++ b/drivers/gpu/drm/drm_dp_helper.c
>> @@ -1960,6 +1960,7 @@ static const struct edid_quirk edid_quirk_list[] = {
>>          { MFG(0x4d, 0x10), PROD_ID(0xe6, 0x14),
>> BIT(DP_QUIRK_FORCE_DPCD_BACKLIGHT) },
>>          { MFG(0x4c, 0x83), PROD_ID(0x47, 0x41),
>> BIT(DP_QUIRK_FORCE_DPCD_BACKLIGHT) },
>>          { MFG(0x09, 0xe5), PROD_ID(0xde, 0x08),
>> BIT(DP_QUIRK_FORCE_DPCD_BACKLIGHT) },
>> +       { MFG(0x4c, 0x83), PROD_ID(0x57, 0x41),
>> BIT(DP_QUIRK_FORCE_DPCD_BACKLIGHT) },
>>   };
>>   
>>   #undef MFG


