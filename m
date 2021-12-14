Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBC0B473CFA
	for <lists+stable@lfdr.de>; Tue, 14 Dec 2021 07:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbhLNGJL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 01:09:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbhLNGJK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Dec 2021 01:09:10 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 644EFC061574;
        Mon, 13 Dec 2021 22:09:10 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id e24so9259655lfc.0;
        Mon, 13 Dec 2021 22:09:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=u86PV6f15E/OmUh1s+ADZl0B3HatTEzbGCdOfeViZ/k=;
        b=nB1HP1/tHxenzCS/nn441hVnLG8SUXGAzpcRjyuSsUaa1XdsOltvdaQ2VpirhHoG7N
         ehqnXvSal35ykH+i9nZ5drDwEIGOBF/ZbY1ZmAQG/ZzQmmBZ0LLD9XcCQ/6wfCZSOzLC
         H16Dtt+wbyR7XZCTwDCRmhao4OR3s/desDzPAMolzAwZEHQzM2EU7syUUPK9VxWV/ptG
         mTeBN4uWWmqmB6R0RyQNvSFqCQGtVGzNyctwYRYsxDHylUCX8Xmp93X6Nf7ljNzHKqS6
         WoMZT1Sg5u0XNa9BxMbanGvwzIfqA1CBvlRRz1ZZTYnlNtgaLIqqtc8+Cfc0miPZrce3
         gTBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=u86PV6f15E/OmUh1s+ADZl0B3HatTEzbGCdOfeViZ/k=;
        b=myxshtBHMAYEYGC5jYhe+BPZnLw1BIPDmRLJQZop3ez3uas21tpcSMhbaY0f4s4UU8
         ToCb/JyOa68Nx+A5Vo5+pO90dvz/ctVd936yzdMdlUHp4t9NewHw73NipPck4Gdth0aD
         NaTTAbk/opzJ/1VMb8cxiYasIg0i991nwsr4l49FQsgaDv4+lmpjR6yiqAgJWReS1kVl
         evdftsEVeP2VXOGofAGJx8qZk9MnNIlrDkmpXI9hfwX/K9FXx5B8V+9rL8vobY1BxNJ6
         dXAUHKpX0nMNcAChk4rQN3IiMsg6cwNetdemMpzWZnjc0pa/+KkDDegPbKB9sgTBO111
         FHhw==
X-Gm-Message-State: AOAM530hYFQEM9TX2t1gjhmf4EUE+4ylYQtYceyLdsG1bcf/D7rmKaM0
        E4LpzzWtss2WS1/9EbsB9JrNCGoOkMA=
X-Google-Smtp-Source: ABdhPJzFCpofPUzfn8YG8Nbcun5mvSSdnb5tD0Lkdki0yfyddtSEbtZdMcFfpLbgTCBtxZVAyjZpsg==
X-Received: by 2002:a19:e054:: with SMTP id g20mr3114434lfj.238.1639462148684;
        Mon, 13 Dec 2021 22:09:08 -0800 (PST)
Received: from [192.168.2.145] (94-29-63-156.dynamic.spd-mgts.ru. [94.29.63.156])
        by smtp.googlemail.com with ESMTPSA id cf34sm1704136lfb.222.2021.12.13.22.09.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Dec 2021 22:09:08 -0800 (PST)
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
From:   Dmitry Osipenko <digetx@gmail.com>
Message-ID: <7230ad0b-2b04-4f1b-b616-b7d98789ded0@gmail.com>
Date:   Tue, 14 Dec 2021 09:09:07 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <50bf5a83-051e-8c12-6502-aabd8edd0a72@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

14.12.2021 09:02, Sameer Pujar пишет:
> 
> 
> On 12/8/2021 5:35 PM, Dmitry Osipenko wrote:
>> 08.12.2021 08:22, Sameer Pujar пишет:
>>>
>>> On 12/7/2021 11:32 PM, Dmitry Osipenko wrote
>>>> If display is already active, then shared power domain is already
>>>> ungated.
>>> If display is already active, then shared power domain is already
>>> ungated. HDA reset is already applied during this ungate. In other
>>> words, HDA would be reset as well when display ungates power-domain.
>> Now, if you'll reload the HDA driver module while display is active,
>> you'll get a different reset behaviour. HDA hardware will be reset on
>> pre-T186, on T186+ it won't be reset.
> 
> How the reset behavior is different? At this point when HDA driver is
> loaded the HW is already reset during display ungate. What matters,
> during HDA driver load, is whether the HW is in predictable state or not
> and the answer is yes. So I am not sure what problem you are referring
> to. Question is, if BPMP already ensures this, then why driver needs to
> take care of it.

1. Enable display
2. Play audio over HDMI
3. HDA hardware now is in dirty state
4. Reload HDA driver
5. In your case HDA is kept in dirty state, in my no
