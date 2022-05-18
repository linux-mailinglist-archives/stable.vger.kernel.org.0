Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9561E52C838
	for <lists+stable@lfdr.de>; Thu, 19 May 2022 01:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231671AbiERX4t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 19:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231771AbiERX4n (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 19:56:43 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52B74A2074
        for <stable@vger.kernel.org>; Wed, 18 May 2022 16:56:41 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id s3so4974031edr.9
        for <stable@vger.kernel.org>; Wed, 18 May 2022 16:56:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:in-reply-to:from:cc:content-transfer-encoding;
        bh=nV7vbEcI/XlaN5+VOLvyZmnBK7oHA+94fUbYDalX+ow=;
        b=Xhcvf84CjweMLL5bEmvyJQalKl6YNdbwCMuVsD/bwVXG5FP2PzcaN2o8tkB/sKDHrv
         4z4mpmrbKrzjiNLpGpza9k2LDVwkk/8zYta5/n1Be8fz/VlOLtmMZC6NySl3GJljcBFB
         aHrJQeJvRBk91wBRVLZu3yKLY5iNSy5HUYecn44ilT5uykd+reZruSMYc3rxYgxKc1v8
         ocbGHugiii15/UT2buIDBBkN9RfEEvhIZs0hIw5XRwOy0b/QF5SqNGF07hjgVOVUosDU
         OhyQdUWR9reEQo0RzucxZhgHF7A79mYIxgA3ZHPWnWCEdaWLoO8ShNQopdi/s87+UEMJ
         i9eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:in-reply-to:from:cc
         :content-transfer-encoding;
        bh=nV7vbEcI/XlaN5+VOLvyZmnBK7oHA+94fUbYDalX+ow=;
        b=Kddkd+TuPuITr+oR6z+4DUwPfNgSvAUXOHTAE/HuIYox2tPc7JegKvNePGoWrZCxZD
         ebkuXlPqr3oodOoxN3puPGsLMM1aXFO+Dm3VMlaN/ZpTuTrLdffRyqw+6qB7A5X0Lgs3
         Xn9IQbcjbbGd4HF2Iwo5+7H0hyJPcJVu6DM/ZYt7OS4b7jx9k45egOFDuHpedRV28jEk
         mpxHNKfppXy9XaB3Zgh291n3VGNjO9IAgeS7BAK+uV1QdbEB5kvz8aW7OC6QufzVYULB
         iyAAwlpySOVQJss8KacqAzwABn5fvJDI+tZy5h6LKwYNOb9ptunK75Fp6nxC0Jdn10R9
         0daw==
X-Gm-Message-State: AOAM532R5K+TmV3FleFJVUtcOG/n7NQOPVyu42PnZetMXUEcEaeO5lih
        ecGW+sZKu+xG86s+MgFrQy0=
X-Google-Smtp-Source: ABdhPJwRaIq1zP7CRaqPrY9231XvaBM0upXxl8n1QRhbOu8FEjEcHM1JzbgIIGJHKlevgoGNXPd8QQ==
X-Received: by 2002:a05:6402:26ca:b0:427:c181:b0ed with SMTP id x10-20020a05640226ca00b00427c181b0edmr2396526edd.400.1652918198706;
        Wed, 18 May 2022 16:56:38 -0700 (PDT)
Received: from [192.168.1.110] ([178.233.88.73])
        by smtp.gmail.com with ESMTPSA id s27-20020a170906221b00b006f3ef214e73sm1474465ejs.217.2022.05.18.16.56.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 May 2022 16:56:38 -0700 (PDT)
Message-ID: <5a0e9339-5bdc-3e05-08f4-9137ebeb5ce5@gmail.com>
Date:   Thu, 19 May 2022 02:56:34 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH] ASoC: ops: Fix the bounds checking in
 snd_soc_put_volsw_sx and snd_soc_put_xr_sx
Content-Language: en-US
To:     Mark Brown <broonie@kernel.org>
References: <fde0dc8a-a861-3c8e-1316-cfa81affc19e@gmail.com>
 <YoThkxU9Q2cDrq4v@sirena.org.uk>
In-Reply-To: <YoThkxU9Q2cDrq4v@sirena.org.uk>
From:   =?UTF-8?Q?Tan_Nay=c4=b1r?= <tannayir@gmail.com>
Cc:     alsa-devel@alsa-project.org, stable@vger.kernel.org,
        Marek Vasut <marex@denx.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

For a control defined like this:
-- SOC_SINGLE_S8_TLV("IIR0 INP0 Volume", 
WCD934X_CDC_SIDETONE_IIR0_IIR_GAIN_B1_CTL, -84, 40, digital_gain) --
This is what the snd_soc_info_volsw_sx reports:
$mc->platform_max:40, $mc->max:40, $mc->min:-84,
$uinfo->value.integer.max:40, $uinfo->value.integer.min:0

Now this is obviously wrong which is another issue which I'll explain a 
bit later
but the mixer control($mc) limits are exactly the same inside
the snd_soc_put_volsw_sx function.
So the min and max fields inside the $mc are the same in 
snd_soc_put_volsw_sx
so this means that the code without my patch has an incorrect check.

Here's an example, this is the check before the patch:
-- if (mc->platform_max && val > mc->platform_max) --
Let's say the userspace passes 50 as $val which should be within the 
range of
0 to 124 so it is a valid value.
The check is done before the val is re-scaled, so it checks whether the val
is bigger than 40 which is the value of platform_max at that point.

Is the $mc->platform_max supposed to be set to the number of steps
as opposed to the maximum value?

Back to the first issue that I've mentioned in this message, the 
snd_soc_info_volsw_sx
reports the wrong value because it adds the $mc->min to the value which 
not necessary.
Curiously enough, there are actually two commits from 6 years ago
on the Qualcomm's fork of Linux that fix this one.
Neither of these commits exist on the upstream Linux kernel at the 
moment. I've linked them below.

For the sake of integrity, all of the values that I've gathered from 
debugging
were the same before and after applying these patches.
What I mean by that is that the only thing that changes when the patches 
below are applied
is that the snd_soc_info_volsw_sx reports the correct range to the userspace
which should be 0 to 124.
Also the snd_soc_put_volsw_sx still checks the value from userspace
which has a range of 0 to 124 against the maximum of the signed range
which is from -84 to 40 regardless of the patches below.

65c7d020fbee8 ("ASoC: Update the Max value of integer controls.")
https://git.codelinaro.org/clo/la/kernel/msm-4.9/-/commit/65c7d020fbee8070f33072291c32eef7584a56d4

0d873de90eb16 ("ASoC: sound: soc: fix incorrect max value")
https://git.codelinaro.org/clo/la/kernel/msm-4.9/-/commit/0d873de90eb16e3af499eb87da1ed14440b788d5

