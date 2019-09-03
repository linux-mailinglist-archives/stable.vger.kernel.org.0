Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4CB9A73F1
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 21:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbfICTq4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 15:46:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:44736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726179AbfICTq4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 15:46:56 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 792C321881;
        Tue,  3 Sep 2019 19:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567540015;
        bh=iGpP72X9Gfm1P4HKsR74LYZo3Ydpk9P15xifOisfBxo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dukkqYi+oIhKbc5l4o0v/PgTWPmdhzuAp1/a1bTLNTKocjXl5O/F3bHdUaJtpa0tV
         5L87acgduZm74OZL7niFVcxCJBRY89xN+UhwedzmFyxm1UWyXZNG/sw+PEP7/NOK2O
         GuMT+liOsStYPwbJHAyztoZ7vvDT3M89tOkVkzZU=
Date:   Tue, 3 Sep 2019 15:46:54 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Jonathan Cameron <jic23@jic23.retrosnub.co.uk>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jonathan Bakker <xc-racer2@live.ca>,
        =?utf-8?B?UGF3ZcWC?= Chmiel <pawel.mikolaj.chmiel@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.19 066/167] iio: adc: exynos-adc: Add S5PV210
 variant
Message-ID: <20190903194654.GI5281@sasha-vm>
References: <20190903162519.7136-1-sashal@kernel.org>
 <20190903162519.7136-66-sashal@kernel.org>
 <20190903185328.74299c4d@archlinux>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190903185328.74299c4d@archlinux>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 03, 2019 at 06:53:28PM +0100, Jonathan Cameron wrote:
>On Tue,  3 Sep 2019 12:23:38 -0400
>Sasha Levin <sashal@kernel.org> wrote:
>
>> From: Jonathan Bakker <xc-racer2@live.ca>
>>
>> [ Upstream commit 882bf52fdeab47dbe991cc0e564b0b51c571d0a3 ]
>>
>> S5PV210's ADC variant is almost the same as v1 except that it has 10
>> channels and doesn't require the pmu register
>>
>> Signed-off-by: Jonathan Bakker <xc-racer2@live.ca>
>> Signed-off-by: Paweł Chmiel <pawel.mikolaj.chmiel@gmail.com>
>> Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>I have no particular objection to adding new IDs (which is more
>or less what this patch is), but I didn't know autosel was
>picking them up.  So a bit of surprise... If intentional
>then fine to apply to stable.

I dragged it in because 103cda6a3b8d2 ("iio: adc: exynos-adc: Use proper
number of channels for Exynos4x12") which is tagged for stable depended
on this patch, and given it just adds new IDs which is part of what we
take for stable I just took it in as is.

--
Thanks,
Sasha
