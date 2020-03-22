Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C96218EBF2
	for <lists+stable@lfdr.de>; Sun, 22 Mar 2020 20:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbgCVTjX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Mar 2020 15:39:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:47170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726502AbgCVTjX (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Mar 2020 15:39:23 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E2772070A;
        Sun, 22 Mar 2020 19:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584905962;
        bh=aGGx1nH/psZA7otCHWR4bp5UFDdxLz4Yls1e8FeqbP8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RpzIB6/NcuUVL2rRNhtd463rKUSmMi1zOKWJ7aOy89Esuu+Q+/QRp6HstMSs9FGn9
         inmSJqWLSN0wR51pFwU8rnc8CDiAcu6Tf9IE78z9qzzL87ikGPu3sKiEsitLF1ibY+
         UWYLCHX1KEqkG4cc5p3hFaSV1vRn/OTd7bOX/sVA=
Date:   Sun, 22 Mar 2020 15:39:21 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Jerome Brunet <jbrunet@baylibre.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mark Brown <broonie@kernel.org>, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org,
        Kevin Hilman <khilman@baylibre.com>
Subject: Re: [PATCH AUTOSEL 5.4 08/35] ASoC: meson: g12a: add tohdmitx reset
Message-ID: <20200322193921.GP4189@sasha-vm>
References: <20200316023411.1263-1-sashal@kernel.org>
 <20200316023411.1263-8-sashal@kernel.org>
 <1ja74gg0v8.fsf@starbuckisacylon.baylibre.com>
 <1jsgi0ckcc.fsf@starbuckisacylon.baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1jsgi0ckcc.fsf@starbuckisacylon.baylibre.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 22, 2020 at 07:31:31PM +0100, Jerome Brunet wrote:
>
>On Mon 16 Mar 2020 at 09:28, Jerome Brunet <jbrunet@baylibre.com> wrote:
>
>> On Mon 16 Mar 2020 at 03:33, Sasha Levin <sashal@kernel.org> wrote:
>>
>>> From: Jerome Brunet <jbrunet@baylibre.com>
>>>
>>> [ Upstream commit 22946f37557e27697aabc8e4f62642bfe4a17fd8 ]
>>>
>>> Reset the g12a hdmi codec glue on probe. This ensure a sane startup state.
>>>
>>> Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
>>> Link: https://lore.kernel.org/r/20200221121146.1498427-1-jbrunet@baylibre.com
>>> Signed-off-by: Mark Brown <broonie@kernel.org>
>>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>>
>> Hi Sasha,
>>
>> The tohdmitx reset property is not in the amlogic g12a DT in v5.4.
>> Backporting this patch on v5.4 would break the hdmi sound, and probably
>> the related sound card since the reset is not optional.
>>
>> Could you please drop this from v5.4 stable ?
>
>Hi Sasha,
>
>I just received a notification that this patch has been applied to 5.4
>stable.
>
>As explained above, it will cause a regression.
>Could you please drop it from v5.4 stable ?

Hi Jerome,

Sorry - I've missed your previous mail. Now dropped from all trees.

-- 
Thanks,
Sasha
