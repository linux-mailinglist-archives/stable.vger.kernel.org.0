Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6D3B2747AB
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 19:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbgIVRqt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 13:46:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:46740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726563AbgIVRqt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Sep 2020 13:46:49 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41889235FD;
        Tue, 22 Sep 2020 17:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600796808;
        bh=oenH9vdrSeEwpGAAQSosUc2ancjCFiFt+bS7Q3FodvE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WzHe7IvkaPznnNvUEzD3HwVFa5e3MVZPSx77gO0aZ7obkzaUe+1w5lnx9cjPynG49
         S4IcH0FK0xhrWB4p729EYloa8Vtdxk0cBD/6um7Dk3R9Tt+j56tb1o176lW6K32VR1
         PpShnQ1Ju8htQOEUxZl8dNJGKjSJbShLV1eRTv3s=
Date:   Tue, 22 Sep 2020 13:46:47 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        patches@opensource.cirrus.com, alsa-devel@alsa-project.org
Subject: Re: [PATCH AUTOSEL 5.8 03/20] ASoC: wm8994: Skip setting of the
 WM8994_MICBIAS register for WM1811
Message-ID: <20200922174647.GP2431@sasha-vm>
References: <20200921144027.2135390-1-sashal@kernel.org>
 <20200921144027.2135390-3-sashal@kernel.org>
 <20200921150701.GA12231@sirena.org.uk>
 <20200922142515.GN2431@sasha-vm>
 <20200922144221.GW4792@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200922144221.GW4792@sirena.org.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 22, 2020 at 03:42:21PM +0100, Mark Brown wrote:
>On Tue, Sep 22, 2020 at 10:25:15AM -0400, Sasha Levin wrote:
>> On Mon, Sep 21, 2020 at 04:07:01PM +0100, Mark Brown wrote:
>
>> > This is pretty much a cosmetic change - previously we were silently not
>> > reading the register, this just removes the attempt to read it since we
>> > added an error message in the core.
>
>> Right, the only reason I took it is that error message - I find that
>> bogus error messages have almost the same (bad) impact as real kernel
>> bugs.
>
>The point is that the error message isn't present in stable kernels so
>there is no impact on any user visible behaviour.

Ah, I see. I'll drop it. Thanks!

-- 
Thanks,
Sasha
