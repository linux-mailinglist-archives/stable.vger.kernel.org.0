Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9B8646C246
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 19:02:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240319AbhLGSFu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 13:05:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240013AbhLGSFu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 13:05:50 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68F23C061574;
        Tue,  7 Dec 2021 10:02:19 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id m12so28911898ljj.6;
        Tue, 07 Dec 2021 10:02:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sqoUoMtUBmHodK2PJJEDxB6ED3784jkw/8tgiFLOL6Q=;
        b=bJFHJd4uXpwYV7ifbUZrGZDtcpLtYf10riM503HihUISrQRgoFT3Q9hZ8ef4bsmQNB
         JG6n7TshIzNt7J2EffIDjCz7U8FaB4o9C2CYEUwj8QIA3354fg6W4CuYn+S1Uj3VtCCr
         5+Rkz/oQGUyLYOxDStDiJHfnfR3zu5qp+x5QP30V9M9T3ZfUyJj9X1Fd0YzssvBI6jvl
         2clFJhgknW4Uhm6nkL9YJMWXt5ReOdPfJo36ECq7dfIF3EWCLt9cmGmLwB2P0i228HGn
         8Uy/0jbUJwj74alicGPV+cSZuof3GjVsF7CKAihZLYAAl7ms/zAs2Ba8kfpQ13ojJjPA
         /1cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sqoUoMtUBmHodK2PJJEDxB6ED3784jkw/8tgiFLOL6Q=;
        b=DwIEHUo0nryGZgYEm+vbVkZy9Y66wmn17OUMqWY8JDF9dzM2JHvNOfZKtXyNKZaND7
         TlMA6aVEjkwNDFfX8yurKSAzhggwCZdXnbKnFB8Gem9gtR65BnDILoIwaOwYKO4ZHk6n
         4IBdYIg9UVX7rQCzGlnww8kQnzFukprTmBjDsJ/fuN3s4YzAM2mAcnbUK7wwWWBKdZm1
         i5+fSDirMvLbN8eK9Pc2V+N6V+/hj0x1CBeBZ30xREWjxDUge8ztUCzdsgdHTKrois6m
         L98GD8BiWsWq8ZV5Si5D80/fsSXiW0nil6r1/rgvEpctv0zugto9UTcANVcktkTtLhOJ
         uW2w==
X-Gm-Message-State: AOAM530JSZUzoZ8EvzgNXp3w67yACYlXp7uxmU+8QnkGkkr+ZBVxr4co
        L/nzfESEs4JQ8Nh+GVCHLlg=
X-Google-Smtp-Source: ABdhPJwCj8oArFSu/8QVwop2LAW+6QUY+qwLMixQnx5V8GYd+tftm6uJDuFh4bo53x4nRWt0VVtYBA==
X-Received: by 2002:a05:651c:503:: with SMTP id o3mr44082043ljp.353.1638900137688;
        Tue, 07 Dec 2021 10:02:17 -0800 (PST)
Received: from [192.168.2.145] (94-29-46-111.dynamic.spd-mgts.ru. [94.29.46.111])
        by smtp.googlemail.com with ESMTPSA id n6sm29541lfh.28.2021.12.07.10.02.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Dec 2021 10:02:16 -0800 (PST)
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
From:   Dmitry Osipenko <digetx@gmail.com>
Message-ID: <3b0de739-7866-3886-be9c-a853c746f8b7@gmail.com>
Date:   Tue, 7 Dec 2021 21:02:14 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <148fba18-5d14-d342-0eb9-4ff224cc58ad@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

07.12.2021 20:37, Sameer Pujar пишет:
..
>> HDA won't be reset while display is active on T186+.
> 
> No. HDA reset is applied whenever power-domain is ungated. It can happen
> when either HDA or display device becomes active.

I said "display is active", where do you see "becomes active"?

> So I don't think that
> it is inconsistent.

If display is already active, then shared power domain is already
ungated. It won't be ungated second time in a row, HDA won't get the reset.
