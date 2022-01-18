Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A10E64922F2
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 10:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233702AbiARJjq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 04:39:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235969AbiARJjq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 04:39:46 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16007C061574;
        Tue, 18 Jan 2022 01:39:46 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id m3so54181152lfu.0;
        Tue, 18 Jan 2022 01:39:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=a0YVlEWbjgSbayNkq6pHh+iGzDRMa2x1N0HZiV2J5M8=;
        b=H+GBCxLRExjSJlYdrsQ+ZmaBiqmUtbP3o4f++IGayxtMEoBGd8XS+BxXsd9baWgDEc
         D7XoACSmazPv4dmQiZI8VJSYaAnpHjDKHC4V72hTHbtIHcLuR9uXaHjFMvV+6u7TkF3I
         PYxeUj6oC5ff6TYvmgQnIaGPlCGfWxPV23AWxG4FH1xxbzC9XP5lLCsZJe1+WkIGtB2u
         CtVwJzokEzgqIugBCicPdIyabeve/FI+fm4eAv3JlxYcTvE3iRqfERLshLzWqIpwybX5
         YHY5M51WuLDVSiDqTtG/Ef+bEYkbA+m1RuXxkVpkSsJIvaicN6WPUoy0KsS3LuBBC/AL
         jZjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=a0YVlEWbjgSbayNkq6pHh+iGzDRMa2x1N0HZiV2J5M8=;
        b=FuW3uwv5+WOcC/hATsPHM560rb2h8UgE2S+eq7CXzEawosM4Ut1Qdtm+iSrHvOpEi/
         EusMx/RXcm2IfiL4uin/xGsn+RTsi4GQ3F5kG75wkj2KpwTwsnOsYfJU8zavrHWCzU9I
         4aQpF9ao0gpGc6wSC/xeUq+SO2pDC5BqsZ7wvI67STtUGq4YMsx08Fjxact/lv0Dxznq
         yYARWvbEY5rQ0Zn2doXEeJ4dya2e8IY5RfLXf6+HKzvNh7Jc761l8jxguDMbw0Ww+3gx
         a+24UNKelj8wltfnyhnjR0o9dzpOb4GTH5JwGjY9zaHr5xuYzVrZ6/8wL7eZB9loDGWN
         b3qw==
X-Gm-Message-State: AOAM533iexUuvlaKIyONCGNpOX1+c+JGBl/Nh0JxhHSk1cqAmyJ7C5uG
        Ht5G8fa69nrbi2IDakoLbhg=
X-Google-Smtp-Source: ABdhPJwrsOw6fWZQAvQPhT0+8RdJOK/tXZZPgey8qzx/rfO+H5bfWmNIDPDsdz61+hdPuHU4nH9kHg==
X-Received: by 2002:a2e:98c8:: with SMTP id s8mr20029474ljj.407.1642498784488;
        Tue, 18 Jan 2022 01:39:44 -0800 (PST)
Received: from [192.168.2.145] (46-138-227-157.dynamic.spd-mgts.ru. [46.138.227.157])
        by smtp.googlemail.com with ESMTPSA id d18sm659567ljl.22.2022.01.18.01.39.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jan 2022 01:39:44 -0800 (PST)
Message-ID: <3bfdaf7b-c34d-1396-c6c7-2e22996b7643@gmail.com>
Date:   Tue, 18 Jan 2022 12:39:43 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH AUTOSEL 5.15 123/188] drm/tegra: dc: rgb: Allow changing
 PLLD rate on Tegra30+
Content-Language: en-US
From:   Dmitry Osipenko <digetx@gmail.com>
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Maxim Schwalm <maxim.schwalm@gmail.com>,
        Thierry Reding <treding@nvidia.com>, thierry.reding@gmail.com,
        airlied@linux.ie, daniel@ffwll.ch, jonathanh@nvidia.com,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org
References: <20220118023152.1948105-1-sashal@kernel.org>
 <20220118023152.1948105-123-sashal@kernel.org>
 <1fa23a4d-f647-c3ae-df8c-4cbd91f5a4c6@gmail.com>
In-Reply-To: <1fa23a4d-f647-c3ae-df8c-4cbd91f5a4c6@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

18.01.2022 12:37, Dmitry Osipenko пишет:
> 18.01.2022 05:30, Sasha Levin пишет:
>> From: Dmitry Osipenko <digetx@gmail.com>
>>
>> [ Upstream commit 0c921b6d4ba06bc899fd84d3ce1c1afd3d00bc1c ]
>>
>> Asus Transformer TF700T is a Tegra30 tablet device which uses RGB->DSI
>> bridge that requires a precise clock rate in order to operate properly.
>> Tegra30 has a dedicated PLL for each display controller, hence the PLL
>> rate can be changed freely. Allow PLL rate changes on Tegra30+ for RGB
>> output. Configure the clock rate before display controller is enabled
>> since DC itself may be running off this PLL and it's not okay to change
>> the rate of the active PLL that doesn't support dynamic frequency
>> switching since hardware will hang.
>>
>> Tested-by: Maxim Schwalm <maxim.schwalm@gmail.com> #TF700T
>> Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
>> Signed-off-by: Thierry Reding <treding@nvidia.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  drivers/gpu/drm/tegra/dc.c  | 27 ++++++++++++--------
>>  drivers/gpu/drm/tegra/dc.h  |  1 +
>>  drivers/gpu/drm/tegra/rgb.c | 49 +++++++++++++++++++++++++++++++++++--
>>  3 files changed, 65 insertions(+), 12 deletions(-)
> 
> Hi,
> 
> This patch shouldn't be ported to any stable kernel because h/w that
> needs this patch was just merged to the 5.17.

* support of h/w that needs..
