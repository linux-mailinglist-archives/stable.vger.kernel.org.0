Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA99DA842B
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 15:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725965AbfIDNIT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 09:08:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53599 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729296AbfIDNIS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Sep 2019 09:08:18 -0400
Received: from [222.130.137.249] (helo=[192.168.1.108])
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <hui.wang@canonical.com>)
        id 1i5V1E-0005EK-L7; Wed, 04 Sep 2019 13:08:16 +0000
Subject: Re: [PATCH] ALSA: hda/realtek - Fix the problem of two front mics on
 a ThinkCentre
To:     Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org,
        tiwai@suse.de
Cc:     stable@vger.kernel.org
References: <20190904055327.9883-1-hui.wang@canonical.com>
 <20190904123534.ED0DD23402@mail.kernel.org>
From:   Hui Wang <hui.wang@canonical.com>
Message-ID: <b5ab2817-dd0a-e8f6-a827-9a5313715a69@canonical.com>
Date:   Wed, 4 Sep 2019 21:08:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190904123534.ED0DD23402@mail.kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Let's drop this patch to v4.9.190 and v4.4.190, it is fine to apply to 
v5.2.11,  v4.19.69 and v4.14.141 only.

Thanks.

On 2019/9/4 下午8:35, Sasha Levin wrote:
> Hi,
>
> [This is an automated email]
>
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
>
> The bot has tested the following trees: v5.2.11, v4.19.69, v4.14.141, v4.9.190, v4.4.190.
>
> v5.2.11: Build OK!
> v4.19.69: Build OK!
> v4.14.141: Build OK!
> v4.9.190: Failed to apply! Possible dependencies:
>      216d7aebbfbe ("ALSA: hda/realtek - Fix headset mic and speaker on Asus X441SA/X441UV")
>      5824ce8de7b1 ("ALSA: hda/realtek - Add support for Acer Aspire E5-475 headset mic")
>      615966adc4b6 ("ALSA: hda/realtek - Fix headset mic on several Asus laptops with ALC255")
>      823ff161fe51 ("ALSA: hda - Fix click noises on Samsung Ativ Book 8")
>      8da5bbfc7cbb ("ALSA: hda - change the location for one mic on a Lenovo machine")
>      9eb5d0e635eb ("ALSA: hda/realtek - Add support headphone Mic for ALC221 of HP platform")
>      c1732ede5e80 ("ALSA: hda/realtek - Fix headset and mic on several Asus laptops with ALC256")
>      c6790c8e770c ("ALSA: hda/realtek - Add support for headset MIC for ALC622")
>      ca169cc2f9e1 ("ALSA: hda/realtek - Add Dual Codecs support for Lenovo P520/420")
>      f33f79f3d0e5 ("ALSA: hda/realtek - change the location for one of two front microphones")
>
> v4.4.190: Failed to apply! Possible dependencies:
>      1a3f099101b8 ("ALSA: hda - Fix surround output pins for ASRock B150M mobo")
>      216d7aebbfbe ("ALSA: hda/realtek - Fix headset mic and speaker on Asus X441SA/X441UV")
>      5824ce8de7b1 ("ALSA: hda/realtek - Add support for Acer Aspire E5-475 headset mic")
>      615966adc4b6 ("ALSA: hda/realtek - Fix headset mic on several Asus laptops with ALC255")
>      78f4f7c2341f ("ALSA: hda/realtek - ALC891 headset mode for Dell")
>      823ff161fe51 ("ALSA: hda - Fix click noises on Samsung Ativ Book 8")
>      8da5bbfc7cbb ("ALSA: hda - change the location for one mic on a Lenovo machine")
>      9b51fe3efe4c ("ALSA: hda - On-board speaker fixup on ACER Veriton")
>      9eb5d0e635eb ("ALSA: hda/realtek - Add support headphone Mic for ALC221 of HP platform")
>      abaa2274811d ("ALSA: hda/realtek - fix headset mic detection for MSI MS-B120")
>      c1732ede5e80 ("ALSA: hda/realtek - Fix headset and mic on several Asus laptops with ALC256")
>      c6790c8e770c ("ALSA: hda/realtek - Add support for headset MIC for ALC622")
>      ca169cc2f9e1 ("ALSA: hda/realtek - Add Dual Codecs support for Lenovo P520/420")
>      f33f79f3d0e5 ("ALSA: hda/realtek - change the location for one of two front microphones")
>
>
> NOTE: The patch will not be queued to stable trees until it is upstream.
>
> How should we proceed with this patch?
>
> --
> Thanks,
> Sasha
>
