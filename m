Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D508283D88
	for <lists+stable@lfdr.de>; Wed,  7 Aug 2019 00:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbfHFWsV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 18:48:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:50872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726044AbfHFWsU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 18:48:20 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8EA83216F4;
        Tue,  6 Aug 2019 22:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565131699;
        bh=Y6rSVjtU51HL7lb/M4xvIrBasd9WZXh1oW73VdEI3rs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ewDEjorwCcYbSjcQ161+1mbHdROByeOLc+oI/GjwQyLpp0rAV9O6tGjCI672ync4r
         NTteRUHoB5eCIuB1RC7ZzmBifNAMcPhQQL27ycB2fEVWecv/u+P5YAyILh1d87r8Si
         CDx9U9JXqNdyrsETB9nSog4RDgVcZVCPpjq/Z6sg=
Date:   Tue, 6 Aug 2019 18:48:18 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Alim Akhtar <alim.akhtar@gmail.com>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH 4.19 46/74] mmc: dw_mmc: Fix occasional hang after tuning
 on eMMC
Message-ID: <20190806224818.GQ17747@sasha-vm>
References: <20190805124935.819068648@linuxfoundation.org>
 <20190805124939.613665562@linuxfoundation.org>
 <20190806223139.GA9937@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190806223139.GA9937@amd>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 07, 2019 at 12:31:39AM +0200, Pavel Machek wrote:
>Hi!
>
>> I'm hoping that whatever problems exynos was having in the past are
>> somehow magically fixed now and we can make the behavior the same for
>> all commands.
>
>Dunno. Maybe they are in mainline, but are they fixed in all the
>stable releases this is being applied to?

Are they not? If they're broken, then no one is using them now anyways.

If anyone tries, and it's still broken, we'll at least have a chance to
get it fixed.

--
Thanks,
Sasha
