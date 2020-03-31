Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB815199713
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 15:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730972AbgCaNLb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 09:11:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:40116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730961AbgCaNLa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 09:11:30 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A72620757;
        Tue, 31 Mar 2020 13:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585660290;
        bh=BTbc/zwckK+KsTeoNdCpv3xhH2SfMEDaz/AD3AvHqSc=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=HzzVGoQpJDvLZhoWMkJ2CTv9N/KBsUg5DeXP20OgQ6Rm47Ut4RTCeGnRPZtn5nnsN
         FPvsyJRxTYsl2f6Dm8BupaL3QpHV9g1aOILBFY2yqepBDGLVMoq+9fSJvBaBe6Z9vr
         C1TN4N+Uo35saz9T48ZaFgUdr7F5ZiMkAyWMELzA=
Date:   Tue, 31 Mar 2020 13:11:29 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Hui Wang <hui.wang@canonical.com>
To:     alsa-devel@alsa-project.org, tiwai@suse.de, stable@vger.kernel.org
Cc:     Kailang Yang <kailang@realtek.com>
Cc:     <stable@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] ALSA: hda/realtek - a fake key event is triggered by running shutup
In-Reply-To: <20200329080642.20287-1-hui.wang@canonical.com>
References: <20200329080642.20287-1-hui.wang@canonical.com>
Message-Id: <20200331131130.0A72620757@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 78def224f59c ("ALSA: hda/realtek - Add Headset Mic supported").

The bot has tested the following trees: v5.5.13, v5.4.28, v4.19.113.

v5.5.13: Build OK!
v5.4.28: Build OK!
v4.19.113: Failed to apply! Possible dependencies:
    10f5b1b85ed1 ("ALSA: hda/realtek - Fixed Headset Mic JD not stable")
    2b3b6497c38d ("ALSA: hda/realtek - Add more codec supported Headset Button")
    8983eb602af5 ("ALSA: hda/realtek - Move to ACT_INIT state")
    c8a9afa632f0 ("ALSA: hda/realtek: merge alc_fixup_headset_jack to alc295_fixup_chromebook")
    d3ba58bb8959 ("ALSA: hda/realtek - Support low power consumption for ALC295")
    e854747d7593 ("ALSA: hda/realtek - Enable headset button support for new codec")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
