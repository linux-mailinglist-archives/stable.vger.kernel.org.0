Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB8446BA86
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 12:57:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235959AbhLGMB2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 07:01:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231542AbhLGMB2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 07:01:28 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C893BC061574;
        Tue,  7 Dec 2021 03:57:57 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id z7so32934541lfi.11;
        Tue, 07 Dec 2021 03:57:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=plzsSmhgPNtDpsGtXQUnfrI8h3dSda395HMl2iG3SuA=;
        b=iyKr1MurwxWda44ZyfWPKvOS6nj+VfYfQM7RTH/Zj8L2tak3VVkwf31PqGTmpegadq
         91pckZUPU4PBqqF46pKghNJthHC1dfCyYJ7eXMYGef5EE/ESHzkmtbEjoCxTk528U93r
         +iHjw/Q+Udg0g6DBqv61JQlmPRpn0B46PZLtFhKCCN3gM9Ut6YZFyr94byMoPAptgwAO
         z4XxoAqoMvqMrGUbMqN82SDyMUVs2jKSDWsIe1P76AA/R3ZiFbJyO1ntHevL3wQ8xR72
         51dWYvPlPZIqjSO2TgMRp9EKuVcIbS4oUogkQvviaj53x9G5vEMQfkMAD6Sivsq1PMRs
         8e5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=plzsSmhgPNtDpsGtXQUnfrI8h3dSda395HMl2iG3SuA=;
        b=czns+8NnES3eSwVJKLDugPG4OktjnkYa+yGmq0n6Tme2xQtjMCjFWJ7F7jGI8IXZcw
         Qeyqjvh5dWQe5auzS7KKGHmHXM9ZbumK2PONfJuKI9ysJs+6AsbJA+xof7KcW47xeG6l
         IhB6CUiaqyzqvOaZmveO295zekQ2doc2Twu51ToRD9QupFHYRRH7bRuPm1w54QyEuHcn
         MJk+DE6ZRvYu+/e4w1NPM4f3GEfru1ivEY6kiiqPeWS7LTZedThtb1WEmuAgDYUwXDGZ
         Zlk3b1vsFdXH6e4CMorSeaDB0Zj81yBnRTX6bZPifbItWyd5rOx+65B2uxRRx0hz2ES8
         nh7w==
X-Gm-Message-State: AOAM530Lbmhadyw3tz4pz3rGxUo9aTKps+hTbGAZLI/eGFv1o7MEvPeS
        UX6Uc9cWYGcdfMX2H7tTqReYkutRJeA=
X-Google-Smtp-Source: ABdhPJwQBiN5fOAvH4OFJ+BjV2Fim81s1zJF7Nig/omJZCfIEi0M8gTsvczRHxlKF6f/1tC4FcVyJg==
X-Received: by 2002:a05:6512:33cd:: with SMTP id d13mr11400239lfg.360.1638878275882;
        Tue, 07 Dec 2021 03:57:55 -0800 (PST)
Received: from [192.168.2.145] (94-29-46-111.dynamic.spd-mgts.ru. [94.29.46.111])
        by smtp.googlemail.com with ESMTPSA id b14sm1666824lfs.174.2021.12.07.03.57.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Dec 2021 03:57:55 -0800 (PST)
Subject: Re: [PATCH 1/3] ALSA: hda/tegra: Skip reset on BPMP devices
To:     Jon Hunter <jonathanh@nvidia.com>,
        Sameer Pujar <spujar@nvidia.com>, tiwai@suse.com,
        broonie@kernel.org, lgirdwood@gmail.com, robh+dt@kernel.org,
        thierry.reding@gmail.com, perex@perex.cz
Cc:     alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <1638858770-22594-1-git-send-email-spujar@nvidia.com>
 <1638858770-22594-2-git-send-email-spujar@nvidia.com>
 <7742adae-cdbe-a9ea-2cef-f63363298d73@gmail.com>
 <2f29f787-7c77-a56e-3b90-0fc452fd1c88@gmail.com>
 <9c21aa0d-b7e6-17b8-cd1a-f12a2b2a1a57@gmail.com>
 <5e50e8a1-5436-b543-f15d-50c5089304e3@nvidia.com>
From:   Dmitry Osipenko <digetx@gmail.com>
Message-ID: <9da3de11-b6c5-b2ac-f4cf-e14c73ec134a@gmail.com>
Date:   Tue, 7 Dec 2021 14:57:54 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <5e50e8a1-5436-b543-f15d-50c5089304e3@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

07.12.2021 14:02, Jon Hunter пишет:
> 
> On 07/12/2021 10:58, Dmitry Osipenko wrote:
>> 07.12.2021 13:44, Dmitry Osipenko пишет:
>>> 07.12.2021 13:22, Dmitry Osipenko пишет:
>>>> 07.12.2021 09:32, Sameer Pujar пишет:
>>>>> HDA regression is recently reported on Tegra194 based platforms.
>>>>> This happens because "hda2codec_2x" reset does not really exist
>>>>> in Tegra194 and it causes probe failure. All the HDA based audio
>>>>> tests fail at the moment. This underlying issue is exposed by
>>>>> commit c045ceb5a145 ("reset: tegra-bpmp: Handle errors in BPMP
>>>>> response") which now checks return code of BPMP command response.
>>
>> I see that this BPMP commit already has been reverted. There is no
>> problem in this hda_tegra driver at all.
> 
> That is temporary until this fix is merged and then we will revert the
> revert.

It's the device-tree that is broken, not the driver. If you don't care
about broken HDMI audio using outdated dtb, then there is nothing to fix
in the code.

Otherwise, the fix is to skip the non-existent reset.

You could add workaround to the BPMP reset driver by making it always
return success for TEGRA194_RESET_HDA2CODEC_2X invocation instead of
making the FW call for that reset.
