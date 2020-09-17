Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC5C26E49B
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 20:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726409AbgIQSxi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 14:53:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:37238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728450AbgIQQUv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 12:20:51 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE0602078D;
        Thu, 17 Sep 2020 15:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600358010;
        bh=xLgjMm7ateerqRvOW/ACV+xUBV1vmhn39rf9uYU/foI=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Cc:Subject:In-Reply-To:References:
         From;
        b=PVIoDK0ynVeiPKncmAE/r00LLMAmT93ur5TuqzR5gqcQqdoumd61XJEJKCNDUBc09
         Q2L0POyfd4dPsIqaye1scjTkNzc8LBoKXxWkuja/auEa9DwTHk3dzuL6iocjG9gi+r
         KIyk7uTnOR1rH1ElQjoHXruDS56CBsPaEJrPV9iw=
Date:   Thu, 17 Sep 2020 15:53:30 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Hui Wang <hui.wang@canonical.com>
To:     alsa-devel@alsa-project.org, tiwai@suse.de, kailang@realtek.com
Cc:     stable@vger.kernel.org
Cc:     Kailang Yang <kailang@realtek.com>
Cc:     <stable@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] ALSA: hda/realtek - Couldn't detect Mic if booting with headset plugged
In-Reply-To: <20200914065118.19238-1-hui.wang@canonical.com>
References: <20200914065118.19238-1-hui.wang@canonical.com>
Message-Id: <20200917155330.AE0602078D@mail.kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.8.9, v5.4.65, v4.19.145, v4.14.198, v4.9.236, v4.4.236.

v5.8.9: Build OK!
v5.4.65: Build OK!
v4.19.145: Build OK!
v4.14.198: Build OK!
v4.9.236: Failed to apply! Possible dependencies:
    0a6f0600efc3 ("ALSA: hda/realtek - New codecs support for ALC215/ALC285/ALC289")
    1078bef0cd92 ("ALSA: hda/realtek - Support ALC300")
    1c9609e3a8cf ("ALSA: hda - Reduce the suspend time consumption for ALC256")
    3aabf94c2d95 ("ALSA: hda/realtek - Fix ALC275 no sound issue")
    4a219ef8f370 ("ALSA: hda/realtek - Add ALC256 HP depop function")
    532a7784c376 ("ALSA: hda/realtek - There is no loopback mixer in the ALC234/274/294")
    693abe11aa6b ("ALSA: hda/realtek - Fixed hp_pin no value")
    71683c32dee6 ("ALSA: hda/realtek - Support headset mode for ALC234/ALC274/ALC294")
    bde1a7459623 ("ALSA: hda/realtek - Fixed headphone issue for ALC700")
    c0ca5eced222 ("ALSA: hda/realtek - Reduce click noise on Dell Precision 5820 headphone")
    c2d6af53a43f ("ALSA: hda/realtek - Add default procedure for suspend and resume state")

v4.4.236: Failed to apply! Possible dependencies:
    0a6f0600efc3 ("ALSA: hda/realtek - New codecs support for ALC215/ALC285/ALC289")
    1078bef0cd92 ("ALSA: hda/realtek - Support ALC300")
    1c9609e3a8cf ("ALSA: hda - Reduce the suspend time consumption for ALC256")
    3aabf94c2d95 ("ALSA: hda/realtek - Fix ALC275 no sound issue")
    4a219ef8f370 ("ALSA: hda/realtek - Add ALC256 HP depop function")
    532a7784c376 ("ALSA: hda/realtek - There is no loopback mixer in the ALC234/274/294")
    693abe11aa6b ("ALSA: hda/realtek - Fixed hp_pin no value")
    71683c32dee6 ("ALSA: hda/realtek - Support headset mode for ALC234/ALC274/ALC294")
    bde1a7459623 ("ALSA: hda/realtek - Fixed headphone issue for ALC700")
    c0ca5eced222 ("ALSA: hda/realtek - Reduce click noise on Dell Precision 5820 headphone")
    c2d6af53a43f ("ALSA: hda/realtek - Add default procedure for suspend and resume state")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
