Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B078A2306AE
	for <lists+stable@lfdr.de>; Tue, 28 Jul 2020 11:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728199AbgG1Jit (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jul 2020 05:38:49 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:21336 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728072AbgG1Jit (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jul 2020 05:38:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595929127;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8nd42wB2B75Djczagy6XPy4IiHftdikBO1IfPmRtaGA=;
        b=QJTAT7FMjl6D+Mfsf/j7uuRUMA+ndkdGV29dmcYGrCq9AuswZRGVY8lVhHZrNHY6SAhv4k
        HBIXCVijlgcYjMVwQumctHNkg20De9TRcmEW9yKWc4vb4nGEgoCJ52sof++lXGur8DE3Wr
        /HgkPsOjzNdBMlzGDM8ny/9uf2Z5uBE=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-235-Dvs4epsgO7ClxHl6zyL6mA-1; Tue, 28 Jul 2020 05:38:45 -0400
X-MC-Unique: Dvs4epsgO7ClxHl6zyL6mA-1
Received: by mail-ej1-f69.google.com with SMTP id a19so1579373ejs.12
        for <stable@vger.kernel.org>; Tue, 28 Jul 2020 02:38:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8nd42wB2B75Djczagy6XPy4IiHftdikBO1IfPmRtaGA=;
        b=ss/OVwIXjyzNaOmZqaw1H/kIweJ9AyUERLPLfJReAZ/s9irxKUwijbOkCM6c8UBYrN
         4tK33oEXCLImbXtL9EEMyY7ZeqQ+hMR7uxalJKAp+SPTGoosFgfU4loa/1e1J/jM5Y75
         4LDsnmzA/2b+YoFdkd7RLPLjI1HObORytc5wETAMCPhFWgPQ8Rzsd/th2Fh3AYLYqJIR
         LASx6hbnRmlUOgwA7UnKJk43lzS1kMXiAkzURs7adVt3zUBQ+/T3ODB7eday/8wRnwch
         AxP2/GtnkScLkeckEL6RvcNejiMERmq/bqngJSrgQ7H9W7pGjEhrXdCNVY22zM2yt7wH
         UzXQ==
X-Gm-Message-State: AOAM5320Bs2beetJZhUuRaNklL7LwTi0ad5u5RlZg0QMcCvDV2YWOqCr
        +iHkMbaM2tOGptWoPxa2ypl7IdUpCl6hp5SOnjQ+kz+TaTNJ9o21e5s8DGp0FmQE9TeQF8mqTvg
        PlVaaGPGi0U4wuSAo
X-Received: by 2002:a05:6402:217:: with SMTP id t23mr12553614edv.224.1595929123922;
        Tue, 28 Jul 2020 02:38:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxJoNVCmgySPilxaRNDDCDGvUaUKF5uAAZf5FZDEAcd7iyP8+uYTky2xv0wvJc6EG6o24sp8w==
X-Received: by 2002:a05:6402:217:: with SMTP id t23mr12553590edv.224.1595929123657;
        Tue, 28 Jul 2020 02:38:43 -0700 (PDT)
Received: from x1.localdomain (2001-1c00-0c0c-fe00-d2ea-f29d-118b-24dc.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:d2ea:f29d:118b:24dc])
        by smtp.gmail.com with ESMTPSA id z101sm9567358ede.6.2020.07.28.02.38.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jul 2020 02:38:43 -0700 (PDT)
Subject: Re: [PATCH] media: uvcvideo: Fix uvc_ctrl_fixup_xu_info() not having
 any effect
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, stable@vger.kernel.org
References: <20200724114823.108237-1-hdegoede@redhat.com>
 <20200727222541.GC15448@pendragon.ideasonboard.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <77593cf5-c3e5-c3ea-a79f-25cb63890e57@redhat.com>
Date:   Tue, 28 Jul 2020 11:38:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200727222541.GC15448@pendragon.ideasonboard.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 7/28/20 12:25 AM, Laurent Pinchart wrote:
> Hi Hans,
> 
> Thank you for the patch.
> 
> On Fri, Jul 24, 2020 at 01:48:23PM +0200, Hans de Goede wrote:
>> uvc_ctrl_add_info() calls uvc_ctrl_get_flags() which will override
>> the fixed-up flags set by uvc_ctrl_fixup_xu_info().
>>
>> This commit fixes this by adding a is_xu argument to uvc_ctrl_add_info()
>> and skipping the uvc_ctrl_get_flags() call for xu ctrls.
>>
>> Note that the xu path has already called uvc_ctrl_get_flags() from
>> uvc_ctrl_fill_xu_info() before calling uvc_ctrl_add_info().
>>
>> This fixes the xu motor controls not working properly on a Logitech
>> 046d:08cc, and presumably also on the other Logitech models which have
>> a quirk for this in the uvc_ctrl_fixup_xu_info() function.
>>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>> ---
>>   drivers/media/usb/uvc/uvc_ctrl.c | 11 ++++++-----
>>   1 file changed, 6 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
>> index e399b9fad757..4bdea5814d6a 100644
>> --- a/drivers/media/usb/uvc/uvc_ctrl.c
>> +++ b/drivers/media/usb/uvc/uvc_ctrl.c
>> @@ -1815,7 +1815,7 @@ static int uvc_ctrl_fill_xu_info(struct uvc_device *dev,
>>   }
>>   
>>   static int uvc_ctrl_add_info(struct uvc_device *dev, struct uvc_control *ctrl,
>> -	const struct uvc_control_info *info);
>> +	const struct uvc_control_info *info, bool is_xu);
>>   
>>   static int uvc_ctrl_init_xu_ctrl(struct uvc_device *dev,
>>   	struct uvc_control *ctrl)
>> @@ -1830,7 +1830,7 @@ static int uvc_ctrl_init_xu_ctrl(struct uvc_device *dev,
>>   	if (ret < 0)
>>   		return ret;
>>   
>> -	ret = uvc_ctrl_add_info(dev, ctrl, &info);
>> +	ret = uvc_ctrl_add_info(dev, ctrl, &info, true);
>>   	if (ret < 0)
>>   		uvc_trace(UVC_TRACE_CONTROL, "Failed to initialize control "
>>   			  "%pUl/%u on device %s entity %u\n", info.entity,
>> @@ -2009,7 +2009,7 @@ int uvc_ctrl_restore_values(struct uvc_device *dev)
>>    * Add control information to a given control.
>>    */
>>   static int uvc_ctrl_add_info(struct uvc_device *dev, struct uvc_control *ctrl,
>> -	const struct uvc_control_info *info)
>> +	const struct uvc_control_info *info, bool is_xu)
>>   {
>>   	int ret = 0;
>>   
>> @@ -2029,7 +2029,8 @@ static int uvc_ctrl_add_info(struct uvc_device *dev, struct uvc_control *ctrl,
>>   	 * default flag values from the uvc_ctrl array when the device doesn't
>>   	 * properly implement GET_INFO on standard controls.
>>   	 */
>> -	uvc_ctrl_get_flags(dev, ctrl, &ctrl->info);
>> +	if (!is_xu)
>> +		uvc_ctrl_get_flags(dev, ctrl, &ctrl->info);
> 
> Would it make sense to instead move this line (and the above comment) to
> uvc_ctrl_init_ctrl(), right after the uvc_ctrl_add_info() call ?

I was thinking about the same lines, since that seems like the
obvious / logical fix. I was thinking about doing it before the
uvc_ctrl_add_info() call, but that will not work, because info
is const before the call.

Doing it after the add_info() call, as you suggest, we can pass
&ctrl->info to the get_flags call. So yes that will work and
is the logical thing to do.

I'll spin a v2 with this change.

> If you
> would prefer keeping it here, I think is_xu should be renamed to
> update_flags (with the true/false values switched) to make it clearer.
> It would then also add a comment to uvc_ctrl_init_xu_ctrl() right before
> the call to uvc_ctrl_add_info() to state that we don't update flags to
> avoid overwriting the value set by uvc_ctrl_fixup_xu_info() in
> uvc_ctrl_fill_xu_info().
> 
> What's your preference ?

See above.

Regards,

Hans



> 
>>   
>>   	ctrl->initialized = 1;
>>   
>> @@ -2252,7 +2253,7 @@ static void uvc_ctrl_init_ctrl(struct uvc_device *dev, struct uvc_control *ctrl)
>>   	for (; info < iend; ++info) {
>>   		if (uvc_entity_match_guid(ctrl->entity, info->entity) &&
>>   		    ctrl->index == info->index) {
>> -			uvc_ctrl_add_info(dev, ctrl, info);
>> +			uvc_ctrl_add_info(dev, ctrl, info, false);
>>   			break;
>>   		 }
>>   	}
> 

