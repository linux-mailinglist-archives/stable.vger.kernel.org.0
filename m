Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC74C36ED
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 16:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388931AbfJAOSt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 10:18:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:33274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727055AbfJAOSs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Oct 2019 10:18:48 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F78E2086A;
        Tue,  1 Oct 2019 14:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569939528;
        bh=BZoLkO7pPzU3r96BwmjE8Yk+cfOBfvTp6vVFJajgGi0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LuvHpqFnQEAf2BjLJouneSSWDpXnphl0go8fxpv4Np+kR/D7JMIYeMixWOcgAGOtR
         Z4z06rexQ5MhaJ1WtOeaYIX/aSmVcJA3YLsYIAciSbfVbyhs1akYxuTApsNlVSoSCh
         tSX8x5tbdGjsvyvGROQLF2Ptws9GzIE+lgDBmphs=
Date:   Tue, 1 Oct 2019 10:18:46 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Jerome Brunet <jbrunet@baylibre.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mark Brown <broonie@kernel.org>,
        linux-amlogic@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 5.3 034/203] ASoC: meson: g12a-tohdmitx: override
 codec2codec params
Message-ID: <20191001141846.GU8171@sasha-vm>
References: <20190922184350.30563-1-sashal@kernel.org>
 <20190922184350.30563-34-sashal@kernel.org>
 <1j7e5ztnoo.fsf@starbuckisacylon.baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1j7e5ztnoo.fsf@starbuckisacylon.baylibre.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 23, 2019 at 10:35:35AM +0200, Jerome Brunet wrote:
>On Sun 22 Sep 2019 at 14:41, Sasha Levin <sashal@kernel.org> wrote:
>
>> From: Jerome Brunet <jbrunet@baylibre.com>
>>
>> [ Upstream commit 2c4956bc1e9062e5e3c5ea7612294f24e6d4fbdd ]
>>
>> So far, forwarding the hw_params of the input to output relied on the
>> .hw_params() callback of the cpu side of the codec2codec link to be called
>> first. This is a bit weak.
>>
>> Instead, override the stream params of the codec2codec to link to set it up
>> correctly.
>
>Hi Sasha
>
>This change depends on the following series in ASoC:
>https://lore.kernel.org/r/20190725165949.29699-1-jbrunet@baylibre.com
>which has also been merged in this merge window.
>
>With this change, things are done (IMO) in a better way but there was no
>known issue before that.
>
>I don't think it is worth backporting the mentioned ASoC series to
>5.3. I would suggest to just drop this change from stable.

I've dropped it, thank you.

--
Thanks,
Sasha
