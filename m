Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 739634743FB
	for <lists+stable@lfdr.de>; Tue, 14 Dec 2021 14:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232414AbhLNN4Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 08:56:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbhLNN4Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Dec 2021 08:56:16 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE3B1C061574;
        Tue, 14 Dec 2021 05:56:15 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id u3so36998074lfl.2;
        Tue, 14 Dec 2021 05:56:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ov1iHx+DbaxD+iHI0Gl52GMo9SpDpJ2lnEERZMJTQc0=;
        b=PCN+/1TXNrEnIWgXa9Ms5J/9ctNNSoMaK3CgAZuUEkyNZ5ljmYFglFOkxA7CRow2PB
         +diaiwIvMw9UeUujxgonngIcbHvXYo0BVP0KWlk0gtfON9lMcEXPXUVMrYFXDi7v21xN
         zer5d5ICKk58mX8MqKAwK4ff0FZCqFTrp/SdMMOYi8tBUzeqg7X72Y05OIf3gfqTswBo
         wILCCniRxptpP9q+n2Oqg0VRg1xUyLOhSV+2Qj7HerA8u+uZO4ptYAjYLQb6vQseLUVd
         iCCoI0sXF32rAhNJDFu7p9FqQxg/9GsXrJ1uuzm4E0NzFSaA887IVXBUoAWvfSRMyTvv
         UQFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ov1iHx+DbaxD+iHI0Gl52GMo9SpDpJ2lnEERZMJTQc0=;
        b=Vg3Rj2losi+Lccq++NtIJwtscnlwlafiJEC4ZywyBX/k+kaedhqLiQvsgetPUAfWRf
         AHSOaNBTvNtUKvaMp1UT8FEJrPjejW/LwoyLZPCVuINkwjtOzkaHocteTw0vQQ9h5PO2
         dG8i9FsZquVRs3GI8K7HuvOCYyfPJmbddP+klSTO1plyx7ofodkW1+R9fLmMAwuLA0wy
         Q9IfPbPrQ+rkRkpzyw5gSONWoM3bJmZIGUNqHNJrA0NCOZjiCvLImZMK05zkaYRO+gw0
         kGtC1PO95gCfcs1s7+GI+wE0Vl3hmfhpyLiKo15LBwxfrcVhcDUHIiucDLCv4A4nXhj+
         rtFQ==
X-Gm-Message-State: AOAM531UwR3otFyYgnOa2ew5aC3J7AuyDIexj3sXKucXpk+s7Dh18Xuv
        t7vk374TGIWpJgYb+sBcjNk=
X-Google-Smtp-Source: ABdhPJzir6qiHtR9sVJHfjCLkS//nrIH5PQaLZq8UcVv5KSRk4JLkxpk1YKgGvYjCBPB6t11uHsAqA==
X-Received: by 2002:ac2:5615:: with SMTP id v21mr5340562lfd.112.1639490174001;
        Tue, 14 Dec 2021 05:56:14 -0800 (PST)
Received: from [192.168.2.145] (94-29-63-156.dynamic.spd-mgts.ru. [94.29.63.156])
        by smtp.googlemail.com with ESMTPSA id q24sm1838370lfp.103.2021.12.14.05.56.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Dec 2021 05:56:13 -0800 (PST)
Subject: Re: [PATCH 1/3] ALSA: hda/tegra: Skip reset on BPMP devices
To:     Sameer Pujar <spujar@nvidia.com>, tiwai@suse.com,
        broonie@kernel.org, lgirdwood@gmail.com, thierry.reding@gmail.com,
        perex@perex.cz
Cc:     jonathanh@nvidia.com, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mohan Kumar <mkumard@nvidia.com>, robh+dt@kernel.org
References: <1638858770-22594-1-git-send-email-spujar@nvidia.com>
 <1638858770-22594-2-git-send-email-spujar@nvidia.com>
 <7742adae-cdbe-a9ea-2cef-f63363298d73@gmail.com>
 <8fd704d9-43ce-e34a-a3c0-b48381ef0cd8@nvidia.com>
 <56bb43b6-8d72-b1de-4402-a2cb31707bd9@gmail.com>
 <4855e9c4-e4c2-528b-c9ad-2be7209dc62a@nvidia.com>
 <5d441571-c1c2-5433-729f-86d6396c2853@gmail.com>
 <f32cde65-63dc-67f8-ded8-b58ea5e89f4e@nvidia.com>
 <95cc7efa-251c-690b-9afa-53ee9e052c34@gmail.com>
 <148fba18-5d14-d342-0eb9-4ff224cc58ad@nvidia.com>
 <3b0de739-7866-3886-be9c-a853c746f8b7@gmail.com>
 <73d04377-9898-930b-09db-bb6c4b3eb90a@nvidia.com>
 <ad388f5e-6f60-cf78-8510-87aec8524e33@gmail.com>
 <50bf5a83-051e-8c12-6502-aabd8edd0a72@nvidia.com>
 <7230ad0b-2b04-4f1b-b616-b7d98789ded0@gmail.com>
 <48f891bc-d8f6-2634-6dd1-6ea4f14ae6a3@nvidia.com>
From:   Dmitry Osipenko <digetx@gmail.com>
Message-ID: <0761f6f2-27f8-4e1a-fabc-9d319f465a9e@gmail.com>
Date:   Tue, 14 Dec 2021 16:56:12 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <48f891bc-d8f6-2634-6dd1-6ea4f14ae6a3@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

14.12.2021 10:22, Sameer Pujar пишет:
...
>>> How the reset behavior is different? At this point when HDA driver is
>>> loaded the HW is already reset during display ungate. What matters,
>>> during HDA driver load, is whether the HW is in predictable state or not
>>> and the answer is yes. So I am not sure what problem you are referring
>>> to. Question is, if BPMP already ensures this, then why driver needs to
>>> take care of it.
>> 1. Enable display
>> 2. Play audio over HDMI
> 
>> 3. HDA hardware now is in dirty state
> 
> Why this would be a dirty state? It is rather a functional state. Isn't
> it? Power-domain is ON while all this happens.

In general state should be a functional, but we shouldn't assume that.
There is always a possibility for a subtle bug in a driver that may put
h/w into a bad state. Full hardware reset is encouraged by users.

> Another point is, with present logic the reset is not applied for every
> runtime PM resume of HDA device, which is confusing. It depends on the
> state of 'chip->running' flag and I don't see this getting cleared
> anywhere. Would you say subsequent HDA playback happen under a dirty state?

This is a good point. There should be another potential problem in the
HDA driver for newer SoCs because apparently we don't re-initialize HDA
controller properly after runtime PM resume.

See hda_tegra_first_init() that is invoked only during driver probe, it
configures FPCI_DBG_CFG_2 register on T194, which isn't done by
hda_tegra_init(), and thus, this register may be  in reset state after
resume from RPM suspend. It should be a bug in the HDA driver that needs
to be fixed.

On older SoCs: HDA resides in the APB power domain which could be
disabled only across system suspend/resume. HDA is only clock-gated
during runtime PM suspend.

On newer SoCs: HDA power state could be lost after RPM suspend/resume,
depending on the state of display. I'm wondering whether HDMI playback
works after DPMS on T194+, I assume this case was never tested properly.

It looks like it should be safe to reset HDA on runtime PM resume
regardless of the chip->running, and thus, we could remove that check
and reset HDA unconditionally. Will great if you could check/test and
improve this in the driver.

I'm also wondering whether snd_power_change_state() should be moved into
RPM callbacks and whether this function does anything practically useful
on Tegra at all.
