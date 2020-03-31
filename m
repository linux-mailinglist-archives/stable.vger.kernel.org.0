Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7CB19971A
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 15:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730975AbgCaNLj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 09:11:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:40068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730939AbgCaNL2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 09:11:28 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B95B220786;
        Tue, 31 Mar 2020 13:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585660288;
        bh=E0ZiGGpWnxZaGahYOcWQMjN9JjsdC0P9wppib5vRFlY=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=jFM65O2qJCku15188+q3R7FmKYdvYYfHuOq7pF6KY27kuf7S8JnBMGUh8chTmiTRB
         Ppm/tLE6q0yURG63lG/up/BxnaGVciuAEh0L4x7Fq04+1ciYFrb1Ha9R4gkQZw7UYb
         ZUt3/QULxz8ARVvTnt96ljyipqTUXLwcCEvvlDBM=
Date:   Tue, 31 Mar 2020 13:11:27 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Thomas Hebb <tommyhebb@gmail.com>
To:     alsa-devel@alsa-project.org, linux-kernel@vger.kernel.or
Cc:     Kailang Yang <kailang@realtek.com>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 1/3] ALSA: doc: Document PC Beep Hidden Register on Realtek ALC256
In-Reply-To: <bd69dfdeaf40ff31c4b7b797c829bb320031739c.1585553414.git.tommyhebb@gmail.com>
References: <bd69dfdeaf40ff31c4b7b797c829bb320031739c.1585553414.git.tommyhebb@gmail.com>
Message-Id: <20200331131127.B95B220786@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.5.13, v5.4.28, v4.19.113, v4.14.174, v4.9.217, v4.4.217.

v5.5.13: Build OK!
v5.4.28: Build OK!
v4.19.113: Build OK!
v4.14.174: Build OK!
v4.9.217: Failed to apply! Possible dependencies:
    76ab4e15158c ("ALSA: doc: ReSTize HD-Audio-DP-MST-audio.txt")
    8551914a5e19 ("ALSA: doc: ReSTize alsa-driver-api document")
    9000d69925ac ("ALSA: doc: ReSTize HD-Audio document")
    a4caad753f0c ("ALSA: doc: ReSTize HD-Audio-Models document")
    fe0abd18e1ef ("ALSA: doc: ReSTize HD-Audio-Controls document")

v4.4.217: Failed to apply! Possible dependencies:
    34d505193bd1 ("cfg80211: basic support for PBSS network type")
    35eb8f7b1a37 ("cfg80211: Improve Connect/Associate command documentation")
    38de03d2a289 ("nl80211: add feature for BSS selection support")
    463c35fb7981 ("ALSA: Add documentation about HD-audio DP MST")
    76ab4e15158c ("ALSA: doc: ReSTize HD-Audio-DP-MST-audio.txt")
    819bf593767c ("docs-rst: sphinxify 802.11 documentation")
    8551914a5e19 ("ALSA: doc: ReSTize alsa-driver-api document")
    9000d69925ac ("ALSA: doc: ReSTize HD-Audio document")
    a4caad753f0c ("ALSA: doc: ReSTize HD-Audio-Models document")
    ba6fbacf9c07 ("cfg80211: Add option to specify previous BSSID for Connect command")
    bf1ecd210541 ("cfg80211: Allow cfg80211_connect_result() errors to be distinguished")
    e705498945ad ("cfg80211: Add option to report the bss entry in connect result")
    fa44b7ec9bc4 ("ALSA: hda - Update documentation")
    fe0abd18e1ef ("ALSA: doc: ReSTize HD-Audio-Controls document")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
