Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68C7A46B95A
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 11:44:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234432AbhLGKrj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 05:47:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbhLGKri (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 05:47:38 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5B67C061746;
        Tue,  7 Dec 2021 02:44:08 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id n12so32616591lfe.1;
        Tue, 07 Dec 2021 02:44:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GTY458qscFL4zCNgrOoq7nfsYMMYLdnO5OGlspbKm8A=;
        b=Xrw5tNA8ddJCZZfFtYx8nYKhUZdl8cE7vpx/c8cejLLBcxZjhCaZx2H2+uL811Ny4a
         RhOTbB/44rnqNKuCMDkN3TrfeDu+G2W/BTNgINQwbZdQhysH5rYaxHO4axvnH4DPv62Y
         OMLTX4SILniGXCNEp3mHQ8tcLx6p6CL0vuh9Kps3Tm0JETB5dWB/AiDoNXh7qSOg4HNc
         aZHDjHUwE+0FgATmvbZ+y8GylUXFYENI8fmZK4vv1xwGWBbkHGhIShE3495e5ztH9VwR
         aF7MWA+ZufeykzuwawilpRuQylJIMTIGxgzeKiOa4dgHuxGy9rF8gtwekwKLA956CF8d
         l32g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GTY458qscFL4zCNgrOoq7nfsYMMYLdnO5OGlspbKm8A=;
        b=cDvso6/oQ/Zo2OLZJIEn40vj6O0zJBtBVEO2UY2tv+G2a0AJiHszrVBbtbA24CDUD2
         czQptoHWAJ7bWbiMv2bdTac3rKmp6po6TUSCRCl2+ZgWA+CRA/s5tyfc9DZ2ivD+JWVY
         eFy78kOIK0ibA7cT2c0qXwapLzinFPT/rSwLqTsv9bEwg/RGZB70grgm/8kOedZRasHf
         uWofPc4b8PARGYKsoUGSxihIDBKvhdfuotgh7RCtqhcgiuG+VsG8J14rnQdiTg/Y47/W
         2pg0/hGbD4lH0kTcS6E00Lpmi1m4patlXs/ZKv9Nx3k2VXErv5AmfR9XdOq1868Gzihk
         7GMQ==
X-Gm-Message-State: AOAM533liTEOOHUPg+vU0VvVeZCc6t1/HTnRpdzQXs5nEGULpyxUPGIZ
        RgQ78rrU0ngIaQMaRfJ8aYyuOLtmDws=
X-Google-Smtp-Source: ABdhPJyFB+FQBCdM0pWLTlNf+RWgmGRbBRwJt6T/X+LP5gnOtiLiGCxzX5gtJFxiTKiG61zidFm5UQ==
X-Received: by 2002:ac2:5388:: with SMTP id g8mr41211335lfh.382.1638873846629;
        Tue, 07 Dec 2021 02:44:06 -0800 (PST)
Received: from [192.168.2.145] (94-29-46-111.dynamic.spd-mgts.ru. [94.29.46.111])
        by smtp.googlemail.com with ESMTPSA id w6sm1649527lfr.11.2021.12.07.02.44.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Dec 2021 02:44:06 -0800 (PST)
Subject: Re: [PATCH 1/3] ALSA: hda/tegra: Skip reset on BPMP devices
From:   Dmitry Osipenko <digetx@gmail.com>
To:     Sameer Pujar <spujar@nvidia.com>, tiwai@suse.com,
        broonie@kernel.org, lgirdwood@gmail.com, robh+dt@kernel.org,
        thierry.reding@gmail.com, perex@perex.cz
Cc:     jonathanh@nvidia.com, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <1638858770-22594-1-git-send-email-spujar@nvidia.com>
 <1638858770-22594-2-git-send-email-spujar@nvidia.com>
 <7742adae-cdbe-a9ea-2cef-f63363298d73@gmail.com>
Message-ID: <2f29f787-7c77-a56e-3b90-0fc452fd1c88@gmail.com>
Date:   Tue, 7 Dec 2021 13:44:05 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <7742adae-cdbe-a9ea-2cef-f63363298d73@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

07.12.2021 13:22, Dmitry Osipenko пишет:
> 07.12.2021 09:32, Sameer Pujar пишет:
>> HDA regression is recently reported on Tegra194 based platforms.
>> This happens because "hda2codec_2x" reset does not really exist
>> in Tegra194 and it causes probe failure. All the HDA based audio
>> tests fail at the moment. This underlying issue is exposed by
>> commit c045ceb5a145 ("reset: tegra-bpmp: Handle errors in BPMP
>> response") which now checks return code of BPMP command response.
>>
>> The failure can be fixed by avoiding above reset in the driver,
>> but the explicit reset is not necessary for Tegra devices which
>> depend on BPMP. On such devices, BPMP ensures reset application
>> during unpowergate calls. Hence skip reset on these devices
>> which is applicable for Tegra186 and later.
> 
> The power domain is shared with the display, AFAICS. The point of reset
> is to bring h/w into predictable state. It doesn't make sense to me to
> skip the reset.
> 
> If T194+ doesn't have hda2codec_2x reset, then don't request that reset
> for T194+.
> 

I don't see the problem in the driver. It's only the device-tree that is
wrong. This hda_tegra.c patch should be unneeded, please fix only the
device-tree.
