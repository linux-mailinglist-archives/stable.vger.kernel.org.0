Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3EC74F0008
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 11:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353940AbiDBJQz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 05:16:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350640AbiDBJQy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 05:16:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1CD4C7678
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 02:15:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648890902;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FXdqP9zE7LBfSRWNpgzsUsb+Q78+F/WT2YIOnHUTmfQ=;
        b=NUnrhFXp7iA/wyphM8RM4egembC3nsFZ/fLxwyMQPMjsTdKf7xJSoBsvK+jhsCrzrqQ8lr
        h7viaqZKuqbCzAvVOSNv53cHn5lWktUgkHjFFcoi8/C3IhwpNWoV2sm/rUom4asL4oPuOR
        9TDJvX17np7y9qoTZYndTwLdwG1Xm9E=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-480-fpcoeNiNPpqVqaDPHVXb1w-1; Sat, 02 Apr 2022 05:15:01 -0400
X-MC-Unique: fpcoeNiNPpqVqaDPHVXb1w-1
Received: by mail-ed1-f69.google.com with SMTP id q25-20020a50aa99000000b004192a64d410so2727373edc.16
        for <stable@vger.kernel.org>; Sat, 02 Apr 2022 02:15:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=FXdqP9zE7LBfSRWNpgzsUsb+Q78+F/WT2YIOnHUTmfQ=;
        b=cy4bOklGjyvZFPb9I0u8ZtCSNKPp4gCX3eJD5wQ0stpUyBVbEo0u3Tw4Q1yG9EUEJm
         /2MPYJQbgzaBwvLjRQpCEd11T03HR5/gb9DbaRJMQfLVaEdTL94A0SfvRWSzksocZQSv
         /vx/wHKEllUzCTW77H01+0zw2UgBJOMpIsW9IU0CdonYuIfYjky6XzuT72vcUtwqaMpA
         OZylYRJqB8KlJq13gqAArbODNs5fQOVrjHNq/mLlq9O86dd2Id9qe9LLP1hqgjm95Gyd
         IuGG31a8DGhtYnYTk59/dkTr1SjWlDNTmZUEq6xEV0RMqiVxtcCnR8ICk1bwtZd2wDmH
         ANUA==
X-Gm-Message-State: AOAM5301zHfmLFmHtrB2v6W4mSlmpVrijrx6kA/wELd4prT1hdSlhu5U
        d4klQhzEvdT0glxcDXW5tKHLu3ACGoU+hWDJ8c2CkQhMl2B7Lpq7fZHfFi5kAd86AmEMJCDuVkr
        ObVJF4dmvkYp4UZ+y
X-Received: by 2002:a17:906:4786:b0:6e0:c7b:d267 with SMTP id cw6-20020a170906478600b006e00c7bd267mr3133447ejc.115.1648890899882;
        Sat, 02 Apr 2022 02:14:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwmctKj/v9mEgm3bFTAayqwUgHbGVFGNbKm1A5bUq5M707BxXCi0ZcxpQ4c72TKk4YGOmhvSw==
X-Received: by 2002:a17:906:4786:b0:6e0:c7b:d267 with SMTP id cw6-20020a170906478600b006e00c7bd267mr3133435ejc.115.1648890899682;
        Sat, 02 Apr 2022 02:14:59 -0700 (PDT)
Received: from ?IPV6:2001:1c00:c1e:bf00:1db8:22d3:1bc9:8ca1? (2001-1c00-0c1e-bf00-1db8-22d3-1bc9-8ca1.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:1db8:22d3:1bc9:8ca1])
        by smtp.gmail.com with ESMTPSA id d7-20020a50cd47000000b004187eacb4d6sm2229189edj.37.2022.04.02.02.14.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 Apr 2022 02:14:59 -0700 (PDT)
Message-ID: <dcc41ac1-107b-7ada-ff41-da69d94f1274@redhat.com>
Date:   Sat, 2 Apr 2022 11:14:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH AUTOSEL 5.17 001/149] drm: Add orientation quirk for GPD
 Win Max
Content-Language: en-US
To:     Anisse Astier <anisse@astier.eu>, Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jani Nikula <jani.nikula@intel.com>,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        tzimmermann@suse.de, airlied@linux.ie, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org
References: <20220401142536.1948161-1-sashal@kernel.org>
 <YkdhftH7tyPU8Gqt@bilrost>
From:   Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <YkdhftH7tyPU8Gqt@bilrost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 4/1/22 22:33, Anisse Astier wrote:
> Hi Sasha,
> 
> Le Fri, Apr 01, 2022 at 10:23:08AM -0400, Sasha Levin a écrit :
>> From: Anisse Astier <anisse@astier.eu>
>>
>> [ Upstream commit 0b464ca3e0dd3cec65f28bc6d396d82f19080f69 ]
>>
>> Panel is 800x1280, but mounted on a laptop form factor, sideways.
>>
>> Signed-off-by: Anisse Astier <anisse@astier.eu>
>> Reviewed-by: Hans de Goede <hdegoede@redhat.com>
>> Signed-off-by: Jani Nikula <jani.nikula@intel.com>
>> Link: https://patchwork.freedesktop.org/patch/msgid/20211229222200.53128-3-anisse@astier.eu
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> I don't think this patch will be very useful, because it won't fix the
> device's display orientation without the previous patch it came with,
> titled "drm/i915/opregion: add support for mailbox #5 EDID"
> (e35d8762b04f89f9f5a188d0c440d3a2c1d010ed); while I'd like both to be
> added

Well actually it will already put e.g. the text console the right way up
since efifb also uses this quirks and gives a hint to fbcon to rotate
the text. So it is not entirely useless.

And since all quirks added to drivers/gpu/drm/drm_panel_orientation_quirks.c
typically get backported having this one in place now will avoid conflicts
with future backports.

That combined with not really seeing a downside to already having
this in place even without the i915 support being sorted out makes
me lean more towards the direction of believing that having this
in 5.17 is fine...

Regards,

Hans

