Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22602195983
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 16:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727742AbgC0PDu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Mar 2020 11:03:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:44112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727773AbgC0PDr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Mar 2020 11:03:47 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E7962074F;
        Fri, 27 Mar 2020 15:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585321426;
        bh=SqNhXOiO4TwOUv+gSJZ1sxEfPcaEczkDfJTWZlSNz1Q=;
        h=Date:From:To:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:
         From;
        b=V6HOd8maQOKkRG6X2vkXG9WJM3TOQTn8hfAmOgJjedRC0eu1sZL6G011KKpMPkE7q
         vkKB1ZDeYS2tioceNZ6f3ymarCeJWswWhpRQsb2jVHaCnazEjsEJCctTxJWzdRtwUX
         MpWh5+xD+0k2EvP5ziZHktK5tlDQmBXiWqtvs1z4=
Date:   Fri, 27 Mar 2020 15:03:45 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
To:     Jouni Malinen <jouni@codeaurora.org>
To:     linux-wireless@vger.kernel.org
Cc:     Jouni Malinen <jouni@codeaurora.org>, stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 1/2] mac80211: Check port authorization in the ieee80211_tx_dequeue() case
In-Reply-To: <20200326155133.ced84317ea29.I34d4c47cd8cc8a4042b38a76f16a601fbcbfd9b3@changeid>
References: <20200326155133.ced84317ea29.I34d4c47cd8cc8a4042b38a76f16a601fbcbfd9b3@changeid>
Message-Id: <20200327150346.8E7962074F@mail.kernel.org>
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
v4.19.112: Build OK!
v4.14.174: Build OK!
v4.9.217: Build OK!
v4.4.217: Failed to apply! Possible dependencies:
    311048911758 ("mac80211: allow driver to prevent two stations w/ same address")
    412a6d800c73 ("mac80211: support hw managing reorder logic")
    49ddf8e6e234 ("mac80211: add fast-rx path")
    4f6b1b3daaf1 ("mac80211: fix last RX rate data consistency")
    506bcfa8abeb ("mac80211: limit the A-MSDU Tx based on peer's capabilities")
    52cfa1d6146c ("mac80211: track and tell driver about GO client P2P PS abilities")
    6e0456b54545 ("mac80211: add A-MSDU tx support")
    86c7ec9eb154 ("mac80211: properly free skb when r-o-c for TX fails")
    a2fcfccbad43 ("mac80211: move off-channel/mgmt-tx code to offchannel.c")
    a7201a6c5ea0 ("mac80211: Recalc min chandef when station is associated")
    b8da6b6a99b4 ("mac80211: add separate last_ack variable")
    bb42f2d13ffc ("mac80211: Move reorder-sensitive TX handlers to after TXQ dequeue")
    c9c5962b56c1 ("mac80211: enable collecting station statistics per-CPU")
    dfdfc2beb0dd ("mac80211: Parse legacy and HT rate in injected frames")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
