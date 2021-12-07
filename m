Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 484FE46BD3D
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 15:07:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233045AbhLGOLA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 09:11:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232979AbhLGOK7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 09:10:59 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AEE5C061574;
        Tue,  7 Dec 2021 06:07:29 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id l7so27680257lja.2;
        Tue, 07 Dec 2021 06:07:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lJQIRwsjkZEXbwzLzd39gaDLY4c1jN1Jzr2fT+gRzoo=;
        b=X7Mow1MF701sh2MYATVC08oUkjkjDSSqzKXJkkm6TbgcqHm3IbYo9egi0QSjkeMpfN
         pCGLJqoULwaYTH0LVdkY5GIJYwwTdEnTi/7JOJNem+J7g4iNfXlukqVnniIsbaOi6KKY
         uUD5DZlhYDmILqLOGiTfKTxSj9HECq+cjSg2rWKNUr73r4MDU7zPPhJp50/r9hHpDRUQ
         fYnYgtnlVj8vfox/oql6GQppDOR13j0OQotbXt2r3lyXLMvdza/PcQ00AV4gKoqV2y8V
         zP7p0KPUrHQ8PlFJOnBxI+ArYzc23zLgo/hl9ecHbz4oeJ1cEMVnpR6p/nSpDqnDjhhB
         cX8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lJQIRwsjkZEXbwzLzd39gaDLY4c1jN1Jzr2fT+gRzoo=;
        b=ml/hGrqpoC1JgamCn1j5FnhxGSI6jSrxi3NBZfvDgMMugLFlErQcZdqmeYT5bN2Adz
         /YyoOYjmSsSKMySUEAVK+1geaZ4uDCoScdV0NF8OZ8lUghTjFch7XWj8g+QyO+F15AXs
         UxYFPYx3dHd1fwHMEm70VAADDD0sPnH8YLwdlZi+VRut8lM92nYGp/PQHQKXkQ2OiRmb
         o81UJmpka1h/lcqQ6OSoFbQzU/WaW26oP/A1hUZOK/lqiKnbD+jlHZM5lzy3pvLrFL2a
         95hX8rhESiPvWzIF2y6Xw7CDCIKy0K9v8uKPY88ibOFwZsgPVdRPSiv/DIHzxWvRK10S
         kw3g==
X-Gm-Message-State: AOAM532a1VKLWPvTu1lgkGuqOI4BznZL4ViRO/HcFXt1tKhPoyDFaWAl
        nfI/AJCDFGvSuM9RZhr9fCw=
X-Google-Smtp-Source: ABdhPJwzhtGd5aUdaqo36sCrgV4k2hE+7JskRwIN6JedpeQyMg15GdGn3ThfyMrWgn9Gl+WryPjQ5A==
X-Received: by 2002:a2e:9bd4:: with SMTP id w20mr42417463ljj.69.1638886047429;
        Tue, 07 Dec 2021 06:07:27 -0800 (PST)
Received: from [192.168.2.145] (94-29-46-111.dynamic.spd-mgts.ru. [94.29.46.111])
        by smtp.googlemail.com with ESMTPSA id a7sm1697292lfi.149.2021.12.07.06.07.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Dec 2021 06:07:26 -0800 (PST)
Subject: Re: [PATCH 1/3] ALSA: hda/tegra: Skip reset on BPMP devices
To:     Sameer Pujar <spujar@nvidia.com>, tiwai@suse.com,
        broonie@kernel.org, lgirdwood@gmail.com, robh+dt@kernel.org,
        thierry.reding@gmail.com, perex@perex.cz
Cc:     jonathanh@nvidia.com, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mohan Kumar <mkumard@nvidia.com>
References: <1638858770-22594-1-git-send-email-spujar@nvidia.com>
 <1638858770-22594-2-git-send-email-spujar@nvidia.com>
 <7742adae-cdbe-a9ea-2cef-f63363298d73@gmail.com>
 <8fd704d9-43ce-e34a-a3c0-b48381ef0cd8@nvidia.com>
 <56bb43b6-8d72-b1de-4402-a2cb31707bd9@gmail.com>
 <4855e9c4-e4c2-528b-c9ad-2be7209dc62a@nvidia.com>
From:   Dmitry Osipenko <digetx@gmail.com>
Message-ID: <5d441571-c1c2-5433-729f-86d6396c2853@gmail.com>
Date:   Tue, 7 Dec 2021 17:07:26 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <4855e9c4-e4c2-528b-c9ad-2be7209dc62a@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

07.12.2021 15:40, Sameer Pujar пишет:
> 
> 
> On 12/7/2021 5:35 PM, Dmitry Osipenko wrote:
>> External email: Use caution opening links or attachments
>>
>>
>> 07.12.2021 15:00, Sameer Pujar пишет:
>>>
>>> On 12/7/2021 3:52 PM, Dmitry Osipenko wrote:
>>>> 07.12.2021 09:32, Sameer Pujar пишет:
>>>>> HDA regression is recently reported on Tegra194 based platforms.
>>>>> This happens because "hda2codec_2x" reset does not really exist
>>>>> in Tegra194 and it causes probe failure. All the HDA based audio
>>>>> tests fail at the moment. This underlying issue is exposed by
>>>>> commit c045ceb5a145 ("reset: tegra-bpmp: Handle errors in BPMP
>>>>> response") which now checks return code of BPMP command response.
>>>>>
>>>>> The failure can be fixed by avoiding above reset in the driver,
>>>>> but the explicit reset is not necessary for Tegra devices which
>>>>> depend on BPMP. On such devices, BPMP ensures reset application
>>>>> during unpowergate calls. Hence skip reset on these devices
>>>>> which is applicable for Tegra186 and later.
>>>> The power domain is shared with the display, AFAICS. The point of reset
>>>> is to bring h/w into predictable state. It doesn't make sense to me to
>>>> skip the reset.
>>> Yes the power-domain is shared with display. As mentioned above,
>>> explicit reset in driver is not really necessary since BPMP is already
>>> doing it during unpowergate stage. So the h/w is already ensured to be
>>> in a good state.
>> If you'll reload the driver module, then h/w won't be reset.
> 
> How the reload case would be different? Can you please specify more
> details if you are referring to a particular scenario?

You have a shared power domain. Since power domain can be turned off
only when nobody keeps domain turned on, you now making reset of HDA
controller dependent on the state of display driver. Do you want to have
inconsistent h/w reset behaviour depending on the runtime state of
display driver?
