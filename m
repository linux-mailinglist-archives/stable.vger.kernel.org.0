Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8250A202DA8
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 01:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbgFUXez (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Jun 2020 19:34:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:58846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726500AbgFUXez (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 21 Jun 2020 19:34:55 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68816252F5;
        Sun, 21 Jun 2020 23:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592782494;
        bh=W8kZXpcfmOusXfXo2/vgBybV1csqrf5weDBsejZCvqM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HJ7Fy/oFMKqv5SRpIDwlXibmw/vihc2j0r2Da3mJn/Tm4kGtZG0WoUHHD7UPuhL0N
         ZGutB3R4M5Fjo/9GKqTEf6BgxdL8zdxO86bvH5Vjoe/oQfxhl+ArIcNzfPtgxgmhRc
         9DzC9KXiaXkMEbr67jzl3o77h4WHNdpz2ri2iiJc=
Date:   Sun, 21 Jun 2020 19:34:53 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Wei Li <liwei391@huawei.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH AUTOSEL 5.7 130/388] ASoC: Fix wrong dependency of da7210
 and wm8983
Message-ID: <20200621233453.GB1931@sasha-vm>
References: <20200618010805.600873-1-sashal@kernel.org>
 <20200618010805.600873-130-sashal@kernel.org>
 <20200618110258.GD5789@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200618110258.GD5789@sirena.org.uk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 18, 2020 at 12:02:58PM +0100, Mark Brown wrote:
>On Wed, Jun 17, 2020 at 09:03:47PM -0400, Sasha Levin wrote:
>> From: Wei Li <liwei391@huawei.com>
>>
>> [ Upstream commit c1c050ee74d67aeb879fd38e3a07139d7fdb79f4 ]
>>
>> As these two drivers support I2C and SPI, we should add the SND_SOC_I2C_AND_SPI
>> dependency instead.
>
>This is purely about build testing, are you sure this is stable
>material?

Is this not something that can happen in practice?

-- 
Thanks,
Sasha
