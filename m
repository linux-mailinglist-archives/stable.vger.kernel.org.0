Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5D9E199714
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 15:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730905AbgCaNLc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 09:11:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:40210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730974AbgCaNLc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 09:11:32 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A2BE21924;
        Tue, 31 Mar 2020 13:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585660291;
        bh=uvJBXe/1fKLbNAJZnngR2H1ble9LkRNQIerQekqdres=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=Efu5PD2A/fHEQkGebgGpQkhqXpVs2Doj2VEKECAFDnm9/6k0C+AIn3YMnfZg5C8t4
         cjs5FlNfJxU+86lND5K8kLa46ZgPQ2zAdobvj7cYvP2xu8sfPOOKTCL43KKvB/3KMb
         0DMZSO1S7Np4X+Qxhsx1ppqJ10nMLn5lFZHMWYvQ=
Date:   Tue, 31 Mar 2020 13:11:30 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Thomas Hebb <tommyhebb@gmail.com>
To:     alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Cc:     Kailang Yang <kailang@realtek.com>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 3/3] ALSA: hda/realtek - Remove now-unnecessary XPS 13 headphone noise fixups
In-Reply-To: <028b0c410238090546cf80ef6075b3b9139986a7.1585553414.git.tommyhebb@gmail.com>
References: <028b0c410238090546cf80ef6075b3b9139986a7.1585553414.git.tommyhebb@gmail.com>
Message-Id: <20200331131131.2A2BE21924@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 8c69729b4439 ("ALSA: hda - Fix headphone noise after Dell XPS 13 resume back from S3").

The bot has tested the following trees: v5.5.13, v5.4.28, v4.19.113, v4.14.174, v4.9.217, v4.4.217.

v5.5.13: Build OK!
v5.4.28: Build OK!
v4.19.113: Build OK!
v4.14.174: Failed to apply! Possible dependencies:
    1099f48457d0 ("ALSA: hda/realtek: Reduce the Headphone static noise on XPS 9350/9360")
    28d1d6d2f314 ("ALSA: hda - Add model string for Intel reference board quirk")
    a26d96c7802e ("ALSA: hda/realtek - Comprehensive model list for ALC259 & co")
    c0ca5eced222 ("ALSA: hda/realtek - Reduce click noise on Dell Precision 5820 headphone")
    c1350bff69d1 ("ALSA: hda - Clean up ALC299 init code")
    da911b1f5e98 ("ALSA: hda/realtek - update ALC225 depop optimize")

v4.9.217: Failed to apply! Possible dependencies:
    8551914a5e19 ("ALSA: doc: ReSTize alsa-driver-api document")
    9000d69925ac ("ALSA: doc: ReSTize HD-Audio document")
    a26d96c7802e ("ALSA: hda/realtek - Comprehensive model list for ALC259 & co")
    a4caad753f0c ("ALSA: doc: ReSTize HD-Audio-Models document")
    a79e7df97592 ("ALSA: hda - Update the list of quirk models")

v4.4.217: Failed to apply! Possible dependencies:
    34d505193bd1 ("cfg80211: basic support for PBSS network type")
    35eb8f7b1a37 ("cfg80211: Improve Connect/Associate command documentation")
    38de03d2a289 ("nl80211: add feature for BSS selection support")
    819bf593767c ("docs-rst: sphinxify 802.11 documentation")
    8551914a5e19 ("ALSA: doc: ReSTize alsa-driver-api document")
    9000d69925ac ("ALSA: doc: ReSTize HD-Audio document")
    a26d96c7802e ("ALSA: hda/realtek - Comprehensive model list for ALC259 & co")
    a4caad753f0c ("ALSA: doc: ReSTize HD-Audio-Models document")
    ba6fbacf9c07 ("cfg80211: Add option to specify previous BSSID for Connect command")
    bf1ecd210541 ("cfg80211: Allow cfg80211_connect_result() errors to be distinguished")
    e705498945ad ("cfg80211: Add option to report the bss entry in connect result")
    fa44b7ec9bc4 ("ALSA: hda - Update documentation")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
