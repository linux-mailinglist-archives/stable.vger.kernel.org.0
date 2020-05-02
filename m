Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E03EE1C25E4
	for <lists+stable@lfdr.de>; Sat,  2 May 2020 15:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727968AbgEBNqK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 May 2020 09:46:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:40460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727921AbgEBNqK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 2 May 2020 09:46:10 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01EF52071E;
        Sat,  2 May 2020 13:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588427170;
        bh=WLPBfrFHzrvESRQsTHmGqqosrH0f38pZglhziMIG60Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uLFW385mqVmkvrFNgsAy4k37hESslO80u8MjL+zu6gNMGd5Yr19y5cxDeVSQ5XaJu
         af/j678AcWUtir12hnJs1bQQin7J4mHEo61a18aZjWoFiC47uZy039lPBfUZe2/cdm
         gFHzoXD20W6a5oC0Ees2Abxg2kwIhhNailzHs5AQ=
Date:   Sat, 2 May 2020 09:46:08 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jerome Brunet <jbrunet@baylibre.com>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH AUTOSEL 5.6 45/79] ASoC: meson: axg-card: fix
 codec-to-codec link setup
Message-ID: <20200502134608.GG13035@sasha-vm>
References: <20200430135043.19851-1-sashal@kernel.org>
 <20200430135043.19851-45-sashal@kernel.org>
 <20200430135610.GD4633@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200430135610.GD4633@sirena.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 30, 2020 at 02:56:10PM +0100, Mark Brown wrote:
>On Thu, Apr 30, 2020 at 09:50:09AM -0400, Sasha Levin wrote:
>
>> Since the addition of commit 9b5db059366a ("ASoC: soc-pcm: dpcm: Only allow
>> playback/capture if supported"), meson-axg cards which have codec-to-codec
>> links fail to init and Oops:
>
>This clearly describes the issue as only being present after the above
>commit which is not in v5.6.

Uh, I thought that the fixes tag points to the same commit as mentioned
in the description... I'll drop it, sorry.

-- 
Thanks,
Sasha
