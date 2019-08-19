Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2EBB925B9
	for <lists+stable@lfdr.de>; Mon, 19 Aug 2019 16:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727444AbfHSOCU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Aug 2019 10:02:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57152 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727354AbfHSOCT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Aug 2019 10:02:19 -0400
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7CD5C883BA
        for <stable@vger.kernel.org>; Mon, 19 Aug 2019 14:02:19 +0000 (UTC)
Received: by mail-wm1-f70.google.com with SMTP id f14so291202wmh.7
        for <stable@vger.kernel.org>; Mon, 19 Aug 2019 07:02:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PUIjNZIKR9LCnddltfWlb7W4sRr7FHdtzbFD6nc+9Kw=;
        b=Y5f0j9k/5qUbxuG2T1SvkHpJ2bimDm1MVI2BEEAj/9ggsba6MWovXHIIMteT2oYmEv
         YpQMC+Ywd2qubRxd1GXSfOVMJoR2YIOXZ22XJNWGbRbCRdTBssse5lOL84khekcrO81/
         HQpgVSd1cADkjmCErXdnSdE0D4QWadTRsMI4nHVy/Q1zEEUX4yxQj7lguSA3hr9OoCgJ
         RNSu3FfIrp2dEn9sSUu808M9BjjAIZfrCgILvlG9MW3XFRhZTjLPbDgJZzvj47EvS+YT
         9BEd5fSp4DEd9m4I9DBpFMleCezegbdDo83ccEuBYaWflUO/w1OnVBjMLkk+kdsHJzHo
         gdIQ==
X-Gm-Message-State: APjAAAXPTPGAmxrEJsFaBMLTmfYkeFYdQgRonAwJfWUbYCt/+1Y77i00
        lD87QFpJChs29ytT/3VuSWRLMNYPUFD4ICzUFqW3f/u0TiwNmenZJ9l4yThQ5cPKo1bI11t5839
        ipiWCSml+CBqzr0N/
X-Received: by 2002:a7b:c947:: with SMTP id i7mr21323295wml.77.1566223337909;
        Mon, 19 Aug 2019 07:02:17 -0700 (PDT)
X-Google-Smtp-Source: APXvYqw3IF0kXS9esJmdxJ0xt2LFC6UgPAqOlxQ49z0GzdlVFp83a7DxuX7k+SUbSlwpyckWuDZKNQ==
X-Received: by 2002:a7b:c947:: with SMTP id i7mr21323271wml.77.1566223337666;
        Mon, 19 Aug 2019 07:02:17 -0700 (PDT)
Received: from shalem.localdomain (84-106-84-65.cable.dynamic.v4.ziggo.nl. [84.106.84.65])
        by smtp.gmail.com with ESMTPSA id q20sm48314455wrc.79.2019.08.19.07.02.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Aug 2019 07:02:17 -0700 (PDT)
Subject: Re: [PATCH] efifb: BGRT: Improve efifb_bgrt_sanity_check
To:     Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc:     Peter Jones <pjones@redhat.com>, dri-devel@lists.freedesktop.org,
        linux-fbdev@vger.kernel.org, stable@vger.kernel.org
References: <20190721131918.10115-1-hdegoede@redhat.com>
 <CGME20190817084100epcas3p15bc1b42c02d8d86969a4a403896d6fee@epcas3p1.samsung.com>
 <a94c96de-16a5-7b52-a964-f8974e867a65@redhat.com>
 <9da1b656-4640-fe16-9def-fe6c069ed39e@samsung.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <7a2f6fed-c059-6d56-52e5-326f0e44bc6f@redhat.com>
Date:   Mon, 19 Aug 2019 16:02:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <9da1b656-4640-fe16-9def-fe6c069ed39e@samsung.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 19-08-19 16:01, Bartlomiej Zolnierkiewicz wrote:
> 
> On 8/17/19 10:40 AM, Hans de Goede wrote:
>> Hi,
> 
> Hi Hans,
> 
>> On 21-07-19 15:19, Hans de Goede wrote:
>>> For various reasons, at least with x86 EFI firmwares, the xoffset and
>>> yoffset in the BGRT info are not always reliable.
>>>
>>> Extensive testing has shown that when the info is correct, the
>>> BGRT image is always exactly centered horizontally (the yoffset variable
>>> is more variable and not always predictable).
>>>
>>> This commit simplifies / improves the bgrt_sanity_check to simply
>>> check that the BGRT image is exactly centered horizontally and skips
>>> (re)drawing it when it is not.
>>>
>>> This fixes the BGRT image sometimes being drawn in the wrong place.
>>>
>>> Cc: stable@vger.kernel.org
>>> Fixes: 88fe4ceb2447 ("efifb: BGRT: Do not copy the boot graphics for non native resolutions")
>>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>>
>> ping? I do not see this one in -next yet, what is the status of this
>> patch?
> Patch queued for v5.4, thanks and sorry for the delay.

No problem, thank you all the maintainer work you do on fbdev.

Regards,

Hans

