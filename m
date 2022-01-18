Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABC044922E8
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 10:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345702AbiARJhz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 04:37:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240557AbiARJhy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 04:37:54 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 430EFC061574;
        Tue, 18 Jan 2022 01:37:54 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id o12so51511669lfu.12;
        Tue, 18 Jan 2022 01:37:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=DeGHxvOkcbTC/3aO1jG67yYJNY+X5JLaHOHG742whjc=;
        b=j289bUD6/nRw1kvMteOz/gAeSpGxqR1YbsBSM35IwtNK3cz53ODPP2U0Gpitwhg0Vy
         Vd82mJsuKN1LIVSf+xzNofaKd7D1zKuUjsNZjHHmCMYy5/zpdme25+/uW30plHWI5ShL
         up+MqI9j/Ksd3B4JHZCVF+MrbXycXG87IsDBRS2kN+dzIKeZiThlm2MV8ZEiJraHY6HM
         oUSQUf0RgyTUX+3S/2uTazv1X7wEEJR6R6NNyrI4kNnnTjnEzs02mNuA1Gs5+9xDWu05
         jBmPbwnqf8cXOMxnBwARL3zcUZxLJUAmKd6ANbdOK4/zuwJdbRqbTcvgdbiK1bQiaU81
         +eDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=DeGHxvOkcbTC/3aO1jG67yYJNY+X5JLaHOHG742whjc=;
        b=4WZ5N2xxoHgphGnNEwdn5+9XEH3kOpY7xJAr8V44e6J6oj90hSSZxDYLGvD1i92KCX
         F4glxldqIXTueVWofvTsfdT9k0buYo//xSCFdvaJiE3Hd1r9QDEedyWpiqu/ktqT9BHc
         onohCCIlTCYl5YGyA2mFw9fawGqmz0F5HOt16eohRXTzjhn5QU7rFTs9Qve1OYo/fqKZ
         8Zh7zUWTBjYCx8P5sus4u8FUZ9dASpNUOQEYTND3XPLgweX8tMNo+vPL0VfeXRxyGVhh
         Hfh2q7VyNhPYrBZEX1iz3a7LtSqwfErc+SnJsK8gUHBwDhSDM/SBaBGgW08pK1+ppQ83
         AbHw==
X-Gm-Message-State: AOAM532nMMGerhhlMPS3N8LtTIBGYghuyA4G4ZZpxIf0zw9bvKUg4YdJ
        D633vwl0ZbqxEBTTFZacPW0=
X-Google-Smtp-Source: ABdhPJwTHY46PIQGIjoqtqIH7KsMzep7tLv9PsCznK/890ApCoT/rYMS/bG85Zy7ncA3FY3KkVpWrw==
X-Received: by 2002:a2e:a413:: with SMTP id p19mr19853738ljn.12.1642498672632;
        Tue, 18 Jan 2022 01:37:52 -0800 (PST)
Received: from [192.168.2.145] (46-138-227-157.dynamic.spd-mgts.ru. [46.138.227.157])
        by smtp.googlemail.com with ESMTPSA id n14sm1585857ljg.47.2022.01.18.01.37.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jan 2022 01:37:52 -0800 (PST)
Message-ID: <1fa23a4d-f647-c3ae-df8c-4cbd91f5a4c6@gmail.com>
Date:   Tue, 18 Jan 2022 12:37:51 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH AUTOSEL 5.15 123/188] drm/tegra: dc: rgb: Allow changing
 PLLD rate on Tegra30+
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Maxim Schwalm <maxim.schwalm@gmail.com>,
        Thierry Reding <treding@nvidia.com>, thierry.reding@gmail.com,
        airlied@linux.ie, daniel@ffwll.ch, jonathanh@nvidia.com,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org
References: <20220118023152.1948105-1-sashal@kernel.org>
 <20220118023152.1948105-123-sashal@kernel.org>
From:   Dmitry Osipenko <digetx@gmail.com>
In-Reply-To: <20220118023152.1948105-123-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

18.01.2022 05:30, Sasha Levin пишет:
> From: Dmitry Osipenko <digetx@gmail.com>
> 
> [ Upstream commit 0c921b6d4ba06bc899fd84d3ce1c1afd3d00bc1c ]
> 
> Asus Transformer TF700T is a Tegra30 tablet device which uses RGB->DSI
> bridge that requires a precise clock rate in order to operate properly.
> Tegra30 has a dedicated PLL for each display controller, hence the PLL
> rate can be changed freely. Allow PLL rate changes on Tegra30+ for RGB
> output. Configure the clock rate before display controller is enabled
> since DC itself may be running off this PLL and it's not okay to change
> the rate of the active PLL that doesn't support dynamic frequency
> switching since hardware will hang.
> 
> Tested-by: Maxim Schwalm <maxim.schwalm@gmail.com> #TF700T
> Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/gpu/drm/tegra/dc.c  | 27 ++++++++++++--------
>  drivers/gpu/drm/tegra/dc.h  |  1 +
>  drivers/gpu/drm/tegra/rgb.c | 49 +++++++++++++++++++++++++++++++++++--
>  3 files changed, 65 insertions(+), 12 deletions(-)

Hi,

This patch shouldn't be ported to any stable kernel because h/w that
needs this patch was just merged to the 5.17.
