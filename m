Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB88C22998F
	for <lists+stable@lfdr.de>; Wed, 22 Jul 2020 15:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732241AbgGVNsv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jul 2020 09:48:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:35152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726425AbgGVNst (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jul 2020 09:48:49 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF17A2065D;
        Wed, 22 Jul 2020 13:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595425729;
        bh=UVmbuLKopkN2E3NVwRVE/SS4uLAvidcAX3P5wvIaRiU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2cNJj3xXCHuNZIQ2dmW2I79gpY8nouuA60DzCwNP1JoRpuOLnGoXD6yfs3bKqff6x
         +jaT+OAZgrFzi5aPdaMHVbOSW8vxIh2VlKWgjnqGKibGgnKjLAhPslR4loWk92icm8
         whUh6QG6tqb76QCyS4SaIqQ6vGqIDHoZONQwTbUE=
Date:   Wed, 22 Jul 2020 09:48:47 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Kai Vehmanen <kai.vehmanen@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alsa-devel@alsa-project.org, Takashi Iwai <tiwai@suse.de>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Subject: Re: [PATCH AUTOSEL 4.4 7/9] ALSA: hda/hdmi: fix failures at PCM open
 on Intel ICL and later
Message-ID: <20200722134847.GC406581@sasha-vm>
References: <20200714144024.4036118-1-sashal@kernel.org>
 <20200714144024.4036118-7-sashal@kernel.org>
 <alpine.DEB.2.22.394.2007151332320.3186@eliteleevi.tm.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.22.394.2007151332320.3186@eliteleevi.tm.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 15, 2020 at 01:52:05PM +0300, Kai Vehmanen wrote:
>Hi Sasha,
>
>On Tue, 14 Jul 2020, Sasha Levin wrote:
>
>> From: Kai Vehmanen <kai.vehmanen@linux.intel.com>
>>
>> [ Upstream commit 56275036d8185f92eceac7479d48b858ee3dab84 ]
>>
>> When HDMI PCM devices are opened in a specific order, with at least one
>> HDMI/DP receiver connected, ALSA PCM open fails to -EBUSY on the
>> connected monitor, on recent Intel platforms (ICL/JSL and newer). While
>
>we don't have Ice Lake hardware support in the HDA HDMI codec driver in
>any 4.x stable trees (only in 5.1+), so this patch will not help on those
>and can be dropped.

Will do, thank you.

-- 
Thanks,
Sasha
