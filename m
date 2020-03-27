Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4684195979
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 16:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727352AbgC0PDl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Mar 2020 11:03:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:43888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726900AbgC0PDl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Mar 2020 11:03:41 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC3F02074F;
        Fri, 27 Mar 2020 15:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585321420;
        bh=Kd9WUVxxdJ8IwPViet/JxDNGiuRsM6gngbsVDBvRls0=;
        h=Date:From:To:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:
         From;
        b=Pirx67GGHppPvQoBGwgnlJ9r/hVtfVmT0EnEoFN+GpLXd19DSEoCeLmEGTahLKqhQ
         UWEYnWrZ1N941x3ZNDxwq7CIts7Oj08ke27jevg5i98I2aNeq0P4CerzDC8Z/qrctE
         Vc1E3MnF7y49CquK6BAnPFN+Qd54SII/TKpycuQo=
Date:   Fri, 27 Mar 2020 15:03:39 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
To:     Johannes Berg <johannes.berg@intel.com>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>, stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 2/2] mac80211: mark station unauthorized before key removal
In-Reply-To: <20200326155133.ccb4fb0bb356.If48f0f0504efdcf16b8921f48c6d3bb2cb763c99@changeid>
References: <20200326155133.ccb4fb0bb356.If48f0f0504efdcf16b8921f48c6d3bb2cb763c99@changeid>
Message-Id: <20200327150339.CC3F02074F@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.5.11, v5.4.27, v4.19.112, v4.14.174, v4.9.217, v4.4.217.

v5.5.11: Build OK!
v5.4.27: Build OK!
v4.19.112: Failed to apply! Possible dependencies:
    1e87fec9fa52 ("mac80211: call rate_control_send_low() internally")
    adf8ed01e4fd ("mac80211: add an optional TXQ for other PS-buffered frames")
    ba905bf432f6 ("mac80211: store tx power value from user to station")
    bd718fc11d5b ("mac80211: use STA info in rate_control_send_low()")
    edba6bdad6fe ("mac80211: allow AMSDU size limitation per-TID")

v4.14.174: Failed to apply! Possible dependencies:
    0832b603c758 ("mac80211: don't put null-data frames on the normal TXQ")
    1e87fec9fa52 ("mac80211: call rate_control_send_low() internally")
    7c181f4fcdc6 ("mac80211: add ieee80211_hw flag for QoS NDP support")
    94ba92713f83 ("mac80211: Call mgd_prep_tx before transmitting deauthentication")
    a403f3bf6390 ("mac80211: remove pointless flags=0 assignment")
    adf8ed01e4fd ("mac80211: add an optional TXQ for other PS-buffered frames")
    ba905bf432f6 ("mac80211: store tx power value from user to station")
    bd718fc11d5b ("mac80211: use STA info in rate_control_send_low()")
    e2fb1b839208 ("mac80211: enable TDLS peer buffer STA feature")
    e552af058148 ("mac80211: limit wmm params to comply with ETSI requirements")
    ecaf71de4143 ("iwlwifi: mvm: rs: introduce new API for rate scaling")
    edba6bdad6fe ("mac80211: allow AMSDU size limitation per-TID")

v4.9.217: Failed to apply! Possible dependencies:
    06efdbe70f9c ("ath10k: refactor ath10k_peer_assoc_h_phymode()")
    50f08edf9809 ("ath9k: Switch to using mac80211 intermediate software queues.")
    63fefa050477 ("ath9k: Introduce airtime fairness scheduling between stations")
    7f406cd16a0f ("mac80211: encode rate type (legacy, HT, VHT) with fewer bits")
    7fdd69c5af21 ("mac80211: clean up rate encoding bits in RX status")
    a17d93ff3a95 ("mac80211: fix legacy and invalid rx-rate report")
    bc1efd739b61 ("ath10k: add VHT160 support")
    da6a4352e7c8 ("mac80211: separate encoding/bandwidth from flags")
    dcba665b1f4a ("mac80211: use bitfield macros for encoded rate")

v4.4.217: Failed to apply! Possible dependencies:
    0ead2510f8ce ("mac80211: allow the driver to send EOSP when needed")
    311048911758 ("mac80211: allow driver to prevent two stations w/ same address")
    412a6d800c73 ("mac80211: support hw managing reorder logic")
    4f6b1b3daaf1 ("mac80211: fix last RX rate data consistency")
    7f406cd16a0f ("mac80211: encode rate type (legacy, HT, VHT) with fewer bits")
    7fdd69c5af21 ("mac80211: clean up rate encoding bits in RX status")
    a17d93ff3a95 ("mac80211: fix legacy and invalid rx-rate report")
    b8da6b6a99b4 ("mac80211: add separate last_ack variable")
    bc1efd739b61 ("ath10k: add VHT160 support")
    da6a4352e7c8 ("mac80211: separate encoding/bandwidth from flags")
    dcba665b1f4a ("mac80211: use bitfield macros for encoded rate")
    f59374eb427f ("mac80211: synchronize driver rx queues before removing a station")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
