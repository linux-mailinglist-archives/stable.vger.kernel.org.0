Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 844993D422A
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 23:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232401AbhGWUog (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Jul 2021 16:44:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:48076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232375AbhGWUof (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Jul 2021 16:44:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80F3560EB1;
        Fri, 23 Jul 2021 21:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627075506;
        bh=L2rxadH+AUh2Pwd80ajPT5po5yZXxvRMdsUUDexNG8U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=njGl9A2y+NSDXY8YVtI+QI0lOt2xP24i8NSn23mCptGQUj9BulHNDVazOYEKtRYjh
         uDjYz+UXnG17wD4GAj0MVXMCfNvd1rLPGPglt+dWel2meaBI5Sks6shlm5+HVx+LFX
         3BADzLXKRQ+fuiTA0eDOI+/55sLN4/By88hqTvjVERbfemdjbL+bs0oH94iCKe1Xev
         1yZ05xJWHarLZnd+36spK4LOgE8paPuIOmY17/n4ZS3MmVz6POhJ3qiIfevC87JyBv
         t5g3GWTuwT5gzXVGy1hZ4JAJK/eOtbOnbl5dOf5dplOlgE1pFA6O4fC1vf36tQv5eB
         3ycOAjLIiYZOA==
Date:   Fri, 23 Jul 2021 17:25:05 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: Re: [PATCH 5.10 038/125] arm64: dts: qcom: msm8996: Make CPUCC
 actually probe (and work)
Message-ID: <YPszsUlUbE6W5MKg@sashalap>
References: <20210722155624.672583740@linuxfoundation.org>
 <20210722155625.957020845@linuxfoundation.org>
 <20210723200732.GB22684@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210723200732.GB22684@duo.ucw.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 23, 2021 at 10:07:32PM +0200, Pavel Machek wrote:
>Hi!
>> Fix the compatible to make the driver probe and tell the
>> driver where to look for the "xo" clock to make sure everything
>> works.
>>
>> Then we get a happy (eh, happier) 8996:
>>
>> somainline-sdcard:/home/konrad# cat /sys/kernel/debug/clk/pwrcl_pll/clk_rate
>> 1152000000
>>
>> Don't backport without "arm64: dts: qcom: msm8996: Add CPU opps", as
>> the system fails to boot without consumers for these clocks.
>
>Changelog says this has dependency on
>b502efda6480d7577f9f822fd450d6bc3a4ac2e6.
>
>But that one is not in 5.10 AFAICT.

I'll drop it from everywhere, thanks!


-- 
Thanks,
Sasha
