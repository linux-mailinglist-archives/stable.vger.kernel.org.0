Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2E919973B
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 15:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730358AbgCaNSi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 09:18:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45395 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730464AbgCaNSi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Mar 2020 09:18:38 -0400
Received: from [222.130.137.59] (helo=[192.168.2.112])
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <hui.wang@canonical.com>)
        id 1jJGmp-0002G4-HN; Tue, 31 Mar 2020 13:18:36 +0000
Subject: Re: [PATCH] ALSA: hda/realtek - a fake key event is triggered by
 running shutup
To:     Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org,
        tiwai@suse.de, stable@vger.kernel.org
Cc:     Kailang Yang <kailang@realtek.com>
References: <20200329080642.20287-1-hui.wang@canonical.com>
 <20200331131130.0A72620757@mail.kernel.org>
From:   Hui Wang <hui.wang@canonical.com>
Message-ID: <67aedfb4-a7c0-7127-b468-99e302863053@canonical.com>
Date:   Tue, 31 Mar 2020 21:18:21 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200331131130.0A72620757@mail.kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 2020/3/31 下午9:11, Sasha Levin wrote:
> Hi
>
> [This is an automated email]
>
> This commit has been processed because it contains a "Fixes:" tag
> fixing commit: 78def224f59c ("ALSA: hda/realtek - Add Headset Mic supported").
>
> The bot has tested the following trees: v5.5.13, v5.4.28, v4.19.113.
>
> v5.5.13: Build OK!
> v5.4.28: Build OK!
> v4.19.113: Failed to apply! Possible dependencies:
>      10f5b1b85ed1 ("ALSA: hda/realtek - Fixed Headset Mic JD not stable")
>      2b3b6497c38d ("ALSA: hda/realtek - Add more codec supported Headset Button")
>      8983eb602af5 ("ALSA: hda/realtek - Move to ACT_INIT state")
>      c8a9afa632f0 ("ALSA: hda/realtek: merge alc_fixup_headset_jack to alc295_fixup_chromebook")
>      d3ba58bb8959 ("ALSA: hda/realtek - Support low power consumption for ALC295")
>      e854747d7593 ("ALSA: hda/realtek - Enable headset button support for new codec")
>
>
> NOTE: The patch will not be queued to stable trees until it is upstream.
>
> How should we proceed with this patch?

Please apply this patch to v5.5.13 and v5.4.28. Drop this patch from 
v4.19.113.

thanks.

Hui.

>
