Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2384E1FF4BA
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 16:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbgFROas (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 10:30:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:53734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726132AbgFROas (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jun 2020 10:30:48 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4809E207E8;
        Thu, 18 Jun 2020 14:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592490647;
        bh=obOL30SQn9wE32rmVgFOC0DRObEfMlUdqxWbZkdA/zk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MLAR0Z+XKCoWsWUztqZIKmKpbTfIvoXxXpVb57ccLX3wqamwcWmdavGWQEDSabc7o
         RiNyr0iPWgpKrnpklb+iGwNvHEmN/5sR9r7KAPkbokHsovHisg/go7+5bFIF9n90cT
         17pOBbSz12/hBbeKYEC9PRlq0Zw6x0u72Lr7XirA=
Date:   Thu, 18 Jun 2020 10:30:46 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dmitry Osipenko <digetx@gmail.com>,
        alsa-devel@alsa-project.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.7 004/388] ASoC: tegra: tegra_wm8903: Support
 nvidia, headset property
Message-ID: <20200618143046.GT1931@sasha-vm>
References: <20200618010805.600873-1-sashal@kernel.org>
 <20200618010805.600873-4-sashal@kernel.org>
 <20200618110023.GB5789@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200618110023.GB5789@sirena.org.uk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 18, 2020 at 12:00:23PM +0100, Mark Brown wrote:
>On Wed, Jun 17, 2020 at 09:01:41PM -0400, Sasha Levin wrote:
>> From: Dmitry Osipenko <digetx@gmail.com>
>>
>> [ Upstream commit 3ef9d5073b552d56bd6daf2af1e89b7e8d4df183 ]
>>
>> The microphone-jack state needs to be masked in a case of a 4-pin jack
>> when microphone and ground pins are shorted. Presence of nvidia,headset
>> tells that WM8903 CODEC driver should mask microphone's status if short
>> circuit is detected, i.e headphones are inserted.
>
>This is a new feature not a bugfix.

I saw this patch more as a hardware quirk.

-- 
Thanks,
Sasha
