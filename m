Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D03F546BAB0
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 13:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231589AbhLGMJT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 07:09:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236052AbhLGMJQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 07:09:16 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97D7CC061574;
        Tue,  7 Dec 2021 04:05:45 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id bi37so33081777lfb.5;
        Tue, 07 Dec 2021 04:05:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5KguUb/6H3/lFEhf1osMyGDeEZ7yTTjU3cEIbM5ujcg=;
        b=IsyGD1u7lrKJX2EiEtATetS94Wv2RLht0Q+4fMKQzjV4ZwywlvXHU6hGjX4Un7/vwo
         y/g37T90X0gd0o42hntPjoKihVG44480rF3scm3+BpmSYLegLdkoeXGN1ra1ortv5mWv
         lF7aDu88gO+lHbuVsDVc+skOhdZAzkHxnu5vjDP0aKiIkn7MSzLKteiZxoFqRsD83EKO
         yVRAGq5rJVQG2yqV+U/axnGP86PWWTKGbXx34+UDTjfdMU6FHJyQ++MxOJWd5XHG+EKi
         /CZmuI6NsQsAFmiYDJgiUUbb/4J2KQXkExK8v9g6+yiK68gNIU/C9UEonnNeRKh/XUAw
         HETw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5KguUb/6H3/lFEhf1osMyGDeEZ7yTTjU3cEIbM5ujcg=;
        b=q0t0t+9J2Jf4Usz10N6cGf9ksquk39RyOwWT18FAoMaeEFrEvTcMNEaDv90d/h6KYZ
         dQnvC7O5MJqOi4MZ13wGJoVnHXWCknzOlL/7WWzD30xQyo3vJ/tqzCxgD8YfsAvhJOkz
         2BNWLz1Stf/gg3Sv3Oph+t7uIQxB2JftiRjNO0P3q6maeaw5siNKczSZ7cJSTxvVcDdA
         x4CyAmyLS/lBUpzN+uJ1EsJRB2FpWNJfTMsrkhgaCql+BBBzQY8DwYAbjI7AnOcU25SD
         7FN8vT182KhB5a/rW52wvDL/kdo93YOYY+Er/JkhmL4vOGuAf7XVAGj/rFcjsJfq4WCt
         OLJA==
X-Gm-Message-State: AOAM531OIZdJnmq1NuWDGKfwqqO2GFWOP3ySu6M4SNPFnGPB3h6l+Pad
        C4V9kGN5VfP7LxPD/fr4VTTtHhfjGZY=
X-Google-Smtp-Source: ABdhPJx4NtgiFUA11M9GWn2N+bw7b/A2Y96uMLskZdbgm8PDefZKgiFTwWLlFC/3Iw5WpMq6kwTR8w==
X-Received: by 2002:a05:6512:1192:: with SMTP id g18mr40937025lfr.40.1638878743940;
        Tue, 07 Dec 2021 04:05:43 -0800 (PST)
Received: from [192.168.2.145] (94-29-46-111.dynamic.spd-mgts.ru. [94.29.46.111])
        by smtp.googlemail.com with ESMTPSA id s15sm1663658lfp.252.2021.12.07.04.05.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Dec 2021 04:05:43 -0800 (PST)
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
From:   Dmitry Osipenko <digetx@gmail.com>
Message-ID: <56bb43b6-8d72-b1de-4402-a2cb31707bd9@gmail.com>
Date:   Tue, 7 Dec 2021 15:05:42 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <8fd704d9-43ce-e34a-a3c0-b48381ef0cd8@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

07.12.2021 15:00, Sameer Pujar пишет:
> 
> 
> On 12/7/2021 3:52 PM, Dmitry Osipenko wrote:
>> 07.12.2021 09:32, Sameer Pujar пишет:
>>> HDA regression is recently reported on Tegra194 based platforms.
>>> This happens because "hda2codec_2x" reset does not really exist
>>> in Tegra194 and it causes probe failure. All the HDA based audio
>>> tests fail at the moment. This underlying issue is exposed by
>>> commit c045ceb5a145 ("reset: tegra-bpmp: Handle errors in BPMP
>>> response") which now checks return code of BPMP command response.
>>>
>>> The failure can be fixed by avoiding above reset in the driver,
>>> but the explicit reset is not necessary for Tegra devices which
>>> depend on BPMP. On such devices, BPMP ensures reset application
>>> during unpowergate calls. Hence skip reset on these devices
>>> which is applicable for Tegra186 and later.
>> The power domain is shared with the display, AFAICS. The point of reset
>> is to bring h/w into predictable state. It doesn't make sense to me to
>> skip the reset.
> 
> Yes the power-domain is shared with display. As mentioned above,
> explicit reset in driver is not really necessary since BPMP is already
> doing it during unpowergate stage. So the h/w is already ensured to be
> in a good state.

If you'll reload the driver module, then h/w won't be reset.
